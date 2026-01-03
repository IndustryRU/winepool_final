import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/wines/domain/region.dart';
import 'dart:developer';

part 'regions_provider.g.dart';

@riverpod
Future<List<Region>> regionsList(Ref ref, List<String> countryCodes) async {
  log('Начало загрузки списка регионов для стран: $countryCodes');
  
  final supabaseClient = ref.watch(supabaseClientProvider);
  
  try {
    // Вызываем новую SQL-функцию, которая возвращает только регионы с активными винодельнями
    final stopwatch = Stopwatch()..start();
    
    // Выполняем RPC вызов в зависимости от наличия фильтра по странам
    final response = countryCodes.isEmpty
        ? await supabaseClient.rpc('get_regions_with_wines').select()
        : await supabaseClient.rpc(
            'get_regions_by_countries', 
            params: {'country_codes': '{${countryCodes.join(',')}}'}
          ).select();
    
    stopwatch.stop();
    
    log('Получен ответ от RPC-функции за ${stopwatch.elapsedMilliseconds} мс. Количество записей: ${response.length}');
    
    // Добавляем более детальное логирование - выводим сам список регионов
    if (response.isNotEmpty) {
      log('Список полученных регионов:');
      for (int i = 0; i < response.length && i < 10; i++) { // Ограничиваем вывод первыми 10 элементами для читаемости
        final item = response[i];
        log('  - ID: ${item['id']}, Название: ${item['name']}, Код страны: ${item['country_code']}');
      }
      if (response.length > 10) {
        log('  ... и еще ${response.length - 10} регионов');
      }
    } else {
      log('Список регионов пуст');
    }
    
    // Преобразуем результат в список регионов
    final regions = <Region>[];
    
    for (final item in response) {
      regions.add(
        Region(
          id: item['id'].toString(),
          name: item['name'] as String,
          countryCode: item['country_code'] as String,
        ),
      );
    }
    
    log('Завершена обработка данных. Возвращаем ${regions.length} регионов');
    
    return regions;
  } catch (e) {
    log('Ошибка при загрузке регионов: $e');
    rethrow;
  }
}