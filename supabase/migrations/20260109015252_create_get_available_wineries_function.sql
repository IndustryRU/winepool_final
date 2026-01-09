CREATE OR REPLACE FUNCTION get_available_wineries()
RETURNS TABLE(id uuid, name text) AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT w.id, w.name
  FROM public.wineries w
  JOIN public.wines wi ON w.id = wi.winery_id
  JOIN public.offers o ON wi.id = o.wine_id
  WHERE o.is_active = true AND wi.winery_id IS NOT NULL
  GROUP BY w.id
  ORDER BY w.name;
END;
$$ LANGUAGE plpgsql;