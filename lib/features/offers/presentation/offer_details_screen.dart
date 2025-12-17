import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:winepool_final/features/cart/application/cart_controller.dart';
import 'package:winepool_final/features/offers/domain/offer.dart';
import 'package:winepool_final/features/offers/application/offer_details_controller.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/reviews/application/reviews_controller.dart';
import 'package:winepool_final/features/reviews/domain/review.dart';
import 'package:winepool_final/features/reviews/presentation/add_review_screen.dart';
import 'package:winepool_final/core/providers/supabase_provider.dart';
import 'package:winepool_final/features/wines/presentation/widgets/wine_characteristic_icons.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import '../../../common/widgets/shimmer_loading_indicator.dart';

class OfferDetailsScreen extends HookConsumerWidget {
  final String offerId;

  const OfferDetailsScreen({
    super.key,
    required this.offerId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerState = ref.watch(offerDetailsControllerProvider(offerId));
    final scale = useState<double>(1.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Детали предложения'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: offerState.when(
        data: (offer) {
          final wine = offer.wine;
          if (wine == null) {
            return const Center(
              child: Text('Информация о вине отсутствует'),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Фото вина
                _buildWineImage(wine.imageUrl, scale, context),
                
                const SizedBox(height: 16),
                
                // Название вина
                Text(
                  wine.name ?? 'Название не указано',
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

                // Отображение пиктограмм с текстовыми описаниями
                _buildInfoRowWithIcon(
                  WineColorIcon(color: wine.color, size: 24.0),
                  'Цвет:',
                  wine.color?.nameRu ?? 'Не указан',
                ),
                _buildInfoRowWithIcon(
                  WineSugarIcon(sugar: wine.sugar, size: 24.0),
                  'Сахар:',
                  wine.sugar?.nameRu ?? 'Не указан',
                ),
                _buildInfoRowWithIcon(
                  WineAlcoholIcon(alcoholLevel: wine.alcoholLevel, size: 24.0),
                  'Алкоголь:',
                  '${wine.alcoholLevel?.toStringAsFixed(1) ?? "Не указан"}%',
                ),
                _buildInfoRowWithIcon(
                  WineCountryIcon(country: wine.winery?.country, size: 24.0),
                  'Страна:',
                  wine.winery?.countryName ?? 'Не указана',
                ),
                _buildInfoRow(
                  'Сорт винограда:',
                  wine.grapeVariety ?? 'Не указан',
                ),
                _buildInfoRow('Год:', offer.vintage?.toString() ?? 'Не указан'),
                // Отзывы и рейтинг
                _buildInfoRow('Рейтинг:', wine.averageRating?.toStringAsFixed(1) ?? '0.0'),
                _buildInfoRow('Отзывы:', (wine.reviewsCount ?? 0).toString()),
                const SizedBox(height: 16),
                _buildInfoRow('Температура подачи:', wine.servingTemperature ?? 'Не указана'),
                
                const SizedBox(height: 16),
                
                // Детали предложения
                _buildSectionTitle('Детали предложения'),
                
                _buildInfoRow('Цена:', offer.price != null ? '${offer.price!.toStringAsFixed(0)} ₽' : 'Не указана'),
                _buildInfoRow('Объем бутылки:', offer.bottleSize != null ? '${offer.bottleSize!} л' : 'Не указан'),
                _buildInfoRow('Продавец:', offer.seller?.shopName ?? 'Не указан'),
                
                const SizedBox(height: 24),

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
                                        // Отображение имени пользователя, если доступно
                                        if (review.userName != null && review.userName!.isNotEmpty)
                                          Text(
                                            review.userName!,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
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

                // Кнопка "Добавить в корзину" и "Оставить отзыв"
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
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
                          'В корзину',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Consumer(
                      builder: (context, ref, child) {
                        final userId = ref.watch(supabaseClientProvider).auth.currentUser?.id;
                        
                        if (userId == null) {
                          return const SizedBox.shrink(); // Скрываем кнопку, если пользователь не авторизован
                        }
                        
                        return ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddReviewScreen(
                                  wineId: wine.id ?? '',
                                  userId: userId, // Передаем реальный ID пользователя
                                  offerId: offerId, // Передаем offerId для инвалидации провайдера
                                ),
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
                            'Оставить отзыв',
                            style: TextStyle(fontSize: 16),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: ShimmerLoadingIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки данных предложения: $error'),
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

  Widget _buildInfoRowWithIcon(Widget icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Row(
              children: [
                icon,
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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

  Widget _buildWineImage(String? imageUrl, ValueNotifier<double> scale, BuildContext context) {
    final bool isValidUrl = imageUrl != null && imageUrl.startsWith('http');
    final alignment = useState<Alignment>(Alignment.center);
    final controller = useAnimationController(duration: const Duration(milliseconds: 100));
    final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    final animation = Tween<double>(begin: 1.0, end: 1.6).animate(curvedAnimation);

    useEffect(() {
      void listener() {
        scale.value = animation.value;
      }

      animation.addListener(listener);
      return () => animation.removeListener(listener);
    }, [animation]);

    return GestureDetector(
       onLongPressStart: (LongPressStartDetails details) {
          // Convert local position to alignment
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = details.localPosition;
          Size size = renderBox.size;
          double dx = (localPosition.dx / size.width - 0.5) * 2; // Convert to range [-1, 1]
          double dy = (localPosition.dy / size.height - 0.5) * 2; // Convert to range [-1, 1]
          alignment.value = Alignment(dx, dy);
          
          controller.forward();
        },
        onLongPressEnd: (LongPressEndDetails details) {
          controller.reverse();
        },
       child: Transform.scale(
        scale: scale.value,
        alignment: alignment.value,
        child: Container(
          width: double.infinity,
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isValidUrl ? null : Colors.grey[30],
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
        ),
      ),
    );
  }
}