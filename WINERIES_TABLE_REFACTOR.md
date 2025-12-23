# Рефакторинг таблицы `wineries`

## 1. Анализ текущей структуры

Текущая структура таблицы `wineries` выглядит следующим образом:

```sql
create table public.wineries (
  id uuid not null default gen_random_uuid (),
  name text not null,
  description text null,
  logo_url text null,
  region text null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  banner_url text null,
  winemaker text null,
  website text null,
  location_text text null,
  country_code character varying(2) null,
  constraint wineries_pkey primary key (id),
  constraint fk_wineries_country_code foreign KEY (country_code) references countries (code)
) TABLESPACE pg_default;
```

**Выявленные недостатки:**

1.  **Поле `region`:** Хранение региона в виде текстового поля (`text`) приводит к несогласованности данных из-за возможных опечаток или разных наименований одного и того же региона. Это значительно усложняет фильтрацию и аналитику.
2.  **Поле `location_text`:** Текстовое представление адреса не позволяет использовать геоданные для отображения виноделен на карте и поиска по местоположению.
3.  **Отсутствие важных полей:** Для полноты картины и будущих функций не хватает таких данных, как год основания, контактная информация и статус партнерства.

## 2. Предлагаемые улучшения

### 2.1. Создание таблицы `regions`

Для нормализации данных и обеспечения их консистентности предлагается вынести регионы в отдельную справочную таблицу `regions`.

*   **Обоснование:** Это позволит избежать дублирования и ошибок при вводе, а также упростит реализацию фильтрации по регионам в приложении. Связь будет осуществляться по принципу "один ко многим" (один регион - много виноделен).

### 2.2. Добавление полей для геолокации

Добавление координат позволит интегрировать карты в приложение.

*   **Обоснование:** Поля `latitude` и `longitude` необходимы для точного определения местоположения винодельни, что открывает возможности для визуализации данных на карте и построения маршрутов.

### 2.3. Добавление дополнительных атрибутов

Для обогащения данных о винодельнях предлагается добавить следующие поля:

*   `founded_year` (integer): Год основания.
*   `is_partner` (boolean): Флаг, указывающий на партнерство с нашей платформой.
*   `phone` (text): Контактный телефон.
*   `email` (text): Контактный email.

*   **Обоснование:** Эти данные повысят информативность карточки винодельни для конечного пользователя и предоставят дополнительные возможности для бизнес-логики (например, отображение специальных предложений от партнеров).

## 3. SQL-скрипты для миграции

### 3.1. Создание таблицы `regions`

```sql
CREATE TABLE public.regions (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    country_code CHARACTER VARYING(2) NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT regions_pkey PRIMARY KEY (id),
    CONSTRAINT fk_regions_country_code FOREIGN KEY (country_code) REFERENCES countries(code),
    CONSTRAINT regions_name_country_code_key UNIQUE (name, country_code)
);

COMMENT ON TABLE public.regions IS 'Справочник винодельческих регионов';
COMMENT ON COLUMN public.regions.name IS 'Название региона';
COMMENT ON COLUMN public.regions.country_code IS 'Код страны (ISO 3166-1 alpha-2)';

```

### 3.2. Изменение таблицы `wineries`

```sql
-- Шаг 1: Добавляем новые столбцы
ALTER TABLE public.wineries
ADD COLUMN region_id UUID NULL,
ADD COLUMN latitude NUMERIC(9, 6) NULL,
ADD COLUMN longitude NUMERIC(9, 6) NULL,
ADD COLUMN founded_year INTEGER NULL,
ADD COLUMN is_partner BOOLEAN NOT NULL DEFAULT false,
ADD COLUMN phone TEXT NULL,
ADD COLUMN email TEXT NULL;

-- Шаг 2: Добавляем внешний ключ для связи с регионами
ALTER TABLE public.wineries
ADD CONSTRAINT fk_wineries_region_id FOREIGN KEY (region_id) REFERENCES public.regions(id);

-- Шаг 3: (Опционально) Заполняем новую таблицу regions и обновляем wineries.
-- Этот шаг потребует отдельного скрипта для переноса данных.
-- INSERT INTO public.regions (name, country_code)
-- SELECT DISTINCT region, country_code FROM public.wineries WHERE region IS NOT NULL;
--
-- UPDATE public.wineries w
-- SET region_id = r.id
-- FROM public.regions r
-- WHERE w.region = r.name AND w.country_code = r.country_code;

-- Шаг 4: Удаляем старый столбец region
ALTER TABLE public.wineries
DROP COLUMN region;

-- Добавляем комментарии к новым столбцам
COMMENT ON COLUMN public.wineries.region_id IS 'Ссылка на регион винодельни';
COMMENT ON COLUMN public.wineries.latitude IS 'Широта местоположения винодельни';
COMMENT ON COLUMN public.wineries.longitude IS 'Долгота местоположения винодельни';
COMMENT ON COLUMN public.wineries.founded_year IS 'Год основания винодельни';
COMMENT ON COLUMN public.wineries.is_partner IS 'Является ли винодельня партнером';
COMMENT ON COLUMN public.wineries.phone IS 'Контактный телефон винодельни';
COMMENT ON COLUMN public.wineries.email IS 'Контактный email винодельни';
```

## 4. Mermaid-диаграмма

```mermaid
erDiagram
    countries {
        varchar(2) code PK
        varchar name
    }

    regions {
        uuid id PK
        varchar name
        varchar(2) country_code FK
    }

    wineries {
        uuid id PK
        text name
        text description
        text logo_url
        text banner_url
        text winemaker
        text website
        text location_text
        varchar(2) country_code FK
        uuid region_id FK
        numeric latitude
        numeric longitude
        integer founded_year
        boolean is_partner
        text phone
        text email
    }

    countries ||--o{ regions : "has"
    countries ||--o{ wineries : "has"
    regions ||--o{ wineries : "has"
