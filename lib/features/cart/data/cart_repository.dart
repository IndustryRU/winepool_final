import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:winepool_final/features/cart/domain/cart_item.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import '../../../core/providers.dart';

part 'cart_repository.g.dart';

class CartRepository {
  final SupabaseClient _supabaseClient;

  CartRepository(this._supabaseClient);

 /// Fetches cart items with associated product data
   Future<List<CartItem>> fetchCartItems() async {
     final cartItemsData = await _supabaseClient
         .from('cart_items')
         .select()
         .eq('user_id', _supabaseClient.auth.currentUser!.id);

     if (cartItemsData.isEmpty) return [];

     final offerIds = cartItemsData.map((item) => item['product_id'] as String).toList(); // Использую product_id, так как CartItem использует его
     final offersData = await _supabaseClient.from('offers').select().inFilter('id', offerIds); // Использую offers

     final offersMap = {for (var p in offersData) p['id'] as String: Offer.fromJson(p)};

     // Загружаем информацию о винах для каждого предложения
     final wineIds = offersData.map((offer) => offer['wine_id'] as String).toSet().toList();
     final winesData = await _supabaseClient.from('wines').select().inFilter('id', wineIds);
     final winesMap = {for (var w in winesData) w['id'] as String: Wine.fromJson(w)};

     // Обновляем предложения, добавляя информацию о винах
     final updatedOffersMap = <String, Offer>{};
     for (final offerEntry in offersMap.entries) {
       final offer = offerEntry.value;
       final wine = winesMap[offer.wineId];
       final updatedOffer = Offer(
         id: offer.id,
         sellerId: offer.sellerId,
         wineId: offer.wineId,
         price: offer.price,
         createdAt: offer.createdAt,
         wine: wine,
       );
       updatedOffersMap[offerEntry.key] = updatedOffer;
     }

     return cartItemsData.map((item) {
       final cartItem = CartItem.fromJson(item);
       return cartItem.copyWith(offer: updatedOffersMap[cartItem.productId]); // Использую offer, так как CartItem теперь использует его
     }).toList();
   }

  /// Adds a product to the cart or updates quantity if already exists
  Future<void> addToCart({required String productId, required int quantity}) async {
    print('--- REPO: Adding $productId to cart for user ${_supabaseClient.auth.currentUser!.id} ---');
    final userId = _supabaseClient.auth.currentUser!.id;
    
    // Check if item already exists in cart
    final existingItems = await _supabaseClient
        .from('cart_items')
        .select('id, quantity')
        .eq('user_id', userId)
        .eq('product_id', productId)
        .limit(1);
    
    if (existingItems.isNotEmpty) {
      final existingItem = existingItems.first;
      // Update existing item
      await _supabaseClient
          .from('cart_items')
          .update({
            'quantity': (existingItem['quantity'] as int) + quantity,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', existingItem['id']);
    } else {
      // Insert new item
      await _supabaseClient
          .from('cart_items')
          .insert({
            'user_id': userId,
            'product_id': productId,
            'quantity': quantity,
          });
    }
    print('--- REPO: Added to cart successfully ---');
  }

  /// Removes an item from the cart
  Future<void> removeFromCart(String cartItemId) async {
    await _supabaseClient
        .from('cart_items')
        .delete()
        .eq('id', cartItemId);
  }

  /// Creates orders from cart items grouped by seller and clears the cart
  Future<void> createOrderFromCart(List<CartItem> cartItems) async {
    try {
      // Group items by seller_id
      final itemsBySeller = <String, List<CartItem>>{};
      for (final item in cartItems) {
        final sellerId = item.offer!.sellerId ?? '';
        itemsBySeller.putIfAbsent(sellerId, () => []).add(item);
      }

      // Create separate order for each seller
      for (final sellerEntry in itemsBySeller.entries) {
        final sellerItems = sellerEntry.value;
        final sellerTotalPrice = sellerItems.fold<double>(
          0, (sum, item) => sum + ((item.offer!.price ?? 0) * (item.quantity ?? 0)));

        // Create order
        final orderResponse = await _supabaseClient
            .from('orders')
            .insert({
              'user_id': _supabaseClient.auth.currentUser!.id,
              'total_price': sellerTotalPrice,
              'status': 'pending', // Default status
            })
            .select('id')
            .single();
        final orderId = orderResponse['id'] as String;

        // Create order items
        final orderItems = sellerItems.map((item) => {
          'order_id': orderId,
          'offer_id': item.productId, // Использую offer_id, так как OrderItem использует его
          'quantity': item.quantity,
          'price_at_purchase': item.offer!.price,
        }).toList();
        await _supabaseClient.from('order_items').insert(orderItems);
      }

      // Clear cart
      await _supabaseClient
          .from('cart_items')
          .delete()
          .eq('user_id', _supabaseClient.auth.currentUser!.id);
    } catch (e) {
      // Re-throw the error to be handled by the caller
      rethrow;
    }
  }

  /// Clears all items from the user's cart
  Future<void> clearCart() async {
    await _supabaseClient
        .from('cart_items')
        .delete()
        .eq('user_id', _supabaseClient.auth.currentUser!.id);
  }
}

@riverpod
CartRepository cartRepository(Ref ref) {
  final supabaseClient = ref.watch(supabaseClientProvider);
  return CartRepository(supabaseClient);
}