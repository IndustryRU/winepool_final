import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:winepool_final/features/cellar/application/cellar_controller.dart';
import 'package:winepool_final/features/wines/domain/wine.dart';
import '../domain/models.dart';
import '../../catalog/presentation/widgets/rating_filter_widget.dart';

class AddTastingScreen extends HookConsumerWidget {
  final Wine wine;

  const AddTastingScreen({super.key, required this.wine});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesController = useTextEditingController();
    final rating = useState<double>(0.0);
    final publishAsReview = useState(false);

    return PopScope(
      canPop: false, // Отключаем стандартное поведение кнопки "назад"
      onPopInvoked: (didPop) {
        if (!didPop) {
          context.pop(); // Используем GoRouter для навигации
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Добавить дегустацию'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.pop(), // Используем GoRouter
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                wine.name ?? '',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),
              
              // Виджет выбора рейтинга
              const Text(
                'Оценка',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              StarRatingSelector(
                initialRating: rating.value,
                onRatingChanged: (newRating) {
                  rating.value = newRating;
                },
              ),
              const SizedBox(height: 16),
              
              // Поле для заметок
              const Text(
                'Заметки',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: notesController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Введите ваши впечатления от вина...',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              
              // Чекбокс "Опубликовать как отзыв"
              CheckboxListTile(
                title: const Text('Опубликовать как отзыв'),
                value: publishAsReview.value,
                onChanged: (bool? newValue) {
                  publishAsReview.value = newValue ?? false;
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            try {
              // Вызов метода для добавления дегустации
              await ref.read(cellarControllerProvider.notifier).addTasting(
                wineId: wine.id ?? '',
                rating: rating.value,
                notes: notesController.text.isNotEmpty ? notesController.text : null,
                tastingDate: DateTime.now(), // Устанавливаем текущую дату по умолчанию
                publishAsReview: publishAsReview.value,
              );

              // Инвалидируем провайдер, чтобы обновить список
              ref.invalidate(cellarTastingsProvider);

              // Показываем сообщение об успехе
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Дегустация успешно добавлена!'),
                    backgroundColor: Colors.green,
                  ),
                );
                // Закрытие экрана
                context.pop();
              }
            } catch (e) {
              // Показываем сообщение об ошибке
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Ошибка при добавлении дегустации: $e'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            }
          },
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}