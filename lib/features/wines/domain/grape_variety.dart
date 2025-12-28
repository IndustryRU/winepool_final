import 'package:freezed_annotation/freezed_annotation.dart';

part 'grape_variety.freezed.dart';
part 'grape_variety.g.dart';

@freezed
abstract class GrapeVariety with _$GrapeVariety {
  const factory GrapeVariety({
    String? id,
    @JsonKey(name: 'name') String? name,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _GrapeVariety;

  factory GrapeVariety.fromJson(Map<String, dynamic> json) => _$GrapeVarietyFromJson(json);
}