import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winepool_final/features/orders/application/orders_controller.dart';
import 'package:winepool_final/features/orders/domain/order.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class OrderDetailsScreen extends ConsumerWidget {
 const OrderDetailsScreen({super.key, required this.orderId});
   
   final String orderId;
   
   @override
   Widget build(BuildContext context, WidgetRef ref) {
     final orderAsync = ref.watch(orderProvider(orderId));
     
     return Scaffold(
       appBar: AppBar(
         title: const Text('Детали заказа'),
       ),
       body: orderAsync.when(
         data: (order) {
           if (order == null) {
             return const Center(child: Text('Заказ не найден'));
           }
           
           return SingleChildScrollView(
             child: Padding(
               padding: const EdgeInsets.all(16.0),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   // Статус заказа
                   Container(
                     padding: const EdgeInsets.all(12.0),
                     decoration: BoxDecoration(
                       color: _getStatusColor(order.status),
                       borderRadius: BorderRadius.circular(8.0),
                     ),
                     child: Text(
                       order.statusRu,
                       style: const TextStyle(
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                         fontSize: 16,
                       ),
                     ),
                   ),
                   
                   const SizedBox(height: 16),
                   
                   // Дата заказа
                   _buildDetailItem(
                     'Дата заказа',
                     order.createdAt != null
                         ? DateFormat('dd.MM.yyyy HH:mm').format(order.createdAt!)
                         : 'Не указана',
                   ),
                   
                   const SizedBox(height: 16),
                   
                   // Общая сумма
                   _buildDetailItem(
                     'Общая сумма',
                     '${order.totalPrice?.toStringAsFixed(2) ?? '0'} ₽',
                     isTotal: true,
                   ),
                   
                   const SizedBox(height: 24),
                   
                   // Заголовок списка товаров
                   const Text(
                     'Товары в заказе',
                     style: TextStyle(
                       fontSize: 18,
                       fontWeight: FontWeight.bold,
                     ),
                   ),
                   
                   const SizedBox(height: 12),
                   
                   // Список товаров
                   ..._buildOrderItems(order),
                 ],
               ),
             ),
           );
         },
         loading: () => const Center(child: ShimmerLoadingIndicator()),
         error: (error, stack) => Center(
           child: Text('Ошибка загрузки деталей заказа: $error'),
         ),
       ),
     );
   }
   
   Widget _buildDetailItem(String label, String value, {bool isTotal = false}) {
     return Container(
       padding: const EdgeInsets.symmetric(vertical: 8.0),
       child: Row(
         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         children: [
           Text(
             label,
             style: const TextStyle(
               fontSize: 16,
               color: Colors.grey,
             ),
           ),
           Text(
             value,
             style: TextStyle(
               fontSize: 16,
               fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
               color: isTotal ? Colors.black : Colors.black87,
             ),
           ),
         ],
       ),
     );
   }
   
   List<Widget> _buildOrderItems(Order order) {
     if (order.items == null || order.items!.isEmpty) {
       return [
         const Card(
           child: Padding(
             padding: EdgeInsets.all(16.0),
             child: Text('В заказе нет товаров'),
           ),
         ),
       ];
     }
     
     return order.items!.map((item) {
       final wineName = item.offer?.wine?.name ?? 'Неизвестное вино';
       final price = item.priceAtPurchase ?? 0;
       final quantity = item.quantity ?? 0;
       final totalPrice = price * quantity;
       
       return Card(
         margin: const EdgeInsets.only(bottom: 12),
         child: Padding(
           padding: const EdgeInsets.all(12.0),
           child: Row(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Изображение вина (если доступно)
               Container(
                 width: 60,
                 height: 60,
                 decoration: BoxDecoration(
                   color: Colors.grey[200],
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: item.offer?.wine?.imageUrl != null
                     ? Image.network(
                         item.offer?.wine?.imageUrl ?? '',
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) => const Icon(
                           Icons.wine_bar,
                           color: Colors.grey,
                         ),
                       )
                     : const Icon(
                         Icons.wine_bar,
                         color: Colors.grey,
                       ),
               ),
               const SizedBox(width: 12),
               
               // Информация о вине
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       wineName,
                       style: const TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     const SizedBox(height: 4),
                     Text(
                       '${price.toStringAsFixed(2)} ₽ × $quantity',
                       style: const TextStyle(
                         fontSize: 14,
                         color: Colors.grey,
                       ),
                     ),
                   ],
                 ),
               ),
               
               // Общая цена для этого товара
               Text(
                 '${totalPrice.toStringAsFixed(2)} ₽',
                 style: const TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                 ),
               ),
             ],
           ),
         ),
       );
     }).toList();
   }
   
   Color _getStatusColor(String? status) {
     switch (status?.toLowerCase()) {
       case 'pending':
         return Colors.blue;
       case 'confirmed':
         return Colors.green;
       case 'inprogress':
       case 'in_progress':
         return Colors.orange;
       case 'shipped':
         return Colors.purple;
       case 'delivered':
         return Colors.green;
       case 'cancelled':
         return Colors.red;
       default:
         return Colors.grey;
     }
   }
 }
