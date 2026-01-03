import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/catalog/application/regions_provider.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/presentation/region_selection_screen.dart';
import 'package:winepool_final/features/wines/domain/region.dart';

class RegionFilterWidget extends ConsumerWidget {
  const RegionFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Получаем текущие фильтры для получения выбранных стран
    final catalogFilters = ref.watch(catalogFiltersProvider);
    final selectedCountries = catalogFilters.country ?? [];
    
    // Получаем список регионов на основе выбранных стран
    final regionsAsync = ref.watch(regionsListProvider(selectedCountries));
    
    return regionsAsync.when(
      data: (allRegions) {
        // Получаем уже выбранные значения регионов
        final selectedValues = catalogFilters.region ?? [];
        
        // Формируем текст для отображения выбранных регионов
        String getSelectedRegionsText() {
          if (selectedValues.isEmpty) return 'Регион';
          
          if (selectedValues.length == 1) {
            final region = allRegions.firstWhere(
              (region) => region.id == selectedValues.first,
              orElse: () => Region(id: selectedValues.first, name: selectedValues.first, countryCode: ''),
            );
            return region.name ?? region.id ?? '';
          }
          
          return '${selectedValues.length} регионов';
        }

        return GestureDetector(
          onTap: () async {
            // Открываем новый экран выбора регионов
            final result = await Navigator.push<List<String>>(
              context,
              MaterialPageRoute(
                builder: (context) => RegionSelectionScreen(
                  initialSelectedRegions: selectedValues,
                  availableCountries: selectedCountries,
                ),
              ),
            );
            
            if (result != null) {
              ref.read(catalogFiltersProvider.notifier).updateRegion(result);
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
                  getSelectedRegionsText(),
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
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Ошибка загрузки регионов: $error'),
      ),
    );
  }
}
