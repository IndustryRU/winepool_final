import 'package:flutter/material.dart';
//import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/offers/application/all_offers_controller.dart';
//import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';

class WineDetailsScreen extends ConsumerWidget {
  final Wine wine;

  const WineDetailsScreen({super.key, required this.wine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(allOffersControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(wine.name ?? ''),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Изображение вина
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    wine.name ?? '',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Основная информация о вине
              Text(
                wine.name ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              _buildDetailItem('Цвет', wine.color?.name ?? ''),
              _buildDetailItem('Сахар', wine.sugar?.name ?? ''),
              _buildDetailItem('Крепость', (wine.alcoholLevel != null) ? wine.alcoholLevel.toString() : 'Не указано'),
              _buildDetailItem('Сорт винограда', wine.grapeVariety ?? ''),
              if (wine.description != null) ...[
                const SizedBox(height: 16),
                Text(
                  'Описание',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  wine.description ?? '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
              
              const SizedBox(height: 24),
              Text(
                'Предложения',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              // Список предложений для этого вина
              offersState.when(
                data: (offers) {
                  final wineOffers = offers.where((offer) => offer.wineId == wine.id).toList();
                  if (wineOffers.isEmpty) {
                    return const Center(
                      child: Text('Нет доступных предложений для этого вина'),
                    );
                  }
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: wineOffers.length,
                    itemBuilder: (context, index) {
                      final offer = wineOffers[index];
                      return Card(
                        child: ListTile(
                          title: Text('Цена: ${offer.price} руб.'),
                          subtitle: Text('Продавец: ${offer.sellerId}'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // TODO: Перейти к деталям предложения
                          },
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text('Ошибка загрузки предложений: $error'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(),
            ),
          ),
        ],
      ),
    );
  }
}