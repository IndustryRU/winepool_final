import 'package:badges/badges.dart' as badges;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/filter_options_provider.dart';
import 'package:winepool_final/features/catalog/application/temporary_selection_providers.dart';
import 'package:winepool_final/core/widgets/custom_search_field.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/winery_list_item.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

class WineryFilterWidget extends ConsumerWidget {
  const WineryFilterWidget({super.key});

 @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(catalogFiltersProvider.select((f) => f.wineryIds.length));
    log('--- WineryFilterWidget REBUILT --- Selected count: $selectedCount');

    return Column(
      children: [
        // Ручка для смахивания
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8), // Переместили отступы сюда
          child: Center(
            child: Container(
              width: 40,
              height: 4,
              // margin удален из Container
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        // Заголовок и кнопки
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              Text(
                'Винодельни',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  // Сбрасываем временное состояние и применяем его к основному
                  ref.read(temporaryWineryIdsProvider.notifier).clear();
                  ref.read(catalogFiltersProvider.notifier).setWineries([]);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  // Применяем временное состояние к основному
                  final temporaryIds = ref.read(temporaryWineryIdsProvider);
                  ref.read(catalogFiltersProvider.notifier).setWineries(temporaryIds);
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        // --- Список популярных виноделен (вместо Expanded) ---
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final partnerWineriesAsync = ref.watch(partnerWineriesProvider);
              final temporaryWineryIds = ref.watch(temporaryWineryIdsProvider);

              return partnerWineriesAsync.when(
                loading: () => const ShimmerLoadingIndicator(),
                error: (error, stack) => Center(child: Text('Ошибка: $error')),
                data: (wineries) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text('Популярные винодельни', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: wineries.length,
                          itemBuilder: (context, index) {
                            final winery = wineries[index];
                            return WineryListItem(
                              winery: winery,
                              isSelected: temporaryWineryIds.contains(winery.id ?? ''),
                              onChanged: (isSelected) {
                                if (winery.id == null || winery.id!.isEmpty) return;
                                
                                final notifier = ref.read(temporaryWineryIdsProvider.notifier);
                                if (isSelected == true) {
                                  notifier.toggle(winery.id!);
                                } else {
                                  notifier.toggle(winery.id!);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      // --- Блок с выбранными чипами ---
                      // Получаем все винодельни, чтобы найти по ID
                      Builder(
                        builder: (context) {
                          final allWineriesAsync = ref.watch(allWineriesProvider);

                          // Отфильтровываем ID, которые не входят в список популярных
                          final popularWineryIds = wineries.map((w) => w.id).toSet();
                          final selectedNotPopularIds = temporaryWineryIds.where((id) => !popularWineryIds.contains(id)).toList();

                          if (selectedNotPopularIds.isNotEmpty && allWineriesAsync is AsyncData<List<Winery>>) {
                            final allWineriesData = allWineriesAsync.value;
                            final selectedWineries = selectedNotPopularIds.map((id) {
                              return allWineriesData.firstWhere((w) => w.id == id, orElse: () => Winery(id: id, name: 'Загрузка...'));
                            }).toList();

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Divider(),
                                const Padding(
                                  padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                                  child: Text('Выбранные', style: TextStyle(fontWeight: FontWeight.bold)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16),
                                  child: Wrap(
                                    spacing: 8.0,
                                    runSpacing: 4.0,
                                    children: selectedWineries.map((winery) {
                                      return Chip(
                                        label: Text(winery.name ?? ''),
                                        onDeleted: () {
                                          ref.read(temporaryWineryIdsProvider.notifier).toggle(winery.id ?? '');
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            // Если нет выбранных не-популярных, возвращаем пустой виджет
                            return const SizedBox.shrink();
                          }
                        }
                      )
                    ],
                  );
                },
              );
            },
          ),
        ),
        // Нижняя ссылка
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              context.go('/wines-catalog/winery-selection');
            },
            child: Text(
              'Все винодельни',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue),
            ),
          ),
        ),
      ],
    );
  }
}

void _showWineryFilterBottomSheet(BuildContext context, WidgetRef ref) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return SizedBox(
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Text('Винодельни', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      ref.read(catalogFiltersProvider.notifier).clearWineries();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(Icons.check),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _WineryFilterContent(),
            ),
          ],
        ),
      );
    },
  );
}

class _WineryFilterContent extends ConsumerWidget {
  const _WineryFilterContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return HookBuilder(
      builder: (BuildContext context) {
        final searchQuery = useState('');
        final localSelectedIds = useState<List<String>>([]);

        // Инициализация локального состояния из глобального провайдера
        useEffect(() {
          final initialIds = ref.read(catalogFiltersProvider).wineryIds;
          localSelectedIds.value = List.from(initialIds);
          return null;
        }, const []);

        return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomSearchField(
                  onChanged: (value) {
                    searchQuery.value = value;
                  },
                  hintText: 'Поиск виноделен...',
                ),
              ),
              const SizedBox(height: 16),
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
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          itemCount: filteredWineries.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 2),
                          itemBuilder: (context, index) {
                            final winery = filteredWineries[index];
                            final isSelected = localSelectedIds.value.contains(winery.id);
        
                            return WineryListItem(
                              winery: winery,
                              isSelected: isSelected,
                              onChanged: (selected) {
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
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Применить выбранные фильтры
                    ref.read(catalogFiltersProvider.notifier).setWineries(localSelectedIds.value);
                    Navigator.of(context).pop(); // Закрыть BottomSheet
                  },
                  child: const Text('Применить'),
                ),
              ),
               const SizedBox(height: 16),
            ],
          );
      },
    );
  }
}
