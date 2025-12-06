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
    final result = await winesRepository.searchAll(query, categories);
    print(result);
    return result;
  },
);

class SearchResultsScreen extends HookConsumerWidget {
  const SearchResultsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final searchController = useTextEditingController();
    final currentQuery = useState('');
    final scale = useState<double>(1.0);
    final alignment = useState<Alignment>(Alignment.center);
    final controller = useAnimationController(duration: const Duration(milliseconds: 100));
    final curvedAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    final animation = Tween<double>(begin: 1.0, end: 1.4).animate(curvedAnimation);

    useEffect(() {
      void listener() {
        scale.value = animation.value;
      }

      animation.addListener(listener);
      return () => animation.removeListener(listener);
    }, [animation]);
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
        final searchParams = useMemoized(() => <String, dynamic>{
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
      child: GestureDetector(
        onLongPressStart: (LongPressStartDetails details) {
          // Convert local position to alignment
          RenderBox renderBox = context.findRenderObject() as RenderBox;
          Offset localPosition = details.localPosition;
          Size size = renderBox.size;
          double dx = (localPosition.dx / size.width - 0.5) * 2; // Convert to range [-1, 1]
          double dy = (localPosition.dy / size.height - 0.5) * 2; // Convert to range [-1, 1]
          alignment.value = Alignment(dx, dy);
          
          controller
            ..duration = const Duration(milliseconds: 100);
          controller.forward();
        },
        onLongPressEnd: (LongPressEndDetails details) {
          controller
            ..duration = const Duration(milliseconds: 100);
          controller.reverse();
        },
        child: Transform.scale(
          scale: scale.value,
          alignment: alignment.value,
          child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: searchController,
                decoration: InputDecoration(
                  hintText: 'Поиск вина, винодельни или сорта...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showFiltersModal(context, selectedSearchCategories, ref);
                    },
                  ),
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
            ],
          ),
        ),
        body: searchResults.when(
          data: (results) {
            final wines = (results['wines'] as List<dynamic>?)?.cast<Map<String, dynamic>>() ?? [];
            print(wines);
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
                return WineTile(wine: wine, isSearch: true);
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
      ), // Закрывающая скобка для Scaffold
    ), // Закрывающая скобка для Transform.scale
  ), // Закрывающая скобка для GestureDetector
); // Закрывающая скобка для WillPopScope
  }
}
void showFiltersModal(
  BuildContext context,
  ValueNotifier<Set<String>> selectedCategories,
  WidgetRef ref,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext modalContext) {
      return FiltersModal(
        initialCategories: selectedCategories.value,
        onApply: (Set<String> newCategories) {
          selectedCategories.value = newCategories;
          ref.invalidate(searchAllProvider);
          Navigator.of(modalContext).pop();
        },
      );
    },
 );
}

class FiltersModal extends HookWidget {
  final Set<String> initialCategories;
  final void Function(Set<String> newCategories) onApply;

  const FiltersModal({
    super.key,
    required this.initialCategories,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final selectedCategoriesState = useState<Set<String>>(initialCategories);

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Фильтры поиска',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Вина'),
            value: selectedCategoriesState.value.contains('wines_name'),
            onChanged: (bool? value) {
              if (value == null) return;
              if (value) {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value,
                  'wines_name'
                };
              } else {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value
                }..remove('wines_name');
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Сорта'),
            value: selectedCategoriesState.value.contains('wines_grape_variety'),
            onChanged: (bool? value) {
              if (value == null) return;
              if (value) {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value,
                  'wines_grape_variety'
                };
              } else {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value
                }..remove('wines_grape_variety');
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Винодельни'),
            value: selectedCategoriesState.value.contains('wineries_name'),
            onChanged: (bool? value) {
              if (value == null) return;
              if (value) {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value,
                  'wineries_name'
                };
              } else {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value
                }..remove('wineries_name');
              }
            },
          ),
          CheckboxListTile(
            title: const Text('Местоположение'),
            value: selectedCategoriesState.value.contains('wineries_location'),
            onChanged: (bool? value) {
              if (value == null) return;
              if (value) {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value,
                  'wineries_location'
                };
              } else {
                selectedCategoriesState.value = {
                  ...selectedCategoriesState.value
                }..remove('wineries_location');
              }
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onApply(selectedCategoriesState.value);
            },
            child: const Text('Применить'),
          ),
        ],
      ),
    );
  }
}
