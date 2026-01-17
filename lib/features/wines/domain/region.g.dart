// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Region _$RegionFromJson(Map<String, dynamic> json) => _Region(
  id: json['id'] as String?,
  name: json['name'] as String?,
  countryCode: json['countryCode'] as String?,
  isPopular: json['isPopular'] as bool? ?? false,
  country: json['countries'] == null
      ? null
      : Country.fromJson(json['countries'] as Map<String, dynamic>),
);

Map<String, dynamic> _$RegionToJson(_Region instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'countryCode': instance.countryCode,
  'isPopular': instance.isPopular,
  'countries': instance.country,
};
