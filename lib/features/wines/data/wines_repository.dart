import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import '../domain/wine.dart';
import '../domain/wine_characteristics.dart';
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
        .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
        .order('created_at', ascending: false);

    final response = await query;
    debugPrint('--- SUPABASE RESPONSE ---');
    debugPrint(response.toString());
    debugPrint('--- END OF SUPABASE RESPONSE ---');

    final List<dynamic> data = response as List<dynamic>;

    // Отфильтруем на клиенте, если includeDeleted = false
    if (!includeDeleted) {
      final filteredResponse = data.where((item) => item['is_deleted'] == false).toList();
      debugPrint('Filtered response length: ${filteredResponse.length}');
      return filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
    }
    
    return data.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
  }

 Future<List<Wine>> fetchAllWinesNoFilter({bool includeDeleted = false}) async {
    var query = _supabaseClient
        .from('wines')
        .select('*, wineries(*, country:countries(*)), grape_varieties(*)');

    final response = await query;
    final List<dynamic> data = response as List<dynamic>;
    
    // Отфильтруем на клиенте, если includeDeleted = false
    if (!includeDeleted) {
      final filteredResponse = data.where((item) => item['is_deleted'] == false).toList();
      return filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
    }
    
    return data.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
  }

 Future<Wine> fetchWine(String wineId) async {
    // Загружаем вино и его сорта винограда
    final response = await _supabaseClient
        .from('wines')
        .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
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
    final List<dynamic> data = response as List<dynamic>;
    return data.map((json) => json['grape_variety_id'] as String).toList();
  }

  Future<List<Wine>> fetchWinesByWinery(String wineryId, {bool includeDeleted = false}) async {
    var query = _supabaseClient
        .from('wines')
        .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
        .eq('winery_id', wineryId);

    final response = await query;
    debugPrint('--- FETCH WINES BY WINERY RESPONSE ---');
    debugPrint(response.toString());
    debugPrint('--- END FETCH WINES BY WINERY RESPONSE ---');
    
    final List<dynamic> data = response as List<dynamic>;
    
    // Отфильтруем на клиенте, если includeDeleted = false
    final filteredResponse = !includeDeleted 
        ? data.where((item) => item['is_deleted'] == false).toList()
        : data;
    
    // Для каждого вина загружаем его сорта винограда
    final wines = filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
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
              .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
              .order('average_rating', ascending: false)
              .limit(10);

          final response = await query;
          debugPrint('--- FETCH POPULAR WINES RESPONSE ---');
          debugPrint(response.toString());
          debugPrint('--- END FETCH POPULAR WINES RESPONSE ---');
          
          final List<dynamic> data = response as List<dynamic>;
          
          // Отфильтруем на клиенте, если includeDeleted = false
          final filteredResponse = !includeDeleted 
              ? data.where((item) => item['is_deleted'] == false).toList()
              : data;
          
          // Для каждого вина загружаем его сорта винограда
          final wines = filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
          final updatedWines = <Wine>[];

          for (final wine in wines) {
            if (wine.id != null) {
              final grapeVarietyIds = await _getGrapeVarietyIdsForWine(wine.id!);
              updatedWines.add(wine.copyWith(grapeVarietyIds: grapeVarietyIds));
            }
          }

          return updatedWines;
        }

       Future<List<Wine>> fetchNewWines({bool includeDeleted = false}) async {
          var query = _supabaseClient
              .from('wines')
              .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
              .order('created_at', ascending: false)
              .limit(10);

          final response = await query;
          debugPrint('--- FETCH NEW WINES RESPONSE ---');
          debugPrint(response.toString());
          debugPrint('--- END FETCH NEW WINES RESPONSE ---');
          
          final List<dynamic> data = response as List<dynamic>;
          
          // Отфильтруем на клиенте, если includeDeleted = false
          final filteredResponse = !includeDeleted 
              ? data.where((item) => item['is_deleted'] == false).toList()
              : data;
          
          // Для каждого вина загружаем его сорта винограда
          final wines = filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
          final updatedWines = <Wine>[];

          for (final wine in wines) {
            if (wine.id != null) {
              final grapeVarietyIds = await _getGrapeVarietyIdsForWine(wine.id!);
              updatedWines.add(wine.copyWith(grapeVarietyIds: grapeVarietyIds));
            }
          }

          return updatedWines;
        }

       Future<List<Wine>> searchWines(String query, {bool includeDeleted = false}) async {
          var queryBuilder = _supabaseClient
              .from('wines')
              .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
              .ilike('name', '%$query%');

          final response = await queryBuilder;
          debugPrint('--- SEARCH WINES RESPONSE ---');
          debugPrint(response.toString());
          debugPrint('--- END SEARCH WINES RESPONSE ---');
          
          final List<dynamic> data = response as List<dynamic>;
          
          // Отфильтруем на клиенте, если includeDeleted = false
          if (!includeDeleted) {
            final filteredResponse = data.where((item) => item['is_deleted'] == false).toList();
            return filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
          }
          
          return data.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
        }

       Future<List<Wine>> fetchWinesWithFilters({
         List<WineColor>? color,
         List<WineType>? type,
         List<WineSugar>? sugar,
         double? minPrice,
         double? maxPrice,
         List<String>? country,
         List<String>? region,
         List<String>? grapeIds,
         List<String>? wineryIds,
         double? minRating,
         List<String>? bottleSizeIds,
         List<int>? vintages,
         bool showUnavailable = false,
         String? sortOption,
         bool includeDeleted = false,
       }) async {
         color = color ?? [];
         type = type ?? [];
         sugar = sugar ?? [];
         country = country ?? [];
         region = region ?? [];
         grapeIds = grapeIds ?? [];
         wineryIds = wineryIds ?? [];
         bottleSizeIds = bottleSizeIds ?? [];
         vintages = vintages ?? [];

         log('WinesRepository: Fetching with wineryIds: $wineryIds');
         try {
           debugPrint('--- FETCH WINES CALLED WITH FILTERS ---');
           
           dynamic query = _supabaseClient
               .from('wines')
               .select('*, wineries(*, country:countries(*)), grape_varieties(*), offers!inner(*)');

           // Преобразуем enum-ы в строки для фильтрации
           if (color.isNotEmpty) {
             final colorStrings = color.map((c) => c.name).toList();
             query = query.inFilter('color', colorStrings);
           }
           if (type.isNotEmpty) {
             final typeStrings = type.map((t) => t.name).toList();
             query = query.inFilter('type', typeStrings);
           }
           if (sugar.isNotEmpty) {
             final sugarStrings = sugar.map((s) => s.toDbValue()).toList();
             query = query.inFilter('sugar', sugarStrings);
           }
           if (minPrice != null) {
             query = query.gte('offers.price', minPrice);
           }
           if (maxPrice != null) {
             query = query.lte('offers.price', maxPrice);
           }
           if (country.isNotEmpty) {
             query = query.inFilter('wineries.country_code', country);
           }
           if (region.isNotEmpty) {
             query = query.inFilter('wineries.region', region);
           }
           if (wineryIds.isNotEmpty) {
             query = query.inFilter('winery_id', wineryIds);
           }
           if (grapeIds.isNotEmpty) {
             final wineGrapeVarietyResponse = await _supabaseClient
                 .from('wine_grape_varieties')
                 .select('wine_id')
                 .inFilter('grape_variety_id', grapeIds);
             
             if (wineGrapeVarietyResponse.isNotEmpty) {
                final List<dynamic> data = wineGrapeVarietyResponse as List<dynamic>;
                final wineIds = data.map((item) => item['wine_id'] as String).toList();
                query = query.inFilter('id', wineIds);
             } else {
               return [];
             }
           }
           if (minRating != null) {
             query = query.gte('average_rating', minRating);
           }
           if (bottleSizeIds.isNotEmpty) {
             query = query.inFilter('offers.bottle_size_id', bottleSizeIds);
           }
           
           if (vintages.isNotEmpty) {
             final offersResponse = await _supabaseClient
                 .from('offers')
                 .select('wine_id')
                 .inFilter('vintage', vintages);
             
             final List<dynamic> offersData = offersResponse as List<dynamic>;
             if (offersData.isNotEmpty) {
               final wineIds = offersData.map((item) => item['wine_id'] as String).toSet().toList();
               query = query.inFilter('id', wineIds);
             } else {
               // Если нет предложений с таким винтажом, возвращаем пустой список
               return [];
             }
           }
           
           if (!showUnavailable) {
             // query = query.eq('is_available', true);
           }

           if (sortOption != null) {
             switch (sortOption) {
               case 'popular':
                 query = query.order('average_rating', ascending: false);
                 break;
               case 'newest':
                 query = query.order('created_at', ascending: false);
                 break;
               case 'price_asc':
                 query = query.order('offers.price', ascending: true);
                 break;
               case 'price_desc':
                 query = query.order('offers.price', ascending: false);
                 break;
               case 'rating_desc':
                 query = query.order('average_rating', ascending: false);
                 break;
             }
           } else {
             query = query.order('created_at', ascending: false);
           }

           final response = await query;

           final List<dynamic> data = response as List<dynamic>;

           if (!includeDeleted) {
             final filteredResponse = data.where((item) => item['is_deleted'] == false).toList();
             return filteredResponse.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
           }
           
           return data.map((e) => Wine.fromJson(e as Map<String, dynamic>)).toList();
         } catch (e) {
           debugPrint('Error in fetchWinesWithFilters: $e');
           rethrow;
         }
       }

       Future<Map<String, dynamic>> searchAll(String query, [Set<String> categories = const {}, bool includeDeleted = false]) async {
         final searchCategories = categories.isEmpty
             ? ['wines_name', 'wines_grape_variety', 'wineries_name'] // По умолчанию все категории
             : categories.toList();
         
         try {
           final Map<String, dynamic> result = {'wines': [], 'wineries': []};
           
           // Поиск по винам (по названию)
           if (searchCategories.contains('wines_name')) {
             final wineResults = await _supabaseClient
                 .from('wines')
                 .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
                 .ilike('name', '%$query%')
                 .limit(10);
             
             result['wines'] = wineResults;
           }
           
           // Поиск по сортам винограда
           if (searchCategories.contains('wines_grape_variety')) {
             // Сначала находим ID сортов винограда, соответствующих запросу
             final grapeVarietyResults = await _supabaseClient
                 .from('grape_varieties')
                 .select('id')
                 .ilike('name', '%$query%');
             
             if (grapeVarietyResults.isNotEmpty) {
               final List<String> grapeVarietyIds = grapeVarietyResults
                   .map((item) => item['id'] as String)
                   .toList();
               
               // Затем находим вина, связанные с этими сортами
               final wineResults = await _supabaseClient
                   .from('wines')
                   .select('*, wineries(*, country:countries(*)), grape_varieties(*)')
                   .inFilter('id', await _getWineIdsByGrapeVarietyIds(grapeVarietyIds))
                   .limit(10);
               
               // Добавляем только уникальные вина
               final List<dynamic> existingWineIds = result['wines'].map((w) => w['id']).toList();
               for (final wine in wineResults) {
                 if (!existingWineIds.contains(wine['id'])) {
                   result['wines'].add(wine);
                 }
               }
             }
           }
           
           // Поиск по винодельням
           if (searchCategories.contains('wineries_name')) {
             final wineryResults = await _supabaseClient
                 .from('wineries')
                 .select('*, country:country_code(*)')
                 .ilike('name', '%$query%')
                 .limit(10);
             
             result['wineries'] = wineryResults;
           }
           
           debugPrint('--- SEARCH ALL RESPONSE ---');
           debugPrint(result.toString());
           debugPrint('--- END SEARCH ALL RESPONSE ---');
           
           return result;
         } catch (e) {
           log('Error in searchAll: $e');
           rethrow;
         }
       }
       
       Future<List<String>> _getWineIdsByGrapeVarietyIds(List<String> grapeVarietyIds) async {
         final response = await _supabaseClient
             .from('wine_grape_varieties')
             .select('wine_id')
             .inFilter('grape_variety_id', grapeVarietyIds);
         
         final List<dynamic> data = response as List<dynamic>;
         return data.map((item) => item['wine_id'] as String).toList();
       }

       Future<void> restoreWine(String wineId) async {
         await _supabaseClient
             .from('wines')
             .update({'is_deleted': false})
             .eq('id', wineId);
       }
}
