create table public.wines (
  id uuid not null default gen_random_uuid (),
  winery_id uuid null,
  name text not null,
  description text null,
  image_url text null,
  country text null,
  region text null,
  grape_variety text null,
  pairing text null,
  aroma text null,
  color public.wine_color null,
  type public.wine_type null,
  sugar public.wine_sugar null,
  sweetness smallint null,
  acidity smallint null,
  tannins smallint null,
  saturation smallint null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  vintage integer null,
  serving_temperature text null,
  alcohol_level numeric null,
  rating numeric null default 0,
  is_deleted boolean null default false,
  average_rating numeric null default 0.0,
  reviews_count integer null default 0,
  constraint wines_pkey primary key (id),
  constraint wines_winery_id_fkey foreign KEY (winery_id) references wineries (id),
  constraint wines_acidity_check check (
    (
      (acidity >= 1)
      and (acidity <= 5)
    )
  ),
  constraint wines_saturation_check check (
    (
      (saturation >= 1)
      and (saturation <= 5)
    )
  ),
  constraint wines_sweetness_check check (
    (
      (sweetness >= 1)
      and (sweetness <= 5)
    )
  ),
  constraint wines_tannins_check check (
    (
      (tannins >= 1)
      and (tannins <= 5)
    )
  )
) TABLESPACE pg_default;

create index IF not exists idx_wines_name_search on public.wines using gin (to_tsvector('english'::regconfig, name)) TABLESPACE pg_default;