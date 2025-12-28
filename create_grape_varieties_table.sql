-- Создание таблицы grape_varieties
CREATE TABLE public.grape_varieties (
    id UUID NOT NULL DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    description TEXT NULL,
    origin_region TEXT NULL,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    CONSTRAINT grape_varieties_pkey PRIMARY KEY (id),
    CONSTRAINT grape_varieties_name_key UNIQUE (name)
);

COMMENT ON TABLE public.grape_varieties IS 'Справочник сортов винограда';
COMMENT ON COLUMN public.grape_varieties.name IS 'Название сорта винограда';
COMMENT ON COLUMN public.grape_varieties.description IS 'Описание сорта винограда';
COMMENT ON COLUMN public.grape_varieties.origin_region IS 'Регион происхождения сорта';
COMMENT ON COLUMN public.grape_varieties.created_at IS 'Дата и время создания записи';
COMMENT ON COLUMN public.grape_varieties.updated_at IS 'Дата и время последнего обновления записи';