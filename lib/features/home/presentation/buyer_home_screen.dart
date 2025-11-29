import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/offers/application/all_offers_controller.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/auth/application/auth_controller.dart';

class BuyerHomeScreen extends ConsumerWidget {
 const BuyerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersAsync = ref.watch(allOffersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Витрина'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () => context.push('/my-orders'),
            tooltip: 'Мои заказы',
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () => context.push('/cart'),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => context.push('/profile'),
            tooltip: 'Профиль',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
            tooltip: 'Выйти',
          ),
        ],
      ),
      body: offersAsync.when(
        data: (offers) => GridView.builder(
          padding: const EdgeInsets.all(8.0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 0.7, // Подберите соотношение сторон
          ),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return OfferCard(offer: offer);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}

// Виджет для карточки товара
class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer});

  final Offer offer;

  @override
  Widget build(BuildContext context) {
    // Отладочная печать
    print('Seller data for offer ${offer.id}: ${offer.seller?.toJson()}');
    // Используем ?? для безопасности, если wine или winery будут null
    final wineName = offer.wine?.name ?? 'Без названия';
    final wineryName = offer.wine?.winery?.name ?? 'Винодельня неизвестна';
    final imageUrl = offer.wine?.imageUrl;
    final bool isValidUrl = imageUrl != null && imageUrl.startsWith('http');

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          context.push('/offers/${offer.id}', extra: offer);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Изображение
            Expanded(
              child: isValidUrl
                  ? CachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.wine_bar, size: 48, color: Colors.grey),
                    )
                  : Container(
                      color: Colors.grey[200],
                      child: const Icon(Icons.wine_bar, size: 48, color: Colors.grey),
                    ),
            ),
            // Информация
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    wineryName,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    wineName,
                    style: Theme.of(context).textTheme.titleMedium,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${offer.price?.toStringAsFixed(2) ?? '...'} ₽',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Продавец: ${offer.seller?.shopName ?? '...'}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}