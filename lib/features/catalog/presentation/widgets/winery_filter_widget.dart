import 'package:badges/badges.dart' as badges;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/wineries_provider.dart';
import 'package:winepool_final/core/widgets/custom_search_field.dart';
import 'package:winepool_final/features/wines/domain/winery.dart';

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
                  ref.read(catalogFiltersProvider.notifier).setWineries([]);
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
        // Пустое пространство
        const Expanded(child: SizedBox()),
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
                      loading: () => const Center(child: CircularProgressIndicator()),
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
