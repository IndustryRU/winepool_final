import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';
import 'package:winepool_final/features/orders/presentation/my_sales_screen.dart';
import 'package:winepool_final/features/offers/application/offers_controller.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class SellerHomeScreen extends StatefulWidget {
  const SellerHomeScreen({super.key});

  @override
  State<SellerHomeScreen> createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Домашний экран продавца'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              final ref = ProviderScope.containerOf(context);
              ref.read(authControllerProvider.notifier).forceSignOut();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_forever, color: Colors.red),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Подтверждение удаления аккаунта'),
                  content: const Text('Вы уверены, что хотите удалить свой аккаунт? Это действие нельзя отменить.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Отмена'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        final ref = ProviderScope.containerOf(context);
                        ref.read(authControllerProvider.notifier).deleteAccount();
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
      body: _selectedIndex == 0
          ? _buildOffersScreen(context)
          : const MySalesScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.store),
            label: 'Мои Предложения',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Мои Заказы',
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () {
                context.push('/add-offer');
              },
              child: const Icon(Icons.add),
            )
          : null,
    );
  }

  Widget _buildOffersScreen(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final state = ref.watch(offersControllerProvider);

        return state.when(
          data: (products) => ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final offer = products[index];
              return ListTile(
                title: Text(offer.wine?.name ?? 'Название не найдено'),
                subtitle: offer.isActive
                    ? Text('Цена: ${offer.price}')
                    : Text('Цена: ${offer.price} (в архиве)', style: TextStyle(color: Colors.grey)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (offer.isActive)
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          context.push('/edit-offer/${offer.id}', extra: offer);
                        },
                      ),
                    if (offer.isActive)
                      IconButton(
                        icon: const Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Подтверждение'),
                              content: const Text('Вы уверены, что хотите удалить это предложение?'),
                              actions: [
                                TextButton(
                                  onPressed: () => context.pop(),
                                  child: const Text('Отмена'),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    final ref = ProviderScope.containerOf(context);
                                    await ref.read(offersControllerProvider.notifier).deleteOffer(offer.id);
                                    ref.invalidate(offersControllerProvider);
                                    // ignore: use_build_context_synchronously
                                    if (context.mounted) context.pop(); // Закрыть диалог
                                  },
                                  child: const Text('Удалить'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
                tileColor: offer.isActive ? null : Colors.grey.shade100,
              );
            },
          ),
          loading: () => const Center(
            child: ShimmerLoadingIndicator(),
          ),
          error: (error, stack) => Center(
            child: Text('Ошибка: $error'),
          ),
        );
      },
    );
  }
}