import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/catalog_filter_chip.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/winery_filter_widget.dart';
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
      CatalogFilterType.winery, // Переместили сюда
      CatalogFilterType.color,
      CatalogFilterType.type,
      CatalogFilterType.sugar,
      CatalogFilterType.price,
      CatalogFilterType.country,
      CatalogFilterType.region,
      CatalogFilterType.grape,
      CatalogFilterType.rating,
      CatalogFilterType.year,
      CatalogFilterType.volume,
    ];

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
                  }
                  // TODO: Добавить обработку для других типов фильтров
                },
              ),
            ),
        ],
      ),
    );
  }
}
