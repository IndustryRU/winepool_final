import 'package:flutter/material.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';

Widget buildSugarFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  final selectedValues = (selectedFilters.value['sugar'] as List<String>?) ?? [];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (WineSugar sugar in WineSugar.values.where((s) => s != WineSugar.unknown))
        CheckboxListTile(
          title: Text(sugar.nameRu),
          value: selectedValues.contains(sugar.name),
          onChanged: (bool? value) {
            if (value == true) {
              selectedValues.add(sugar.name);
            } else {
              selectedValues.remove(sugar.name);
            }
            selectedFilters.value['sugar'] = selectedValues;
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
    ],
  );
}