import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/filter_options_provider.dart';
import 'package:winepool_final/features/catalog/application/temporary_selection_providers.dart';
import 'package:winepool_final/features/wines/domain/country.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/country_list_item.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

class CountryFilterWidget extends ConsumerWidget {
  const CountryFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Ручка
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        // Заголовок и кнопки
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text('Страны', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(temporaryCountryCodesProvider.notifier).clear();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  final temporaryCodes = ref.read(temporaryCountryCodesProvider);
                  ref.read(catalogFiltersProvider.notifier).updateFilters(ref.read(catalogFiltersProvider).copyWith(country: temporaryCodes));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        // Список популярных стран
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final popularCountriesAsync = ref.watch(popularCountriesProvider);
              final temporaryCountryCodes = ref.watch(temporaryCountryCodesProvider);

              return popularCountriesAsync.when(
                loading: () => const Center(child: ShimmerLoadingIndicator()),
                error: (error, stack) => Center(child: Text('Ошибка: $error')),
                data: (countries) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text('Популярные страны', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: countries.length,
                          itemBuilder: (context, index) {
                            final country = countries[index];
                            return CountryListItem(
                              country: country,
                              isSelected: temporaryCountryCodes.contains(country.code),
                              onChanged: (isSelected) {
                                ref.read(temporaryCountryCodesProvider.notifier).toggle(country.code);
                              },
                            );
                          },
                        ),
                      ),
                      // Выбранные страны, не входящие в популярные
                      Builder(
                        builder: (context) {
                          final allCountriesAsync = ref.watch(allCountriesProvider);
                          final popularCountryCodes = countries.map((c) => c.code).toSet();
                          final selectedNotPopularCodes = temporaryCountryCodes.where((code) => !popularCountryCodes.contains(code)).toList();

                          if (selectedNotPopularCodes.isNotEmpty && allCountriesAsync is AsyncData<List<Country>>) {
                            final allCountriesData = allCountriesAsync.value;
                            final selectedCountries = selectedNotPopularCodes.map((code) {
                              return allCountriesData.firstWhere((c) => c.code == code, orElse: () => Country(code: code, name: '...', isPopular: false));
                            }).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Text('Выбранные', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: selectedCountries.map((country) {
                                      return Chip(
                                        label: Text(country.name),
                                        onDeleted: () {
                                          ref.read(temporaryCountryCodesProvider.notifier).toggle(country.code);
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        // Ссылка на полный список
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              context.go('/wines-catalog/country-selection');
            },
            child: Text('Все страны', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue)),
          ),
        ),
      ],
    );
  }
}