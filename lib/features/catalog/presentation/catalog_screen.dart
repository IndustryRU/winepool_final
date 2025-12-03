import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import 'package:winepool_final/features/wines/application/wines_controller.dart';
import 'package:winepool_final/features/wines/domain/wine_characteristics.dart';
import 'package:winepool_final/features/catalog/application/catalog_controller.dart';

// Провайдер для фильтров

// Используем сгенерированный провайдер напрямую
// final filteredWinesProvider = FutureProvider.autoDispose.family<List<Wine>, Map<String, dynamic>>((ref, filters) async {
//   return await ref.watch(winesWithFiltersProvider(filters));
// });

class CatalogScreen extends ConsumerWidget {
  const CatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filters = ref.watch(catalogFiltersProvider);
    final winesAsync = ref.watch(winesWithFiltersProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Каталог вин'),
      ),
      body: Column(
        children: [
          // Панель фильтров
          FilterPanel(
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
    );
  }
}

class FilterPanel extends StatefulWidget {
  final Map<String, dynamic> filters;
  final Function(Map<String, dynamic>) onFiltersChanged;

  const FilterPanel({
    super.key,
    required this.filters,
    required this.onFiltersChanged,
  });

  @override
  State<FilterPanel> createState() => _FilterPanelState();
}

class _FilterPanelState extends State<FilterPanel> {
  late Map<String, dynamic> _currentFilters;

  @override
  void initState() {
    super.initState();
    _currentFilters = Map.from(widget.filters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Фильтр по цвету
          _buildColorFilter(),
          const SizedBox(height: 16),
          
          // Фильтр по типу
          _buildTypeFilter(),
          const SizedBox(height: 16),
          
          // Фильтр по уровню сахара
          _buildSugarFilter(),
          const SizedBox(height: 16),
          
          // Фильтр по цене
          _buildPriceFilter(),
          
          // Кнопка применения фильтров
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _applyFilters,
            child: const Text('Применить фильтры'),
          ),
        ],
      ),
    );
  }

  Widget _buildColorFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Цвет:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: WineColor.values
              .where((color) => color != WineColor.unknown)
              .map((color) => FilterChip(
                    label: Text(_colorToString(color)),
                    selected: _currentFilters['color'] == color.name,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _currentFilters['color'] = color.name;
                        } else {
                          _currentFilters.remove('color');
                        }
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Тип:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: WineType.values
              .where((type) => type != WineType.unknown)
              .map((type) => FilterChip(
                    label: Text(_typeToString(type)),
                    selected: _currentFilters['type'] == type.name,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _currentFilters['type'] = type.name;
                        } else {
                          _currentFilters.remove('type');
                        }
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSugarFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Сахар:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: WineSugar.values
              .where((sugar) => sugar != WineSugar.unknown)
              .map((sugar) => FilterChip(
                    label: Text(_sugarToString(sugar)),
                    selected: _currentFilters['sugar'] == sugar.name,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          _currentFilters['sugar'] = sugar.name;
                        } else {
                          _currentFilters.remove('sugar');
                        }
                      });
                    },
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildPriceFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Цена:', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Мин. цена',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _currentFilters['min_price'] = int.tryParse(value);
                    } else {
                      _currentFilters.remove('min_price');
                    }
                  });
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Макс. цена',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    if (value.isNotEmpty) {
                      _currentFilters['max_price'] = int.tryParse(value);
                    } else {
                      _currentFilters.remove('max_price');
                    }
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _applyFilters() {
    widget.onFiltersChanged(_currentFilters);
  }

  String _colorToString(WineColor color) {
    return color.nameRu;
  }

  String _typeToString(WineType type) {
    return type.nameRu;
  }

  String _sugarToString(WineSugar sugar) {
    return sugar.nameRu;
  }
}