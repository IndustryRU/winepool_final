create or replace function get_user_analytics()
returns json
language sql
security definer
as $$
  select
    json_build_object(
      'top_varieties', (
        select
          json_agg(t)
        from (
          select
            w.grape_variety,
            count(*)::int
          from user_tastings ut
          join wines w on ut.wine_id = w.id
          where ut.user_id = auth.uid()
          group by w.grape_variety
          order by count(*) desc
          limit 5
        ) t
      ),
      'top_countries', (
        select
          json_agg(t)
        from (
          select
            c.name as country_name,
            count(*)::int
          from user_tastings ut
          join wines w on ut.wine_id = w.id
          join wineries wn on w.winery_id = wn.id
          join countries c on wn.country_code = c.code
          where ut.user_id = auth.uid()
          group by c.name
          order by count(*) desc
          limit 3
        ) t
      ),
      'average_rating', (
        select
          avg(rating)
        from user_tastings
        where user_id = auth.uid()
      ),
      'taste_web', (
        select
          json_build_object(
            'sweetness', avg(w.sweetness),
            'acidity', avg(w.acidity),
            'tannins', avg(w.tannins),
            'saturation', avg(w.saturation)
          )
        from user_tastings ut
        join wines w on ut.wine_id = w.id
        where ut.user_id = auth.uid()
      )
    );
$$;