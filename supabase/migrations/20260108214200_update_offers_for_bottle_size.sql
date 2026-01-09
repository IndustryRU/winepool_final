-- 1. Удаляем старый столбец, чтобы избежать конфликтов.
-- ВНИМАНИЕ: это приведет к потере данных в этом столбце, если они были.
-- В реальном проекте потребовалась бы более сложная миграция с сохранением данных.
ALTER TABLE public.offers DROP COLUMN IF EXISTS bottle_size;

-- 2. Добавляем новый столбец с типом UUID для внешнего ключа.
ALTER TABLE public.offers ADD COLUMN bottle_size_id UUID;

-- 3. Устанавливаем внешний ключ, связывающий offers и bottle_sizes.
ALTER TABLE public.offers ADD CONSTRAINT offers_bottle_size_id_fkey FOREIGN KEY (bottle_size_id) REFERENCES public.bottle_sizes(id);