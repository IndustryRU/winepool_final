import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';

part 'winery.freezed.dart';
part 'winery.g.dart';

@freezed
abstract class Winery with _$Winery {
  const factory Winery({
    required String id,
    String? name,
    String? description,
    @JsonKey(name: 'logo_url') String? logoUrl,
    @JsonKey(name: 'banner_url') String? bannerUrl,
    String? winemaker,
    String? website,
    @JsonKey(name: 'location_text') String? locationText,
    String? country,
    String? region,
  }) = _Winery;

  factory Winery.fromJson(Map<String, dynamic> json) => _$WineryFromJson(json);
}