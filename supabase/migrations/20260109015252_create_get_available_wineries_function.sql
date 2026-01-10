CREATE OR REPLACE FUNCTION get_available_wineries()
RETURNS TABLE(id uuid, name text, logo_url text) AS $$ -- Добавили logo_url в возвращаемый тип
BEGIN
  RETURN QUERY
  SELECT DISTINCT w.id, w.name, w.logo_url -- Добавили logo_url в SELECT
  FROM public.wineries w
  JOIN public.wines wi ON w.id = wi.winery_id
  JOIN public.offers o ON wi.id = o.wine_id
  WHERE o.is_active = true
  ORDER BY w.name;
END;
$$ LANGUAGE plpgsql;