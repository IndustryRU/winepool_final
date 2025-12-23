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

  Future<List<Winery>> fetchAllWineries() async {
    final response = await _supabaseClient
        .from('wineries')
        .select('id, name, country_code, region_id, winemaker, website, description, logo_url, banner_url, location_text, latitude, longitude, founded_year, is_partner, phone, email, created_at, countries!inner(name), regions!inner(name)')
        .order('created_at', ascending: false);
    print(response);

    return response.map((json) => Winery.fromJson(json)).toList();
  }

  Future<Winery> fetchWinery(String wineryId) async {
    final response = await _supabaseClient
        .from('wineries')
        .select('id, name, description, logo_url, banner_url, created_at, countries!inner(name)')
        .eq('id', wineryId)
        .single();
    print(response);

    return Winery.fromJson(response);
  }

  Future<Winery> fetchWineryById(String id) async {
    final data = await _supabaseClient
        .from('wineries')
        .select('*, countries!inner(name), regions!inner(name)')
        .eq('id', id)
        .single();
    print(data);
    return Winery.fromJson(data);
  }
  
  Future<Winery> addWinery(Winery winery) async {
    try {
      print('Начало добавления винодельни: ${winery.name}');
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
          })
          .select('id, name, country_code, region_id, winemaker, website, description, logo_url, banner_url, location_text, latitude, longitude, founded_year, is_partner, phone, email, created_at, countries!inner(name), regions!inner(name)')
          .single();
      print(response);

      print('Завершено добавление винодельни: ${winery.name}');
      return Winery.fromJson(response);
    } catch (e, st) {
      print('Error adding winery in repository: $e');
      print('Stack trace: $st');
      rethrow;
    }
  }

  Future<Winery> updateWinery(Winery winery) async {
    if (winery.id == null) {
      throw Exception('Cannot update winery without ID');
    }
    try {
      print('Начало обновления винодельни: ${winery.name}');
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
          .select('id, name, country_code, region_id, winemaker, website, description, logo_url, banner_url, location_text, latitude, longitude, founded_year, is_partner, phone, email, created_at, countries!inner(name), regions!inner(name)')
          .single();
      print(response);

      return Winery.fromJson(response);
    } catch (e, st) {
      print('Error updating winery in repository: $e');
      print('Stack trace: $st');
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
    // Сначала удаляем все вина, принадлежащие этой винодельне
    await _supabaseClient.from('wines').delete().match({'winery_id': wineryId});

    // Затем удаляем саму винодельню
    await _supabaseClient
        .from('wineries')
        .delete()
        .eq('id', wineryId);
  }

  Future<void> deleteWineryFromWineryObject(Winery winery) async {
    if (winery.id == null) {
      throw Exception('Cannot delete winery without ID');
    }
    await deleteWineryFromWineryObject(winery);
  }
  
  Future<List<Region>> getRegions() async {
    final response = await _supabaseClient
        .from('regions')
        .select('id, name, country_code');
    
    return response.map((json) => Region.fromJson(json)).toList();
  }
}