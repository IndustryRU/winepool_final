import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/core/providers.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/wines/data/wineries_repository.dart';

part 'filter_options_provider.g.dart';

@riverpod
Future<List<Winery>> allWineries(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_wineries');
  return (data as List).map((json) => Winery.fromJson(json)).toList();
}

@riverpod
Future<List<WineColor>> availableColors(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_colors');
  // Supabase возвращает список строк, нам нужно их преобразовать в enum
  return (data as List).map((s) => WineColor.values.byName(s)).toList();
}

@riverpod
Future<List<WineSugar>> availableSugars(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_sugars');
  return (data as List).map((s) => WineSugar.values.firstWhere((e) => e.toDbValue() == s, orElse: () => WineSugar.unknown)).where((s) => s != WineSugar.unknown).toList();
}

@riverpod
Future<List<WineType>> availableTypes(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_types');
  return (data as List).map((s) => WineType.values.byName(s)).toList();
}

@riverpod
Future<List<Winery>> partnerWineries(Ref ref) async {
  // Используем репозиторий, а не прямой вызов rpc
  final wineriesRepository = ref.watch(wineriesRepositoryProvider);
  return wineriesRepository.getPartnerWineries();
}

@riverpod
Future<List<int>> availableVintages(Ref ref) async {
  final client = ref.watch(supabaseClientProvider);
  final data = await client.rpc('get_available_vintages');
  
  // Добавляем проверку и правильный парсинг
  if (data is List) {
    return data.map((item) {
      if (item is int) {
        return item;
      } else if (item is Map && item.containsKey('vintage')) {
        return item['vintage'] as int;
      }
      return 0; // Или другое значение по умолчанию/обработка ошибки
    }).where((v) => v != 0).toList();
  }
  return [];
}