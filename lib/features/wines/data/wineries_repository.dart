import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/winery.dart';
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
        .select('id, name, country, region, winemaker, website, description, logo_url, banner_url, location_text, created_at')
        .order('created_at', ascending: false);

    return response.map((json) => Winery.fromJson(json)).toList();
  }

  Future<Winery> fetchWinery(String wineryId) async {
    final response = await _supabaseClient
        .from('wineries')
        .select('id, name, description, logo_url, banner_url, created_at')
        .eq('id', wineryId)
        .single();

    return Winery.fromJson(response);
  }

  Future<Winery> fetchWineryById(String id) async {
    final data = await _supabaseClient
        .from('wineries')
        .select()
        .eq('id', id)
        .single();
    return Winery.fromJson(data);
  }
  Future<Winery> addWinery(Winery winery) async {
    print('Начало добавления винодельни: ${winery.name}');
    final response = await _supabaseClient
        .from('wineries')
        .insert({
          'name': winery.name,
          'country': winery.country,
          'region': winery.region,
          'winemaker': winery.winemaker,
          'website': winery.website,
          'description': winery.description,
          'logo_url': winery.logoUrl,
          'banner_url': winery.bannerUrl,
          'location_text': winery.locationText,
        })
        .select('id, name, country, region, winemaker, website, description, logo_url, banner_url, location_text, created_at')
        .single();

    print('Завершено добавление винодельни: ${winery.name}');
    print('Завершено обновление винодельни: ${winery.name}');
    return Winery.fromJson(response);
  }

  Future<Winery> updateWinery(Winery winery) async {
    if (winery.id == null) {
      throw Exception('Cannot update winery without ID');
    }
    print('Начало обновления винодельни: ${winery.name}');
    final response = await _supabaseClient
        .from('wineries')
        .update({
          'name': winery.name,
          'country': winery.country,
          'region': winery.region,
          'winemaker': winery.winemaker,
          'website': winery.website,
          'description': winery.description,
          'logo_url': winery.logoUrl,
          'banner_url': winery.bannerUrl,
          'location_text': winery.locationText,
        })
        .eq('id', winery.id!)
        .select('id, name, country, region, winemaker, website, description, logo_url, banner_url, location_text, created_at')
        .single();

    return Winery.fromJson(response);
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
}