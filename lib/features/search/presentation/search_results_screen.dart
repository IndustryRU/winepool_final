import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import '../../../features/wines/application/wines_controller.dart';
import '../../../features/wines/data/wines_repository.dart';

final searchWinesProvider = FutureProvider.autoDispose.family<List<Wine>, String>(
  (ref, query) async {
    if (query.isEmpty) {
      return []; // Возвращаем пустой список, если запрос пустой
    }
    final winesRepository = ref.watch(winesRepositoryProvider);
    return await winesRepository.searchWines(query);
  },
);

class SearchResultsScreen extends ConsumerStatefulWidget {
  const SearchResultsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends ConsumerState<SearchResultsScreen> {
  late final TextEditingController _searchController;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Обновляем провайдер при изменении текста
    final searchResults = ref.watch(searchWinesProvider(_currentQuery));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Поиск вина, винодельни или сорта...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.grey[200],
          ),
          onChanged: (value) {
            // Добавляем проверку длины запроса
            if (value.length >= 1) {
              setState(() {
                _currentQuery = value;
              });
            } else if (value.isEmpty) {
              setState(() {
                _currentQuery = value;
              });
            }
            // Если длина меньше 1, но запрос не пустой, не обновляем _currentQuery
          },
        ),
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