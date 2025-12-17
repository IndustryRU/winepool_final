-- Создание таблицы user_storage для хранения личной коллекции вин пользователя

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

-- Включение политики Row Level Security
ALTER TABLE public.user_storage ENABLE ROW LEVEL SECURITY;

-- Создание политик RLS
CREATE POLICY "Allow individual read access" ON public.user_storage
FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Allow individual insert access" ON public.user_storage
FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Allow individual update access" ON public.user_storage
FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Allow individual delete access" ON public.user_storage
FOR DELETE USING (auth.uid() = user_id);

-- Комментарий к таблице
COMMENT ON TABLE public.user_storage IS 'Личная коллекция вин пользователя.';