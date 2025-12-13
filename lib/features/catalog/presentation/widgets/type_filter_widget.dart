import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

Widget buildTypeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  final selectedValues = (selectedFilters.value['type'] as List<String>?) ?? [];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (WineType type in WineType.values.where((t) => t != WineType.unknown))
        CheckboxListTile(
          title: Text(type.nameRu),
          value: selectedValues.contains(type.name),
          onChanged: (bool? value) {
            if (value == true) {
              selectedValues.add(type.name);
            } else {
              selectedValues.remove(type.name);
            }
            selectedFilters.value['type'] = selectedValues;
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
    ],
  );
}