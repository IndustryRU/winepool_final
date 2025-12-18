// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Order _$OrderFromJson(Map<String, dynamic> json) => _Order(
  id: json['id'] as String,
  buyerId: json['user_id'] as String?,
  totalPrice: (json['total_price'] as num?)?.toDouble(),
  status: json['status'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  items: _orderItemsFromJson(json['order_items']),
);

Map<String, dynamic> _$OrderToJson(_Order instance) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.buyerId,
  'total_price': instance.totalPrice,
  'status': instance.status,
  'created_at': instance.createdAt?.toIso8601String(),
};
