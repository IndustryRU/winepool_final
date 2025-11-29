// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_OrderItem _$OrderItemFromJson(Map<String, dynamic> json) => _OrderItem(
  id: json['id'] as String,
  orderId: json['order_id'] as String? ?? '',
  offerId: json['offer_id'] as String?,
  quantity: (json['quantity'] as num?)?.toInt(),
  priceAtPurchase: (json['price_at_purchase'] as num?)?.toDouble(),
  offer: _offerFromJson(json['offers']),
);

Map<String, dynamic> _$OrderItemToJson(_OrderItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'order_id': instance.orderId,
      'offer_id': instance.offerId,
      'quantity': instance.quantity,
      'price_at_purchase': instance.priceAtPurchase,
      'offers': instance.offer,
    };
