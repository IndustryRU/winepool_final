-- Откат: Разрешить дублирование вин в user_storage

-- 1. Удаляем ограничение уникальности для user_id и wine_id
ALTER TABLE public.user_storage
DROP CONSTRAINT IF EXISTS user_storage_user_id_wine_id_key;

-- 2. Заменяем функцию add_to_user_storage на более простую версию,
--    которая только вставляет новую запись без проверок.
CREATE OR REPLACE FUNCTION public.add_to_user_storage(
  p_wine_id INTEGER,
  p_comment TEXT DEFAULT NULL
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
  INSERT INTO public.user_storage (user_id, wine_id, comment)
  VALUES (auth.uid(), p_wine_id, p_comment);
END;
$$;