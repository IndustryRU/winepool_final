// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Profile _$ProfileFromJson(Map<String, dynamic> json) => _Profile(
  id: json['id'] as String,
  role: json['role'] as String?,
  fullName: json['full_name'] as String?,
  username: json['username'] as String?,
  shopName: json['shop_name'] as String?,
);

Map<String, dynamic> _$ProfileToJson(_Profile instance) => <String, dynamic>{
  'id': instance.id,
  'role': instance.role,
  'full_name': instance.fullName,
  'username': instance.username,
  'shop_name': instance.shopName,
};
