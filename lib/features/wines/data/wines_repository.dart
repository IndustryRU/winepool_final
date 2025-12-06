import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/wine.dart';
import '../../../core/providers.dart';

final winesRepositoryProvider = Provider<WinesRepository>((ref) {
  return WinesRepository(ref.read(supabaseClientProvider));
});

class WinesRepository {
  final SupabaseClient _supabaseClient;

  WinesRepository(this._supabaseClient);

  Future<List<Wine>> fetchAllWines() async {
    print('--- FETCHING ALL WINES FROM SUPABASE ---');
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .order('created_at', ascending: false);
    print('--- SUPABASE RESPONSE ---');
    print(response);
    print('--- END OF SUPABASE RESPONSE ---');

    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<List<Wine>> fetchAllWinesNoFilter() async {
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))');
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<Wine> fetchWine(String wineId) async {
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .eq('id', wineId)
        .single();
    print('--- FETCH WINE RESPONSE ---');
    print(response);
    print('--- END FETCH WINE RESPONSE ---');

    return Wine.fromJson(response);
  }

  Future<List<Wine>> fetchWinesByWinery(String wineryId) async {
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .eq('winery_id', wineryId);
    print('--- FETCH WINES BY WINERY RESPONSE ---');
    print(response);
    print('--- END FETCH WINES BY WINERY RESPONSE ---');
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<void> addWine(Wine wine) async {
    await _supabaseClient.from('wines').insert(wine.toJson());
  }

  Future<void> updateWine(Wine wine) async {
    if (wine.id == null) {
      throw Exception('Cannot update wine without ID');
    }
    await _supabaseClient.from('wines').update(wine.toJson()).match({'id': wine.id!});
  }

  Future<void> deleteWine(String wineId) async {
    await _supabaseClient.from('wines').delete().match({'id': wineId});
  }

  Future<List<Wine>> fetchPopularWines() async {
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .order('average_rating', ascending: false)
        .limit(10);
    print('--- FETCH POPULAR WINES RESPONSE ---');
    print(response);
    print('--- END FETCH POPULAR WINES RESPONSE ---');
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<List<Wine>> fetchNewWines() async {
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .order('created_at', ascending: false)
        .limit(10);
    print('--- FETCH NEW WINES RESPONSE ---');
    print(response);
    print('--- END FETCH NEW WINES RESPONSE ---');
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<List<Wine>> searchWines(String query) async {
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .ilike('name', '%$query%');
    print('--- SEARCH WINES RESPONSE ---');
    print(response);
    print('--- END SEARCH WINES RESPONSE ---');
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<List<Wine>> fetchWines(Map<String, dynamic> filters) async {
    var query = _supabaseClient.from('wines').select('*, wineries:winery_id(*, country:country_code(*))');

    // Применяем фильтры
    filters.forEach((key, value) {
      if (value != null) {
        switch (key) {
          case 'color':
            query = query.eq('color', value);
            break;
          case 'type':
            query = query.eq('type', value);
            break;
          case 'sugar':
            query = query.eq('sugar', value);
            break;
          case 'min_price':
            query = query.gte('price', value);
            break;
          case 'max_price':
            query = query.lte('price', value);
            break;
          case 'vintage':
            query = query.eq('vintage', value);
            break;
          case 'min_rating':
            query = query.gte('average_rating', value);
            break;
          case 'max_rating':
            query = query.lte('average_rating', value);
            break;
          case 'winery_id':
            query = query.eq('winery_id', value);
            break;
          // Можно добавить другие фильтры по мере необходимости
        }
      }
    });

    final response = await query;
    print('--- FETCH WINES WITH FILTERS RESPONSE ---');
    print(response);
    print('--- END FETCH WINES WITH FILTERS RESPONSE ---');
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<Map<String, dynamic>> searchAll(String query, [Set<String> categories = const {}]) async {
    final searchCategories = categories.isEmpty
        ? ['wines_name', 'wines_grape_variety', 'wineries_name'] // По умолчанию все категории
        : categories.toList();
    try {
      final response = await _supabaseClient.rpc('search_all', params: {
        'search_query': query,
        'search_categories': searchCategories,
      });
      print('--- SEARCH ALL RESPONSE ---');
      print(response);
      print('--- END SEARCH ALL RESPONSE ---');
      return response as Map<String, dynamic>;
    } catch (e) {
      log('Error in searchAll: $e');
      rethrow;
    }
 }
}