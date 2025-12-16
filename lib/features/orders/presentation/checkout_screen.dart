import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/cart/application/cart_controller.dart';
import 'package:winepool_final/features/cart/domain/cart_item.dart';
import 'package:winepool_final/features/orders/application/orders_controller.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class CheckoutScreen extends HookConsumerWidget {
  const CheckoutScreen({super.key, required this.cartItems});

  final List<CartItem> cartItems;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final addressController = useTextEditingController();
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    final cartState = ref.watch(cartControllerProvider);

    return WillPopScope(
      onWillPop: () async {
        // Возвращаем на предыдущий экран (корзина или главный экран)
        context.go('/cart');
        return false;
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Оформление заказа')),
        body: cartState.when(
          data: (cartItems) {
            final total = cartItems.fold<double>(
              0,
              (sum, item) => sum + ((item.offer?.price ?? 0) * (item.quantity ?? 0)),
            );

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Состав заказа',
                        style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    for (final item in cartItems)
                      ListTile(
                        title: Text(item.offer?.wine?.name ?? ''),
                        subtitle: Text('${item.quantity ?? 0} шт.'),
                        trailing:
                            Text('${(item.offer?.price ?? 0) * (item.quantity ?? 0)} ₽'),
                      ),
                    const Divider(),
                    ListTile(
                      title: Text('Итого', style: Theme.of(context).textTheme.titleMedium),
                      trailing: Text('$total ₽', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 24),
                    Text('Адрес доставки', style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(labelText: 'Город, улица, дом, квартира'),
                      validator: (value) => (value == null || value.isEmpty) ? 'Введите адрес' : null,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async { // <-- async
                        if (formKey.currentState!.validate()) {
                          try {
                            await ref.read(placeOrderControllerProvider.notifier).placeOrder(
                                  items: cartItems,
                                  address: addressController.text,
                                );

                            // --- Логика УСПЕХА ---
                            ref.read(cartControllerProvider.notifier).clearCart();
                            if (!context.mounted) return;
                            context.go('/buyer-home');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Заказ успешно оформлен!')),
                            );

                          } catch (e) {
                            // --- Логика ОШИБКИ ---
                            if (!context.mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Ошибка: $e')),
                            );
                          }
                        }
                      },
                      child: const Text('Подтвердить заказ'),
                    ),
                  ],
                ),
              ),
            );
          },
          loading: () => const Center(child: ShimmerLoadingIndicator()),
          error: (error, stack) => Center(child: Text('Ошибка: $error')),
        ),
      ),
    );
  }
}