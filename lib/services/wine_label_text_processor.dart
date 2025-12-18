import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

class WineLabelTextProcessor {
  /// Извлекает характеристики вина из распознанного текста.
  ///
  /// Возвращает объект [ExtractedWineData] с извлеченными полями.
  /// Поля могут быть null, если соответствующая информация не найдена.
  ExtractedWineData extractWineData(String recognizedText) {
    final lowerText = recognizedText.toLowerCase();

    String? name = _extractName(lowerText);
    String? winery = _extractWinery(lowerText);
    WineColor? color = _extractColor(lowerText);
    WineSugar? sugar = _extractSugar(lowerText);
    double? alcoholLevel = _extractAlcoholLevel(lowerText);
    String? grapeVariety = _extractGrapeVariety(lowerText);
    int? vintage = _extractVintage(lowerText);

    return ExtractedWineData(
      name: name,
      winery: winery,
      color: color,
      sugar: sugar,
      alcoholLevel: alcoholLevel,
      grapeVariety: grapeVariety,
      vintage: vintage,
    );
  }

  String? _extractName(String text) {
    // Простой пример: ищем первое слово с заглавной буквы после "вино" или "название".
    // Реализация может быть гораздо сложнее, включая NLP.
    final nameMatch = RegExp(r'(?:вино|название|назв\.|prod\.|product:\s*)([A-ZА-ЯЁ][a-zA-Zа-яё\s\-]*)', caseSensitive: false)
        .firstMatch(text);
    return nameMatch?.group(1)?.trim();
  }

  String? _extractWinery(String text) {
    // Пример: ищем текст после "произведено" или "винодельня".
    final wineryMatch = RegExp(r'(?:произведено|винодельня|prod\.|producer:\s*)([A-ZА-ЯЁ][a-zA-Zа-яё\s\-]*)', caseSensitive: false)
        .firstMatch(text);
    return wineryMatch?.group(1)?.trim();
  }

  WineColor? _extractColor(String text) {
    if (text.contains('красн') || text.contains('red')) {
      return WineColor.red;
    } else if (text.contains('бел') || text.contains('white')) {
      return WineColor.white;
    } else if (text.contains('роз') || text.contains('rose')) {
      return WineColor.rose;
    }
    return null;
  }

  WineSugar? _extractSugar(String text) {
    if (text.contains('сух') || text.contains('dry')) {
      return WineSugar.dry;
    } else if (text.contains('полусух') || text.contains('semi-dry')) {
      return WineSugar.semiDry;
    } else if (text.contains('полусладк') || text.contains('semi-sweet')) {
      return WineSugar.semiSweet;
    } else if (text.contains('сладк') || text.contains('sweet')) {
      return WineSugar.sweet;
    }
    return null;
  }

  double? _extractAlcoholLevel(String text) {
    final alcoholMatch = RegExp(r'(\d{1,2}\.\d|\d{1,2})\s*%').firstMatch(text);
    if (alcoholMatch != null) {
      final alcoholStr = alcoholMatch.group(1);
      return double.tryParse(alcoholStr!);
    }
    return null;
  }

  String? _extractGrapeVariety(String text) {
    // Пример: ищем текст после "сорт" или "grape".
    final grapeMatch = RegExp(r'(?:сорт|grape|sort\.?\s*)([a-zA-Zа-яё\s\-]*)', caseSensitive: false)
        .firstMatch(text);
    return grapeMatch?.group(1)?.trim();
  }

  int? _extractVintage(String text) {
    // Ищем 4-значное число, возможно, после "винтаж", "vintage", "année", "millésime".
    final vintageMatch = RegExp(r'(?:винтаж|vintage|année|millésime|\.|\s)\s*(\d{4})', caseSensitive: false)
        .firstMatch(text);
    if (vintageMatch != null) {
      final yearStr = vintageMatch.group(1);
      final year = int.tryParse(yearStr!);
      // Проверяем, что год в разумном диапазоне (например, между 1900 и текущим годом + 1).
      if (year != null && year >= 1900 && year <= DateTime.now().year + 1) {
        return year;
      }
    }
    return null;
  }
}

/// Класс для хранения извлеченных из текста данных о вине.
class ExtractedWineData {
  final String? name;
  final String? winery;
  final WineColor? color;
  final WineSugar? sugar;
  final double? alcoholLevel;
  final String? grapeVariety;
  final int? vintage;

  ExtractedWineData({
    this.name,
    this.winery,
    this.color,
    this.sugar,
    this.alcoholLevel,
    this.grapeVariety,
    this.vintage,
  });

  @override
  String toString() {
    return 'ExtractedWineData{name: $name, winery: $winery, color: $color, sugar: $sugar, alcoholLevel: $alcoholLevel, grapeVariety: $grapeVariety, vintage: $vintage}';
  }
}