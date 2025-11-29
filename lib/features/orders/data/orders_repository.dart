import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:logging/logging.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import '../domain/order.dart';
import '../../../features/cart/domain/cart_item.dart';
import '../../../core/providers.dart';

part 'orders_repository.g.dart';

final log = Logger('orders_repository');

class OrdersRepository {
  final SupabaseClient _client;

  OrdersRepository(this._client);
  
  Future<List<Order>> fetchMySales(String sellerId) async {
    final response = await _client
        .from('orders')
        .select('*, order_items(*, offers(*, wines(*)))')
        .eq('seller_id', sellerId)
        .order('created_at', ascending: false);
    return response.map(Order.fromJson).toList();
  }

  Future<List<Order>> fetchMyOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select('*, order_items(*, offers(*, wines(*)))')
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    print('--- fetchMyOrders response: $response ---');
    return response.map(Order.fromJson).toList();
  }

  Future<void> placeOrder({
    required String userId,
    required List<CartItem> items,
    required double total,
    required String address,
  }) async {
    print('--- REPO: Placing order for user $userId with ${items.length} items ---');
    print('--- REPO: Total price: $total, Address: $address ---');
    try {
      await _client.rpc('create_order_from_cart', params: {
        'p_user_id': userId,
        'p_total': total,
        'p_address': address,
        'p_items': items
            .map((item) => {
                  'offer_id': item.offer!.id,
                  'quantity': item.quantity ?? 0,
                  'price': item.offer!.price ?? 0,
                  'seller_id': item.offer!.sellerId, // Добавляем seller_id
                })
            .toList(),
      });
      print('--- REPO: Order placed successfully ---');
    } catch (e) {
      print('--- REPO: Error placing order: $e ---');
      rethrow; // Перебрасываем ошибку, чтобы она была обработана выше
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    await _client
        .from('orders')
        .update({'status': newStatus.name}) // name - для отправки в Supabase
        .eq('id', orderId);
  }
}

@riverpod
OrdersRepository ordersRepository(Ref ref) {
  final client = ref.watch(supabaseClientProvider);
  return OrdersRepository(client);
}