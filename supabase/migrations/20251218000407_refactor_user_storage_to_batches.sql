-- Удаляем старую функцию, если она существует
drop function if exists public.add_to_user_storage;

-- Удаляем старый уникальный индекс, если он существует.
-- Имя индекса может отличаться, поэтому стоит проверить актуальное имя в вашей схеме.
-- Предположим, что он назывался user_storage_wine_id_user_id_key
-- ALTER TABLE public.user_storage DROP CONSTRAINT IF EXISTS user_storage_wine_id_user_id_key;

-- Создаем новый составной уникальный индекс для партий
create unique index user_storage_batch_idx
on public.user_storage (
  user_id,
  wine_id,
  coalesce(purchase_price, -1::real),
  coalesce(purchase_date, '1900-01'::date)
);

-- Создаем новую функцию для добавления вина в погреб пользователя
create or replace function public.add_to_user_storage(
  p_user_id uuid,
  p_wine_id int,
  p_quantity int,
  p_purchase_price int default null,
  p_purchase_date date default null
)
returns void
language plpgsql
as $$
begin
  insert into public.user_storage (
    user_id,
    wine_id,
    quantity,
    purchase_price,
    purchase_date
  )
  values (
    p_user_id,
    p_wine_id,
    p_quantity,
    p_purchase_price,
    p_purchase_date
  )
  on conflict on constraint user_storage_batch_idx
  do update set
    quantity = user_storage.quantity + p_quantity,
    updated_at = now();
end;
$$;