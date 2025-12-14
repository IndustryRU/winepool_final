import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/catalog/application/catalog_controller.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/filter_helpers.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/price_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/color_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/type_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/sugar_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/country_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/region_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/grape_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/rating_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/year_filter_widget.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/volume_filter_widget.dart';

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

    return WillPopScope(
      onWillPop: () async {
        // Используем GoRouter для навигации назад
        context.go('/catalog'); // Предполагаем, что каталог открывается из buyer-home
        return false;
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
                          return WineTile(wine: wines[index]);
                        },
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
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
); // Закрывающая скобка для WillPopScope
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
  'rating',
 'year',
 'volume',
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
              child: FilterButton(
                filterKey: filterKey,
                isActive: selectedFilters.value.containsKey(filterKey),
                onPressed: () => _showFilterModal(context, filterKey, selectedFilters, ref, onFiltersChanged),
              ),
            ),
        ],
      ),
    );
  }

  void _showFilterModal(
    BuildContext context,
    String filterKey,
    ValueNotifier<Map<String, dynamic>> selectedFilters,
    WidgetRef ref,
    Function(Map<String, dynamic>) onFiltersChanged,
 ) async {
    if (filterKey == 'price') {
      // Для ценного фильтра открываем модальное окно и ждем возвращаемого значения
      RangeValues? currentPriceRange;
      
      // Читаем текущие значения цен из провайдера
      final currentFilters = ref.read(catalogFiltersProvider);
      final currentMinPrice = currentFilters['min_price']?.toDouble() ?? 0.0;
      final currentMaxPrice = currentFilters['max_price']?.toDouble() ?? 10000.0;
      
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getFilterTitle(filterKey),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextButton(
                              onPressed: () {
                                // Сбросить фильтр к начальному состоянию
                                selectedFilters.value.remove(filterKey);
                                selectedFilters.value = Map.from(selectedFilters.value);
                                onFiltersChanged(selectedFilters.value);
                                Navigator.of(context).pop(); // Не возвращаем значения при сбросе
                              },
                              child: Text('Сбросить'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Закрыть модальное окно, вернув текущие значения из виджета
                                if (currentPriceRange != null) {
                                  Navigator.of(context).pop(currentPriceRange);
                                } else {
                                  // Если currentPriceRange не был установлен, используем текущие значения из selectedFilters
                                  final currentMinPrice = selectedFilters.value['min_price']?.toDouble() ?? 0.0;
                                  final currentMaxPrice = selectedFilters.value['max_price']?.toDouble() ?? 10000.0;
                                  Navigator.of(context).pop(RangeValues(currentMinPrice, currentMaxPrice));
                                }
                              },
                              child: Text('Применить'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _buildFilterContent(context, filterKey, selectedFilters, ref, (range) {
                              // Коллбэк для обновления currentPriceRange
                              currentPriceRange = range;
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
        ref.read(catalogFiltersProvider.notifier).setPriceRange(returnedValues.start, returnedValues.end);
      }
    } else {
      // Для остальных фильтров оставляем старую логику
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getFilterTitle(filterKey),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            TextButton(
                              onPressed: () {
                                // Сбросить фильтр к начальному состоянию
                                selectedFilters.value.remove(filterKey);
                                selectedFilters.value = Map.from(selectedFilters.value);
                                onFiltersChanged(selectedFilters.value);
                                Navigator.of(context).pop();
                              },
                              child: Text('Сбросить'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Применить фильтр - сохраняем временные значения в основной провайдер
                                ref.read(catalogFiltersProvider.notifier).updateFilters(selectedFilters.value);
                                Navigator.of(context).pop();
                              },
                              child: Text('Применить'),
                            ),
                          ],
                        ),
                        Expanded(
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _buildFilterContent(context, filterKey, selectedFilters, ref),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Сначала:',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          TextButton(
                            onPressed: () {
                              // Сбросить сортировку
                              selectedFilters.value.remove('sort_option');
                              selectedFilters.value = Map.from(selectedFilters.value);
                              onFiltersChanged(selectedFilters.value);
                              Navigator.of(context).pop();
                            },
                            child: Text('Сбросить'),
                          ),
                          TextButton(
                            onPressed: () {
                              // Применить сортировку - сохраняем временные значения в основной провайдер
                              ref.read(catalogFiltersProvider.notifier).updateFilters(selectedFilters.value);
                              Navigator.of(context).pop();
                            },
                            child: Text('Применить'),
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
    WidgetRef ref, [Function(RangeValues)? onPriceRangeChanged]
 ) {
    switch (filterKey) {
      case 'color':
        return buildColorFilter(context, selectedFilters);
      case 'type':
        return buildTypeFilter(context, selectedFilters);
      case 'sugar':
        return buildSugarFilter(context, selectedFilters);
      case 'price':
        if (onPriceRangeChanged != null) {
          // Передаем текущие значения из провайдера в PriceFilterWidget
          final currentFilters = ref.read(catalogFiltersProvider);
          final currentMinPrice = currentFilters['min_price']?.toDouble();
          final currentMaxPrice = currentFilters['max_price']?.toDouble();
          return PriceFilterWidget(
            selectedFilters: selectedFilters,
            onRangeChanged: onPriceRangeChanged,
            initialMinPrice: currentMinPrice,
            initialMaxPrice: currentMaxPrice,
          );
        } else {
          final currentFilters = ref.read(catalogFiltersProvider);
          final currentMinPrice = currentFilters['min_price']?.toDouble();
          final currentMaxPrice = currentFilters['max_price']?.toDouble();
          return PriceFilterWidget(
            selectedFilters: selectedFilters,
            initialMinPrice: currentMinPrice,
            initialMaxPrice: currentMaxPrice,
          );
        }
      case 'country':
        return buildCountryFilter(context, selectedFilters);
      case 'region':
        return buildRegionFilter(context, selectedFilters);
      case 'grape':
        return buildGrapeFilter(context, selectedFilters);
      case 'rating':
        return buildRatingFilter(context, selectedFilters);
      case 'year':
        return buildYearFilter(context, selectedFilters);
      case 'volume':
        return buildVolumeFilter(context, selectedFilters);
      default:
        return Container();
    }
  }

}

class FilterButton extends StatelessWidget {
 final String filterKey;
 final bool isActive;
  final VoidCallback onPressed;

  const FilterButton({
    super.key,
    required this.filterKey,
    required this.isActive,
    required this.onPressed,
  });

 @override
 Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.grey[400] : Colors.grey[200],
        foregroundColor: Colors.black87,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (filterKey == 'price') ...[
            Icon(Icons.monetization_on_outlined, size: 16),
            const SizedBox(width: 4),
          ] else if (filterKey == 'rating') ...[
            Icon(Icons.star_border_outlined, size: 16),
            const SizedBox(width: 4),
          ] else if (filterKey == 'sort') ...[
            Icon(Icons.sort, size: 16),
            const SizedBox(width: 4),
          ],
          Text(getFilterTitle(filterKey)),
        ],
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
    case 'rating':
      return 'Рейтинг';
    case 'year':
      return 'Год';
    case 'volume':
      return 'Объем';
    default:
      return filterKey;
  }
}
