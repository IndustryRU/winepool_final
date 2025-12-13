import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

Widget buildSugarFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      final selectedValues = (filters['sugar'] as List<String>?) ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (WineSugar sugar in WineSugar.values.where((s) => s != WineSugar.unknown))
            CheckboxListTile(
              title: Text(sugar.nameRu),
              value: selectedValues.contains(sugar.name),
              onChanged: (bool? value) {
                final newSelectedValues = List<String>.from(selectedValues);
                if (value == true) {
                  newSelectedValues.add(sugar.name);
                } else {
                  newSelectedValues.remove(sugar.name);
                }
                selectedFilters.value['sugar'] = newSelectedValues;
                selectedFilters.value = Map.from(selectedFilters.value);
              },
            ),
        ],
      );
    },
  );
}