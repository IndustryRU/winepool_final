import 'package:freezed_annotation/freezed_annotation.dart';

part 'grape_variety.freezed.dart';
part 'grape_variety.g.dart';

@freezed
abstract class GrapeVariety with _$GrapeVariety {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory GrapeVariety({
    String? id,
    String? name,
    String? description,
    String? originRegion,
    DateTime? createdAt,
    DateTime? updatedAt,
    @Default(false) bool isPopular,
  }) = _GrapeVariety;

  factory GrapeVariety.fromJson(Map<String, dynamic> json) => _$GrapeVarietyFromJson(json);
}