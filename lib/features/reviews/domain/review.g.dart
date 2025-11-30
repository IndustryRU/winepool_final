// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Review _$ReviewFromJson(Map<String, dynamic> json) => _Review(
  id: json['id'] as String?,
  wineId: json['wine_id'] as String,
  userId: json['user_id'] as String,
  rating: (json['rating'] as num).toDouble(),
  text: json['text'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$ReviewToJson(_Review instance) => <String, dynamic>{
  'wine_id': instance.wineId,
  'user_id': instance.userId,
  'rating': instance.rating,
  'text': instance.text,
  'created_at': instance.createdAt?.toIso8601String(),
};
