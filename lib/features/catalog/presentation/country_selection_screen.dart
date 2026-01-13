import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/core/widgets/custom_search_field.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/country_list_item.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';
import '../application/catalog_filters_provider.dart';
import '../application/filter_options_provider.dart';
import '../application/temporary_selection_providers.dart';

class CountrySelectionScreen extends HookConsumerWidget {
  const CountrySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCodes = ref.watch(temporaryCountryCodesProvider);
    final searchQuery = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Страны'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(temporaryCountryCodesProvider.notifier).clear();
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // Здесь мы не применяем фильтр, а просто возвращаемся назад,
              // т.к. состояние уже обновлено в temporary-провайдере.
              // Применение произойдет в CountryFilterWidget.
              context.pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              onChanged: (value) {
                searchQuery.value = value;
              },
              hintText: 'Поиск стран...',
            ),
          ),
          Expanded(
            child: ref.watch(allCountriesProvider).when(
                  loading: () => const ShimmerLoadingIndicator(),
                  error: (error, stack) => Center(child: Text('Ошибка: $error')),
                  data: (countries) {
                    final filteredCountries = countries.where((country) {
                      final nameLower = country.name.toLowerCase();
                      final searchLower = searchQuery.value.toLowerCase();
                      return nameLower.contains(searchLower);
                    }).toList();

                    return ListView.separated(
                      itemCount: filteredCountries.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final country = filteredCountries[index];
                        final isSelected = selectedCodes.contains(country.code);

                        return CountryListItem(
                          country: country,
                          isSelected: isSelected,
                          onChanged: (selected) {
                            ref.read(temporaryCountryCodesProvider.notifier).toggle(country.code);
                          },
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}