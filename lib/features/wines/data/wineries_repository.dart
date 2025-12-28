import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/winery.dart';
import '../domain/region.dart';
import '../domain/country.dart';
import '../../../core/providers.dart';

final wineriesRepositoryProvider = Provider<WineriesRepository>((ref) {
  return WineriesRepository(ref.read(supabaseClientProvider));
});

class WineriesRepository {
  final SupabaseClient _supabaseClient;

 WineriesRepository(this._supabaseClient);

  Future<List<Winery>> fetchAllWineries({bool includeDeleted = false}) async {
    var query = _supabaseClient
        .from('wineries')
        .select('id, name, country_code, region_id, winemaker, website, description, logo_url, banner_url, location_text, latitude, longitude, founded_year, is_partner, phone, email, is_deleted, created_at, countries!inner(name), regions!inner(name)')
        .order('created_at', ascending: false);

    if (!includeDeleted) {
      // Для фильтрации по is_deleted нужно использовать RPC или изменить подход
      // так как после select() возвращается PostgrestTransformBuilder, а не PostgrestFilterBuilder
      final response = await query;
      // Отфильтруем на клиенте, если includeDeleted = false
      if (!includeDeleted) {
        final filteredResponse = response.where((item) => item['is_deleted'] == false).toList();
        debugPrint('Filtered response length: ${filteredResponse.length}');
        return filteredResponse.map((json) => Winery.fromJson(json)).toList();
      }
      debugPrint(response.toString());
      return response.map((json) => Winery.fromJson(json)).toList();
    }
    
    final response = await query;
    debugPrint(response.toString());
    return response.map((json) => Winery.fromJson(json)).toList();
  }

 Future<Winery> fetchWinery(String wineryId) async {
    final response = await _supabaseClient
        .from('wineries')
        .select('id, name, description, logo_url, banner_url, created_at, is_deleted, countries!inner(name)')
        .eq('id', wineryId)
        .eq('is_deleted', false)
        .single();
    debugPrint(response.toString());

    return Winery.fromJson(response);
 }

 Future<Winery> fetchWineryById(String id) async {
    final data = await _supabaseClient
        .from('wineries')
        .select('*, countries!inner(name), regions!inner(name), is_deleted')
        .eq('id', id)
        .eq('is_deleted', false)
        .single();
    debugPrint(data.toString());
    return Winery.fromJson(data);
 }
   
  Future<Winery> addWinery(Winery winery) async {
    try {
      debugPrint('Начало добавления винодельни: ${winery.name}');
      final response = await _supabaseClient
          .from('wineries')
          .insert({
            'name': winery.name,
            'country_code': winery.countryCode,
            'region_id': winery.regionId,
            'winemaker': winery.winemaker,
            'website': winery.website,
            'description': winery.description,
            'logo_url': winery.logoUrl,
            'banner_url': winery.bannerUrl,
            'location_text': winery.locationText,
            'latitude': winery.latitude,
            'longitude': winery.longitude,
            'founded_year': winery.foundedYear,
            'is_partner': winery.isPartner,
            'phone': winery.phone,
            'email': winery.email,
            'is_deleted': false, // Устанавливаем по умолчанию
          })
          .select('id, name, country_code, region_id, winemaker, website, description, logo_url, banner_url, location_text, latitude, longitude, founded_year, is_partner, phone, email, is_deleted, created_at, countries!inner(name), regions!inner(name)')
          .single();
      debugPrint(response.toString());

      debugPrint('Завершено добавление винодельни: ${winery.name}');
      return Winery.fromJson(response);
    } catch (e, st) {
      debugPrint('Error adding winery in repository: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

 Future<Winery> updateWinery(Winery winery) async {
    if (winery.id == null) {
      throw Exception('Cannot update winery without ID');
    }
    try {
      debugPrint('Начало обновления винодельни: ${winery.name}');
      final response = await _supabaseClient
          .from('wineries')
          .update({
            'name': winery.name,
            'country_code': winery.countryCode,
            'region_id': winery.regionId,
            'winemaker': winery.winemaker,
            'website': winery.website,
            'description': winery.description,
            'logo_url': winery.logoUrl,
            'banner_url': winery.bannerUrl,
            'location_text': winery.locationText,
            'latitude': winery.latitude,
            'longitude': winery.longitude,
            'founded_year': winery.foundedYear,
            'is_partner': winery.isPartner,
            'phone': winery.phone,
            'email': winery.email,
          })
          .eq('id', winery.id!)
          .select('id, name, country_code, region_id, winemaker, website, description, logo_url, banner_url, location_text, latitude, longitude, founded_year, is_partner, phone, email, is_deleted, created_at, countries!inner(name), regions!inner(name)')
          .single();
      debugPrint(response.toString());

      return Winery.fromJson(response);
    } catch (e, st) {
      debugPrint('Error updating winery in repository: $e');
      debugPrint('Stack trace: $st');
      rethrow;
    }
  }

 Future<List<Country>> getCountries() async {
    final response = await _supabaseClient
        .from('countries')
        .select('code, name');
    
    return response.map((json) => Country.fromJson(json)).toList();
  }

  Future<void> deleteWinery(String wineryId) async {
    debugPrint('--- ATTEMPTING TO DELETE WINERY WITH ID: $wineryId ---');
    
    try {
      // Сначала удаляем все вина, принадлежащие этой винодельне
      debugPrint('--- DELETING WINES FOR WINERY ID: $wineryId ---');
      final winesResult = await _supabaseClient.from('wines').update({'is_deleted': true}).match({'winery_id': wineryId});
      debugPrint('--- WINES DELETE RESULT: $winesResult ---');

      // Затем удаляем саму винодельню
      debugPrint('--- DELETING WINERY WITH ID: $wineryId ---');
      final wineryResult = await _supabaseClient
          .from('wineries')
          .update({'is_deleted': true})
          .eq('id', wineryId);
      debugPrint('--- WINERY DELETE RESULT: $wineryResult ---');
      
      debugPrint('--- SUCCESSFULLY MARKED WINERY AND ASSOCIATED WINES AS DELETED FOR WINERY ID: $wineryId ---');
    } catch (e) {
      debugPrint('--- ERROR DELETING WINERY WITH ID: $wineryId, ERROR: $e ---');
      rethrow;
    }
  }

 Future<void> deleteWineryFromWineryObject(Winery winery) async {
    if (winery.id == null) {
      throw Exception('Cannot delete winery without ID');
    }
    debugPrint('--- CALLING deleteWinery with ID: ${winery.id} ---');
    await deleteWinery(winery.id!);
 }
   
  Future<List<Region>> getRegions() async {
    final response = await _supabaseClient
        .from('regions')
        .select('id, name, country_code');
    
    return response.map((json) => Region.fromJson(json)).toList();
  }

  Future<void> restoreWinery(String wineryId) async {
    await _supabaseClient
        .from('wineries')
        .update({'is_deleted': false})
        .eq('id', wineryId);
  }
}