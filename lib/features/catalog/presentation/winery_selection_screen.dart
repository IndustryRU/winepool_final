import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../application/wineries_provider.dart';
import '../application/catalog_filters_provider.dart';

class WinerySelectionScreen extends HookConsumerWidget {
  const WinerySelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Винодельни'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.read(catalogFiltersProvider.notifier).clearWineries();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Поиск виноделен',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              // Здесь можно добавить логику поиска
            ),
          ),
          Expanded(
            child: ref.watch(allWineriesProvider).when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(child: Text('Ошибка: $error')),
                  data: (wineries) {
                    return ListView.builder(
                      itemCount: wineries.length,
                      itemBuilder: (context, index) {
                        final winery = wineries[index];
                        return CheckboxListTile(
                          title: Text(winery.name ?? ''),
                          value: ref.watch(
                            catalogFiltersProvider.select(
                              (f) => f.wineryIds.contains(winery.id ?? ''),
                            ),
                          ),
                          onChanged: (selected) {
                            ref.read(catalogFiltersProvider.notifier).toggleWineryId(winery.id ?? '');
                          },
                        );
                      },
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}