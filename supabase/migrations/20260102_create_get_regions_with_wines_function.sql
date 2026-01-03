-- Create function to get regions that have active wineries
CREATE OR REPLACE FUNCTION get_regions_with_wines()
RETURNS SETOF regions
LANGUAGE plpgsql
STABLE
AS $$
BEGIN
  RETURN QUERY
  SELECT DISTINCT r.*
  FROM regions r
  INNER JOIN wineries w ON r.id = w.region_id
  WHERE w.is_deleted = false;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_regions_with_wines() TO anon;
GRANT EXECUTE ON FUNCTION get_regions_with_wines() TO authenticated;