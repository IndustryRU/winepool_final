import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    @JsonKey(name: 'product_id', defaultValue: '')
    String? productId, // Оставляю product_id, так как в БД это поле
    int? quantity,
    @JsonKey(includeFromJson: false, includeToJson: false)
    Offer? offer,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}