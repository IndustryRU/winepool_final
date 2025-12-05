import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'wine_characteristics.dart';

part 'wine.freezed.dart';
part 'wine.g.dart';

/// Конвертирует значение в String, если это int.
String? _valueToString(dynamic value) {
  if (value is int) {
    return value.toString();
  }
  return value as String?;
}

/// Функция для десериализации вложенной модели Winery
Winery? _wineryFromJson(dynamic json) {
  print('Winery JSON: $json'); // Добавляем вывод для отладки
  if (json == null) return null;
  if (json is String) {
    // Если приходит строка, пытаемся распарсить как JSON
    try {
      final jsonData = jsonDecode(json);
      if (jsonData is Map<String, dynamic>) {
        return Winery.fromJson(jsonData);
      }
    } catch (e) {
      print('Ошибка парсинга winery JSON: $e');
    }
  } else if (json is Map<String, dynamic>) {
    return Winery.fromJson(json as Map<String, dynamic>);
  }
  return null;
}

/// Функции для преобразования enum значений в строку и обратно

// WineColor
String? _wineColorToString(WineColor? color) => color?.name;
WineColor? _stringToWineColor(String? color) {
  if (color == null) return null;
  try {
    return WineColor.values.byName(color);
  } catch (e) {
    return WineColor.unknown;
  }
}

// WineType
String? _wineTypeToString(WineType? type) => type?.name;
WineType? _stringToWineType(String? type) {
  if (type == null) return null;
  try {
    return WineType.values.byName(type);
  } catch (e) {
    return WineType.unknown;
  }
}

// WineSugar
String? _wineSugarToString(WineSugar? sugar) => sugar?.name;
WineSugar? _stringToWineSugar(String? sugar) {
  if (sugar == null) return null;
  try {
    return WineSugar.values.byName(sugar);
  } catch (e) {
    return WineSugar.unknown;
  }
}

@freezed
abstract class Wine with _$Wine {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory Wine({
    @JsonKey(includeIfNull: false) String? id,
    @JsonKey(name: 'winery_id', includeIfNull: false) String? wineryId,
    @JsonKey(
      name: 'wineries',
      includeToJson: false,
      fromJson: _wineryFromJson,
    )
    Winery? winery,
    required String name,
    String? description,
    String? grapeVariety,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(
      unknownEnumValue: WineColor.unknown,
      fromJson: _stringToWineColor,
      toJson: _wineColorToString,
    )
    WineColor? color,
    @JsonKey(
      unknownEnumValue: WineType.unknown,
      fromJson: _stringToWineType,
      toJson: _wineTypeToString,
    )
    WineType? type,
    @JsonKey(
      unknownEnumValue: WineSugar.unknown,
      fromJson: _stringToWineSugar,
      toJson: _wineSugarToString,
    )
    WineSugar? sugar,
    int? vintage,
    @JsonKey(name: 'alcohol_level') double? alcoholLevel,
    double? rating,
    @JsonKey(name: 'average_rating') double? averageRating,
    @JsonKey(name: 'reviews_count') int? reviewsCount,
    @JsonKey(name: 'serving_temperature') String? servingTemperature,
    @JsonKey(name: 'sweetness') int? sweetness,
    @JsonKey(name: 'acidity') int? acidity,
    @JsonKey(name: 'tannins') int? tannins,
    @JsonKey(name: 'saturation') int? saturation,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
    @JsonKey(name: 'is_deleted') @Default(false) bool isDeleted,
  }) = _Wine;

  factory Wine.fromJson(Map<String, dynamic> json) => _$WineFromJson(json);
}
