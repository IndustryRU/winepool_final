import 'package:flutter/material.dart';

Widget buildCountryFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  // Получаем список всех стран
  final allCountries = [
    {'code': 'FR', 'name': 'Франция'},
    {'code': 'IT', 'name': 'Италия'},
    {'code': 'ES', 'name': 'Испания'},
    {'code': 'DE', 'name': 'Германия'},
    {'code': 'US', 'name': 'США'},
    {'code': 'AU', 'name': 'Австралия'},
    {'code': 'AR', 'name': 'Аргентина'},
    {'code': 'CL', 'name': 'Чили'},
    {'code': 'ZA', 'name': 'ЮАР'},
    {'code': 'NZ', 'name': 'Новая Зеландия'},
    {'code': 'RU', 'name': 'Россия'},
    {'code': 'GB', 'name': 'Великобритания'},
    {'code': 'PT', 'name': 'Португалия'},
    {'code': 'AU', 'name': 'Австрия'},
    {'code': 'HU', 'name': 'Венгрия'},
    {'code': 'CZ', 'name': 'Чехия'},
    {'code': 'GR', 'name': 'Греция'},
    {'code': 'BE', 'name': 'Бельгия'},
    {'code': 'CH', 'name': 'Швейцария'},
    {'code': 'JP', 'name': 'Япония'},
    {'code': 'CN', 'name': 'Китай'},
  ];
  
  return ValueListenableBuilder<Map<String, dynamic>>(
    valueListenable: selectedFilters,
    builder: (context, filters, child) {
      // Получаем уже выбранные значения
      final selectedValues = (filters['country'] as List<String>?) ?? [];
      
      // Состояние для текста поиска
      final searchController = TextEditingController();
      final filteredCountries = ValueNotifier<List<Map<String, String>>>(allCountries);
      
      // Обработчик изменения текста поиска
      void onSearchTextChanged(String text) {
        if (text.isEmpty) {
          filteredCountries.value = allCountries;
        } else {
          filteredCountries.value = allCountries
              .where((country) => country['name']!.toLowerCase().contains(text.toLowerCase()))
              .toList();
        }
      }
      
      // Обновляем фильтрованный список при изменении начального значения
      WidgetsBinding.instance.addPostFrameCallback((_) {
        onSearchTextChanged(searchController.text);
      });
      
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: searchController,
            decoration: const InputDecoration(
              labelText: 'Поиск по стране',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              onSearchTextChanged(value);
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ValueListenableBuilder<List<Map<String, String>>>(
              valueListenable: filteredCountries,
              builder: (context, countries, child) {
                return ListView(
                  children: [
                    for (Map<String, String> country in countries)
                      CheckboxListTile(
                        title: Text(country['name']!),
                        value: selectedValues.contains(country['code']),
                        onChanged: (bool? value) {
                          final newSelectedValues = List<String>.from(selectedValues);
                          if (value == true) {
                            newSelectedValues.add(country['code']!);
                          } else {
                            newSelectedValues.remove(country['code']!);
                          }
                          selectedFilters.value['country'] = newSelectedValues;
                          selectedFilters.value = Map.from(selectedFilters.value);
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      );
    },
  );
}