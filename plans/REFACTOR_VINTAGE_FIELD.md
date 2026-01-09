# План рефакторинга поля `vintage`

## 1. Подтверждение гипотезы

Гипотеза подтверждена. Поле `wines.vintage` является избыточным и должно быть удалено. Винтаж является атрибутом `Offer` (предложения), а не `Wine` (вина как абстракции).

## 2. Пошаговый план действий

### Шаг 1: Миграция базы данных (Supabase)

-   Создать новый SQL-файл миграции (например, `remove_vintage_from_wines.sql`).
-   Добавить в него команду для удаления столбца:
    ```sql
    ALTER TABLE public.wines
    DROP COLUMN IF EXISTS vintage;
    ```

### Шаг 2: Обновление модели `Wine`

-   **Файл:** `lib/features/wines/domain/wine.dart`
-   **Действие:** Удалить поле `vintage` из `factory Wine.freezed` и из конструктора `_Wine`.

### Шаг 3: Генерация кода

-   **Действие:** Запустить команду `flutter pub run build_runner build --delete-conflicting-outputs`, чтобы обновить сгенерированные файлы (`.g.dart`, `.freezed.dart`) после изменения модели `Wine`.

### Шаг 4: Исправление ошибок компиляции и обновление логики

-   **Файл:** `lib/features/wines/presentation/add_edit_wine_screen.dart`
    -   **Действие:** Удалить `vintageController` и соответствующий `TextFormField`. Поле `vintage` больше не должно передаваться при создании или обновлении `Wine`.
-   **Файл:** `lib/features/wines/data/wines_repository.dart`
    -   **Действие:** Удалить логику фильтрации по `vintage` (`min_year`, `max_year`). Эта фильтрация должна быть перенесена на уровень запроса к таблице `offers`, если потребуется.
-   **Файл:** `lib/features/wines/application/wine_label_search_controller.dart`
    -   **Действие:** Полностью удалить логику, связанную с `vintage` из фильтров и подсчета очков (`score`). Поиск по винтажу должен осуществляться через `offers`.
-   **Файл:** `lib/services/data_import_service.dart`
    -   **Действие:** Удалить обработку поля `vintage` при импорте данных для `Wine`.
-   **Файл:** `lib/features/wines/presentation/wine_details_screen.dart`
    -   **Действие:** Проверить и удалить использование `vintage`. Если там отображался год, теперь эту информацию нужно будет получать из списка `offers` для данного вина.

## 3. Диаграмма последовательности (Mermaid)

```mermaid
sequenceDiagram
    participant User
    participant App as Приложение
    participant Supabase

    User->>App: Запускает рефакторинг
    App->>Supabase: 1. Выполняет миграцию [ALTER TABLE wines DROP COLUMN vintage]
    Supabase-->>App: Миграция успешна

    App->>App: 2. Удаляет 'vintage' из модели Wine
    App->>App: 3. Запускает build_runner

    App->>App: 4. Рефакторит код:
    Note right of App: - AddEditWineScreen<br>- WinesRepository<br>- WineLabelSearchController<br>- DataImportService

    User->>App: Открывает экран вина
    App->>Supabase: Запрашивает данные вина [без vintage]
    App->>Supabase: Запрашивает 'offers' для этого вина [с vintage]
    Supabase-->>App: Возвращает данные
    App-->>User: Отображает винтажи из 'offers'