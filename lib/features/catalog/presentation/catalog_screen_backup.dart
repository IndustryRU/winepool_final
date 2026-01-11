import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:badges/badges.dart' as badges;
//import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/catalog/application/catalog_controller.dart' as old_controller;
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart' as new_provider;
import 'package:winepool_final/features/catalog/application/catalog_controller.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/filter_helpers.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/price_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/color_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/type_filter_widget.dart';
//import 'package:winepool_final/features/catalog/presentation/widgets/sugar_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/country_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/region_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/grape_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/rating_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/year_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/bottle_size_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/winery_filter_widget.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

// Провайдер для фильтров

// Используем сгенерированный провайдер напрямую
// final filteredWinesProvider = FutureProvider.autoDispose.family<List<Wine>, Map<String, dynamic>>((ref, filters) async {
//   return await ref.watch(winesWithFiltersProvider(filters));
// });

class CatalogScreen extends HookConsumerWidget {
  const CatalogScreen({super.key});

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(catalogFiltersProvider);
    final winesAsync = ref.watch(winesWithActiveFiltersProvider);
    final scale = useState<double>(1.0);
    final alignment = useState<Alignment>(Alignment.center);
    final controller = useAnimationController(duration: const Duration(milliseconds: 100));
    final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    final animation = Tween<double>(begin: 1.0, end: 1.4).animate(curvedAnimation);

