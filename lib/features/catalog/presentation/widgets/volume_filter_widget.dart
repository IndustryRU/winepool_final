import 'package:flutter/material.dart';

Widget buildVolumeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      final selectedValues = (filters['volume'] as List<String>?) ?? [];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          for (String volume in ['0.375', '0.75', '1.5', '3', '6'])
            CheckboxListTile(
              title: Text('${volume} л'),
              value: selectedValues.contains(volume),
              onChanged: (bool? value) {
                final newSelectedValues = List<String>.from(selectedValues);
                if (value == true) {
                  newSelectedValues.add(volume);
                } else {
                  newSelectedValues.remove(volume);
                }
                selectedFilters.value['volume'] = newSelectedValues;
                selectedFilters.value = Map.from(selectedFilters.value);
              },
            ),
        ],
      );
    },
  );
}