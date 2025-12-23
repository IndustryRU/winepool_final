import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:winepool_final/features/wines/domain/region.dart';

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
    @JsonKey(name: 'region_id') String? regionId,
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'latitude') double? latitude,
    @JsonKey(name: 'longitude') double? longitude,
    @JsonKey(name: 'founded_year') int? foundedYear,
    @JsonKey(name: 'is_partner') bool? isPartner,
    @JsonKey(name: 'phone') String? phone,
    @JsonKey(name: 'email') String? email,
    @JsonKey(name: 'country', fromJson: _countryFromJson) Country? country,
    @JsonKey(name: 'region', fromJson: _regionFromJson) Region? regionObject,
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

Region? _regionFromJson(dynamic json) {
  if (json == null) return null;

  // Проверяем, является ли json строкой (region_id)
  if (json is String) {
    // Создаем объект Region с id региона
    // Имя региона будет недоступно при десериализации из строки
    return Region(id: json, name: '', countryCode: '');
  }

  if (json is Map<String, dynamic>) {
    return Region.fromJson(json);
  }
  
  if (json is List<dynamic> && json.isNotEmpty) {
    final firstElement = json.first;
    if (firstElement is Map<String, dynamic>) {
      return Region.fromJson(firstElement);
    }
  }

  return null;
}

// Расширение для удобного доступа к информации о стране
extension WineryCountryExtension on Winery {
  String? get countryName => country?.name ?? countryCode;
  String? get countryCodeFromCountry => country?.code ?? countryCode;
}

// Расширение для удобного доступа к информации о регионе
extension WineryRegionExtension on Winery {
  String? get regionName => regionObject?.name;
  String? get regionIdFromRegion => regionObject?.id ?? regionId;
}