    useEffect(() {
      void listener() {
        scale.value = animation.value;
      }

      animation.addListener(listener);
      return () => animation.removeListener(listener);
    }, [animation]);

    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        // Используем GoRouter для навигации назад
        context.go('/catalog'); // Предполагаем, что каталог открывается из buyer-home
      },
      child: GestureDetector(
        onLongPressStart: (LongPressStartDetails details) {
          // Convert local position to alignment
          final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
          if (renderBox == null) return; // Проверяем, что RenderBox не null
          
          Offset localPosition = details.localPosition;
          Size size = renderBox.size;
          double dx = (localPosition.dx / size.width - 0.5) * 2; // Convert to range [-1, 1]
          double dy = (localPosition.dy / size.height - 0.5) * 2; // Convert to range [-1, 1]
          alignment.value = Alignment(dx, dy);
          
          controller
            ..duration = const Duration(milliseconds: 100);
          controller.forward();
        },
        onLongPressEnd: (LongPressEndDetails details) {
          // Проверяем, что контроллер все еще активен и не завершил анимацию в обратном направлении
          if (controller.status != AnimationStatus.dismissed) {
            controller
              ..duration = const Duration(milliseconds: 10);
            try {
              controller.reverse();
            } catch (e) {
              // Игнорируем ошибку, если контроллер уже уничтожен
            }
          }
        },
        child: Transform.scale(
          scale: scale.value,
          alignment: alignment.value,
          child: Scaffold(
        appBar: AppBar(
          title: const Text('Каталог вин'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go('/catalog');
            },
          ),
        ),
        body: Column(
          children: [
            // Горизонтальный слайдер фильтров
            FilterSlider(
              filters: filters,
              onFiltersChanged: (newFilters) {
                ref.read(catalogFiltersProvider.notifier).updateFilters(newFilters);
              },
            ),
            const SizedBox(height: 16),
            // Список вин
            Expanded(
              child: winesAsync.when(
                data: (wines) => wines.isEmpty
                    ? const Center(
                        child: Text('Ничего не найдено'),
                      )
                    : ListView.builder(
                        itemCount: wines.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              GoRouter.of(context).push('/wine/${wines[index].id}', extra: wines[index]);
                            },
                            child: WineTile(wine: wines[index]),
                          );
                        },
                      ),
                loading: () => const ShimmerLoadingIndicator(),
                error: (error, stack) => Center(
                  child: SelectableText.rich(
                    TextSpan(
                      text: 'Ошибка: ${error.toString()}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ), // Закрывающая скобка для Scaffold
    ), // Закрывающая скобка для Transform.scale
 ), // Закрывающая скобка для GestureDetector
); // Закрывающая скобка для PopScope
  }

}

// Фильтры
const List<String> filterKeys = [
  'color',
 'type',
  'sugar',
  'price',
  'country',
  'region',
 'grape',
  'min_rating',
 'year',
 'volume',
 'winery',
];

class FilterSlider extends HookConsumerWidget {
  final Map<String, dynamic> filters;
   final Function(Map<String, dynamic>) onFiltersChanged;

   const FilterSlider({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
 Widget build(BuildContext context, WidgetRef ref) {
    final selectedFilters = useState<Map<String, dynamic>>(Map.from(filters));

    final sortOption = selectedFilters.value['sort_option'] ?? '';

    // Создаем временные переменные для всех возможных фильтров на уровне build метода
    final tempPriceRange = useState(RangeValues(0.0, 1000.0)); // Значения по умолчанию, будут обновлены при вызове модального окна
    final tempShowUnavailable = useState(false);
    final tempColors = useState<List<String>>([]);
    final tempTypes = useState<List<String>>([]);
    final tempSugars = useState<List<String>>([]);
    final tempCountries = useState<List<String>>([]);
    final tempRegions = useState<List<String>>([]);
    final tempGrapes = useState<List<String>>([]);
    final tempRating = useState<double>(selectedFilters.value['min_rating']?.toDouble() ?? 0.0);
    final tempMinYear = useState<int>(1900);
    final tempMaxYear = useState<int>(DateTime.now().year);
    final tempVolumes = useState<List<String>>([]);

    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          // Кнопка сортировки (первая)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterButton(
              filterKey: 'sort',
              isActive: sortOption.isNotEmpty,
              onPressed: () => _showSortModal(context, selectedFilters, ref, onFiltersChanged),
            ),
          ),
          for (String filterKey in filterKeys)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child:
                () {
                  if (filterKey == 'winery') {
                    final wineryIds = (filters['winery_ids'] as List<dynamic>?)?.cast<String>() ?? [];
                    log('--- FilterSlider is building FilterButton for "winery" --- Active: ${wineryIds.isNotEmpty}, Count: ${wineryIds.length}');
                  }
                  return filterKey == 'winery'
                  ? FilterButton(
                      filterKey: filterKey,
                      isActive: _isFilterActive(filters, filterKey),
                    onPressed: () => _showFilterModal(
                      context, 
                      filterKey, 
                      selectedFilters, 
                      ref, 
                      onFiltersChanged,
                      tempPriceRange,
                      tempShowUnavailable,
                      tempColors,
                      tempTypes,
                      tempSugars,
                      tempCountries,
                      tempRegions,
                      tempGrapes,
                      tempRating,
                      tempMinYear,
                      tempMaxYear,
                      tempVolumes,
                    ),
                    selectedCount: (filters['winery_ids'] as List<dynamic>?)?.length ?? 0,
                    onDeleted: () => ref.read(catalogFiltersProvider.notifier).clearWineries(),
                  )
                : FilterButton(
                    filterKey: filterKey,
                    isActive: _isFilterActive(filters, filterKey),
                    onPressed: () => _showFilterModal(
                      context, 
                      filterKey, 
                      selectedFilters, 
                      ref, 
                      onFiltersChanged,
                      tempPriceRange,
                      tempShowUnavailable,
                      tempColors,
                      tempTypes,
                      tempSugars,
                      tempCountries,
                      tempRegions,
                      tempGrapes,
                      tempRating,
                      tempMinYear,
                      tempMaxYear,
                      tempVolumes,
                      ),
                    );
                }()
            ),
        ],
      ),
    );
 }

 // Метод для проверки активности фильтра
  bool _isFilterActive(Map<String, dynamic> currentFilters, String filterKey) {
    switch (filterKey) {
      case 'color':
      case 'type':
      case 'sugar':
      case 'country':
      case 'region':
      case 'grape':
      case 'volume':
      case 'winery':
        return (currentFilters['winery_ids'] as List<dynamic>?)?.isNotEmpty ?? false;
      case 'price':
        // Для цены проверяем, есть ли установленные минимальная или максимальная цена
        return currentFilters['min_price'] != null || currentFilters['max_price'] != null;
      case 'min_rating':
        // Для рейтинга проверяем, больше ли значение 0
        return currentFilters['min_rating'] != null && currentFilters['min_rating'] > 0;
      case 'year':
        // Для года проверяем, заданы ли конкретные годы (отличные от стандартных)
        final minYear = currentFilters['min_year'];
        final maxYear = currentFilters['max_year'];
        final defaultMinYear = 190;
        final defaultMaxYear = DateTime.now().year;
        
        return (minYear != null && minYear != defaultMinYear) || 
               (maxYear != null && maxYear != defaultMaxYear);
      default:
        // Для остальных фильтров проверяем наличие ключа
        return currentFilters.containsKey(filterKey);
    }
  }

  void _showFilterModal(
    BuildContext context,
    String filterKey,
    ValueNotifier<Map<String, dynamic>> selectedFilters,
    WidgetRef ref,
    Function(Map<String, dynamic>) onFiltersChanged,
    ValueNotifier<RangeValues> tempPriceRange,
    ValueNotifier<bool> tempShowUnavailable,
    ValueNotifier<List<String>> tempColors,
    ValueNotifier<List<String>> tempTypes,
    ValueNotifier<List<String>> tempSugars,
    ValueNotifier<List<String>> tempCountries,
    ValueNotifier<List<String>> tempRegions,
    ValueNotifier<List<String>> tempGrapes,
    ValueNotifier<double> tempRating,
    ValueNotifier<int> tempMinYear,
    ValueNotifier<int> tempMaxYear,
    ValueNotifier<List<String>> tempVolumes,
  ) async {
    // Получаем текущие фильтры из провайдера
    final currentFilters = ref.read(catalogFiltersProvider);
    
    // Обновляем временные переменные текущими значениями фильтров
    tempPriceRange.value = RangeValues(
      (currentFilters['min_price']?.toDouble() ?? 0.0),
      (currentFilters['max_price']?.toDouble() ?? 1000.0)
    );
    tempShowUnavailable.value = currentFilters['show_unavailable'] ?? false;
    tempColors.value = (currentFilters['color'] as List<dynamic>?)?.cast<String>() ?? [];
    tempTypes.value = (currentFilters['type'] as List<dynamic>?)?.cast<String>() ?? [];
    tempSugars.value = (currentFilters['sugar'] as List<dynamic>?)?.cast<String>() ?? [];
    tempCountries.value = (currentFilters['country'] as List<dynamic>?)?.cast<String>() ?? [];
    tempRegions.value = (currentFilters['region'] as List<dynamic>?)?.cast<String>() ?? [];
    tempGrapes.value = (currentFilters['grape'] as List<dynamic>?)?.cast<String>() ?? [];
    tempRating.value = (currentFilters['min_rating'] as num?)?.toDouble() ?? 0.0;
    tempMinYear.value = (currentFilters['min_year'] as num?)?.toInt() ?? 1900;
    tempMaxYear.value = (currentFilters['max_year'] as num?)?.toInt() ?? DateTime.now().year;
    tempVolumes.value = (currentFilters['volume'] as List<dynamic>?)?.cast<String>() ?? [];

    if (filterKey == 'year') {
      // Для фильтра винтажа открываем новый экран выбора винтажа
      context.push('/wines-catalog/vintage-selection');
    } else if (filterKey == 'volume') {
      // Для фильтра объема бутылки открываем новый экран выбора объема
      context.push('/wines-catalog/bottle-size-selection');
    } else if (filterKey == 'price') {
      // Для ценного фильтра открываем модальное окно и ждем возвращаемого значения
      // Читаем текущие значения цен из провайдера
      final currentGlobalFilters = ref.read(catalogFiltersProvider);
      final currentMinPrice = currentGlobalFilters['min_price']?.toDouble() ?? 0.0;
      final currentMaxPrice = currentGlobalFilters['max_price']?.toDouble() ?? 100.0;
      
      // СРАЗУ ИНИЦИАЛИЗИУЕМ временную переменную актуальными значениями
      RangeValues currentPriceRange = RangeValues(currentMinPrice, currentMaxPrice);
      bool? currentShowUnavailable;

      final returnedValues = await showModalBottomSheet<RangeValues>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(getFilterTitle(filterKey), style: Theme.of(context).textTheme.titleLarge),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                // Логика "Сбросить и Применить" для ценового фильтра
                                // СБРОСИТЬ ВСЕ ЛОКАЛЬНЫЕ TEMP ПЕРЕМЕННЫЕ ДО ИХ НАЧАЛЬНЫХ/ДЕФОЛТНЫХ ЗНАЧЕНИЙ
                                tempPriceRange.value = RangeValues(0, 100000);
                                tempShowUnavailable.value = false;
                                
                                // СОБРАТЬ НОВЫЙ ОБЪЕКТ newFilters ИЗ ЭТИХ ТОЛЬКО ЧТО СБРОШЕННЫХ ЛОКАЛЬНЫХ ПЕРЕМЕННЫХ
                                final newFilters = <String, dynamic>{
                                  'min_price': tempPriceRange.value.start,
                                  'max_price': tempPriceRange.value.end,
                                  'show_unavailable': tempShowUnavailable.value,
                                  'color': [...tempColors.value],
                                  'type': [...tempTypes.value],
                                  'sugar': [...tempSugars.value],
                                  'country': [...tempCountries.value],
                                  'region': [...tempRegions.value],
                                  'grape': [...tempGrapes.value],
                                  'min_rating': tempRating.value,
                                  'min_year': tempMinYear.value,
                                  'max_year': tempMaxYear.value,
                                  'volume': [...tempVolumes.value],
                                };
                                
                                // Удаляем пустые списки, чтобы не сохранять их как фильтры
                                if (newFilters['color'].isEmpty) newFilters.remove('color');
                                if (newFilters['type'].isEmpty) newFilters.remove('type');
                                if (newFilters['sugar'].isEmpty) newFilters.remove('sugar');
                                if (newFilters['country'].isEmpty) newFilters.remove('country');
                                if (newFilters['region'].isEmpty) newFilters.remove('region');
                                if (newFilters['grape'].isEmpty) newFilters.remove('grape');
                                if (newFilters['volume'].isEmpty) newFilters.remove('volume');
                                if (newFilters['min_rating'] == 0.0) newFilters.remove('min_rating');
                                if (newFilters['min_year'] == 190 && newFilters['max_year'] == DateTime.now().year) {
                                  newFilters.remove('min_year');
                                  newFilters.remove('max_year');
                                }
                                
                                // ВЫЗВАТЬ ref.read(catalogFiltersProvider.notifier).setAllFilters(newFilters)
                                ref.read(catalogFiltersProvider.notifier).setAllFilters(newFilters);
                                
                                // ЗАКРЫТЬ МОДАЛЬНОЕ ОКНО Navigator.of(context).pop()
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.refresh),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              onPressed: () {
                                // Закрыть модальное окно, вернув текущие значения из виджета
                                Navigator.of(context).pop(currentPriceRange);
                              },
                              icon: Icon(Icons.check),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _buildFilterContent(context, filterKey, selectedFilters, ref, (range) {
                              // Коллбэк для обновления currentPriceRange
                              currentPriceRange = range;
                              // Обновляем также временную переменную
                              Future.microtask(() {
                                tempPriceRange.value = range;
                              });
                            }, (showUnavailable) {
                              // Коллбэк для обновления currentShowUnavailable
                              currentShowUnavailable = showUnavailable;
                              // Обновляем также временную переменную
                              Future.microtask(() {
                                tempShowUnavailable.value = showUnavailable;
                              });
                            }),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );

      // Если возвращаемое значение не null (пользователь не просто закрыл окно), обновляем фильтры
      if (returnedValues != null) {
        // Собираем все текущие фильтры и обновляем только те, которые были изменены в модальном окне
        final currentFilters = ref.read(catalogFiltersProvider);
        final newFilters = Map<String, dynamic>.from(currentFilters);
        
        // Обновляем диапазон цен
        newFilters['min_price'] = returnedValues.start;
        newFilters['max_price'] = returnedValues.end;
        
        // Обновляем значение show_unavailable, если оно было изменено
        if (currentShowUnavailable != null) {
          newFilters['show_unavailable'] = currentShowUnavailable!;
        }
        
        // Атомарно применяем все фильтры
        ref.read(catalogFiltersProvider.notifier).setAllFilters(newFilters);
      }
    } else {
      // Для остальных фильтров создаем модальное окно с обновленной логикой
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return DraggableScrollableSheet(
                expand: false,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(getFilterTitle(filterKey), style: Theme.of(context).textTheme.titleLarge),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                // Остальная логика сброса для других фильтров
                                // СБРОСИТЬ ВСЕ ЛОКАЛЬНЫЕ TEMP ПЕРЕМЕННЫЕ ДО ИХ НАЧАЛЬНЫХ/ДЕФОЛТНЫХ ЗНАЧЕНИЙ
                                tempPriceRange.value = RangeValues(0, 1000);
                                tempShowUnavailable.value = false;
                                tempColors.value = [];
                                tempTypes.value = [];
                                tempSugars.value = [];
                                tempCountries.value = [];
                                tempRegions.value = [];
                                tempGrapes.value = [];
                                tempRating.value = 0.0;
                                tempMinYear.value = 1900;
                                tempMaxYear.value = DateTime.now().year;
                                tempVolumes.value = [];
                                
                                // СОБРАТЬ НОВЫЙ ОБЪЕКТ newFilters ИЗ ЭТИХ ТОЛЬКО ЧТО СБРОШЕННЫХ ЛОКАЛЬНЫХ ПЕРЕМЕННЫХ
                                final newFilters = <String, dynamic>{

                                  'min_price': tempPriceRange.value.start,
                                  'max_price': tempPriceRange.value.end,
                                  'show_unavailable': tempShowUnavailable.value,
                                  'color': [...tempColors.value],
                                  'type': [...tempTypes.value],
                                  'sugar': [...tempSugars.value],
                                  'country': [...tempCountries.value],
                                  'region': [...tempRegions.value],
                                  'grape': [...tempGrapes.value],
                                  'min_rating': tempRating.value,
                                  'min_year': tempMinYear.value,
                                  'max_year': tempMaxYear.value,
                                  'volume': [...tempVolumes.value],
                                };
                                
                                // Удаляем пустые списки, чтобы не сохранять их как фильтры
                                if (newFilters['color'].isEmpty) newFilters.remove('color');
                                if (newFilters['type'].isEmpty) newFilters.remove('type');
                                if (newFilters['sugar'].isEmpty) newFilters.remove('sugar');
                                if (newFilters['country'].isEmpty) newFilters.remove('country');
                                if (newFilters['region'].isEmpty) newFilters.remove('region');
                                if (newFilters['grape'].isEmpty) newFilters.remove('grape');
                                if (newFilters['volume'].isEmpty) newFilters.remove('volume');
                                if (newFilters['min_rating'] == 0.0) newFilters.remove('min_rating');
                                if (newFilters['min_year'] == 190 && newFilters['max_year'] == DateTime.now().year) {
                                  newFilters.remove('min_year');
                                  newFilters.remove('max_year');
                                }
                                
                                // ВЫЗВАТЬ СПЕЦИФИЧЕСКИЙ МЕТОД СБРОСА В ЗАВИСИМОСТИ ОТ ТИПА ФИЛЬТРА
                                switch (filterKey) {
                                  case 'color':
                                    ref.read(catalogFiltersProvider.notifier).resetColorFilter();
                                    break;
                                  case 'type':
                                    ref.read(catalogFiltersProvider.notifier).resetTypeFilter();
                                    break;
                                  case 'sugar':
                                    ref.read(catalogFiltersProvider.notifier).resetSugarFilter();
                                    break;
                                  case 'country':
                                    ref.read(catalogFiltersProvider.notifier).resetCountryFilter();
                                    break;
                                  case 'region':
                                    ref.read(catalogFiltersProvider.notifier).resetRegionFilter();
                                    break;
                                  case 'grape':
                                    ref.read(catalogFiltersProvider.notifier).resetGrapeFilter();
                                    break;
                                  case 'min_rating':
                                    ref.read(catalogFiltersProvider.notifier).resetRatingFilter();
                                    tempRating.value = 0.0;
                                    break;
                                  case 'volume':
                                    ref.read(catalogFiltersProvider.notifier).resetVolumeFilter();
                                    break;
                                  case 'show_unavailable':
                                    ref.read(catalogFiltersProvider.notifier).resetShowUnavailableFilter();
                                    break;
                                  case 'winery':
                                    ref.read(catalogFiltersProvider.notifier).clearWineries();
                                    break;
                                }
                                
                                // ЗАКРЫТЬ МОДАЛЬНОЕ ОКНО Navigator.of(context).pop()
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.refresh),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              onPressed: () {
                                // Применить фильтр - собираем полный набор фильтров из временных переменных
                                // Обновляем tempPriceRange перед применением фильтров, чтобы убедиться, что значения актуальны
                                final currentFilters = ref.read(catalogFiltersProvider);
                                tempPriceRange.value = RangeValues(
                                  (currentFilters['min_price']?.toDouble() ?? 0.0),
                                  (currentFilters['max_price']?.toDouble() ?? 1000.0)
                                );
                                
                                final newFilters = <String, dynamic>{

                                  'min_price': tempPriceRange.value.start,
                                  'max_price': tempPriceRange.value.end,
                                  'show_unavailable': tempShowUnavailable.value,
                                  'color': [...tempColors.value],
                                  'type': [...tempTypes.value],
                                  'sugar': [...tempSugars.value],
                                  'country': [...tempCountries.value],
                                  'region': [...tempRegions.value],
                                  'grape': [...tempGrapes.value],
                                  'min_rating': tempRating.value,
                                  'min_year': tempMinYear.value,
                                  'max_year': tempMaxYear.value,
                                  'volume': [...tempVolumes.value],
                                };
                                // Удаляем пустые списки, чтобы не сохранять их как фильтры
                                if (newFilters['color'].isEmpty) newFilters.remove('color');
                                if (newFilters['type'].isEmpty) newFilters.remove('type');
                                if (newFilters['sugar'].isEmpty) newFilters.remove('sugar');
                                if (newFilters['country'].isEmpty) newFilters.remove('country');
                                if (newFilters['region'].isEmpty) newFilters.remove('region');
                                if (newFilters['grape'].isEmpty) newFilters.remove('grape');
                                if (newFilters['volume'].isEmpty) newFilters.remove('volume');
                                if (newFilters['min_rating'] == 0.0) newFilters.remove('min_rating');
                                if (newFilters['min_year'] == 190 && newFilters['max_year'] == DateTime.now().year) {
                                  newFilters.remove('min_year');
                                  newFilters.remove('max_year');
                                }

                                ref.read(catalogFiltersProvider.notifier).setAllFilters(newFilters);
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.check),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _buildFilterContentWithCallbacks(context, filterKey, selectedFilters, ref, setState, tempColors, tempTypes, tempSugars, tempCountries, tempRegions, tempGrapes, tempRating, tempMinYear, tempMaxYear, tempVolumes),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );
    }
 }

