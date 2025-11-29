import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/cart/application/cart_controller.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

class OfferDetailsScreen extends ConsumerWidget {
  final Offer offer;

  const OfferDetailsScreen({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wine = offer.wine;
    if (wine == null) {
      return const Scaffold(
        body: Center(
          child: Text('Информация о вине отсутствует'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали предложения'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Фото вина
            _buildWineImage(wine.imageUrl),
            
            const SizedBox(height: 16),
            
            // Название вина
            Text(
              wine.name,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Название винодельни
            Text(
              wine.winery?.name ?? 'Винодельня не указана',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.grey[700],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Характеристики вина
            _buildSectionTitle('Характеристики вина'),
            
            _buildInfoRow('Цвет:', wine.color?.nameRu ?? 'Не указан'),
            _buildInfoRow('Тип:', wine.type?.nameRu ?? 'Не указан'),
            _buildInfoRow('Сахар:', wine.sugar?.nameRu ?? 'Не указан'),
            _buildInfoRow('Сорт винограда:', wine.grapeVariety ?? 'Не указан'),
            _buildInfoRow('Год:', offer.vintage?.toString() ?? 'Не указан'),
            _buildInfoRow('Алкоголь:', '${wine.alcoholLevel?.toStringAsFixed(1) ?? "Не указан"}%'),
            _buildInfoRow('Рейтинг:', wine.rating?.toStringAsFixed(1) ?? 'Не указан'),
            _buildInfoRow('Температура подачи:', wine.servingTemperature ?? 'Не указана'),
            
            const SizedBox(height: 16),
            
            // Детали предложения
            _buildSectionTitle('Детали предложения'),
            
            _buildInfoRow('Цена:', offer.price != null ? '${offer.price!.toStringAsFixed(0)} ₽' : 'Не указана'),
            _buildInfoRow('Объем бутылки:', offer.bottleSize != null ? '${offer.bottleSize!} л' : 'Не указан'),
            _buildInfoRow('Продавец:', offer.seller?.shopName ?? 'Не указан'),
            
            const SizedBox(height: 24),
            
            // Кнопка "Добавить в корзину"
            ElevatedButton(
              onPressed: () {
                ref.read(cartControllerProvider.notifier).addItem(offer);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Товар добавлен в корзину'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Добавить в корзину',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWineImage(String? imageUrl) {
    final bool isValidUrl = imageUrl != null && imageUrl.startsWith('http');
    
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: isValidUrl ? null : Colors.grey[300],
      ),
      child: isValidUrl
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.wine_bar,
                size: 100,
                color: Colors.grey,
              ),
            )
          : const Icon(
              Icons.wine_bar,
              size: 100,
              color: Colors.grey,
            ),
    );
 }
}