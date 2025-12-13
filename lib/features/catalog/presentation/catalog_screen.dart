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
    final winesAsync = ref.watch(winesWithFiltersProvider(filters));
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
          RenderBox renderBox = context.findRenderObject() as RenderBox;
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
          controller
            ..duration = const Duration(milliseconds: 10);
          controller.reverse();
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
              onPressed: () => _showSortModal(context, selectedFilters, onFiltersChanged),
            ),
          ),
          for (String filterKey in filterKeys)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: FilterButton(
                filterKey: filterKey,
                isActive: selectedFilters.value.containsKey(filterKey),
                onPressed: () => _showFilterModal(context, filterKey, selectedFilters, onFiltersChanged),
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
    Function(Map<String, dynamic>) onFiltersChanged,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
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
                          // Сбросить фильтр
                          selectedFilters.value.remove(filterKey);
                          selectedFilters.value = Map.from(selectedFilters.value);
                          onFiltersChanged(selectedFilters.value);
                          Navigator.of(context).pop();
                        },
                        child: Text('Сбросить'),
                      ),
                      TextButton(
                        onPressed: () {
                          // Применить фильтр
                          onFiltersChanged(selectedFilters.value);
                          Navigator.of(context).pop();
                        },
                        child: Text('Применить'),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: _buildFilterContent(context, filterKey, selectedFilters),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSortModal(
    BuildContext context,
    ValueNotifier<Map<String, dynamic>> selectedFilters,
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
                              // Применить сортировку
                              onFiltersChanged(selectedFilters.value);
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
  ) {
    switch (filterKey) {
      case 'color':
        return _buildColorFilter(context, selectedFilters);
      case 'type':
        return _buildTypeFilter(context, selectedFilters);
      case 'sugar':
        return _buildSugarFilter(context, selectedFilters);
      case 'price':
        return _buildPriceFilter(context, selectedFilters);
      case 'country':
        return _buildCountryFilter(context, selectedFilters);
      case 'region':
        return _buildRegionFilter(context, selectedFilters);
      case 'grape':
        return _buildGrapeFilter(context, selectedFilters);
      case 'rating':
        return _buildRatingFilter(context, selectedFilters);
      case 'year':
        return _buildYearFilter(context, selectedFilters);
      case 'volume':
        return _buildVolumeFilter(context, selectedFilters);
      default:
        return Container();
    }
  }

  Widget _buildColorFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final selectedValues = (selectedFilters.value['color'] as List<String>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (WineColor color in WineColor.values.where((c) => c != WineColor.unknown))
          CheckboxListTile(
            title: Text(color.nameRu),
            value: selectedValues.contains(color.name),
            onChanged: (bool? value) {
              if (value == true) {
                selectedValues.add(color.name);
              } else {
                selectedValues.remove(color.name);
              }
              selectedFilters.value['color'] = selectedValues;
              selectedFilters.value = Map.from(selectedFilters.value);
            },
          ),
      ],
    );
  }

  Widget _buildTypeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final selectedValues = (selectedFilters.value['type'] as List<String>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (WineType type in WineType.values.where((t) => t != WineType.unknown))
          CheckboxListTile(
            title: Text(type.nameRu),
            value: selectedValues.contains(type.name),
            onChanged: (bool? value) {
              if (value == true) {
                selectedValues.add(type.name);
              } else {
                selectedValues.remove(type.name);
              }
              selectedFilters.value['type'] = selectedValues;
              selectedFilters.value = Map.from(selectedFilters.value);
            },
          ),
      ],
    );
  }

  Widget _buildSugarFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final selectedValues = (selectedFilters.value['sugar'] as List<String>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (WineSugar sugar in WineSugar.values.where((s) => s != WineSugar.unknown))
          CheckboxListTile(
            title: Text(sugar.nameRu),
            value: selectedValues.contains(sugar.name),
            onChanged: (bool? value) {
              if (value == true) {
                selectedValues.add(sugar.name);
              } else {
                selectedValues.remove(sugar.name);
              }
              selectedFilters.value['sugar'] = selectedValues;
              selectedFilters.value = Map.from(selectedFilters.value);
            },
          ),
      ],
    );
  }

  Widget _buildPriceFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final minPrice = selectedFilters.value['min_price'] ?? 0;
    final maxPrice = selectedFilters.value['max_price'] ?? 10000;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('От ${minPrice} до ${maxPrice}'),
        RangeSlider(
          min: 0,
          max: 10000,
          divisions: 100,
          values: RangeValues(minPrice.toDouble(), maxPrice.toDouble()),
          onChanged: (RangeValues values) {
            selectedFilters.value['min_price'] = values.start.toInt();
            selectedFilters.value['max_price'] = values.end.toInt();
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Мин. цена'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final val = int.tryParse(value) ?? 0;
                  selectedFilters.value['min_price'] = val;
                  selectedFilters.value = Map.from(selectedFilters.value);
                },
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: TextField(
                decoration: InputDecoration(labelText: 'Макс. цена'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final val = int.tryParse(value) ?? 10000;
                  selectedFilters.value['max_price'] = val;
                  selectedFilters.value = Map.from(selectedFilters.value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCountryFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    // Заглушка для фильтра страны
    return TextField(
      decoration: InputDecoration(labelText: 'Поиск по стране'),
      onChanged: (value) {
        // Здесь будет реализация поиска по стране
        // selectedFilters.value['country'] = value;
        // selectedFilters.value = Map.from(selectedFilters.value);
      },
    );
  }

  Widget _buildRegionFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    // Заглушка для фильтра региона
    return TextField(
      decoration: InputDecoration(labelText: 'Поиск по региону'),
      onChanged: (value) {
        // Здесь будет реализация поиска по региону
        // selectedFilters.value['region'] = value;
        // selectedFilters.value = Map.from(selectedFilters.value);
      },
    );
  }

  Widget _buildGrapeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    // Заглушка для фильтра сорта
    return TextField(
      decoration: InputDecoration(labelText: 'Поиск по сорту'),
      onChanged: (value) {
        // Здесь будет реализация поиска по сорту
        // selectedFilters.value['grape'] = value;
        // selectedFilters.value = Map.from(selectedFilters.value);
      },
    );
  }

  Widget _buildRatingFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final rating = selectedFilters.value['rating'] ?? 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('От ${rating.toStringAsFixed(1)} звезд'),
        Slider(
          min: 0,
          max: 5,
          divisions: 10,
          label: rating.toStringAsFixed(1),
          value: rating,
          onChanged: (double value) {
            selectedFilters.value['rating'] = value;
            selectedFilters.value = Map.from(selectedFilters.value);
          },
        ),
        Row(
          children: [
            for (int i = 0; i <= 5; i++)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    selectedFilters.value['rating'] = i.toDouble();
                    selectedFilters.value = Map.from(selectedFilters.value);
                  },
                  child: Text(i.toString()),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildYearFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final minYear = selectedFilters.value['min_year'] ?? 1900;
    final maxYear = selectedFilters.value['max_year'] ?? DateTime.now().year;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<int>(
                value: minYear,
                items: [
                  for (int year = 1900; year <= DateTime.now().year; year++)
                    DropdownMenuItem(value: year, child: Text(year.toString())),
                ],
                onChanged: (value) {
                  selectedFilters.value['min_year'] = value;
                  selectedFilters.value = Map.from(selectedFilters.value);
                },
              ),
            ),
            SizedBox(width: 16),
            Text('до'),
            SizedBox(width: 16),
            Expanded(
              child: DropdownButtonFormField<int>(
                value: maxYear,
                items: [
                  for (int year = 1900; year <= DateTime.now().year; year++)
                    DropdownMenuItem(value: year, child: Text(year.toString())),
                ],
                onChanged: (value) {
                  selectedFilters.value['max_year'] = value;
                  selectedFilters.value = Map.from(selectedFilters.value);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVolumeFilter(BuildContext context, ValueNotifier<Map<String, dynamic>> selectedFilters) {
    final selectedValues = (selectedFilters.value['volume'] as List<String>?) ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (String volume in ['0.375', '0.75', '1.5', '3', '6'])
          CheckboxListTile(
            title: Text('${volume} л'),
            value: selectedValues.contains(volume),
            onChanged: (bool? value) {
              if (value == true) {
                selectedValues.add(volume);
              } else {
                selectedValues.remove(volume);
              }
              selectedFilters.value['volume'] = selectedValues;
              selectedFilters.value = Map.from(selectedFilters.value);
            },
          ),
      ],
    );
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
