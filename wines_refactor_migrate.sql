-- Миграция для рефакторинга таблицы wines

-- 1. Удаление старых столбцов из таблицы wines
ALTER TABLE public.wines
DROP COLUMN IF EXISTS country,
DROP COLUMN IF EXISTS region,
DROP COLUMN IF EXISTS grape_variety,
DROP COLUMN IF EXISTS rating;

-- 2. Добавление новых столбцов
ALTER TABLE public.wines
ADD COLUMN IF NOT EXISTS barcode TEXT,
ADD COLUMN IF NOT EXISTS awards TEXT[];

-- 3. Создание таблицы для связи многие-ко-многим между винами и сортами винограда
CREATE TABLE IF NOT EXISTS public.wine_grape_varieties (
    wine_id UUID NOT NULL,
    grape_variety_id UUID NOT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    
    CONSTRAINT wine_grape_variety_pkey PRIMARY KEY (wine_id, grape_variety_id),
    
    CONSTRAINT wine_grape_variety_wine_id_fkey FOREIGN KEY (wine_id)
        REFERENCES public.wines(id) ON DELETE CASCADE,
        
    CONSTRAINT wine_grape_variety_grape_variety_id_fkey FOREIGN KEY (grape_variety_id)
        REFERENCES public.grape_varieties(id) ON DELETE CASCADE
);

-- Индексы для ускорения запросов
CREATE INDEX IF NOT EXISTS idx_wine_grape_variety_wine_id ON public.wine_grape_varieties(wine_id);
CREATE INDEX IF NOT EXISTS idx_wine_grape_variety_grape_variety_id ON public.wine_grape_varieties(grape_variety_id);

-- 4. Создание функции для обновления среднего рейтинга и количества отзывов
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

-- 5. Удаление старого триггера, если он существует
DROP TRIGGER IF EXISTS on_review_change ON public.reviews;

-- 6. Создание триггера, который вызывает функцию при изменении отзывов
CREATE TRIGGER on_review_change
AFTER INSERT OR UPDATE OR DELETE ON public.reviews
FOR EACH ROW
EXECUTE FUNCTION public.update_wine_rating();