import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../../features/catalog/application/catalog_filters_provider.dart';

class GrapeFilterWidget extends ConsumerWidget {
  const GrapeFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalogFilters = ref.watch(catalogFiltersProvider);
    
    return ListTile(
      title: Text('Сорта: выбрано ${catalogFilters.grapeIds.length}'),
      onTap: () {
        context.push('/wines-catalog/grape-selection');
      },
    );
  }
}
