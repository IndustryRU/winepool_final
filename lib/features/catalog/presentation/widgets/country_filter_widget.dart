import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/catalog/application/countries_provider.dart';
import 'package:winepool_final/features/catalog/presentation/country_selection_screen.dart';
import 'package:winepool_final/features/wines/domain/country.dart';

Widget buildCountryFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
  return Consumer(
    builder: (context, ref, child) {
      final countriesAsync = ref.watch(countriesListProvider);
      
      return countriesAsync.when(
        data: (allCountries) {
          // Получаем уже выбранные значения
          final selectedValues = (selectedFilters.value['country'] as List<String>?) ?? [];
          
          // Формируем текст для отображения выбранных стран
          String getSelectedCountriesText() {
            if (selectedValues.isEmpty) return 'Страна';
            
            if (selectedValues.length == 1) {
              final country = allCountries.firstWhere(
                (country) => country.code == selectedValues.first,
                orElse: () => Country(code: selectedValues.first, name: selectedValues.first),
              );
              return country.name;
            }
            
            return '${selectedValues.length} стран';
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  // Открываем новый экран выбора стран
                  final result = await Navigator.push<List<String>>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CountrySelectionScreen(
                        initialSelectedCountries: selectedValues,
                      ),
                    ),
                  );
                  
                  if (result != null) {
                    selectedFilters.value['country'] = result;
                    selectedFilters.value = Map.from(selectedFilters.value);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        getSelectedCountriesText(),
                        style: TextStyle(
                          color: selectedValues.isEmpty ? Colors.grey.shade600 : Colors.black87,
                        ),
                      ),
                      Icon(
                        Icons.arrow_drop_down,
                        color: Colors.grey.shade600,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки стран: $error'),
        ),
      );
    },
  );
}