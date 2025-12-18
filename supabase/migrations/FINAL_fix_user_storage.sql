-- Удаляем старую функцию, если она существует (сигнатура без p_user_id)
DROP FUNCTION IF EXISTS public.add_to_user_storage(uuid, integer, real, date, integer, integer);

-- Создаем или заменяем функцию для добавления вина в хранилище пользователя
CREATE OR REPLACE FUNCTION public.add_to_user_storage(
    p_user_id UUID,
    p_wine_id uuid,
    p_quantity integer,
    p_purchase_price real,
    p_purchase_date date,
    p_ideal_drink_from integer,
    p_ideal_drink_to integer
)
RETURNS void
LANGUAGE plpgsql
SECURITY DEFINER
AS $$
BEGIN
    INSERT INTO public.user_storage (
        user_id, 
        wine_id, 
        quantity, 
        purchase_price, 
        purchase_date, 
        ideal_drink_from, 
        ideal_drink_to
    )
    VALUES (
        p_user_id, 
        p_wine_id, 
        p_quantity, 
        p_purchase_price, 
        p_purchase_date, 
        p_ideal_drink_from, 
        p_ideal_drink_to
    );
END;
$$;