import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winepool_final/features/cellar/application/cellar_controller.dart';
import 'package:winepool_final/features/offers/application/all_offers_controller.dart';
import 'package:winepool_final/features/reviews/application/reviews_controller.dart';
import 'package:winepool_final/features/reviews/domain/review.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/reviews/presentation/add_review_screen.dart';
import 'package:go_router/go_router.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class WineDetailsScreen extends ConsumerWidget {
  final Wine wine;

  const WineDetailsScreen({super.key, required this.wine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(allOffersControllerProvider);

    return PopScope(
      canPop: false, // Отключаем стандартное поведение кнопки "назад"
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.pop(); // Используем GoRouter для навигации
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(wine.name ?? ''),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(), // Используем GoRouter
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () {
                _showAddToCellarBottomSheet(context, ref);
              },
            ),
          ],
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
                
                // Отзывы и рейтинг
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Отзывы и рейтинг',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    if (wine.averageRating != null)
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 20),
                          const SizedBox(width: 4),
                          Text(
                            '${wine.averageRating?.toStringAsFixed(1) ?? '0.0'}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '(${wine.reviewsCount ?? 0})',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.grey,
                                ),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Загрузка и отображение отзывов
                Consumer(
                  builder: (context, ref, child) {
                    final reviewsState = ref.watch(reviewsControllerProvider(wine.id ?? ''));
                    
                    return reviewsState.when(
                      data: (reviews) {
                        if (reviews.isEmpty) {
                          return const Center(
                            child: Text('Пока нет отзывов об этом вине'),
                          );
                        }
                        
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: reviews.length,
                          itemBuilder: (context, index) {
                            final review = reviews[index];
                            return Card(
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Звезды рейтинга
                                        Row(
                                          children: List.generate(5, (starIndex) {
                                            return Icon(
                                              starIndex < review.rating.floor()
                                                  ? Icons.star
                                                  : starIndex < review.rating
                                                      ? Icons.star_half
                                                      : Icons.star_border,
                                              color: Colors.amber,
                                              size: 16,
                                            );
                                          }),
                                        ),
                                        // Пустой контейнер для выравнивания (дата будет внизу справа)
                                        const SizedBox.shrink(),
                                      ],
                                    ),
                                    if (review.text != null && review.text!.isNotEmpty) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        review.text!,
                                        style: Theme.of(context).textTheme.bodyMedium,
                                      ),
                                    ],
                                    // Дата отзыва в нижнем правом углу
                                    if (review.createdAt != null)
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          DateFormat('dd.MM.yyyy HH:mm').format(review.createdAt!),
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      loading: () => const Center(child: ShimmerLoadingIndicator()),
                      error: (error, stack) => Center(
                        child: Text('Ошибка загрузки отзывов: $error'),
                      ),
                    );
                  },
                ),
                
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
                          child: InkWell(
                            onTap: () {
                              context.push('/offers/${offer.id}', extra: offer);
                            },
                            child: ListTile(
                              title: Text('Цена: ${offer.price} руб.'),
                              subtitle: Text('Продавец: ${offer.sellerId}'),
                              trailing: const Icon(Icons.arrow_forward_ios),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () => const Center(child: ShimmerLoadingIndicator()),
                  error: (error, stack) => Center(
                    child: Text('Ошибка загрузки предложений: $error'),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Нужно получить ID текущего пользователя для добавления отзыва
            // Пока используем заглушку
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => AddReviewScreen(
                  wineId: wine.id ?? '',
                  userId: 'current_user_id', // Заглушка - нужно получить реальный ID пользователя
                ),
              ),
            );
          },
          child: const Icon(Icons.add_comment),
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

 void _showAddToCellarBottomSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext bottomSheetContext) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Добавить в погребок',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text('Что вы хотите сделать с этим вином?'),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.local_drink),
                title: const Text('Добавить в \'Пробовал\''),
                onTap: () {
                  Navigator.of(bottomSheetContext).pop(); // Закрываем bottom sheet
                  // Используем абсолютный путь для навигации
                  GoRouter.of(context).push('/wine/${wine.id}/add-tasting', extra: wine);
                },
              ),
              ListTile(
                leading: const Icon(Icons.local_bar),
                title: const Text('Добавить в \'Храню\''),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop(); // Закрываем bottom sheet
                  await ref.read(cellarControllerProvider.notifier).addToStorage(
                    wineId: wine.id ?? '',
                    quantity: 1,
                  );
                  ref.invalidate(cellarStorageProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar( // Используем context из build
                      const SnackBar(
                        content: Text('Вино добавлено в ваш погребок'),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => Navigator.of(bottomSheetContext).pop(),
                child: const Text('Отмена'),
              ),
            ],
          ),
        );
      },
    );
 }
}