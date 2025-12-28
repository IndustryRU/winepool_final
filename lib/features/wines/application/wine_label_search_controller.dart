import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/data/wines_repository.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/services/wine_label_text_processor.dart';
import 'package:collection/collection.dart'; // Для метода sorted

final wineLabelSearchProvider = FutureProvider.family<List<Wine>, String>((ref, recognizedText) async {
  final processor = WineLabelTextProcessor();
  final wineLabelData = processor.processText(recognizedText);

  final repository = ref.watch(winesRepositoryProvider);

  // Выполняем многоступенчатую стратегию поиска
  final searchResults = await _multiStageSearch(repository, wineLabelData);

  // Ранжируем результаты
  final rankedResults = _rankResults(searchResults, wineLabelData);

  return rankedResults;
});

/// Многоступенчатая стратегия поиска
Future<List<Wine>> _multiStageSearch(WinesRepository repository, WineLabelData wineLabelData) async {
  List<Wine> results = [];

  // Шаг 1: Поиск по точному совпадению (Highest-Priority Search)
  if (wineLabelData.name != null && wineLabelData.winery != null) {
    // Используем существующий метод searchWines для поиска по названию
    final nameResults = await repository.searchWines(wineLabelData.name!);
    // Фильтруем результаты по производителю
    results = nameResults.where((wine) => 
        wine.winery != null && 
        wine.winery!.name != null &&
        wine.winery!.name!.toLowerCase().contains(wineLabelData.winery!.toLowerCase())
    ).toList();
    if (results.isNotEmpty) {
      return results;
    }
  } else if (wineLabelData.name != null) {
    results = await repository.searchWines(wineLabelData.name!);
    if (results.isNotEmpty) {
      return results;
    }
  }

  // Шаг 2: Полнотекстовый поиск по ключевым сущностям (Full-Text Search)
  // Используем существующий метод searchAll, который поддерживает поиск по нескольким категориям
  // Шаг 2: Полнотекстовый поиск по ВСЕМ ключевым сущностям
  final searchTerms = <String>[];
  if (wineLabelData.name != null) searchTerms.add(wineLabelData.name!);
  if (wineLabelData.winery != null) searchTerms.add(wineLabelData.winery!);
  // Убираем grapeVariety из поиска по searchAll, т.к. она теперь хранится отдельно
  if (wineLabelData.color != null) searchTerms.add(wineLabelData.color!.name);
  if (wineLabelData.sugar != null) searchTerms.add(wineLabelData.sugar!.name);
  
  if (searchTerms.isNotEmpty) {
    try {
      final searchResponse = await repository.searchAll(searchTerms.join(' '));
      final wineResults = searchResponse['wines'] as List<dynamic>?;
      if (wineResults != null) {
        results = wineResults.map((json) => Wine.fromJson(json as Map<String, dynamic>)).toList();
        if (results.isNotEmpty) {
          return results;
        }
      }
    } catch (e) {
      print('SearchAll failed: $e');
    }
  }

  // Шаг 3: Расширенный поиск с фильтрацией (Filtered Search)
  // Используем метод fetchWines с фильтрами
  final filters = <String, dynamic>{};
  // Убираем фильтрацию по grape_variety, т.к. она теперь хранится отдельно и требует JOIN
  if (wineLabelData.vintage != null) filters['vintage'] = wineLabelData.vintage;
  if (wineLabelData.color != null) filters['color'] = wineLabelData.color!.name;
  if (wineLabelData.sugar != null) filters['sugar'] = wineLabelData.sugar!.name;

  if (wineLabelData.name != null) {
    // Сначала ищем по названию, затем применяем фильтры
    final nameResults = await repository.searchWines(wineLabelData.name!);
    results = nameResults.where((wine) {
      bool matches = true;
      // Убираем фильтрацию по grape_variety, т.к. она теперь хранится отдельно
      if (filters['vintage'] != null && wine.vintage != filters['vintage']) {
        matches = false;
      }
      if (filters['color'] != null && wine.color != null && wine.color!.name != filters['color']) {
        matches = false;
      }
      if (filters['sugar'] != null && wine.sugar != null && wine.sugar!.name != filters['sugar']) {
        matches = false;
      }
      return matches;
    }).toList();
    if (results.isNotEmpty) {
      return results;
    }
  }

  if (wineLabelData.winery != null) {
    // Сначала ищем по винодельне, затем применяем фильтры
    // Так как searchWines ищет только по вину, используем searchAll
    try {
      final searchResponse = await repository.searchAll(wineLabelData.winery!);
      final wineResults = searchResponse['wines'] as List<dynamic>?;
      if (wineResults != null) {
        results = wineResults.map((json) => Wine.fromJson(json as Map<String, dynamic>)).toList();
        // Применяем фильтры
        results = results.where((wine) {
          bool matches = true;
          // Убираем фильтрацию по grape_variety, т.к. она теперь хранится отдельно
          if (filters['vintage'] != null && wine.vintage != filters['vintage']) {
            matches = false;
          }
          if (filters['color'] != null && wine.color != null && wine.color!.name != filters['color']) {
            matches = false;
          }
          if (filters['sugar'] != null && wine.sugar != null && wine.sugar!.name != filters['sugar']) {
            matches = false;
          }
          return matches;
        }).toList();
        if (results.isNotEmpty) {
          return results;
        }
      }
    } catch (e) {
      // Если searchAll не сработал, продолжаем с другими методами
      print('SearchAll for winery failed: $e');
    }
  }

  // Шаг 4: Поиск по самому длинному общему подслову (Longest Common Substring)
  // Для этого шага используем потенциальные совпадения
  if (wineLabelData.potentialNames != null && wineLabelData.potentialNames!.isNotEmpty) {
    for (final potentialName in wineLabelData.potentialNames!) {
      if (potentialName.length > 4) { // Используем только длинные слова
        results = await repository.searchWines(potentialName);
        if (results.isNotEmpty) {
          return results;
        }
      }
    }
  }

  if (wineLabelData.potentialWineries != null && wineLabelData.potentialWineries!.isNotEmpty) {
    for (final potentialWinery in wineLabelData.potentialWineries!) {
      if (potentialWinery.length > 4) { // Используем только длинные слова
        try {
          final searchResponse = await repository.searchAll(potentialWinery);
          final wineResults = searchResponse['wines'] as List<dynamic>?;
          if (wineResults != null) {
            results = wineResults.map((json) => Wine.fromJson(json as Map<String, dynamic>)).toList();
            if (results.isNotEmpty) {
              return results;
            }
          }
        } catch (e) {
          // Если searchAll не сработал, продолжаем с другими потенциальными винодельнями
          print('SearchAll for potential winery failed: $e');
        }
      }
    }
  }

  // Если ни один из шагов не дал результата, возвращаем пустой список
  return [];
}

