import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:winepool_final/features/catalog/application/catalog_filters_provider.dart';

class WineryFilterWidget extends ConsumerWidget {
  const WineryFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCount = ref.watch(catalogFiltersProvider.select((f) => f.wineryIds.length));
    log('WineryFilterWidget REBUILT. Selected count from provider: $selectedCount');

    return InputChip(
      label: Text(selectedCount > 0 ? 'Винодельня: $selectedCount' : 'Винодельня'),
      selected: selectedCount > 0,
      onPressed: () => context.push('/wines-catalog/winery-selection'),
      deleteIcon: const Icon(Icons.close, size: 18),
      onDeleted: selectedCount > 0 
        ? () => ref.read(catalogFiltersProvider.notifier).clearWineries()
        : null,
    );
  }
}