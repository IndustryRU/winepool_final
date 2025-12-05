import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import '../../../features/wines/application/wines_controller.dart';
import '../../../features/wines/data/wines_repository.dart';

final searchAllProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, String>(
  (ref, query) async {
    if (query.isEmpty) {
      return {'wines': [], 'wineries': []}; // Возвращаем пустой объект, если запрос пустой
    }
    final winesRepository = ref.watch(winesRepositoryProvider);
    return await winesRepository.searchAll(query);
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
    final searchResults = ref.watch(searchAllProvider(_currentQuery));

    return WillPopScope(
      onWillPop: () async {
        // Возвращаем на предыдущий экран (обычно это главный экран)
        context.go('/buyer-home');
        return false;
      },
      child: Scaffold(
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
        data: (results) {
          final wines = (results['wines'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
          final wineries = (results['wineries'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];

          if (wines.isEmpty && wineries.isEmpty) {
            return const Center(
              child: Text('Ничего не найдено'),
            );
          }

          final List<Widget> children = [];

          if (wines.isNotEmpty) {
            children.add(
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Вина', style: Theme.of(context).textTheme.titleLarge),
              ),
            );
            children.addAll(wines.map((wineData) {
              // Преобразуем Map<String, dynamic> из JSON в объект Wine
              // Для этого Wine.fromJson должен уметь работать с вложенными объектами winery
              final wine = Wine.fromJson(wineData);
              return WineTile(wine: wine);
            }).toList());
          }

          if (wineries.isNotEmpty) {
            children.add(
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text('Винодельни', style: Theme.of(context).textTheme.titleLarge),
              ),
            );
            children.addAll(wineries.map((wineryData) {
              // Здесь мы отображаем просто информацию о винодельне
              // Возможно, потребуется создать отдельный виджет для отображения виноделен
              return ListTile(
                title: Text(wineryData['name'] as String),
                // Добавьте другие поля, если необходимо
              );
            }).toList());
          }

          return ListView(
            children: children,
          );
        },
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
    ),
  );
}
}