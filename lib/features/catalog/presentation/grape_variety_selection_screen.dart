import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/core/widgets/custom_search_field.dart';
import 'package:winepool_final/features/wines/domain/grape_variety.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/grape_variety_list_item.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';
import '../application/catalog_filters_provider.dart';
import '../application/filter_options_provider.dart';
import '../application/temporary_selection_providers.dart';

class GrapeVarietySelectionScreen extends HookConsumerWidget {
  const GrapeVarietySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(temporaryGrapeVarietyIdsProvider);
    final searchQuery = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Сорт винограда'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(temporaryGrapeVarietyIdsProvider.notifier).clear();
            },
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              context.pop();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchField(
              onChanged: (value) {
                searchQuery.value = value;
              },
              hintText: 'Поиск сортов...',
            ),
          ),
          Expanded(
            child: ref.watch(allGrapeVarietiesProvider).when(
                  loading: () => const ShimmerLoadingIndicator(),
                  error: (error, stack) => Center(child: Text('Ошибка: $error')),
                  data: (grapes) {
                    final filteredGrapes = grapes.where((grape) {
                      final nameLower = grape.name?.toLowerCase() ?? '';
                      final searchLower = searchQuery.value.toLowerCase();
                      return nameLower.contains(searchLower);
                    }).toList();

                    return ListView.separated(
                      itemCount: filteredGrapes.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final grape = filteredGrapes[index];
                        final isSelected = selectedIds.contains(grape.id);

                        return GrapeVarietyListItem(
                          grapeVariety: grape,
                          isSelected: isSelected,
                          onChanged: (selected) {
                            if (grape.id != null) {
                              ref.read(temporaryGrapeVarietyIdsProvider.notifier).toggle(grape.id!);
                            }
                          },
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}