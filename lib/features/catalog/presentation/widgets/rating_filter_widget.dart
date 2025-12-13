import 'package:flutter/material.dart';

Widget buildRatingFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  final rating = selectedFilters.value['min_rating'] ?? 0.0;
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('От ${rating.toStringAsFixed(1)} звезд'),
      Slider(
        min: 0,
        max: 5,
        divisions: 10, // 0.5 шаги (10 делений между 0 и 5)
        label: rating.toStringAsFixed(1),
        value: rating,
        onChanged: (double value) {
          selectedFilters.value['min_rating'] = value;
          selectedFilters.value = Map.from(selectedFilters.value);
        },
      ),
      // Визуальное отображение звезд
      Row(
        children: [
          for (int i = 0; i <= 5; i++)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  selectedFilters.value['min_rating'] = i.toDouble();
                  selectedFilters.value = Map.from(selectedFilters.value);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (i > 0) ...[
                      Icon(Icons.star, size: 16, color: i <= rating ? Colors.amber : Colors.grey),
                      const SizedBox(width: 4),
                    ],
                    Text(i.toString()),
                  ],
                ),
              ),
            ),
        ],
      ),
    ],
  );
}