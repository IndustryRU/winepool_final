import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';
import 'package:winepool_final/features/catalog/application/filter_options_provider.dart';
import 'package:winepool_final/features/catalog/application/temporary_selection_providers.dart';
import 'package:winepool_final/features/wines/domain/grape_variety.dart';
import 'package:winepool_final/features/catalog/presentation/widgets/grape_variety_list_item.dart';
import 'package:winepool_final/common/widgets/shimmer_loading_indicator.dart';

class GrapeVarietyFilterWidget extends ConsumerWidget {
  const GrapeVarietyFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        // Ручка
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Center(
            child: Container(
              width: 40,
              height: 4,
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
              Text('Сорт винограда', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              const Spacer(),
              IconButton(
                onPressed: () {
                  ref.read(temporaryGrapeVarietyIdsProvider.notifier).clear();
                },
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                onPressed: () {
                  final temporaryIds = ref.read(temporaryGrapeVarietyIdsProvider);
                  ref.read(catalogFiltersProvider.notifier).updateFilters(ref.read(catalogFiltersProvider).copyWith(grapeIds: temporaryIds));
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ),
        // Список популярных сортов
        Expanded(
          child: Consumer(
            builder: (context, ref, child) {
              final popularGrapesAsync = ref.watch(popularGrapeVarietiesProvider);
              final temporaryGrapeIds = ref.watch(temporaryGrapeVarietyIdsProvider);

              return popularGrapesAsync.when(
                loading: () => const Center(child: ShimmerLoadingIndicator()),
                error: (error, stack) => Center(child: Text('Ошибка: $error')),
                data: (grapes) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                        child: Text('Популярные сорта', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: grapes.length,
                          itemBuilder: (context, index) {
                            final grape = grapes[index];
                            return GrapeVarietyListItem(
                              grapeVariety: grape,
                              isSelected: temporaryGrapeIds.contains(grape.id),
                              onChanged: (isSelected) {
                                if(grape.id != null) {
                                  ref.read(temporaryGrapeVarietyIdsProvider.notifier).toggle(grape.id!);
                                }
                              },
                            );
                          },
                        ),
                      ),
                      // Выбранные сорта, не входящие в популярные
                      Builder(
                        builder: (context) {
                          final allGrapesAsync = ref.watch(allGrapeVarietiesProvider);
                          final popularGrapeIds = grapes.map((g) => g.id).toSet();
                          final selectedNotPopularIds = temporaryGrapeIds.where((id) => !popularGrapeIds.contains(id)).toList();

                          if (selectedNotPopularIds.isNotEmpty && allGrapesAsync is AsyncData<List<GrapeVariety>>) {
                            final allGrapesData = allGrapesAsync.value;
                            final selectedGrapes = selectedNotPopularIds.map((id) {
                              return allGrapesData.firstWhere((g) => g.id == id, orElse: () => GrapeVariety(id: id, name: '...'));
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
                                    children: selectedGrapes.map((grape) {
                                      return Chip(
                                        label: Text(grape.name ?? ''),
                                        onDeleted: () {
                                          if(grape.id != null) {
                                            ref.read(temporaryGrapeVarietyIdsProvider.notifier).toggle(grape.id!);
                                          }
                                        },
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
        // Ссылка на полный список
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: InkWell(
            onTap: () {
              context.go('/wines-catalog/grape-variety-selection');
            },
            child: Text('Все сорта', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.blue)),
          ),
        ),
      ],
    );
  }
}