import 'package:flutter/material.dart';

Widget buildVolumeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  final selectedValues = (selectedFilters.value['volume'] as List<String>?) ?? [];
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      for (String volume in ['0.375', '0.75', '1.5', '3', '6'])
        CheckboxListTile(
          title: Text('${volume} л'),
          value: selectedValues.contains(volume),
          onChanged: (bool? value) {
            if (value == true) {
              selectedValues.add(volume);
            } else {
              selectedValues.remove(volume);
            }
            selectedFilters.value['volume'] = selectedValues;
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
    ],
  );
}