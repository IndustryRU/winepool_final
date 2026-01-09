// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bottle_size.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BottleSize _$BottleSizeFromJson(Map<String, dynamic> json) => _BottleSize(
  id: json['id'] as String?,
  sizeMl: (json['size_ml'] as num?)?.toInt(),
  sizeL: json['size_l'] as String?,
);

Map<String, dynamic> _$BottleSizeToJson(_BottleSize instance) =>
    <String, dynamic>{
      'id': instance.id,
      'size_ml': instance.sizeMl,
      'size_l': instance.sizeL,
    };
