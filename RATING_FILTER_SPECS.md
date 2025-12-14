# Спецификация фильтра по рейтингу (Rating Filter Specs)

## Обзор
Новый фильтр по рейтингу заменяет текущий неудобный интерфейс на интуитивно понятный с интерактивными звездами. Фильтр будет отображаться в модальном окне и позволит пользователям выбирать минимальный рейтинг от 0 до 5 звезд.

## Архитектура компонентов

### RatingFilterWidget
Основной виджет-контейнер, отображаемый в модальном окне.

**Структура:**
- Заголовок: "Фильтр по рейтингу" (Text с соответствующим стилем).
- StarRatingSelector: Виджет для выбора звезд.
- Текстовое пояснение: "Выберите минимальный рейтинг" (Text с описанием).
- Кнопки действий: "Применить" и "Отмена" (Row с ElevatedButton для каждой).

**Поведение:**
- Принимает начальное значение рейтинга через параметр (например, `int initialRating`).
- Управляет состоянием выбранного рейтинга.
- При нажатии "Применить" передает выбранное значение обратно в CatalogScreen через callback (например, `void onApply(int rating)`).
- При нажатии "Отмена" закрывает модальное окно без изменений.

**Пример использования:**
```dart
showDialog(
  context: context,
  builder: (context) => RatingFilterWidget(
    initialRating: currentRating,
    onApply: (rating) {
      // Обновить фильтр в CatalogScreen
      setState(() => currentRating = rating);
    },
  ),
);
```

### StarRatingSelector
Дочерний виджет, реализующий логику выбора звезд.

**Структура:**
- Row с 5 элементами (IconButton или InkWell + Icon).
- Каждый элемент представляет одну звезду (Icon(Icons.star)).

**Управление состоянием:**
- Локальное состояние: `int selectedRating` (от 0 до 5), инициализируется значением из RatingFilterWidget.
- Использует `useState` из Flutter Hooks для управления состоянием.

**Визуализация:**
- Цвет звезд: `index < selectedRating ? Colors.amber : Colors.grey` (где index от 0 до 4).
- Заполненные звезды (amber) для выбранного рейтинга и выше, пустые (grey) для остальных.

**Взаимодействие:**
- onPressed для каждой звезды: Устанавливает `selectedRating = index + 1` (чтобы выбрать от 1 до 5 звезд).
- Для выбора 0 звезд: Отдельная логика сброса (см. ниже).

**Пример кода:**
```dart
class StarRatingSelector extends HookConsumerWidget {
  const StarRatingSelector({super.key, required this.onRatingChanged});

  final void Function(int) onRatingChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRating = useState(0);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            Icons.star,
            color: index < selectedRating.value ? Colors.amber : Colors.grey,
          ),
          onPressed: () {
            selectedRating.value = index + 1;
            onRatingChanged(selectedRating.value);
          },
        );
      }),
    );
  }
}
```

### Логика сброса
- **Повторное нажатие на выбранную звезду:** Если пользователь нажимает на звезду, которая уже выбрана (т.е. index + 1 == selectedRating), то сбросить рейтинг до 0.
- **Альтернатива:** Добавить отдельную кнопку "Сбросить" рядом с Row звезд, которая устанавливает selectedRating = 0.

**Рекомендация:** Использовать повторное нажатие для простоты интерфейса, без дополнительной кнопки.

### Обратная связь
- RatingFilterWidget получает callback `onApply` от CatalogScreen.
- При нажатии "Применить" вызывает `onApply(selectedRating.value)`, передавая финальное значение.
- CatalogScreen обновляет свой фильтр и применяет его к списку товаров (аналогично фильтру цен).

**Интеграция с CatalogScreen:**
- Добавить поле для текущего рейтинга фильтра (например, `int ratingFilter = 0;`).
- В UI фильтров добавить кнопку или элемент для открытия RatingFilterWidget.
- После применения обновить запрос к Supabase или локальный фильтр списка.

## Дополнительные замечания
- Использовать const конструкторы для оптимизации.
- Обеспечить доступность: Добавить семантику для screen readers.
- Тестирование: Проверить на разных размерах экранов и ориентациях.
- Производительность: Минимизировать rebuilds с помощью const и ключей.