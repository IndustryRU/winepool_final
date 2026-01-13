ALTER TABLE public.countries
ADD COLUMN is_popular BOOLEAN DEFAULT false;

-- Сразу отметим несколько стран как популярные для теста
UPDATE public.countries
SET is_popular = true
WHERE code IN ('RU', 'FR', 'IT', 'ES', 'GE');