import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

Widget buildColorFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      final selectedValues = (filters['color'] as List<String>?) ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (WineColor color in [WineColor.red, WineColor.white, WineColor.rose])
            CheckboxListTile(
              title: Text(color.nameRu),
              value: selectedValues.contains(color.name),
              onChanged: (bool? value) {
                final newSelectedValues = List<String>.from(selectedValues);
                if (value == true) {
                  newSelectedValues.add(color.name);
                } else {
                  newSelectedValues.remove(color.name);
                }
                selectedFilters.value['color'] = newSelectedValues;
                selectedFilters.value = Map.from(selectedFilters.value);
              },
            ),
        ],
      );
    },
  );
}