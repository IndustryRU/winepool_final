create table public.cart_items (
  id uuid not null default gen_random_uuid (),
  user_id uuid not null,
  product_id uuid not null,
  quantity integer not null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  constraint cart_items_pkey primary key (id),
  constraint cart_items_product_id_fkey foreign KEY (product_id) references offers (id),
  constraint cart_items_user_id_fkey foreign KEY (user_id) references profiles (id),
  constraint cart_items_quantity_check check ((quantity > 0))
) TABLESPACE pg_default;