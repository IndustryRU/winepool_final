# 🍷 Спецификация: Интерактивный Погребок (My Cellar) - MVP

Этот документ описывает архитектуру базы данных и API для реализации MVP функционала "Интерактивный Погребок".

---

## 1. Архитектура Базы Данных (Supabase/PostgreSQL)

Будут созданы две новые таблицы для хранения данных пользователя: `user_tastings` (приватные дегустационные заметки) и `user_storage` (личный склад вина).

### 1.1 Таблица `user_tastings`

Хранит личные записи пользователя о продегустированных винах.

```sql
CREATE TABLE public.user_tastings (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    wine_id UUID NOT NULL,
    tasting_date TIMESTAMPTZ NOT NULL DEFAULT now(),
    rating NUMERIC NOT NULL,
    notes TEXT,
    photo_url TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_tastings_pkey PRIMARY KEY (id),
    CONSTRAINT user_tastings_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles (id) ON DELETE CASCADE,
    CONSTRAINT user_tastings_wine_id_fkey FOREIGN KEY (wine_id) REFERENCES public.wines (id) ON DELETE CASCADE,
    CONSTRAINT user_tastings_rating_check CHECK (rating >= 0 AND rating <= 5)
);

-- RLS Policies
ALTER TABLE public.user_tastings ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow individual read access" ON public.user_tastings
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Allow individual insert access" ON public.user_tastings
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow individual update access" ON public.user_tastings
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Allow individual delete access" ON public.user_tastings
FOR DELETE USING (auth.uid() = user_id);
```

### 1.2 Таблица `user_storage`

Хранит информацию о винах, которые пользователь имеет в своей коллекции.

```sql
CREATE TABLE public.user_storage (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL,
    wine_id UUID NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    purchase_price NUMERIC,
    purchase_date TIMESTAMPTZ,
    ideal_drink_from INTEGER, -- Год
    ideal_drink_to INTEGER,   -- Год
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT user_storage_pkey PRIMARY KEY (id),
    CONSTRAINT user_storage_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.profiles (id) ON DELETE CASCADE,
    CONSTRAINT user_storage_wine_id_fkey FOREIGN KEY (wine_id) REFERENCES public.wines (id) ON DELETE CASCADE,
    CONSTRAINT user_storage_quantity_check CHECK (quantity > 0)
);

-- RLS Policies
ALTER TABLE public.user_storage ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow individual read access" ON public.user_storage
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Allow individual insert access" ON public.user_storage
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow individual update access" ON public.user_storage
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Allow individual delete access" ON public.user_storage
FOR DELETE USING (auth.uid() = user_id);
```

---

## 2. API (RPC-функции)

### 2.1 Функции для `user_tastings`

*   **`get_user_tastings()`**
    *   **Описание:** Возвращает все дегустационные заметки текущего пользователя.
    *   **Параметры:** нет (`user_id` берется из `auth.uid()`).
    *   **Возвращает:** `SETOF user_tastings`.

*   **`add_user_tasting(wine_id, rating, notes, photo_url, tasting_date)`**
    *   **Описание:** Добавляет новую дегустационную заметку.
    *   **Параметры:** `wine_id UUID`, `rating NUMERIC`, `notes TEXT`, `photo_url TEXT`, `tasting_date TIMESTAMPTZ`.
    *   **Возвращает:** `user_tastings` (созданная запись).

*   **`delete_user_tasting(tasting_id)`**
    *   **Описание:** Удаляет заметку.
    *   **Параметры:** `tasting_id UUID`.
    *   **Возвращает:** `void`.

### 2.2 Функции для `user_storage`

*   **`get_user_storage()`**
    *   **Описание:** Возвращает все вина в "погребке" текущего пользователя.
    *   **Параметры:** нет.
    *   **Возвращает:** `SETOF user_storage`.

*   **`add_to_user_storage(wine_id, quantity, ...)`**
    *   **Описание:** Добавляет вино в погребок. Если такое вино уже есть, увеличивает `quantity`.
    *   **Параметры:** `wine_id UUID`, `quantity INTEGER`, `purchase_price NUMERIC`, `purchase_date TIMESTAMPTZ`, ...
    *   **Возвращает:** `user_storage`.

*   **`update_storage_item_quantity(item_id, new_quantity)`**
    *   **Описание:** Обновляет количество бутылок. Если `new_quantity` <= 0, запись удаляется.
    *   **Параметры:** `item_id UUID`, `new_quantity INTEGER`.
    *   **Возвращает:** `void`.

---

## 3. Логика Автоматического Пополнения

*   **Триггер:** Необходимо создать триггер на таблице `orders`.
*   **Событие:** `AFTER UPDATE`
*   **Условие:** `WHEN (new.status = 'completed' AND old.status != 'completed')`
*   **Действие:** Триггерная функция должна пройтись по всем `order_items`, связанным с этим заказом, и для каждого из них вызвать логику, аналогичную `add_to_user_storage`, добавляя `wine_id` и `quantity` в погребок покупателя (`user_id`).
