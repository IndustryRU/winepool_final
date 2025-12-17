import 'package:freezed_annotation/freezed_annotation.dart';

part 'analytics_models.freezed.dart';
part 'analytics_models.g.dart';

@freezed
abstract class AnalyticsData with _$AnalyticsData {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory AnalyticsData({
    required List<TopVariety> topVarieties,
    required List<TopCountry> topCountries,
    required double? averageRating,
    required TasteWeb? tasteWeb,
  }) = _AnalyticsData;

  factory AnalyticsData.fromJson(Map<String, dynamic> json) =>
      _$AnalyticsDataFromJson(json);
}

@freezed
abstract class TopVariety with _$TopVariety {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TopVariety({
    String? grapeVariety,
    required int count,
  }) = _TopVariety;

  factory TopVariety.fromJson(Map<String, dynamic> json) =>
      _$TopVarietyFromJson(json);
}

@freezed
abstract class TopCountry with _$TopCountry {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TopCountry({
    String? countryName,
    required int count,
  }) = _TopCountry;

  factory TopCountry.fromJson(Map<String, dynamic> json) =>
      _$TopCountryFromJson(json);
}

@freezed
abstract class TasteWeb with _$TasteWeb {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory TasteWeb({
    required double? sweetness,
    required double? acidity,
    required double? tannins,
    required double? saturation,
  }) = _TasteWeb;

  factory TasteWeb.fromJson(Map<String, dynamic> json) =>
      _$TasteWebFromJson(json);
}