create table public.orders (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null,
  total_price numeric not null,
  status text not null default 'pending'::text,
  created_at timestamp with time zone not null default now(),
  total numeric not null,
  delivery_address text null,
  seller_id uuid not null,
  constraint orders_pkey primary key (id),
  constraint orders_seller_id_fkey foreign KEY (seller_id) references profiles (id),
  constraint orders_user_id_fkey foreign KEY (user_id) references profiles (id)
) TABLESPACE pg_default;