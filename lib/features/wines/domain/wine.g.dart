// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wine.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Wine _$WineFromJson(Map<String, dynamic> json) => _Wine(
  id: json['id'] as String?,
  wineryId: json['winery_id'] as String?,
  winery: _wineryFromJson(json['wineries']),
  name: json['name'] as String,
  description: json['description'] as String?,
  grapeVariety: json['grape_variety'] as String?,
  imageUrl: json['image_url'] as String?,
  color: _stringToWineColor(json['color'] as String?),
  type: _stringToWineType(json['type'] as String?),
  sugar: _stringToWineSugar(json['sugar'] as String?),
  vintage: (json['vintage'] as num?)?.toInt(),
  alcoholLevel: (json['alcohol_level'] as num?)?.toDouble(),
  rating: (json['rating'] as num?)?.toDouble(),
  averageRating: (json['average_rating'] as num?)?.toDouble(),
  reviewsCount: (json['reviews_count'] as num?)?.toInt(),
  servingTemperature: json['serving_temperature'] as String?,
  sweetness: (json['sweetness'] as num?)?.toInt(),
  acidity: (json['acidity'] as num?)?.toInt(),
  tannins: (json['tannins'] as num?)?.toInt(),
  saturation: (json['saturation'] as num?)?.toInt(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  isDeleted: json['is_deleted'] as bool? ?? false,
);

Map<String, dynamic> _$WineToJson(_Wine instance) => <String, dynamic>{
  'id': ?instance.id,
  'winery_id': ?instance.wineryId,
  'name': instance.name,
  'description': instance.description,
  'grape_variety': instance.grapeVariety,
  'image_url': instance.imageUrl,
  'color': _wineColorToString(instance.color),
  'type': _wineTypeToString(instance.type),
  'sugar': _wineSugarToString(instance.sugar),
  'vintage': instance.vintage,
  'alcohol_level': instance.alcoholLevel,
  'rating': instance.rating,
  'average_rating': instance.averageRating,
  'reviews_count': instance.reviewsCount,
  'serving_temperature': instance.servingTemperature,
  'sweetness': instance.sweetness,
  'acidity': instance.acidity,
  'tannins': instance.tannins,
  'saturation': instance.saturation,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'is_deleted': instance.isDeleted,
};