Widget _buildFilterContentWithCallbacks(
 BuildContext context,
 String filterKey,
  ValueNotifier<Map<String, dynamic>> selectedFilters,
  WidgetRef ref,
 StateSetter setState,
 ValueNotifier<List<String>> tempColors,
  ValueNotifier<List<String>> tempTypes,
  ValueNotifier<List<String>> tempSugars,
  ValueNotifier<List<String>> tempCountries,
  ValueNotifier<List<String>> tempRegions,
  ValueNotifier<List<String>> tempGrapes,
  ValueNotifier<double> tempRating,
  ValueNotifier<int> tempMinYear,
  ValueNotifier<int> tempMaxYear,
  ValueNotifier<List<String>> tempVolumes,
) {
  switch (filterKey) {
    case 'color':
      return ValueListenableBuilder<List<String>>(
        valueListenable: tempColors,
        builder: (context, colors, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (WineColor color in [WineColor.red, WineColor.white, WineColor.rose])
                CheckboxListTile(
                  title: Text(color.name),
                  value: colors.contains(color.name),
                  onChanged: (bool? value) {
                    setState(() {
                      final newColors = List<String>.from(colors);
                      if (value == true) {
                        newColors.add(color.name);
                      } else {
                        newColors.remove(color.name);
                      }
                      tempColors.value = newColors;
                    });
                  },
                ),
            ],
          );
        },
      );
    case 'type':
      return ValueListenableBuilder<List<String>>(
        valueListenable: tempTypes,
        builder: (context, types, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (WineType type in WineType.values.where((t) => t != WineType.unknown))
                CheckboxListTile(
                  title: Text(type.name),
                  value: types.contains(type.name),
                  onChanged: (bool? value) {
                    setState(() {
                      final newTypes = List<String>.from(types);
                      if (value == true) {
                        newTypes.add(type.name);
                      } else {
                        newTypes.remove(type.name);
                      }
                      tempTypes.value = newTypes;
                    });
                  },
                ),
            ],
          );
        },
      );
    case 'sugar':
      return ValueListenableBuilder<List<String>>(
        valueListenable: tempSugars,
        builder: (context, sugars, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (WineSugar sugar in WineSugar.values.where((s) => s != WineSugar.unknown))
                CheckboxListTile(
                  title: Text(sugar.name),
                  value: sugars.contains(sugar.name),
                  onChanged: (bool? value) {
                    setState(() {
                      final newSugars = List<String>.from(sugars);
                      if (value == true) {
                        newSugars.add(sugar.name);
                      } else {
                        newSugars.remove(sugar.name);
                      }
                      tempSugars.value = newSugars;
                    });
                  },
                ),
            ],
          );
        },
      );
    case 'price':
      final currentFilters = ref.read(catalogFiltersProvider);
      final currentMinPrice = currentFilters['min_price']?.toDouble();
      final currentMaxPrice = currentFilters['max_price']?.toDouble();
      final initialShowUnavailable = currentFilters['show_unavailable'] ?? false;
      return PriceFilterWidget(
        selectedFilters: selectedFilters,
        initialMinPrice: currentMinPrice,
        initialMaxPrice: currentMaxPrice,
        initialShowUnavailable: initialShowUnavailable,
      );
    case 'country':
      return ValueListenableBuilder<List<String>>(
        valueListenable: tempCountries,
        builder: (context, countries, child) {
          return buildCountryFilter(context, selectedFilters);
        },
      );
    case 'region':
      return ValueListenableBuilder<List<String>>(
        valueListenable: tempRegions,
        builder: (context, regions, child) {
          return const RegionFilterWidget();
        },
      );
    case 'grape':
      return ValueListenableBuilder<List<String>>(
        valueListenable: tempGrapes,
        builder: (context, grapes, child) {
          return const GrapeFilterWidget();
        },
      );
    case 'min_rating':
      return RatingFilterWidget(
        initialRating: tempRating.value,
        onRatingChanged: (rating) {
          tempRating.value = rating;
        },
      );
    case 'year':
      final currentFilters = ref.read(catalogFiltersProvider);
      final currentMinYear = currentFilters['min_year']?.toInt() ?? 1900;
      final currentMaxYear = currentFilters['max_year']?.toInt() ?? DateTime.now().year;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: tempMinYear.value,
                  items: [
                    for (int year = 190; year <= DateTime.now().year; year++)
                      DropdownMenuItem(value: year, child: Text(year.toString())),
                  ],
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        tempMinYear.value = value;
                      });
                    }
                  },
                ),
              ),
              SizedBox(width: 16),
              Text('до'),
              SizedBox(width: 16),
              Expanded(
                child: DropdownButtonFormField<int>(
                  value: tempMaxYear.value,
                  items: [
                    for (int year = 190; year <= DateTime.now().year; year++)
                      DropdownMenuItem(value: year, child: Text(year.toString())),
                  ],
                  onChanged: (int? value) {
                    if (value != null) {
                      setState(() {
                        tempMaxYear.value = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      );
    case 'volume':
      return const BottleSizeFilterWidget();
    case 'winery':
      return const WineryFilterWidget();
    default:
      return Container();
  }
}

void _showSortModal(
      BuildContext context,
      ValueNotifier<Map<String, dynamic>> selectedFilters,
      WidgetRef ref,
      Function(Map<String, dynamic>) onFiltersChanged,
) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            expand: false,
            builder: (BuildContext context, ScrollController scrollController) {
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  final currentSortOption = selectedFilters.value['sort_option'] ?? 'popular'; // По умолчанию 'popular'
                  
                  return Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Порядок', style: Theme.of(context).textTheme.titleLarge),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                // Сбросить сортировку
                                selectedFilters.value.remove('sort_option');
                                selectedFilters.value = Map.from(selectedFilters.value);
                                onFiltersChanged(selectedFilters.value);
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.refresh),
                            ),
                            SizedBox(width: 16),
                            IconButton(
                              onPressed: () {
                                // Применить сортировку - сохраняем временные значения в основной провайдер
                                ref.read(catalogFiltersProvider.notifier).setAllFilters(selectedFilters.value);
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.check),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RadioListTile<String>(
                                  title: Text('Популярные'),
                                  value: 'popular',
                                  groupValue: currentSortOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilters.value['sort_option'] = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text('Новинки'),
                                  value: 'newest',
                                  groupValue: currentSortOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilters.value['sort_option'] = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text('Дешевле'),
                                  value: 'price_asc',
                                  groupValue: currentSortOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilters.value['sort_option'] = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text('Дороже'),
                                  value: 'price_desc',
                                  groupValue: currentSortOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilters.value['sort_option'] = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text('С высоким рейтингом'),
                                  value: 'rating_desc',
                                  groupValue: currentSortOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilters.value['sort_option'] = value;
                                    });
                                  },
                                ),
                                RadioListTile<String>(
                                  title: Text('С большими скидками'),
                                  value: 'discount',
                                  groupValue: currentSortOption,
                                  onChanged: (value) {
                                    setState(() {
                                      selectedFilters.value['sort_option'] = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          );
        },
      );
   }

 Widget _buildFilterContent(
     BuildContext context,
     String filterKey,
     ValueNotifier<Map<String, dynamic>> selectedFilters,
     WidgetRef ref, [Function(RangeValues)? onPriceRangeChanged, Function(bool)? onShowUnavailableChanged]
  ) {
     switch (filterKey) {
       case 'color':
         //return buildColorFilter(context, selectedFilters);
       case 'type':
        // return buildTypeFilter(context, selectedFilters);
       case 'sugar':
       //  return buildSugarFilter(context, selectedFilters);
       case 'price':
         if (onPriceRangeChanged != null) {
           // Передаем текущие значения из провайдера в PriceFilterWidget
           final currentFilters = ref.read(catalogFiltersProvider);
           final currentMinPrice = currentFilters['min_price']?.toDouble();
           final currentMaxPrice = currentFilters['max_price']?.toDouble();
           final initialShowUnavailable = currentFilters['show_unavailable'] ?? false;
           return PriceFilterWidget(
             selectedFilters: selectedFilters,
             onRangeChanged: (newValues) {
               Future.microtask(() {
                 onPriceRangeChanged(newValues);
               });
             },
             onShowUnavailableChanged: (showUnavailable) {
               Future.microtask(() {
                 onShowUnavailableChanged?.call(showUnavailable);
               });
             },
             initialMinPrice: currentMinPrice,
             initialMaxPrice: currentMaxPrice,
             initialShowUnavailable: initialShowUnavailable,
           );
         } else {
           final currentFilters = ref.read(catalogFiltersProvider);
           final currentMinPrice = currentFilters['min_price']?.toDouble();
           final currentMaxPrice = currentFilters['max_price']?.toDouble();
           final initialShowUnavailable = currentFilters['show_unavailable'] ?? false;
           return PriceFilterWidget(
             selectedFilters: selectedFilters,
             initialMinPrice: currentMinPrice,
             initialMaxPrice: currentMaxPrice,
             initialShowUnavailable: initialShowUnavailable,
           );
         }
       case 'country':
         return buildCountryFilter(context, selectedFilters);
       case 'region':
         return const RegionFilterWidget();
       case 'grape':
         return const GrapeFilterWidget();
       case 'min_rating':
         return RatingFilterWidget(
           initialRating: selectedFilters.value['min_rating']?.toDouble() ?? 0.0,
           onRatingChanged: (rating) {
             selectedFilters.value['min_rating'] = rating;
             selectedFilters.value = Map.from(selectedFilters.value);
           },
         );
       case 'year':
         return buildYearFilter(context, selectedFilters);
       case 'volume':
         return const BottleSizeFilterWidget();
       case 'winery':
         return const WineryFilterWidget();
       default:
         return Container();
     }
 }

}

