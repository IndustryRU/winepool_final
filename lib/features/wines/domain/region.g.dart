// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Region _$RegionFromJson(Map<String, dynamic> json) => _Region(
  id: json['id'] as String?,
  name: json['name'] as String?,
  countryCode: json['country_code'] as String?,
);

Map<String, dynamic> _$RegionToJson(_Region instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'country_code': instance.countryCode,
};
