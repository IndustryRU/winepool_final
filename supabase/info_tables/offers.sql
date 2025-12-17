create table public.offers (
  id uuid not null default gen_random_uuid (),
  seller_id uuid not null,
  price numeric not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  wine_id uuid not null,
  bottle_size numeric null,
  vintage integer null,
  is_active boolean null default true,
  constraint products_pkey primary key (id),
  constraint offers_wine_id_fkey foreign KEY (wine_id) references wines (id),
  constraint products_seller_id_fkey foreign KEY (seller_id) references profiles (id),
  constraint products_price_check check ((price > (0)::numeric))
) TABLESPACE pg_default;