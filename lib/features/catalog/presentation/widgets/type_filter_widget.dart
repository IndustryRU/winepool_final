import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

Widget buildTypeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      final selectedValues = (filters['type'] as List<String>?) ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (WineType type in WineType.values.where((t) => t != WineType.unknown))
            CheckboxListTile(
              title: Text(type.nameRu),
              value: selectedValues.contains(type.name),
              onChanged: (bool? value) {
                final newSelectedValues = List<String>.from(selectedValues);
                if (value == true) {
                  newSelectedValues.add(type.name);
                } else {
                  newSelectedValues.remove(type.name);
                }
                selectedFilters.value['type'] = newSelectedValues;
                selectedFilters.value = Map.from(selectedFilters.value);
              },
            ),
        ],
      );
    },
  );
}