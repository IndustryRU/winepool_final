import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

class SortFilterWidget extends ConsumerWidget {
  const SortFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentSortOption = ref.watch(catalogFiltersProvider.select((f) => f.sortOption));
    final notifier = ref.read(catalogFiltersProvider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('Сортировка', style: Theme.of(context).textTheme.titleLarge),
        ),
        RadioListTile<String?>(
          title: const Text('По умолчанию (Новинки)'),
          value: null,
          groupValue: currentSortOption,
          onChanged: (value) {
            notifier.setSortOption(value);
            Navigator.of(context).pop();
          },
        ),
        RadioListTile<String>(
          title: const Text('Популярные'),
          value: 'popular',
          groupValue: currentSortOption,
          onChanged: (value) {
            notifier.setSortOption(value);
            Navigator.of(context).pop();
          },
        ),
        RadioListTile<String>(
          title: const Text('Дешевле'),
          value: 'price_asc',
          groupValue: currentSortOption,
          onChanged: (value) {
            notifier.setSortOption(value);
            Navigator.of(context).pop();
          },
        ),
        RadioListTile<String>(
          title: const Text('Дороже'),
          value: 'price_desc',
          groupValue: currentSortOption,
          onChanged: (value) {
            notifier.setSortOption(value);
            Navigator.of(context).pop();
          },
        ),
        RadioListTile<String>(
          title: const Text('С высоким рейтингом'),
          value: 'rating_desc',
          groupValue: currentSortOption,
          onChanged: (value) {
            notifier.setSortOption(value);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}