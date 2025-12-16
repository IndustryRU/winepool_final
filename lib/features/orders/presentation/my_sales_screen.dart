import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winepool_final/features/orders/application/orders_controller.dart';
import 'package:winepool_final/features/orders/domain/order.dart';
import 'package:winepool_final/features/orders/presentation/order_details_screen.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class MySalesScreen extends ConsumerWidget {
 const MySalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mySalesAsync = ref.watch(mySalesProvider);

    return mySalesAsync.when(
      data: (orders) {
        if (orders.isEmpty) {
          return const Center(child: Text('У вас пока нет продаж.'));
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(mySalesProvider);
            await ref.refresh(mySalesProvider.future);
          },
          child: ListView.builder(
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return OrderCard(order: order); // Используем тот же OrderCard
            },
          ),
        );
      },
      loading: () => const Center(child: ShimmerLoadingIndicator()),
      error: (error, stack) => Center(child: Text('Ошибка: $error')),
    );
  }
}

// Этот виджет можно будет вынести в общий файл, если он еще не там
class OrderCard extends ConsumerWidget {
  const OrderCard({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formattedDate = order.createdAt != null
        ? DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt!)
        : 'Дата неизвестна';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text('Заказ от $formattedDate'),
        subtitle: Text('Статус: ${order.status != null ? OrderStatus.values.firstWhere((e) => e.name == order.status).toRu() : 'Неизвестен'}'),
        trailing: order.status != null ? DropdownButton<String>(
          value: order.status,
          onChanged: (newStatus) async {
            if (newStatus != null && newStatus != order.status) {
              // Вызов метода для обновления статуса
              await ref.read(mySalesControllerProvider.notifier).updateOrderStatus(order.id, OrderStatus.values.firstWhere((e) => e.name == newStatus));
              ref.invalidate(mySalesProvider);
            }
          },
          items: OrderStatus.values.map((status) {
            return DropdownMenuItem(
              value: status.name,
              child: Text(status.toRu()),
            );
          }).toList(),
        ) : null,
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