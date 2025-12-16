# Спецификация рефакторинга агрегирующего провайдера для BuyerHomeScreen

## Обзор
На `BuyerHomeScreen` в настоящее время используются два отдельных индикатора загрузки для блоков "Популярных вин" и "Новинок". Цель рефакторинга — заменить их на один центральный индикатор загрузки, который отображается, пока загружается хотя бы один из блоков.

## Создание агрегирующего провайдера

### Описание
Создать новый провайдер `homeScreenAggregateProvider`, который будет агрегировать состояния загрузки от двух существующих провайдеров: `popularWinesProvider` и `newWinesProvider`.

### Реализация
Провайдер должен быть реализован с использованием аннотации `@riverpod` и типа `AsyncNotifierProvider` или аналогичного для обработки асинхронных данных.

#### Логика агрегации
Внутри провайдера использовать `ref.watch` для наблюдения за `popularWinesProvider` и `newWinesProvider`:

- Получить `AsyncValue` для каждого провайдера:
  ```dart
  final popularWines = ref.watch(popularWinesProvider);
  final newWines = ref.watch(newWinesProvider);
  ```

- Определить логику возврата:
  - Если `popularWines.isLoading || newWines.isLoading`, вернуть `const AsyncValue.loading()`.
  - Если `popularWines.hasError || newWines.hasError`, вернуть `AsyncValue.error(...)` с соответствующей ошибкой (можно объединить ошибки или выбрать первую).
  - Если оба провайдера в состоянии `hasValue`, вернуть `AsyncValue.data(...)` с данными, содержащими оба списка вин. Данные могут быть представлены в виде кортежа `(popular: popularWines.value, new: newWines.value)` или специального класса, например `HomeScreenData(popularWines: popularWines.value, newWines: newWines.value)`.

### Пример кода
```dart
@riverpod
class HomeScreenAggregate extends _$HomeScreenAggregate {
  @override
  FutureOr<HomeScreenData> build() async {
    final popularWines = ref.watch(popularWinesProvider);
    final newWines = ref.watch(newWinesProvider);

    if (popularWines.isLoading || newWines.isLoading) {
      return const AsyncValue.loading();
    }

    if (popularWines.hasError || newWines.hasError) {
      final error = popularWines.error ?? newWines.error;
      return AsyncValue.error(error!, StackTrace.current);
    }

    return AsyncValue.data(HomeScreenData(
      popularWines: popularWines.value!,
      newWines: newWines.value!,
    ));
  }
}

class HomeScreenData {
  final List<Wine> popularWines;
  final List<Wine> newWines;

  HomeScreenData({required this.popularWines, required this.newWines});
}
```

## Рефакторинг BuyerHomeScreen

### Описание
Изменить `BuyerHomeScreen`, чтобы он использовал `ref.watch(homeScreenAggregateProvider)` вместо отдельных `watch` для `popularWinesProvider` и `newWinesProvider`.

### Изменения в коде
- В методе `build` заменить два отдельных `watch` на один:
  ```dart
  final aggregateData = ref.watch(homeScreenAggregateProvider);
  ```

- Использовать один метод `when` на `aggregateData`:
  - `loading:` — показать один `ShimmerLoadingIndicator` по центру экрана.
  - `error:` — показать сообщение об ошибке, используя `SelectableText.rich` с красным цветом.
  - `data:` — построить весь экран, используя данные из `aggregateData.value` (например, `data.popularWines` и `data.newWines`).

### Пример структуры build метода
```dart
@override
Widget build(BuildContext context, WidgetRef ref) {
  final aggregateData = ref.watch(homeScreenAggregateProvider);

  return aggregateData.when(
    loading: () => const Center(child: ShimmerLoadingIndicator()),
    error: (error, stack) => Center(
      child: SelectableText.rich(
        TextSpan(text: 'Ошибка загрузки: $error'),
        style: TextStyle(color: Colors.red),
      ),
    ),
    data: (data) => Scaffold(
      // Построить экран с data.popularWines и data.newWines
      body: Column(
        children: [
          // Виджет для популярных вин с data.popularWines
          // Виджет для новинок с data.newWines
        ],
      ),
    ),
  );
}
```

## Следующие шаги
После реализации этого плана, запустить `flutter pub run build_runner build --delete-conflicting-outputs` для генерации кода от аннотаций Riverpod и Freezed.