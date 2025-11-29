import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

part 'order_item.freezed.dart';
part 'order_item.g.dart';

Offer? _offerFromJson(dynamic json) {
  if (json is List && json.isNotEmpty) {
    // Берем первый элемент из массива offers
    return Offer.fromJson(json[0] as Map<String, dynamic>);
  } else if (json is Map<String, dynamic>) {
    // Если это уже одиночный объект, а не массив
    return Offer.fromJson(json);
  }
  return null;
}

@freezed
abstract class OrderItem with _$OrderItem {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory OrderItem({
    required String id,
    @JsonKey(defaultValue: '') String? orderId,
    @JsonKey(name: 'offer_id') String? offerId,
    int? quantity,
    @JsonKey(name: 'price_at_purchase') double? priceAtPurchase,
    // Поле для вложенного `Offer`
    @JsonKey(name: 'offers', fromJson: _offerFromJson) // <-- ДОБАВЬ ЭТУ АННОТАЦИЮ
    Offer? offer,
  }) = _OrderItem;
  factory OrderItem.fromJson(Map<String, dynamic> json) {
    print('--- ORDER ITEM FROM JSON ---');
    print(json);
    return _$OrderItemFromJson(json);
  }
}