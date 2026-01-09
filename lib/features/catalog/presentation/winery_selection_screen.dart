import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'dart:developer';

import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:collection/collection.dart';

import '../application/catalog_filters_provider.dart';
import '../application/wineries_provider.dart';
import '../domain/winery.dart';

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
            child: TextField(
              onChanged: (value) {
                searchQuery.value = value;
              },
              decoration: const InputDecoration(
                labelText: 'Поиск виноделен',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
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

                    return ListView.builder(
                      itemCount: filteredWineries.length,
                      itemBuilder: (context, index) {
                        final winery = filteredWineries[index];
                        // 4. Управляем состоянием Checkbox через локальное `selectedWineryIds`
                        final isSelected = localSelectedIds.value.contains(winery.id);

                        return CheckboxListTile(
                          title: Text(winery.name ?? 'Имя не указано'),
                          value: isSelected,
                          onChanged: (bool? selected) {
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
