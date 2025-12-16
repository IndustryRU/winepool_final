import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../application/cart_controller.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartAsync = ref.watch(cartControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Корзина'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: cartAsync.when(
        data: (cartItems) {
          if (cartItems.isEmpty) {
            return const Center(child: Text('Корзина пуста'));
          }

          final total = cartItems.fold<double>(
              0, (sum, item) => sum + ((item.offer?.price ?? 0) * (item.quantity ?? 0)));

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return ListTile(
                      title: Text(item.offer?.wine?.name ?? ''),
                      subtitle: Text('${item.offer?.price ?? 0} ₽'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => ref.read(cartControllerProvider.notifier).decrementItem(item.id),
                          ),
                          Text(item.quantity.toString()),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () => ref.read(cartControllerProvider.notifier).incrementItem(item.id),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              print('--- Deleting item: ${item.id} ---');
                              showDialog(
                                context: context,
                                builder: (dialogContext) => AlertDialog(
                                  title: const Text('Удалить товар'),
                                  content: const Text('Вы уверены, что хотите удалить этот товар из корзины?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(dialogContext).pop(),
                                      child: const Text('Отмена'),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        print('--- Confirming delete for item: ${item.id} ---');
                                        ref.read(cartControllerProvider.notifier).removeItem(item.id);
                                        Navigator.of(dialogContext).pop();
                                      },
                                      child: const Text('Удалить', style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Итого: $total ₽', style: Theme.of(context).textTheme.titleLarge),
                    ElevatedButton(
                      onPressed: () {
                        if (cartItems.isNotEmpty) {
                          context.push('/checkout', extra: cartItems);
                        }
                      },
                      child: const Text('Оформить заказ'),
                    ),
                  ],
                ),
              )
            ],
          );
        },
        loading: () => const Center(child: ShimmerLoadingIndicator()),
        error: (err, st) => Center(child: Text('Ошибка: $err')),
      ),
    );
  }
}