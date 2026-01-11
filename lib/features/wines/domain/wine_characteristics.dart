import 'package:json_annotation/json_annotation.dart';

enum WineColor {
  red,
  white,
  @JsonValue('rosé')
  rose,
  orange, // Добавляем недостающий цвет
  unknown
}

enum WineType {
  still,
  sparkling,
  fortified,
  unknown
}

enum WineSugar {
  dry,
  @JsonValue('semi_dry') // Вот так!
  semiDry,
  @JsonValue('semi_sweet') // И вот так!
  semiSweet,
  sweet,
  unknown
}

// Для WineColor
extension WineColorExtension on WineColor {
  String get nameRu {
    switch (this) {
      case WineColor.red: return 'Красное';
      case WineColor.white: return 'Белое';
      case WineColor.rose: return 'Розовое';
      case WineColor.orange: return 'Оранжевое';
      case WineColor.unknown: return 'Неизвестный';
    }
  }
}

// Для WineType
extension WineTypeExtension on WineType {
  String get nameRu {
    switch (this) {
      case WineType.still: return 'Тихое';
      case WineType.sparkling: return 'Игристое';
      case WineType.fortified: return 'Крепленое';
      case WineType.unknown: return 'Неизвестный';
    }
  }
}

// Для WineSugar
extension WineSugarExtension on WineSugar {
  String get nameRu {
    switch (this) {
      case WineSugar.dry: return 'Сухое';
      case WineSugar.semiDry: return 'Полусухое';
      case WineSugar.semiSweet: return 'Полусладкое';
      case WineSugar.sweet: return 'Сладкое';
      case WineSugar.unknown: return 'Неизвестный';
    }
  }
}

// Extension для преобразования WineSugar в snake_case для базы данных
extension WineSugarDbExtension on WineSugar {
  String toDbValue() {
    switch (this) {
      case WineSugar.semiDry:
        return 'semi_dry';
      case WineSugar.semiSweet:
        return 'semi_sweet';
      default:
        return this.name;
    }
  }
}