// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  id: json['id'] as String,
  sellerId: json['seller_id'] as String?,
  wineId: json['wine_id'] as String?,
  price: (json['price'] as num?)?.toDouble(),
  vintage: (json['vintage'] as num?)?.toInt(),
  bottleSize: (json['bottle_size'] as num?)?.toDouble(),
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  isActive: json['is_active'] as bool? ?? true,
  wine: json['wines'] == null
      ? null
      : Wine.fromJson(json['wines'] as Map<String, dynamic>),
  seller: json['profiles'] == null
      ? null
      : Profile.fromJson(json['profiles'] as Map<String, dynamic>),
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'id': instance.id,
  'seller_id': instance.sellerId,
  'wine_id': instance.wineId,
  'price': instance.price,
  'vintage': instance.vintage,
  'bottle_size': instance.bottleSize,
  'created_at': instance.createdAt?.toIso8601String(),
  'is_active': instance.isActive,
};
