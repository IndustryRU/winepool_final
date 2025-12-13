import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

Widget buildColorFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  final selectedValues = (selectedFilters.value['color'] as List<String>?) ?? [];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (WineColor color in [WineColor.red, WineColor.white, WineColor.rose])
        CheckboxListTile(
          title: Text(color.nameRu),
          value: selectedValues.contains(color.name),
          onChanged: (bool? value) {
            if (value == true) {
              selectedValues.add(color.name);
            } else {
              selectedValues.remove(color.name);
            }
            selectedFilters.value['color'] = selectedValues;
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
    ],
  );
}