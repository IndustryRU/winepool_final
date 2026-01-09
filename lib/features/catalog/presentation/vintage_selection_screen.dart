import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/vintage_provider.dart';
import '../application/catalog_filters_provider.dart';

class VintageSelectionScreen extends ConsumerWidget {
  const VintageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVintages = ref.watch(catalogFiltersProvider.select((filters) => filters.vintages));
    final availableVintagesAsync = ref.watch(availableVintagesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Выберите винтажи'),
        actions: [
          TextButton(
            onPressed: () {
              // Сбрасываем фильтр по винтажам
              ref.read(catalogFiltersProvider.notifier).setVintages([]);
              Navigator.pop(context);
            },
            child: const Text('Сбросить'),
          ),
        ],
      ),
      body: availableVintagesAsync.when(
        data: (vintages) => ListView.builder(
          itemCount: vintages.length,
          itemBuilder: (context, index) {
            final vintage = vintages[index];
            final isSelected = selectedVintages.contains(vintage);

            return CheckboxListTile(
              title: Text(vintage.toString()),
              value: isSelected,
              onChanged: (bool? value) {
                if (value == null) return;

                if (value) {
                  // Добавляем винтаж к выбранным
                  ref.read(catalogFiltersProvider.notifier).addVintage(vintage);
                } else {
                  // Удаляем винтаж из выбранных
                  ref.read(catalogFiltersProvider.notifier).removeVintage(vintage);
                }
              },
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Ошибка: $error')),
      ),
    );
  }
}