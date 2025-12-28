# Рефакторинг таблицы `wines`

Этот документ описывает предлагаемые изменения в структуре таблицы `wines` для улучшения нормализации данных, согласованности и добавления автоматизированных вычислений.

## 1. Анализ текущей структуры

Текущая структура таблицы `wines` содержит несколько полей, которые могут быть улучшены:

```sql
create table public.wines (
  id uuid not null default gen_random_uuid (),
  winery_id uuid null,
  name text not null,
  description text null,
  image_url text null,
  country text null,            -- (1) Дублирование
  region text null,             -- (1) Дублирование
  grape_variety text null,      -- (2) Ненормализованное поле
  pairing text null,
  aroma text null,
  color public.wine_color null,
  type public.wine_type null,
  sugar public.wine_sugar null,
  sweetness smallint null,
  acidity smallint null,
  tannins smallint null,
  saturation smallint null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  vintage integer null,
  serving_temperature text null,
  alcohol_level numeric null,
  rating numeric null default 0, -- (3) Устаревшее поле
  is_deleted boolean null default false,
  average_rating numeric null default 0.0,
  reviews_count integer null default 0,
  constraint wines_pkey primary key (id),
  constraint wines_winery_id_fkey foreign KEY (winery_id) references wineries (id)
);
```

**Проблемные области:**

1.  **Денормализация `country` и `region`**: Поля `country` и `region` хранят текстовые значения, которые дублируют информацию из связанных таблиц `countries` и `regions`. Данные должны быть доступны через связь с `wineries`.
2.  **Негибкое хранение сортов винограда**: Поле `grape_variety` имеет тип `text`, что не позволяет эффективно связывать одно вино с несколькими сортами винограда и усложняет фильтрацию.
3.  **Дублирование полей рейтинга**: Поля `rating` и `average_rating` кажутся избыточными. `average_rating` и `reviews_count` должны вычисляться автоматически на основе данных из таблицы `reviews`, а поле `rating` является устаревшим.

## 2. Предлагаемые улучшения

### 2.1. Нормализация данных

*   **Удаление полей `country` и `region`**: Эти данные теперь будут получаться через `winery_id` -> `wineries.region_id` -> `regions.country_code`.
*   **Связь "многие ко многим" для сортов винограда**:
    *   Создать новую таблицу `wine_grape_varieties` для связи `wines` и `grape_varieties`.
    *   Удалить поле `grape_variety` из таблицы `wines`.

### 2.2. Автоматизация вычисления рейтинга

*   **Удаление поля `rating`**: Это поле больше не нужно, так как `average_rating` будет служить основным показателем.
*   **Создание функции и триггера**:
    *   SQL-функция `update_wine_rating()` будет вычислять средний рейтинг и количество отзывов для вина.
    *   Триггер `on_review_change` будет вызывать эту функцию при операциях `INSERT`, `UPDATE` или `DELETE` в таблице `reviews`.

### 2.3. Добавление новых полей

Для расширения функциональности предлагается добавить следующие поля в таблицу `wines`:

*   `barcode` (TEXT): Для хранения штрих-кода EAN-13 или другого формата.
*   `awards` (TEXT[]): Массив текстовых строк для хранения информации о наградах.

### 2.4. Обновленная диаграмма ERD

```mermaid
erDiagram
    wineries {
        uuid id PK
        text name
        uuid region_id FK
        text country_code FK
    }

    wines {
        uuid id PK
        uuid winery_id FK
        text name
        numeric average_rating
        integer reviews_count
        text barcode
        text[] awards
        -- другие поля
    }

    reviews {
        uuid id PK
        uuid wine_id FK
        integer rating
        -- другие поля
    }

    grape_varieties {
        uuid id PK
        text name
    }

    wine_grape_varieties {
        uuid wine_id PK, FK
        uuid grape_variety_id PK, FK
    }

    regions {
        uuid id PK
        text name
        text country_code FK
    }

    countries {
        text code PK
        text name
    }

    wineries ||--o{ wines : "производит"
    wines ||--o{ reviews : "имеет"
    wines ||--|{ wine_grape_varieties : "состоит из"
    grape_varieties ||--|{ wine_grape_varieties : "является частью"
    wineries }|--|| regions : "находится в"
    regions }|--|| countries : "находится в"
```

