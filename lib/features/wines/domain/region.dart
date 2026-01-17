import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/wines/domain/country.dart';

part 'region.freezed.dart';
part 'region.g.dart';

@freezed
abstract class Region with _$Region {
  const factory Region({
    String? id,
    String? name,
    String? countryCode,
    @Default(false) bool isPopular,
    @JsonKey(name: 'countries') Country? country,
  }) = _Region;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
}