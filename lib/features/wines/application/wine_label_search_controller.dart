import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/data/wines_repository.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/services/wine_label_text_processor.dart';

final wineLabelSearchProvider = FutureProvider.family<List<Wine>, String>((ref, recognizedText) async {
  final processor = WineLabelTextProcessor();
  final extractedData = processor.extractWineData(recognizedText);

  final repository = ref.watch(winesRepositoryProvider);

  // Формируем фильтры на основе извлеченных данных
  final filters = <String, dynamic>{};
  if (extractedData.name != null) filters['name'] = extractedData.name;
  if (extractedData.winery != null) filters['winery'] = extractedData.winery;
  if (extractedData.color != null) filters['color'] = extractedData.color!.name;
  if (extractedData.sugar != null) filters['sugar'] = extractedData.sugar!.name;
  if (extractedData.alcoholLevel != null) filters['alcohol_level'] = extractedData.alcoholLevel;
  if (extractedData.grapeVariety != null) filters['grape_variety'] = extractedData.grapeVariety;
  if (extractedData.vintage != null) filters['vintage'] = extractedData.vintage;

  // Выполняем поиск с фильтрами
  // Для простоты используем уже существующий метод fetchWines, который принимает Map<String, dynamic>
  // В реальности может потребоваться создание нового метода в репозитории для "умного" поиска.
  // Пока реализуем простой поиск по названию, если оно есть.
  if (extractedData.name != null) {
    return repository.searchWines(extractedData.name!);
  } else if (filters.isNotEmpty) {
    // Если нет точного названия, но есть другие данные, можно попробовать RPC-функцию
    // или реализовать сложный поиск в Supabase.
    // Пока возвращаем пустой список, если нет названия.
    // TODO: Реализовать сложный поиск по другим характеристикам.
    return [];
  } else {
    return [];
  }
});