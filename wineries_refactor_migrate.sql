-- 1. Создание таблицы `regions`
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

-- 2. Изменение таблицы `wineries`
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