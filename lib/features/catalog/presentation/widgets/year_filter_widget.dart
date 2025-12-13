import 'package:flutter/material.dart';

Widget buildYearFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      final minYear = filters['min_year'] ?? 1900;
      final maxYear = filters['max_year'] ?? DateTime.now().year;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: minYear,
                  items: [
                    for (int year = 1900; year <= DateTime.now().year; year++)
                      DropdownMenuItem(value: year, child: Text(year.toString())),
                  ],
                  onChanged: (value) {
                    selectedFilters.value['min_year'] = value;
                    selectedFilters.value = Map.from(selectedFilters.value);
                  },
                ),
              ),
              SizedBox(width: 16),
              Text('до'),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: maxYear,
                  items: [
                    for (int year = 1900; year <= DateTime.now().year; year++)
                      DropdownMenuItem(value: year, child: Text(year.toString())),
                  ],
                  onChanged: (value) {
                    selectedFilters.value['max_year'] = value;
                    selectedFilters.value = Map.from(selectedFilters.value);
                  },
                ),
              ),
            ],
          ),
        ],
      );
    },
  );
}