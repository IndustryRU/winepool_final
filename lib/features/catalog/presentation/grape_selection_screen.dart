import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/grape_varieties_provider.dart';
import 'package:winepool_final/features/wines/domain/grape_variety.dart';

class GrapeSelectionScreen extends ConsumerStatefulWidget {
  const GrapeSelectionScreen({
    super.key,
 });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GrapeSelectionScreenState();
}

class _GrapeSelectionScreenState extends ConsumerState<GrapeSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    final grapesAsync = ref.watch(allGrapeVarietiesProvider);
    final currentFilters = ref.watch(catalogFiltersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите сорта'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(catalogFiltersProvider.notifier).clearGrapes();
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
      body: grapesAsync.when(
        data: (allGrapes) {
          return GrapeSelectionBody(
            allGrapes: allGrapes,
            selectedGrapeIds: currentFilters.grapeIds,
            ref: ref,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки сортов: $error'),
        ),
      ),
    );
  }
}

class GrapeSelectionBody extends ConsumerStatefulWidget {
  const GrapeSelectionBody({
    super.key,
    required this.allGrapes,
    required this.selectedGrapeIds,
    required this.ref,
  });

  final List<GrapeVariety> allGrapes;
  final List<String> selectedGrapeIds;
  final WidgetRef ref;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _GrapeSelectionBodyState();
}

class _GrapeSelectionBodyState extends ConsumerState<GrapeSelectionBody> {
  final TextEditingController _searchController = TextEditingController();
  List<GrapeVariety> _filteredGrapes = [];

  @override
  void initState() {
    super.initState();
    _filteredGrapes = widget.allGrapes;
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
        _filteredGrapes = widget.allGrapes;
      });
    } else {
      setState(() {
        _filteredGrapes = widget.allGrapes
            .where((grape) => 
                (grape.name?.toLowerCase().contains(query) ?? false) ||
                (grape.id?.toLowerCase().contains(query) ?? false))
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
              labelText: 'Поиск по сорту',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredGrapes.length,
            itemBuilder: (context, index) {
              final grape = _filteredGrapes[index];
              final isSelected = widget.selectedGrapeIds.contains(grape.id);
              
              return CheckboxListTile(
                title: Text(grape.name ?? grape.id ?? ''),
                value: isSelected,
                onChanged: (bool? selected) {
                  if (grape.id != null) {
                    ref.read(catalogFiltersProvider.notifier).toggleGrapeId(grape.id!);
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
