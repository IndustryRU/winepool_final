create table public.wineries (
  id uuid not null default gen_random_uuid (),
  name text not null,
  description text null,
  logo_url text null,
  region text null,
  created_at timestamp with time zone not null default now(),
  updated_at timestamp with time zone not null default now(),
  banner_url text null,
  winemaker text null,
  website text null,
  location_text text null,
  country_code character varying(2) null,
  constraint wineries_pkey primary key (id),
  constraint fk_wineries_country_code foreign KEY (country_code) references countries (code)
) TABLESPACE pg_default;