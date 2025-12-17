create table public.countries (
  code character varying(2) not null,
  name text not null,
  constraint countries_pkey primary key (code)
) TABLESPACE pg_default;