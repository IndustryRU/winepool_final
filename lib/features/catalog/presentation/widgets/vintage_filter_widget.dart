import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../vintage_selection_screen.dart';
import '../../application/catalog_filters_provider.dart';

class VintageFilterWidget extends ConsumerWidget {
  const VintageFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVintages = ref.watch(catalogFiltersProvider.select((filters) => filters.vintages));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Винтаж',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              if (selectedVintages.isNotEmpty)
                TextButton(
                  onPressed: () {
                    ref.read(catalogFiltersProvider.notifier).resetVintageFilter();
                  },
                  child: const Text('Сбросить'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              FilterChip(
                label: const Text('Выбрать винтажи'),
                selected: selectedVintages.isEmpty,
                onSelected: (bool selected) {
                  if (selected) {
                    context.push('/wines-catalog/vintage-selection');
                  }
                },
                selectedColor: Colors.blue.shade100,
                showCheckmark: false,
              ),
              ...selectedVintages.map(
                (vintage) => FilterChip(
                  label: Text(vintage.toString()),
                  selected: true,
                  onSelected: (_) {
                    // Удаляем винтаж из фильтра
                    ref.read(catalogFiltersProvider.notifier).removeVintage(vintage);
                  },
                  selectedColor: Colors.blue.shade100,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}