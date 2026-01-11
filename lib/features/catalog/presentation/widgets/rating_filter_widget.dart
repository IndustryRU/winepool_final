import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/temporary_rating_provider.dart';

class RatingFilterWidget extends ConsumerWidget {
  const RatingFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Ручка
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        // Заголовок и кнопки
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Рейтинг',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(temporaryRatingProvider.notifier).set(0.0);
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  ref.read(catalogFiltersProvider.notifier).updateFilters(
                        ref.read(catalogFiltersProvider).copyWith(
                              minRating: ref.read(temporaryRatingProvider) == 0.0 ? null : ref.read(temporaryRatingProvider),
                            ),
                      );
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Селектор звезд
        StarRatingSelector(
          initialRating: ref.watch(temporaryRatingProvider),
          onRatingChanged: (rating) {
            ref.read(temporaryRatingProvider.notifier).set(rating);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class StarRatingSelector extends ConsumerWidget {
  const StarRatingSelector({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
  });

  final double initialRating;
  final void Function(double rating) onRatingChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < initialRating ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            double newRating = (index + 1).toDouble();
            if (initialRating == newRating) {
              // Повторное нажатие на выбранную звезду - сброс до 0
              onRatingChanged(0.0);
            } else {
              onRatingChanged(newRating);
            }
          },
          tooltip: '${index + 1} звёзд${_getStarSuffix(index + 1)}',
        );
      }),
    );
  }

  String _getStarSuffix(int rating) {
    if (rating >= 11 && rating <= 14) {
      return 'очек';
    }
    switch (rating % 10) {
      case 1:
        return 'очка';
      case 2:
      case 3:
      case 4:
        return 'очки';
      default:
        return 'очек';
    }
  }
}