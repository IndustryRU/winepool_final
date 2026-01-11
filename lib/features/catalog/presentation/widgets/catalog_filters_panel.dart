import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/catalog_filter_chip.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/winery_filter_widget.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/simple_filter_widget.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/catalog/application/wineries_provider.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';
import 'dart:developer';

/// Виджет панели фильтров для экрана каталога.
///
/// Отображает горизонтальный список чипов фильтров.
/// Каждый чип отвечает за отображение своего состояния и вызывает
/// соответствующее модальное окно при нажатии.
class CatalogFiltersPanel extends ConsumerWidget {
  /// Конструктор виджета.
 const CatalogFiltersPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Список всех типов фильтров, которые должны отображаться в панели
    // Порядок определяет порядок отображения чипов
    const filterTypes = [
      CatalogFilterType.sort,
      CatalogFilterType.winery,
      CatalogFilterType.price,
      CatalogFilterType.rating,
      CatalogFilterType.color,
      CatalogFilterType.sugar,
      CatalogFilterType.type,
      CatalogFilterType.country,
      CatalogFilterType.region,
      CatalogFilterType.grape,
      CatalogFilterType.year,
      CatalogFilterType.volume,
    ];

    // Получаем состояние фильтров
    final filters = ref.watch(catalogFiltersProvider);

    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final filterType in filterTypes)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: CatalogFilterChip(
                filterType: filterType,
                // TODO: Реализовать обработчики onTap и onDelete в зависимости от типа фильтра
                // Временно используем пустые функции
                onTap: () {
                  log('Tapped on filter: $filterType');
                  if (filterType == CatalogFilterType.winery) {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * (2 / 3),
                          width: double.infinity, // На всю ширину
                          child: const WineryFilterWidget(),
                        );
                      },
                    );
                  } else if (filterType == CatalogFilterType.color) {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Consumer(
                          builder: (context, ref, _) {
                            final availableColorsAsync = ref.watch(availableColorsProvider);
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * (2 / 3),
                              width: double.infinity,
                              child: availableColorsAsync.when(
                                loading: () => const ShimmerLoadingIndicator(),
                                error: (err, stack) => Center(child: Text('Ошибка: $err')),
                                data: (availableColors) {
                                  return SimpleFilterWidget(
                                    title: 'Цвет',
                                    allOptions: availableColors,
                                    selectedOptions: ref.watch(catalogFiltersProvider).color,
                                    onApply: (selected) {
                                      ref.read(catalogFiltersProvider.notifier).updateFilters(
                                            ref.read(catalogFiltersProvider).copyWith(
                                                  color: selected.cast<WineColor>(),
                                                ),
                                          );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    );
                  } else if (filterType == CatalogFilterType.sugar) {
                    showModalBottomSheet<void>(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * (2 / 3),
                          width: double.infinity,
                          child: SimpleFilterWidget(
                            title: 'Сахар',
                            allOptions: WineSugar.values,
                            selectedOptions: ref.read(catalogFiltersProvider).sugar,
                            onApply: (selected) => ref.read(catalogFiltersProvider.notifier).updateFilters(
                              ref.read(catalogFiltersProvider).copyWith(sugar: selected.cast<WineSugar>()),
                            ),
                          ),
                        );
                      },
                    );
                  }
                  // TODO: Добавить обработку для других типов фильтров
                },
              ),
            ),
          // Показываем кнопку сброса, если есть активные фильтры
          if (filters.isAnyFilterActive)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: ActionChip(
                avatar: const Icon(Icons.refresh, size: 16),
                label: const Text('Сбросить'),
                onPressed: () {
                  ref.read(catalogFiltersProvider.notifier).resetAllFilters();
                },
              ),
            ),
        ],
      ),
    );
  }
}
