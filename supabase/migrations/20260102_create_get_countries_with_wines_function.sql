-- Create a function to get countries that have active wineries
CREATE OR REPLACE FUNCTION get_countries_with_wines()
RETURNS SETOF countries
LANGUAGE sql
STABLE
AS $$
  SELECT DISTINCT c.*
  FROM countries c
  JOIN wineries w ON c.code = w.country_code
  WHERE w.is_deleted = false;
$$;

-- Grant execute permission to service role
GRANT EXECUTE ON FUNCTION get_countries_with_wines() TO service_role;