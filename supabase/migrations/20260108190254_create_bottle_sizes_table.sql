create table public.bottle_sizes (
  id uuid not null default gen_random_uuid (),
  size_ml integer not null,
  size_l text not null,
  constraint bottle_sizes_pkey primary key (id),
  constraint bottle_sizes_size_ml_check check ((size_ml > 0)),
  constraint bottle_sizes_size_ml_unique unique (size_ml),
  constraint bottle_sizes_size_l_unique unique (size_l)
) TABLESPACE pg_default;

insert into public.bottle_sizes (size_ml, size_l) values
(187, '0.187 л'),
(375, '0.375 л'),
(500, '0.5 л'),
(750, '0.75 л'),
(100, '1.0 л'),
(1500, '1.5 л'),
(3000, '3.0 л'),
(6000, '6.0 л');