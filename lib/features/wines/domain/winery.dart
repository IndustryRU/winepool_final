import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';

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
    @JsonKey(name: 'country_code') String? countryCode,
    @JsonKey(name: 'region') String? region,
    @JsonKey(name: 'countries') Map<String, dynamic>? countries,
  }) = _Winery;

  factory Winery.fromJson(Map<String, dynamic> json) => _$WineryFromJson(json);
}

extension WineryExtension on Winery {
  String? get countryName {
    if (countries != null && countries!['name'] != null) {
      return countries!['name'];
    }
    return null;
  }
}