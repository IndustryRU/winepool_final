import 'package:json_annotation/json_annotation.dart';

enum WineColor {
  red,
  white,
  @JsonValue('rosé')
  rose,
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
  @JsonValue('semi-dry')
  semiDry,
  @JsonValue('semi-sweet')
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
      case WineColor.unknown: return 'Неизвестно';
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
      case WineType.unknown: return 'Неизвестно';
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
      case WineSugar.unknown: return 'Неизвестно';
    }
  }
}