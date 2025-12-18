ALTER TABLE public.user_storage
ADD CONSTRAINT user_storage_user_id_wine_id_key UNIQUE (user_id, wine_id);