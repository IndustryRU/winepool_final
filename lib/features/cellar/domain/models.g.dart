// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTasting _$UserTastingFromJson(Map<String, dynamic> json) => _UserTasting(
  id: json['id'] as String?,
  userId: json['user_id'] as String?,
  wineId: json['wine_id'] as String?,
  tastingDate: json['tasting_date'] == null
      ? null
      : DateTime.parse(json['tasting_date'] as String),
  rating: (json['rating'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  photoUrl: json['photo_url'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  wine: Wine.fromJson(json['wine'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserTastingToJson(_UserTasting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'wine_id': instance.wineId,
      'tasting_date': instance.tastingDate?.toIso8601String(),
      'rating': instance.rating,
      'notes': instance.notes,
      'photo_url': instance.photoUrl,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'wine': instance.wine,
    };

_UserStorageItem _$UserStorageItemFromJson(Map<String, dynamic> json) =>
    _UserStorageItem(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      wineId: json['wine_id'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      purchasePrice: (json['purchase_price'] as num?)?.toDouble(),
      purchaseDate: json['purchase_date'] == null
          ? null
          : DateTime.parse(json['purchase_date'] as String),
      idealDrinkFrom: (json['ideal_drink_from'] as num?)?.toInt(),
      idealDrinkTo: (json['ideal_drink_to'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      wine: Wine.fromJson(json['wine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserStorageItemToJson(_UserStorageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'wine_id': instance.wineId,
      'quantity': instance.quantity,
      'purchase_price': instance.purchasePrice,
      'purchase_date': instance.purchaseDate?.toIso8601String(),
      'ideal_drink_from': instance.idealDrinkFrom,
      'ideal_drink_to': instance.idealDrinkTo,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'wine': instance.wine,
    };