/// Система ранжирования результатов
List<Wine> _rankResults(List<Wine> wines, WineLabelData wineLabelData) {
  return wines
      .map((wine) => _calculateRelevanceScore(wine, wineLabelData))
      .toList()
      .sorted((a, b) => b.score.compareTo(a.score))
      .map((scoredWine) => scoredWine.wine)
      .toList();
}

/// Вспомогательный класс для хранения вина с оценкой релевантности
class _ScoredWine {
  final Wine wine;
  final int score;

  _ScoredWine(this.wine, this.score);
}

/// Расчет оценки релевантности для вина
_ScoredWine _calculateRelevanceScore(Wine wine, WineLabelData wineLabelData) {
  int score = 0;

  // Совпадение по названию/производителю
 if (wineLabelData.name != null && wine.name != null) {
    final nameMatch = _calculateStringMatch(wine.name!, wineLabelData.name!);
    if (nameMatch == 100) {
      score += 50; // Точное совпадение
    } else if (nameMatch > 70) {
      score += 30; // Частичное совпадение (все слова)
    } else if (nameMatch > 30) {
      score += 15; // Частичное совпадение (одно из слов)
    }
  }

  if (wineLabelData.winery != null && wine.winery != null && wine.winery!.name != null) {
    final wineryMatch = _calculateStringMatch(wine.winery!.name!, wineLabelData.winery!);
    if (wineryMatch == 100) {
      score += 50; // Точное совпадение
    } else if (wineryMatch > 70) {
      score += 30; // Частичное совпадение (все слова)
    } else if (wineryMatch > 30) {
      score += 15; // Частичное совпадение (одно из слов)
    }
  }

  // Совпадение по сорту винограда - убираем, т.к. поле больше не существует в Wine
  // if (wineLabelData.grapeVariety != null && wine.grapeVariety != null) {
  //   if (wine.grapeVariety!.toLowerCase() == wineLabelData.grapeVariety!.toLowerCase()) {
  //     score += 20;
  //   }
  // }

  // Совпадение по году урожая
  if (wineLabelData.vintage != null && wine.vintage != null) {
    if (wine.vintage == wineLabelData.vintage) {
      score += 10;
    }
  }

  // Совпадение по цвету
  if (wineLabelData.color != null && wine.color != null) {
    if (wine.color == wineLabelData.color) {
      score += 5;
    } else {
      score -= 10; // Штраф за несовпадение
    }
  }

  // Совпадение по сахару
  if (wineLabelData.sugar != null && wine.sugar != null) {
    if (wine.sugar == wineLabelData.sugar) {
      score += 5;
    } else {
      score -= 10; // Штраф за несовпадение
    }
 }

  return _ScoredWine(wine, score);
}

/// Расчет процента совпадения строк
int _calculateStringMatch(String str1, String str2) {
  final words1 = str1.toLowerCase().split(RegExp(r'\s+'));
  final words2 = str2.toLowerCase().split(RegExp(r'\s+'));

  int matches = 0;
 for (final word in words1) {
    if (words2.contains(word)) {
      matches++;
    }
  }

  if (matches == 0) return 0;
 if (matches == words1.length && matches == words2.length) return 100; // Точное совпадение

  return (matches / words1.length).clamp(0.0, 1.0) * 100 ~/ 1;
}