class FilterButton extends StatelessWidget {
     final String filterKey;
    final bool isActive;
     final VoidCallback onPressed;
     final int? selectedCount;
     final VoidCallback? onDeleted;

     const FilterButton({
      super.key,
      required this.filterKey,
      required this.isActive,
      required this.onPressed,
      this.selectedCount,
      this.onDeleted,
    });

   @override
   Widget build(BuildContext context) {
    log('--- FilterButton REBUILT --- Key: $filterKey, IsActive: $isActive, Count: $selectedCount');
       return badges.Badge(
         showBadge: (selectedCount ?? 0) > 0,
         badgeContent: Text(selectedCount.toString()),
         child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: isActive ? Colors.green[300] : Colors.grey[20],
            foregroundColor: Colors.black87,
            elevation: 0, // Убираем тень у кнопки фильтра
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (filterKey == 'price') ...[
                Icon(Icons.monetization_on_outlined, size: 16),
                const SizedBox(width: 4),
              ] else if (filterKey == 'min_rating') ...[
                Icon(Icons.star_border_outlined, size: 16),
                const SizedBox(width: 4),
              ] else if (filterKey == 'sort') ...[
                Icon(Icons.sort, size: 16),
                const SizedBox(width: 4),
              ],
              Text(getFilterTitle(filterKey)),
              if (isActive && onDeleted != null) ...[
                IconButton(
                  icon: Icon(Icons.close, size: 16),
                  onPressed: onDeleted,
                ),
              ],
            ],
          ),
        ),
      );
    }

 }

// Вспомогательная функция для получения заголовка фильтра
String getFilterTitle(String filterKey) {
 switch (filterKey) {
    case 'sort':
      return 'Порядок';
    case 'color':
      return 'Цвет';
    case 'type':
      return 'Тип';
    case 'sugar':
      return 'Сахар';
    case 'price':
      return 'Цена';
    case 'country':
      return 'Страна';
    case 'region':
      return 'Регион';
    case 'grape':
      return 'Сорт';
    case 'min_rating':
      return 'Рейтинг';
    case 'year':
      return 'Винтаж';
    case 'volume':
      return 'Объем';
    case 'winery':
      return 'Винодельня';
    default:
      return filterKey;
  }
}
