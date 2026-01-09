CREATE OR REPLACE FUNCTION get_available_vintages()
RETURNS TABLE(vintage integer) AS $$
BEGIN
 RETURN QUERY
  SELECT DISTINCT o.vintage
  FROM public.offers o
  WHERE o.is_active = true AND o.vintage IS NOT NULL
  ORDER BY o.vintage DESC;
END;
$$ LANGUAGE plpgsql;