import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../application/catalog_filters_provider.dart';

class WineryFilterWidget extends ConsumerWidget {
  const WineryFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(
      catalogFiltersProvider.select((f) => f.wineryIds.length),
    );

    return InputChip(
      label: Text(
        selectedCount > 0 ? 'Винодельня: $selectedCount' : 'Винодельня',
      ),
      selected: selectedCount > 0,
      onPressed: () => context.push('/wines-catalog/winery-selection'),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: selectedCount > 0
          ? () => ref.read(catalogFiltersProvider.notifier).clearWineries()
          : null,
    );
  }
}