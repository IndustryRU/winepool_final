-- Создание таблицы user_tastings для хранения личных дегустационных заметок пользователя

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

-- Включение политики Row Level Security
ALTER TABLE public.user_tastings ENABLE ROW LEVEL SECURITY;

-- Создание политик RLS
CREATE POLICY "Allow individual read access" ON public.user_tastings
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Allow individual insert access" ON public.user_tastings
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow individual update access" ON public.user_tastings
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Allow individual delete access" ON public.user_tastings
FOR DELETE USING (auth.uid() = user_id);

-- Комментарий к таблице
COMMENT ON TABLE public.user_tastings IS 'Личные дегустационные заметки пользователя о винах.';