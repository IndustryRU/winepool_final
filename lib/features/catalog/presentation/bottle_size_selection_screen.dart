import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/offers/application/all_bottle_sizes_provider.dart';
import 'package:winepool_final/features/offers/domain/bottle_size.dart';

class BottleSizeSelectionScreen extends ConsumerStatefulWidget {
  const BottleSizeSelectionScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottleSizeSelectionScreenState();
}

class _BottleSizeSelectionScreenState extends ConsumerState<BottleSizeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final bottleSizesAsync = ref.watch(allBottleSizesProvider);
    final currentFilters = ref.watch(catalogFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите объемы'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(catalogFiltersProvider.notifier).clearBottleSizes();
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
      body: bottleSizesAsync.when(
        data: (allBottleSizes) {
          return BottleSizeSelectionBody(
            allBottleSizes: allBottleSizes,
            selectedBottleSizeIds: currentFilters.bottleSizeIds,
            ref: ref,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки объемов: $error'),
        ),
      ),
    );
  }
}

class BottleSizeSelectionBody extends ConsumerStatefulWidget {
  const BottleSizeSelectionBody({
    super.key,
    required this.allBottleSizes,
    required this.selectedBottleSizeIds,
    required this.ref,
  });

  final List<BottleSize> allBottleSizes;
  final List<String> selectedBottleSizeIds;
  final WidgetRef ref;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottleSizeSelectionBodyState();
}

class _BottleSizeSelectionBodyState extends ConsumerState<BottleSizeSelectionBody> {
  final TextEditingController _searchController = TextEditingController();
  List<BottleSize> _filteredBottleSizes = [];

  @override
  void initState() {
    super.initState();
    _filteredBottleSizes = widget.allBottleSizes;
    _searchController.addListener(_onSearchChanged);
  }

 @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        _filteredBottleSizes = widget.allBottleSizes;
      });
    } else {
      setState(() {
        _filteredBottleSizes = widget.allBottleSizes
            .where((bottleSize) => 
                (bottleSize.sizeL?.toLowerCase().contains(query) ?? false) ||
                (bottleSize.id?.toLowerCase().contains(query) ?? false))
            .toList();
      });
    }
 }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              labelText: 'Поиск по объему',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredBottleSizes.length,
            itemBuilder: (context, index) {
              final bottleSize = _filteredBottleSizes[index];
              final isSelected = widget.selectedBottleSizeIds.contains(bottleSize.id);

              return CheckboxListTile(
                title: Text(bottleSize.sizeL ?? bottleSize.sizeMl?.toString() ?? bottleSize.id ?? ''),
                value: isSelected,
                onChanged: (bool? selected) {
                  if (bottleSize.id != null) {
                    ref.read(catalogFiltersProvider.notifier).toggleBottleSizeId(bottleSize.id!);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }
}