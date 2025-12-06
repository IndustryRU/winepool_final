import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import 'package:winepool_final/features/wines/presentation/wine_tile.dart';
import '../../../features/wines/application/wines_controller.dart';
import '../../../features/wines/data/wines_repository.dart';

final searchAllProvider = FutureProvider.autoDispose.family<Map<String, dynamic>, Map<String, dynamic>>(
  (ref, searchParams) async {
    final query = searchParams['query'] as String? ?? '';
    final categories = searchParams['categories'] as Set<String>? ?? {};
    
    if (query.isEmpty) {
      return {'wines': [], 'wineries': []}; // Возвращаем пустой объект, если запрос пустой
    }
    final winesRepository = ref.watch(winesRepositoryProvider);
    return await winesRepository.searchAll(query, categories);
  },
);

class SearchResultsScreen extends HookConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final currentQuery = useState('');
    final selectedSearchCategories = useState({
      'wines_name',
      'wines_grape_variety',
      'wineries_name'
    }); // По умолчанию включены все категории

    // Используем debounce для поиска
    final debouncedQuery = useState('');
    final debounceTimer = useRef<Timer?>(null);
    
    // Инициализация и очистка ресурсов
    useEffect(() {
      return () {
        debounceTimer.value?.cancel();
        searchController.dispose();
      };
    }, []);

    // Обновляем провайдер при изменении текста
    final searchParams = useMemoized(() => {
      'query': debouncedQuery.value,
      'categories': selectedSearchCategories.value,
    }, [debouncedQuery.value, selectedSearchCategories.value]);
    
    final searchResults = ref.watch(searchAllProvider(searchParams));

    return WillPopScope(
      onWillPop: () async {
        // Возвращаем на предыдущий экран (обычно это главный экран)
        context.go('/buyer-home');
        return false;
      },
      child: Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: searchController,
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
                // Отменяем предыдущий таймер
                debounceTimer.value?.cancel();
                
                if (value.isEmpty) {
                  // Если значение пустое, обновляем немедленно
                  debouncedQuery.value = value;
                } else {
                  // Устанавливаем новый таймер для debounce
                  debounceTimer.value = Timer(const Duration(milliseconds: 500), () {
                    // Проверяем, что виджет еще активен перед обновлением состояния
                    if (context.mounted) {
                      debouncedQuery.value = value;
                    }
                  });
                }
              },
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8.0,
              children: [
                FilterChip(
                  label: const Text('Вина (название)'),
                  selected: selectedSearchCategories.value.contains('wines_name'),
                  onSelected: (selected) {
                    if (selected) {
                      selectedSearchCategories.value = {
                        ...selectedSearchCategories.value,
                        'wines_name'
                      };
                    } else {
                      selectedSearchCategories.value = {
                        ...selectedSearchCategories.value
                      }..remove('wines_name');
                    }
                    // Обновляем провайдер при изменении категорий
                    ref.invalidate(searchAllProvider);
                  },
                ),
                FilterChip(
                  label: const Text('Сорта вин'),
                  selected: selectedSearchCategories.value.contains('wines_grape_variety'),
                  onSelected: (selected) {
                    if (selected) {
                      selectedSearchCategories.value = {
                        ...selectedSearchCategories.value,
                        'wines_grape_variety'
                      };
                    } else {
                      selectedSearchCategories.value = {
                        ...selectedSearchCategories.value
                      }..remove('wines_grape_variety');
                    }
                    // Обновляем провайдер при изменении категорий
                    ref.invalidate(searchAllProvider);
                  },
                ),
                FilterChip(
                  label: const Text('Винодельни'),
                  selected: selectedSearchCategories.value.contains('wineries_name'),
                  onSelected: (selected) {
                    if (selected) {
                      selectedSearchCategories.value = {
                        ...selectedSearchCategories.value,
                        'wineries_name'
                      };
                    } else {
                      selectedSearchCategories.value = {
                        ...selectedSearchCategories.value
                      }..remove('wineries_name');
                    }
                    // Обновляем провайдер при изменении категорий
                    ref.invalidate(searchAllProvider);
                  },
                ),
              ],
            ),
          ],
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