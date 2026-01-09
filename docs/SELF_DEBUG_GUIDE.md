# Руководство по самоконтролю: Избегаем частых ошибок

## Контекст
Повторяющиеся ошибки при использовании `@freezed` и `@riverpod`/`ref` замедляют разработку. Данный гайд фиксирует основные принципы, чтобы минимизировать такие ошибки.

---

## 1. `@freezed` и `abstract class`

**Правило:** Всегда используй `abstract class` при объявлении модели, помеченной `@freezed`.

**✅ Правильно:**
```dart
@freezed
abstract class Wine with _$Wine {
  const factory Wine({
    required String id,
    required String name,
    int? vintage,
  }) = _Wine;
}
```

**❌ Неправильно:**
```dart
@freezed
class Wine with _$Wine {
  const factory Wine({
    required String id,
    required String name,
    int? vintage,
  }) = _Wine;
}
```

---

## 2. `@riverpod` и `Ref`

**Правило:** Строго следуй синтаксису из документации `riverpod_generator`. Имя параметра `ref` должно соответствовать сгенерированному типу (например, `MyProviderNameRef ref`). После изменений в файле — обязательно запускай `build_runner`.

**Пример:**
```dart
@riverpod
Future<Wine> wineById(WineByIdRef ref, String id) async {
  // Логика получения вина по ID
  return await ref.watch(winesRepositoryProvider).getWineById(id);
}
```

**Важно:** После изменения файла запустить:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 3. Альтернатива `@riverpod`

**Правило:** Если `@riverpod` вызывает сложности, используй стандартный `FutureProvider` или `StateNotifierProvider` вручную, как это реализовано в других частях проекта. Это более надежный подход.

**Пример FutureProvider:**
```dart
final wineByIdProvider = FutureProvider.autoDispose.family<Wine, String>(
  (ref, id) => ref.watch(winesRepositoryProvider).getWineById(id),
);
```

---

## 4. Проверка по аналогии

**Правило:** Всегда смотри, как реализованы *другие* провайдеры и модели в проекте, и копируй их структуру.

- Изучи уже существующие `.dart` файлы с `@freezed` и `@riverpod`
- Следуй той же структуре и неймингу
- Обращай внимание на имена сгенерированных классов (например, `_$Wine`)