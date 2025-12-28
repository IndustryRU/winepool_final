import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import '../domain/wine.dart';
import '../../../core/providers.dart';

final winesRepositoryProvider = Provider<WinesRepository>((ref) {
  return WinesRepository(ref.read(supabaseClientProvider));
});

class WinesRepository {
  final SupabaseClient _supabaseClient;

 WinesRepository(this._supabaseClient);

  Future<List<Wine>> fetchAllWines({bool includeDeleted = false}) async {
    debugPrint('--- FETCHING ALL WINES FROM SUPABASE ---');
    var query = _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .order('created_at', ascending: false);

    final response = await query;
    debugPrint('--- SUPABASE RESPONSE ---');
    debugPrint(response.toString());
    debugPrint('--- END OF SUPABASE RESPONSE ---');

    // Отфильтруем на клиенте, если includeDeleted = false
    if (!includeDeleted) {
      final filteredResponse = response.where((item) => item['is_deleted'] == false).toList();
      debugPrint('Filtered response length: ${filteredResponse.length}');
      return filteredResponse.map((json) => Wine.fromJson(json)).toList();
    }
    
    return response.map((json) => Wine.fromJson(json)).toList();
  }

  Future<List<Wine>> fetchAllWinesNoFilter({bool includeDeleted = false}) async {
    var query = _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))');

    final response = await query;
    
    // Отфильтруем на клиенте, если includeDeleted = false
    if (!includeDeleted) {
      final filteredResponse = response.where((item) => item['is_deleted'] == false).toList();
      return filteredResponse.map((json) => Wine.fromJson(json)).toList();
    }
    
    return response.map((json) => Wine.fromJson(json)).toList();
 }

  Future<Wine> fetchWine(String wineId) async {
    // Загружаем вино и его сорта винограда
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .eq('id', wineId)
        .eq('is_deleted', false)
        .single();
    debugPrint('--- FETCH WINE RESPONSE ---');
    debugPrint(response.toString());
    debugPrint('--- END FETCH WINE RESPONSE ---');

    // Загружаем сорта винограда для этого вина
    final grapeVarietyIds = await _getGrapeVarietyIdsForWine(wineId);
    final wine = Wine.fromJson(response);
    return wine.copyWith(grapeVarietyIds: grapeVarietyIds);
  }

  Future<List<String>> _getGrapeVarietyIdsForWine(String wineId) async {
    final response = await _supabaseClient
        .from('wine_grape_varieties')
        .select('grape_variety_id')
        .eq('wine_id', wineId);
    return response.map((json) => json['grape_variety_id'] as String).toList();
  }

  Future<List<Wine>> fetchWinesByWinery(String wineryId, {bool includeDeleted = false}) async {
    var query = _supabaseClient
        .from('wines')
        .select('*, wineries:winery_id(*, country:country_code(*))')
        .eq('winery_id', wineryId);

    final response = await query;
    debugPrint('--- FETCH WINES BY WINERY RESPONSE ---');
    debugPrint(response.toString());
    debugPrint('--- END FETCH WINES BY WINERY RESPONSE ---');
    
    // Отфильтруем на клиенте, если includeDeleted = false
    final filteredResponse = !includeDeleted 
        ? response.where((item) => item['is_deleted'] == false).toList()
        : response;
    
    // Для каждого вина загружаем его сорта винограда
    final wines = filteredResponse.map((json) => Wine.fromJson(json)).toList();
    final updatedWines = <Wine>[];

    for (final wine in wines) {
      if (wine.id != null) {
        final grapeVarietyIds = await _getGrapeVarietyIdsForWine(wine.id!);
        updatedWines.add(wine.copyWith(grapeVarietyIds: grapeVarietyIds));
      }
    }

    return updatedWines;
  }

 Future<void> addWine(Wine wine) async {
    try {
      // Вставляем вино
      final wineJson = wine.toJson();
      wineJson.remove('grape_variety_ids'); // Удаляем поле, так как оно хранится в отдельной таблице
      final response = await _supabaseClient.from('wines').insert([wineJson]).select().single();
      final newWineId = response['id'] as String;
      
      // Добавляем связи с сортами винограда, если они есть
      if (wine.grapeVarietyIds != null && wine.grapeVarietyIds!.isNotEmpty) {
        await _updateGrapeVarietyAssociations(newWineId, wine.grapeVarietyIds!);
      }
    } catch (e) {
      debugPrint('Error in addWine: $e');
      rethrow;
    }
 }

    Future<void> _updateGrapeVarietyAssociations(String wineId, List<String> grapeVarietyIds) async {
      // Сначала удаляем все существующие связи
      await _supabaseClient.from('wine_grape_varieties').delete().eq('wine_id', wineId);
      
      // Затем добавляем новые связи
      if (grapeVarietyIds.isNotEmpty) {
        final associations = grapeVarietyIds.map((grapeId) => {
          'wine_id': wineId,
          'grape_variety_id': grapeId,
        }).toList();
        
        await _supabaseClient.from('wine_grape_varieties').insert(associations);
      }
    }

    Future<void> updateWine(Wine wine) async {
      if (wine.id == null) {
        throw Exception('Cannot update wine without ID');
      }
      
      // Обновляем основную информацию о вине
      final wineJson = wine.toJson();
      wineJson.remove('grape_variety_ids'); // Удаляем поле, так как оно хранится в отдельной таблице
      await _supabaseClient.from('wines').update(wineJson).match({'id': wine.id!});
      
      // Обновляем связи с сортами винограда
      if (wine.grapeVarietyIds != null) {
        await _updateGrapeVarietyAssociations(wine.id!, wine.grapeVarietyIds!);
      }
    }

    Future<void> deleteWine(String wineId) async {
      debugPrint('--- ATTEMPTING TO DELETE WINE WITH ID: $wineId ---');
      
      try {
        // Устанавливаем флаг is_deleted в true вместо физического удаления
        debugPrint('--- UPDATING WINE RECORD WITH is_deleted = true FOR WINE ID: $wineId ---');
        final wineResult = await _supabaseClient.from('wines').update({'is_deleted': true}).match({'id': wineId});
        debugPrint('--- WINE RECORD UPDATE RESULT: $wineResult ---');
        
        debugPrint('--- SUCCESSFULLY MARKED WINE AS DELETED WITH ID: $wineId ---');
      } catch (e) {
        debugPrint('--- ERROR MARKING WINE AS DELETED WITH ID: $wineId, ERROR: $e ---');
        rethrow;
      }
    }

   Future<List<Wine>> fetchPopularWines({bool includeDeleted = false}) async {
      var query = _supabaseClient
          .from('wines')
          .select('*, wineries:winery_id(*, country:country_code(*))')
          .order('average_rating', ascending: false)
          .limit(10);

      final response = await query;
      debugPrint('--- FETCH POPULAR WINES RESPONSE ---');
      debugPrint(response.toString());
      debugPrint('--- END FETCH POPULAR WINES RESPONSE ---');
      
      // Отфильтруем на клиенте, если includeDeleted = false
      if (!includeDeleted) {
        final filteredResponse = response.where((item) => item['is_deleted'] == false).toList();
        return filteredResponse.map((json) => Wine.fromJson(json)).toList();
      }
      
      return response.map((json) => Wine.fromJson(json)).toList();
    }

    Future<List<Wine>> fetchNewWines({bool includeDeleted = false}) async {
      var query = _supabaseClient
          .from('wines')
          .select('*, wineries:winery_id(*, country:country_code(*))')
          .order('created_at', ascending: false)
          .limit(10);

      final response = await query;
      debugPrint('--- FETCH NEW WINES RESPONSE ---');
      debugPrint(response.toString());
      debugPrint('--- END FETCH NEW WINES RESPONSE ---');
      
      // Отфильтруем на клиенте, если includeDeleted = false
      if (!includeDeleted) {
        final filteredResponse = response.where((item) => item['is_deleted'] == false).toList();
        return filteredResponse.map((json) => Wine.fromJson(json)).toList();
      }
      
      return response.map((json) => Wine.fromJson(json)).toList();
    }

    Future<List<Wine>> searchWines(String query, {bool includeDeleted = false}) async {
      var queryBuilder = _supabaseClient
          .from('wines')
          .select('*, wineries:winery_id(*, country:country_code(*))')
          .ilike('name', '%$query%');

      final response = await queryBuilder;
      debugPrint('--- SEARCH WINES RESPONSE ---');
      debugPrint(response.toString());
      debugPrint('--- END SEARCH WINES RESPONSE ---');
      
      // Отфильтруем на клиенте, если includeDeleted = false
      if (!includeDeleted) {
        final filteredResponse = response.where((item) => item['is_deleted'] == false).toList();
        return filteredResponse.map((json) => Wine.fromJson(json)).toList();
      }
      
      return response.map((json) => Wine.fromJson(json)).toList();
    }

    Future<List<Wine>> fetchWines(Map<String, dynamic> filters, {bool includeDeleted = false}) async {
      try {
        debugPrint('--- FETCH WINES CALLED WITH FILTERS ---');
        debugPrint('Filters: $filters');
        
        // Проверяем, есть ли в фильтрах параметры цены
        if (filters.containsKey('min_price')) {
          debugPrint('Min price: ${filters['min_price']}');
        }
        if (filters.containsKey('max_price')) {
          debugPrint('Max price: ${filters['max_price']}');
        }
        
        // Вызываем RPC-функцию с фильтрами
        final response = await _supabaseClient.rpc('get_wines_with_prices', params: {
          'filters': filters,
        });

        debugPrint('--- FETCH WINES WITH RPC RESPONSE ---');
        debugPrint(response.toString());
        debugPrint('--- END FETCH WINES WITH RPC RESPONSE ---');

        // Обрабатываем результат, так как теперь мы получаем JSONB-объекты
        final List<dynamic> results = response as List<dynamic>;
        final processedResponse = results.map((item) {
          if (item is Map<String, dynamic>) {
            // Извлекаем данные из поля 'result', которое возвращает наша функция
            return item['result'] as Map<String, dynamic>;
          } else if (item is Map<String, dynamic> && item.containsKey('result')) {
            return (item['result'] as Map<String, dynamic>?) ?? {};
          } else {
            // Если структура отличается, возвращаем как есть
            return item is Map<String, dynamic> ? item : {};
          }
        }).whereType<Map<String, dynamic>>().toList();

        // Отфильтруем на клиенте, если includeDeleted = false
        if (!includeDeleted) {
          final filteredResponse = processedResponse.where((item) => item['is_deleted'] == false).toList();
          return filteredResponse.map((json) => Wine.fromJson(json)).toList();
        }
        
        return processedResponse.map((json) => Wine.fromJson(json)).toList();
      } catch (e) {
        debugPrint('Error in fetchWines: $e');
        rethrow;
      }
   }

    Future<Map<String, dynamic>> searchAll(String query, [Set<String> categories = const {}, bool includeDeleted = false]) async {
      final searchCategories = categories.isEmpty
          ? ['wines_name', 'wines_grape_variety', 'wineries_name'] // По умолчанию все категории
          : categories.toList();
      try {
        final response = await _supabaseClient.rpc('search_all', params: {
          'search_query': query,
          'search_categories': '{${searchCategories.join(',')}}',
        });
        debugPrint(response.toString());
        debugPrint('--- SEARCH ALL RESPONSE ---');
        debugPrint(response.toString());
        debugPrint('--- END SEARCH ALL RESPONSE ---');
        return response as Map<String, dynamic>;
      } catch (e) {
        log('Error in searchAll: $e');
        rethrow;
      }
   }

    Future<void> restoreWine(String wineId) async {
      await _supabaseClient
          .from('wines')
          .update({'is_deleted': false})
          .eq('id', wineId);
    }
  }
