import 'package:freezed_annotation/freezed_annotation.dart';

part 'region.freezed.dart';
part 'region.g.dart';

@freezed
abstract class Region with _$Region {
  const factory Region({
    String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'country_code') String? countryCode,
  }) = _Region;

  factory Region.fromJson(Map<String, dynamic> json) => _$RegionFromJson(json);
}