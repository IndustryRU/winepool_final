// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grape_variety.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GrapeVariety _$GrapeVarietyFromJson(Map<String, dynamic> json) =>
    _GrapeVariety(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      originRegion: json['origin_region'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      isPopular: json['is_popular'] as bool? ?? false,
    );

Map<String, dynamic> _$GrapeVarietyToJson(_GrapeVariety instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'origin_region': instance.originRegion,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'is_popular': instance.isPopular,
    };
