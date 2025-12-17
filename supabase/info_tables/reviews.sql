create table public.reviews (
  id uuid not null default gen_random_uuid (),
  wine_id uuid not null,
  user_id uuid not null,
  rating numeric not null,
  text text null,
  created_at timestamp with time zone null default now(),
  constraint reviews_pkey primary key (id),
  constraint fk_reviews_user_id foreign KEY (user_id) references profiles (id),
  constraint fk_reviews_wine_id foreign KEY (wine_id) references wines (id),
  constraint reviews_rating_check check (
    (
      (rating >= (0)::numeric)
      and (rating <= (5)::numeric)
    )
  )
) TABLESPACE pg_default;

create index IF not exists idx_reviews_wine_id on public.reviews using btree (wine_id) TABLESPACE pg_default;

create trigger trigger_update_wine_stats
after INSERT
or DELETE
or
update on reviews for EACH row
execute FUNCTION update_wine_stats ();