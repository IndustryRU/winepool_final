import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/cart/data/cart_repository.dart';
import 'package:winepool_final/features/cart/domain/cart_item.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';

final cartControllerProvider = AsyncNotifierProvider<CartController, List<CartItem>>(() => CartController());

class CartController extends AsyncNotifier<List<CartItem>> {
  CartRepository get _repository => ref.read(cartRepositoryProvider);

  @override
  Future<List<CartItem>> build() async {
    // Асинхронно загружаем корзину
    return await _repository.fetchCartItems();
  }
  
  // Все методы теперь должны быть async и вызывать репозиторий

 Future<void> addItem(Offer offer) async {
     if (offer.id == null) {
       return; // Не добавляем товар, если id отсутствует
     }
     
     final currentState = await future;
     final existingItemIndex = currentState.indexWhere((item) => item.offer?.id == offer.id);

     if (existingItemIndex != -1) {
       await incrementItem(currentState[existingItemIndex].id);
     } else {
       final newItem = CartItem(id: offer.id, offer: offer, quantity: 1);
       final newState = [...currentState, newItem];
       state = AsyncValue.data(newState);
       await _repository.addToCart(productId: offer.id, quantity: 1); // Сохраняем
     }
   }

  Future<void> incrementItem(String cartItemId) async {
    final currentState = await future;
    final newState = [
      for (final item in currentState)
        if (item.id == cartItemId)
          item.copyWith(quantity: item.quantity! + 1)
        else
          item,
    ];
    state = AsyncValue.data(newState);
    await _repository.addToCart(productId: cartItemId, quantity: 1); // Сохраняем
  }

  Future<void> decrementItem(String cartItemId) async {
    final currentState = await future;
    final newState = [
      for (final item in currentState)
        if (item.id == cartItemId && item.quantity! > 1)
          item.copyWith(quantity: item.quantity! - 1)
        else
          item,
    ];
    state = AsyncValue.data(newState);
    await _repository.addToCart(productId: cartItemId, quantity: -1); // Сохраняем
  }

  Future<void> removeItem(String cartItemId) async {
    final currentState = await future;
    final newState = currentState.where((item) => item.id != cartItemId).toList();
    state = AsyncValue.data(newState);
    await _repository.removeFromCart(cartItemId); // Сохраняем
  }

  Future<void> clearCart() async {
    state = const AsyncValue.data([]); // Обновляем состояние на пустой список
    // Сохраняем пустое состояние
    await _repository.clearCart();
  }
}