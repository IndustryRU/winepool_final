import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winepool_final/features/orders/application/orders_controller.dart';
import 'package:winepool_final/features/orders/domain/order.dart';
import 'package:winepool_final/features/orders/presentation/order_details_screen.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class MyOrdersScreen extends ConsumerWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myOrdersAsync = ref.watch(myOrdersProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Мои заказы')),
      body: myOrdersAsync.when(
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(child: Text('У вас еще нет заказов.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.refresh(myOrdersProvider.future),
            child: ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order);
              },
            ),
          );
        },
        loading: () => const Center(child: ShimmerLoadingIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final formattedDate = order.createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt!)
        : 'Дата неизвестна';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Заказ от $formattedDate'),
        subtitle: Text('Статус: ${order.statusRu}'),
        trailing: Text('${order.totalPrice ?? 0} ₽'),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => OrderDetailsScreen(orderId: order.id),
            ),
          );
        },
      ),
    );
  }
}