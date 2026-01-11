CREATE OR REPLACE FUNCTION get_available_bottle_sizes()
RETURNS TABLE(id uuid, size_ml integer, size_l text) AS $$
BEGIN
 RETURN QUERY 
  SELECT DISTINCT b.id, b.size_ml, b.size_l
  FROM bottle_sizes b
  JOIN offers o ON b.id = o.bottle_size_id
  WHERE o.is_active = true;
END;
$$ LANGUAGE plpgsql;