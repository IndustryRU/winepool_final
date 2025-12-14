import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RatingFilterWidget extends HookConsumerWidget {
  const RatingFilterWidget({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
  });

  final double initialRating;
  final void Function(double rating) onRatingChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRating = useState(initialRating);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        StarRatingSelector(
          initialRating: selectedRating.value,
          onRatingChanged: (rating) {
            selectedRating.value = rating;
            onRatingChanged(selectedRating.value);
          },
        ),
        const SizedBox(height: 8),
        Text(
          'Выберите минимальный рейтинг',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }
}

class StarRatingSelector extends HookConsumerWidget {
  const StarRatingSelector({
    super.key,
    required this.initialRating,
    required this.onRatingChanged,
  });

  final double initialRating;
  final void Function(double rating) onRatingChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRating = useState(initialRating);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < selectedRating.value ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            double newRating = (index + 1).toDouble();
            if (selectedRating.value == newRating) {
              // Повторное нажатие на выбранную звезду - сброс до 0
              selectedRating.value = 0.0;
            } else {
              selectedRating.value = newRating;
            }
            onRatingChanged(selectedRating.value);
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