## 3. SQL-скрипты для миграции

Ниже приведены скрипты, необходимые для применения описанных изменений.

### 3.1. Удаление старых полей и добавление новых

Этот скрипт удаляет устаревшие и денормализованные поля, а также добавляет новые (`barcode`, `awards`).

```sql
-- Удаление старых столбцов из таблицы wines
ALTER TABLE public.wines
DROP COLUMN IF EXISTS country,
DROP COLUMN IF EXISTS region,
DROP COLUMN IF EXISTS grape_variety,
DROP COLUMN IF EXISTS rating;

-- Добавление новых столбцов
ALTER TABLE public.wines
ADD COLUMN IF NOT EXISTS barcode TEXT,
ADD COLUMN IF NOT EXISTS awards TEXT[];
```

### 3.2. Создание связующей таблицы `wine_grape_varieties`

Эта таблица устанавливает связь "многие ко многим" между винами и сортами винограда.

```sql
-- Создание таблицы для связи многие-ко-многим между винами и сортами винограда
CREATE TABLE IF NOT EXISTS public.wine_grape_varieties (
    wine_id UUID NOT NULL,
    grape_variety_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    
    CONSTRAINT wine_grape_varieties_pkey PRIMARY KEY (wine_id, grape_variety_id),
    
    CONSTRAINT wine_grape_varieties_wine_id_fkey FOREIGN KEY (wine_id)
        REFERENCES public.wines(id) ON DELETE CASCADE,
        
    CONSTRAINT wine_grape_varieties_grape_variety_id_fkey FOREIGN KEY (grape_variety_id)
        REFERENCES public.grape_varieties(id) ON DELETE CASCADE
);

-- Индексы для ускорения запросов
CREATE INDEX IF NOT EXISTS idx_wine_grape_varieties_wine_id ON public.wine_grape_varieties(wine_id);
CREATE INDEX IF NOT EXISTS idx_wine_grape_varieties_grape_variety_id ON public.wine_grape_varieties(grape_variety_id);
```

### 3.3. Функция и триггер для автоматического обновления рейтинга

Эта функция и триггер будут поддерживать `average_rating` и `reviews_count` в актуальном состоянии.

```sql
-- Создание функции для обновления среднего рейтинга и количества отзывов
CREATE OR REPLACE FUNCTION public.update_wine_rating()
RETURNS TRIGGER AS $$
DECLARE
    wine_uuid UUID;
BEGIN
    -- Определяем wine_id в зависимости от операции (INSERT, UPDATE, DELETE)
    IF (TG_OP = 'DELETE') THEN
        wine_uuid := OLD.wine_id;
    ELSE
        wine_uuid := NEW.wine_id;
    END IF;

    -- Обновляем средний рейтинг и количество отзывов в таблице wines
    UPDATE public.wines
    SET
        average_rating = (
            SELECT COALESCE(AVG(rating), 0)
            FROM public.reviews
            WHERE wine_id = wine_uuid AND is_deleted = false
        ),
        reviews_count = (
            SELECT COUNT(*)
            FROM public.reviews
            WHERE wine_id = wine_uuid AND is_deleted = false
        )
    WHERE id = wine_uuid;

    RETURN NULL; -- Результат триггера AFTER игнорируется
END;
$$ LANGUAGE plpgsql;

-- Удаление старого триггера, если он существует
DROP TRIGGER IF EXISTS on_review_change ON public.reviews;

-- Создание триггера, который вызывает функцию при изменении отзывов
CREATE TRIGGER on_review_change
AFTER INSERT OR UPDATE OR DELETE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION public.update_wine_rating();