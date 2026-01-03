import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'dart:developer';

part 'countries_provider.g.dart';

@riverpod
Future<List<Country>> countriesList(Ref ref) async {
  log('Начало загрузки списка стран');
  
  final supabaseClient = ref.watch(supabaseClientProvider);
  
  // Вызываем новую SQL-функцию, которая возвращает только страны с активными винодельнями
  final stopwatch = Stopwatch()..start();
  final response = await supabaseClient.rpc('get_countries_with_wines').select();
  stopwatch.stop();
  
  log('Получен ответ от RPC-функции за ${stopwatch.elapsedMilliseconds} мс. Количество записей: ${response.length}');
  
  // Преобразуем результат в список стран
  final countries = <Country>[];
  
  for (final item in response) {
    countries.add(
      Country(
        code: item['code'] as String,
        name: item['name'] as String,
      ),
    );
  }
  
  log('Завершена обработка данных. Возвращаем ${countries.length} стран');
  
  return countries;
}