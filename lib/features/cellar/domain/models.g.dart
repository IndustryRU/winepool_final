// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserTasting _$UserTastingFromJson(Map<String, dynamic> json) => _UserTasting(
  id: json['id'] as String?,
  userId: json['userId'] as String?,
  wineId: json['wineId'] as String?,
  tastingDate: json['tastingDate'] == null
      ? null
      : DateTime.parse(json['tastingDate'] as String),
  rating: (json['rating'] as num?)?.toDouble(),
  notes: json['notes'] as String?,
  photoUrl: json['photoUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
  wine: Wine.fromJson(json['wine'] as Map<String, dynamic>),
);

Map<String, dynamic> _$UserTastingToJson(_UserTasting instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'wineId': instance.wineId,
      'tastingDate': instance.tastingDate?.toIso8601String(),
      'rating': instance.rating,
      'notes': instance.notes,
      'photoUrl': instance.photoUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'wine': instance.wine,
    };

_UserStorageItem _$UserStorageItemFromJson(Map<String, dynamic> json) =>
    _UserStorageItem(
      id: json['id'] as String?,
      userId: json['userId'] as String?,
      wineId: json['wineId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt(),
      purchasePrice: (json['purchasePrice'] as num?)?.toDouble(),
      purchaseDate: json['purchaseDate'] == null
          ? null
          : DateTime.parse(json['purchaseDate'] as String),
      idealDrinkFrom: (json['idealDrinkFrom'] as num?)?.toInt(),
      idealDrinkTo: (json['idealDrinkTo'] as num?)?.toInt(),
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      wine: Wine.fromJson(json['wine'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserStorageItemToJson(_UserStorageItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'wineId': instance.wineId,
      'quantity': instance.quantity,
      'purchasePrice': instance.purchasePrice,
      'purchaseDate': instance.purchaseDate?.toIso8601String(),
      'idealDrinkFrom': instance.idealDrinkFrom,
      'idealDrinkTo': instance.idealDrinkTo,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'wine': instance.wine,
    };
