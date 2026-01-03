-- Create function to get regions that have active wineries by country codes
CREATE OR REPLACE FUNCTION get_regions_by_countries(country_codes TEXT[])
RETURNS SETOF regions
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT r.*
  FROM regions r
  INNER JOIN wineries w ON r.id = w.region_id
  WHERE w.is_deleted = false 
    AND r.country_code = ANY(country_codes);
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_regions_by_countries(TEXT[]) TO anon;
GRANT EXECUTE ON FUNCTION get_regions_by_countries(TEXT[]) TO authenticated;