import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

class BottleSizeFilterWidget extends ConsumerWidget {
  const BottleSizeFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(
      catalogFiltersProvider.select((filters) => filters.bottleSizeIds.length),
    );

    return ListTile(
      title: const Text('Объем'),
      trailing: Text(
        selectedCount > 0 ? 'Выбрано: $selectedCount' : 'Любой',
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
            ),
      ),
      onTap: () {
        context.push('/wines-catalog/bottle-size-selection');
      },
    );
  }
}