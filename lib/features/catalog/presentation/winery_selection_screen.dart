import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:collection/collection.dart';
import 'package:winepool_final/core/widgets/custom_search_field.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/winery_list_item.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

import '../application/catalog_filters_provider.dart';
import '../application/filter_options_provider.dart';
import '../application/temporary_winery_ids_provider.dart';

class WinerySelectionScreen extends HookConsumerWidget {
  const WinerySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIds = ref.watch(temporaryWineryIdsProvider);

    final searchQuery = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Винодельни'),
        actions: [
          // Кнопка "Сбросить"
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(temporaryWineryIdsProvider.notifier).clear();
            },
          ),
          // Кнопка "Применить"
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              log('WinerySelectionScreen: APPLYING FILTERS. Selected IDs: $selectedIds');
              ref.read(catalogFiltersProvider.notifier).setWineries(selectedIds);
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
              hintText: 'Поиск виноделен...',
            ), // Закрывающая скобка для CustomSearchField
          ),
          Expanded(
            child: ref.watch(allWineriesProvider).when(
                  loading: () => const ShimmerLoadingIndicator(),
                  error: (error, stack) => Center(child: Text('Ошибка: $error')),
                  data: (wineries) {
                    final filteredWineries = wineries.where((winery) {
                      final nameLower = winery.name?.toLowerCase() ?? '';
                      final searchLower = searchQuery.value.toLowerCase();
                      return nameLower.contains(searchLower);
                    }).toList();

                    return ListView.separated(
                      itemCount: filteredWineries.length,
                      separatorBuilder: (context, index) => const SizedBox(height: 2),
                      itemBuilder: (context, index) {
                        final winery = filteredWineries[index];
                        // Управляем состоянием Checkbox через temporaryWineryIdsProvider
                        final isSelected = selectedIds.contains(winery.id);

                        return WineryListItem(
                          winery: winery,
                          isSelected: isSelected,
                          onChanged: (selected) {
                            if (winery.id == null) return;

                            if (selected == true) {
                              ref.read(temporaryWineryIdsProvider.notifier).add(winery.id!);
                            } else {
                              // Проверяем, что winery.id не равно null перед передачей в remove
                              if (winery.id != null) {
                                ref.read(temporaryWineryIdsProvider.notifier).remove(winery.id!);
                              }
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
