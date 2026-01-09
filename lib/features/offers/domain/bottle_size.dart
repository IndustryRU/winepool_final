import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'bottle_size.freezed.dart';
part 'bottle_size.g.dart';

@freezed
abstract class BottleSize with _$BottleSize {
  const factory BottleSize({
    String? id,
    @JsonKey(name: 'size_ml') int? sizeMl,
    @JsonKey(name: 'size_l') String? sizeL,
  }) = _BottleSize;

  factory BottleSize.fromJson(Map<String, dynamic> json) => _$BottleSizeFromJson(json);
}