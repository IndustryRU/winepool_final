import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/orders/domain/order_item.dart';

part 'order.freezed.dart';
part 'order.g.dart';
List<OrderItem>? _orderItemsFromJson(dynamic json) {
  if (json is List) {
    return json.map((item) => OrderItem.fromJson(item as Map<String, dynamic>)).toList();
  }
  return null;
}


@freezed
abstract class Order with _$Order {
  const factory Order({
    required String id,
    @JsonKey(name: 'user_id') String? buyerId,
    @JsonKey(name: 'total_price') double? totalPrice,
    String? status,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'order_items', fromJson: _orderItemsFromJson, includeToJson: false) List<OrderItem>? items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

extension OrderStatusDisplayExtension on Order {
  String get statusRu {
    final statusString = status?.toLowerCase();
    switch (statusString) {
      case 'pending':
        return 'В обработке';
      case 'confirmed':
        return 'Подтверждён';
      case 'inprogress':
      case 'in_progress':
        return 'В работе';
      case 'shipped':
        return 'Передан в доставку';
      case 'delivered':
        return 'Завершен';
      case 'cancelled':
        return 'Отменен';
      default:
        return status ?? 'Неизвестен';
    }
  }
}
enum OrderStatus { pending, inProgress, shipped, delivered, cancelled }

extension OrderStatusExtension on OrderStatus {
  String toRu() {
    switch (this) {
      case OrderStatus.pending:
        return 'В обработке';
      case OrderStatus.inProgress:
        return 'В работе';
      case OrderStatus.shipped:
        return 'Передан в доставку';
      case OrderStatus.delivered:
        return 'Завершен';
      case OrderStatus.cancelled:
        return 'Отменен';
    }
  }
}