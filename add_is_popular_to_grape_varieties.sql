ALTER TABLE public.grape_varieties
ADD COLUMN is_popular BOOLEAN DEFAULT false;

-- Сразу отметим несколько сортов как популярные для теста
UPDATE public.grape_varieties
SET is_popular = true
WHERE name IN ('Каберне Совиньон', 'Мерло', 'Шардоне', 'Совиньон Блан', 'Пино Нуар');