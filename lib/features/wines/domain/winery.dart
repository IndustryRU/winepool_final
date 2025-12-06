import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/country.dart';

part 'winery.freezed.dart';
part 'winery.g.dart';

@freezed
abstract class Winery with _$Winery {
  const factory Winery({
    String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'banner_url') String? bannerUrl,
    @JsonKey(name: 'winemaker') String? winemaker,
    @JsonKey(name: 'website') String? website,
    @JsonKey(name: 'location_text') String? locationText,
    @JsonKey(name: 'region') String? region,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'country', fromJson: _countryFromJson) Country? country,
  }) = _Winery;

  factory Winery.fromJson(Map<String, dynamic> json) => _$WineryFromJson(json);
}

Country? _countryFromJson(dynamic json) {
  if (json == null) return null;

  // Проверяем, является ли json строкой (country_code)
  if (json is String) {
    // Создаем объект Country с кодом страны
    // Имя страны будет недоступно при десериализации из строки
    return Country(code: json, name: '');
  }

  if (json is Map<String, dynamic>) {
    return Country.fromJson(json);
  }
  
  if (json is List<dynamic> && json.isNotEmpty) {
    final firstElement = json.first;
    if (firstElement is Map<String, dynamic>) {
      return Country.fromJson(firstElement);
    }
  }

  return null;
}

// Расширение для удобного доступа к информации о стране
extension WineryCountryExtension on Winery {
  String? get countryName => country?.name ?? countryCode;
  String? get countryCodeFromCountry => country?.code ?? countryCode;
}
