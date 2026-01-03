import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:winepool_final/features/catalog/application/regions_provider.dart';
import 'package:winepool_final/features/wines/domain/region.dart';

part 'region_selection_screen.g.dart';

@riverpod
class SelectedRegions extends _$SelectedRegions {
  @override
  Set<String> build() {
    return {};
  }
}

class RegionSelectionScreen extends ConsumerStatefulWidget {
  const RegionSelectionScreen({
    super.key,
    this.initialSelectedRegions = const [],
    this.availableCountries = const [],
 });

  final List<String> initialSelectedRegions;
  final List<String> availableCountries;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegionSelectionScreenState();
}

class _RegionSelectionScreenState extends ConsumerState<RegionSelectionScreen> {
  @override
  void initState() {
    super.initState();
    // Инициализируем состояние выбранных регионов при первом построении
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(selectedRegionsProvider.notifier).state = widget.initialSelectedRegions.toSet();
    });
  }

 @override
  Widget build(BuildContext context) {
    final regionsAsync = ref.watch(regionsListProvider(widget.availableCountries));
    final selectedRegions = ref.watch(selectedRegionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите регионы'),
        actions: [
          TextButton(
            onPressed: () {
              ref.read(selectedRegionsProvider.notifier).state = {};
            },
            child: const Text('Сбросить'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, selectedRegions.toList());
            },
            child: const Text('Применить'),
          ),
        ],
      ),
      body: regionsAsync.when(
        data: (allRegions) {
          return RegionSelectionBody(
            allRegions: allRegions,
            selectedRegions: selectedRegions,
            ref: ref,
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Ошибка загрузки регионов: $error'),
        ),
      ),
    );
  }
}

class RegionSelectionBody extends ConsumerStatefulWidget {
  const RegionSelectionBody({
    super.key,
    required this.allRegions,
    required this.selectedRegions,
    required this.ref,
  });

  final List<Region> allRegions;
  final Set<String> selectedRegions;
  final WidgetRef ref;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegionSelectionBodyState();
}

class _RegionSelectionBodyState extends ConsumerState<RegionSelectionBody> {
  final TextEditingController _searchController = TextEditingController();
 List<Region> _filteredRegions = [];

  @override
  void initState() {
    super.initState();
    _filteredRegions = widget.allRegions;
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
        _filteredRegions = widget.allRegions;
      });
    } else {
      setState(() {
        _filteredRegions = widget.allRegions
            .where((region) => 
                (region.name?.toLowerCase().contains(query) ?? false) ||
                (region.id?.toLowerCase().contains(query) ?? false))
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
              labelText: 'Поиск по региону',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: _filteredRegions.length,
            itemBuilder: (context, index) {
              final region = _filteredRegions[index];
              final isSelected = widget.selectedRegions.contains(region.id);

              return CheckboxListTile(
                title: Text(region.name ?? region.id ?? ''),
                value: isSelected,
                onChanged: (bool? value) {
                  final selectedRegions = Set<String>.from(widget.selectedRegions);
                  if (value == true) {
                    selectedRegions.add(region.id!);
                  } else {
                    selectedRegions.remove(region.id);
                  }
                  widget.ref.read(selectedRegionsProvider.notifier).state = selectedRegions;
                },
              );
            },
          ),
        ),
      ],
    );
  }
}