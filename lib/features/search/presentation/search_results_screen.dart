import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import '../../../features/wines/application/wines_controller.dart';
import '../../../features/wines/data/wines_repository.dart';

final searchWinesProvider = FutureProvider.autoDispose.family<List<Wine>, String>(
  (ref, query) async {
    final winesRepository = ref.watch(winesRepositoryProvider);
    return await winesRepository.searchWines(query);
  },
);

class SearchResultsScreen extends ConsumerWidget {
  final String query;

  const SearchResultsScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchResults = ref.watch(searchWinesProvider(query));

    return Scaffold(
      appBar: AppBar(
        title: Text('Результаты поиска: "$query"'),
      ),
      body: searchResults.when(
        data: (wines) => wines.isEmpty
            ? const Center(
                child: Text('Ничего не найдено'),
              )
            : ListView.builder(
                itemCount: wines.length,
                itemBuilder: (context, index) {
                  return WineTile(wine: wines[index]);
                },
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: SelectableText.rich(
            TextSpan(
              text: 'Ошибка: ${error.toString()}',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }
}