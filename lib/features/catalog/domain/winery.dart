import 'package:freezed_annotation/freezed_annotation.dart';

part 'winery.freezed.dart';
part 'winery.g.dart';

@freezed
abstract class Winery with _$Winery {
  const factory Winery({
    String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _Winery;

  factory Winery.fromJson(Map<String, dynamic> json) => _$WineryFromJson(json);
}