import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:collection/collection.dart';
import 'package:winepool_final/core/widgets/custom_search_field.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

import '../application/catalog_filters_provider.dart';
import '../application/wineries_provider.dart';

class WinerySelectionScreen extends HookConsumerWidget {
  const WinerySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Локальное состояние для временного хранения ID (тип String)
    final localSelectedIds = useState<List<String>>([]);

    // 2. Инициализация локального состояния из глобального провайдера
    useEffect(() {
      final initialIds = ref.read(catalogFiltersProvider).wineryIds;
      localSelectedIds.value = initialIds;
      log('WinerySelectionScreen: Initialized local state with: $initialIds');
      return null;
    }, const []);

    final searchQuery = useState('');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Винодельни'),
        actions: [
          // Кнопка "Сбросить"
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Очищаем локальное состояние
              localSelectedIds.value = [];
            },
          ),
          // Кнопка "Применить"
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              log('WinerySelectionScreen: APPLYING FILTERS. Local selection: ${localSelectedIds.value}');
              ref.read(catalogFiltersProvider.notifier).setWineries(localSelectedIds.value);
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
                  loading: () => const Center(child: CircularProgressIndicator()),
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
                        // 4. Управляем состоянием Checkbox через локальное `selectedWineryIds`
                        final isSelected = localSelectedIds.value.contains(winery.id);

                        return _WineryListItem(
                          winery: winery,
                          isSelected: isSelected,
                          onSelectionChanged: (selected) {
                            if (winery.id == null) return;

                            final currentIds = List<String>.from(localSelectedIds.value);
                            if (selected == true) {
                              if (!currentIds.contains(winery.id!)) {
                                currentIds.add(winery.id!);
                              }
                            } else {
                              currentIds.remove(winery.id);
                            }
                            localSelectedIds.value = currentIds;
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

class _WineryListItem extends StatelessWidget {
  final Winery winery;
  final bool isSelected;
  final void Function(bool?) onSelectionChanged;

  const _WineryListItem({
    required this.winery,
    required this.isSelected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onSelectionChanged(!isSelected),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: (winery.logoUrl != null && winery.logoUrl!.isNotEmpty)
                    ? Image.network(
                        winery.logoUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          // Плейсхолдер в случае ошибки загрузки
                          return const Icon(Icons.business, color: Colors.grey);
                        },
                      )
                    : const Icon(Icons.business, color: Colors.grey), // Плейсхолдер, если URL пуст
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                winery.name ?? 'Имя не указано',
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Checkbox(
              value: isSelected,
              onChanged: onSelectionChanged,
              side: MaterialStateBorderSide.resolveWith(
                (states) => const BorderSide(
                  color: Colors.black,
                  width: 1.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
