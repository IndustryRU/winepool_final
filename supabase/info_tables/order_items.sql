create table public.order_items (
  id uuid not null default gen_random_uuid (),
  order_id uuid not null,
  offer_id uuid null,
  quantity integer not null,
  price_at_purchase numeric not null,
  price numeric not null,
  constraint order_items_pkey primary key (id),
  constraint order_items_offer_id_fkey foreign KEY (offer_id) references offers (id),
  constraint order_items_order_id_fkey foreign KEY (order_id) references orders (id)
) TABLESPACE pg_default;