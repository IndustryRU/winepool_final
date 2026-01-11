import 'package:badges/badges.dart' as badges;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

/// Виджет для отображения отдельного фильтра в панели фilters каталога.
///
/// Этот виджет отвечает за отображение состояния (активен/неактивен),
/// количество выбранных элементов (если применимо) и действия при нажатии.
class CatalogFilterChip extends ConsumerWidget {
  /// Тип фильтра, определяющий его поведение и внешний вид.
  final CatalogFilterType filterType;

  /// Обработчик нажатия на чип фильтра.
  /// Открывает соответствующее модальное окно выбора фильтров.
  final VoidCallback onTap;

  /// Обработчик удаления выбранного фильтра.
  /// Например, для сброса фильтра "Винодельня".
  final VoidCallback? onDelete;

  /// Конструктор виджета.
  const CatalogFilterChip({
    super.key,
    required this.filterType,
    required this.onTap,
    this.onDelete,
  });

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    // Подписываемся на состояние фильтров, чтобы получить информацию об активности и количестве выбранных элементов.
    // Используем поля из CatalogFiltersState напрямую
    final filterState = ref.watch(catalogFiltersProvider.select((state) {
      switch (filterType) {
        case CatalogFilterType.sort:
          return {
            'isActive': state.sortOption != null && state.sortOption != '',
            'count': 0,
          };
        case CatalogFilterType.color:
          return {
            'isActive': state.color.isNotEmpty,
            'count': state.color.length,
          };
        case CatalogFilterType.type:
          return {
            'isActive': state.type.isNotEmpty,
            'count': state.type.length,
          };
        case CatalogFilterType.sugar:
          return {
            'isActive': state.sugar.isNotEmpty,
            'count': state.sugar.length,
          };
        case CatalogFilterType.price:
          return {
            'isActive': state.minPrice != null || state.maxPrice != null,
            'count': 0, // Цена не имеет "количества", но может иметь индикатор активности
          };
        case CatalogFilterType.country:
          return {
            'isActive': state.country.isNotEmpty,
            'count': state.country.length,
          };
        case CatalogFilterType.region:
          return {
            'isActive': state.region.isNotEmpty,
            'count': state.region.length,
          };
        case CatalogFilterType.grape:
          return {
            'isActive': state.grapeIds.isNotEmpty,
            'count': state.grapeIds.length,
          };
        case CatalogFilterType.rating:
          final rating = state.minRating;
          return {
            'isActive': rating != null && rating > 0,
            'count': 0,
          };
        case CatalogFilterType.year:
          final defaultMinYear = 1900;
          final defaultMaxYear = DateTime.now().year;
          return {
            'isActive': (state.minYear != defaultMinYear) ||
                (state.maxYear != null && state.maxYear != defaultMaxYear),
            'count': 0,
          };
        case CatalogFilterType.volume:
          return {
            'isActive': state.bottleSizeIds.isNotEmpty,
            'count': state.bottleSizeIds.length,
          };
        case CatalogFilterType.winery:
          return {
            'isActive': state.wineryIds.isNotEmpty,
            'count': state.wineryIds.length,
          };
      }
    }));

    final isActive = filterState['isActive'] as bool;
    final count = filterState['count'] as int;

    log('--- CatalogFilterChip REBUILT --- Type: $filterType, IsActive: $isActive, Count: $count');

    return InputChip(
      label: badges.Badge(
        // Показываем бейдж с количеством только если счетчик > 0
        showBadge: count > 0,
        badgeContent: Text(count.toString(), style: const TextStyle(fontSize: 10)),
        badgeStyle: badges.BadgeStyle(
          badgeColor: Colors.grey[200]!,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Иконка для специфических типов фильтров
            if (filterType == CatalogFilterType.winery) ...[
              const Icon(Icons.business, size: 16),
              const SizedBox(width: 4),
            ] else if (filterType == CatalogFilterType.price) ...[
              const Icon(Icons.monetization_on_outlined, size: 16),
              const SizedBox(width: 4),
            ] else if (filterType == CatalogFilterType.rating) ...[
              const Icon(Icons.star_border_outlined, size: 16),
              const SizedBox(width: 4),
            ] else if (filterType == CatalogFilterType.sort) ...[
              const Icon(Icons.sort, size: 16),
              const SizedBox(width: 4),
            ],
            Text(_getFilterTitle(filterType)),
          ],
        ),
      ),
      selected: isActive,
      selectedColor: Colors.grey[600],
      deleteIconColor: Colors.white,
      labelStyle: TextStyle(color: isActive ? Colors.white : Colors.black),
      showCheckmark: false,
      onPressed: onTap,
      onDeleted: isActive ? onDelete ?? () {
        switch (filterType) {
          case CatalogFilterType.winery:
            ref.read(catalogFiltersProvider.notifier).setWineries([]);
            break;
          case CatalogFilterType.region:
            ref.read(catalogFiltersProvider.notifier).resetRegionFilter();
            break;
          case CatalogFilterType.grape:
            ref.read(catalogFiltersProvider.notifier).clearGrapes();
            break;
          case CatalogFilterType.color:
            ref.read(catalogFiltersProvider.notifier).resetColorFilter();
            break;
          case CatalogFilterType.type:
            ref.read(catalogFiltersProvider.notifier).resetTypeFilter();
            break;
          case CatalogFilterType.sugar:
            ref.read(catalogFiltersProvider.notifier).resetSugarFilter();
            break;
          case CatalogFilterType.price:
            ref.read(catalogFiltersProvider.notifier).resetPriceFilter();
            break;
          case CatalogFilterType.country:
            ref.read(catalogFiltersProvider.notifier).resetCountryFilter();
            break;
          case CatalogFilterType.rating:
            ref.read(catalogFiltersProvider.notifier).resetRatingFilter();
            break;
          case CatalogFilterType.year:
            ref.read(catalogFiltersProvider.notifier).resetYearFilter();
            break;
          case CatalogFilterType.volume:
            ref.read(catalogFiltersProvider.notifier).clearBottleSizes();
            break;
          case CatalogFilterType.sort:
            // Для сортировки просто сбрасываем значение
            final currentState = ref.read(catalogFiltersProvider);
            ref.read(catalogFiltersProvider.notifier).updateFilters(currentState.copyWith(sortOption: null));
            break;
        }
      } : null,
    );
  }

  /// Вспомогательная функция для получения заголовка фильтра на основе его типа.
  String _getFilterTitle(CatalogFilterType type) {
    switch (type) {
      case CatalogFilterType.sort:
        return 'Порядок';
      case CatalogFilterType.color:
        return 'Цвет';
      case CatalogFilterType.type:
        return 'Тип';
      case CatalogFilterType.sugar:
        return 'Сахар';
      case CatalogFilterType.price:
        return 'Цена';
      case CatalogFilterType.country:
        return 'Страна';
      case CatalogFilterType.region:
        return 'Регион';
      case CatalogFilterType.grape:
        return 'Сорт';
      case CatalogFilterType.rating:
        return 'Рейтинг';
      case CatalogFilterType.year:
        return 'Винтаж';
      case CatalogFilterType.volume:
        return 'Объем';
      case CatalogFilterType.winery:
        return 'Винодельня';
    }
  }
}

/// Перечисление типов фильтров, используемых в каталоге.
enum CatalogFilterType {
 sort,
  color,
  type,
  sugar,
  price,
  country,
  region,
  grape,
  rating,
  year,
  volume,
  winery,
}