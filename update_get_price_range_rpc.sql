CREATE OR REPLACE FUNCTION public.get_price_range(filters jsonb)
RETURNS TABLE(min_price numeric, max_price numeric)
LANGUAGE plpgsql
AS $function$
DECLARE
    query_text TEXT;
BEGIN
    query_text := '
        SELECT 
            COALESCE(MIN(o.price)::DECIMAL, 0) AS min_price,
            COALESCE(MAX(o.price)::DECIMAL, 10000) AS max_price
        FROM wines w
        INNER JOIN offers o ON w.id = o.wine_id
        LEFT JOIN wineries wn ON w.winery_id = wn.id
        WHERE w.is_deleted = FALSE AND o.price IS NOT NULL';

    IF filters ? 'color' AND jsonb_array_length(filters->'color') > 0 THEN
        query_text := query_text || ' AND w.color::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''color'')))';
    END IF;

    IF filters ? 'type' AND jsonb_array_length(filters->'type') > 0 THEN
        query_text := query_text || ' AND w.type::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''type'')))';
    END IF;

    IF filters ? 'sugar' AND jsonb_array_length(filters->'sugar') > 0 THEN
        query_text := query_text || ' AND w.sugar::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''sugar'')))';
    END IF;

    IF filters ? 'vintages' AND jsonb_array_length(filters->'vintages') > 0 THEN
        query_text := query_text || ' AND o.vintage = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''vintages'))::int[])';
    END IF;

    IF filters ? 'min_rating' THEN
        query_text := query_text || ' AND w.average_rating >= ($1->>''min_rating')::double precision';
    END IF;

    IF filters ? 'winery_ids' AND jsonb_array_length(filters->'winery_ids') > 0 THEN
        query_text := query_text || ' AND w.winery_id = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''winery_ids''))::uuid[])';
    END IF;

    IF filters ? 'country' AND jsonb_array_length(filters->'country') > 0 THEN
        query_text := query_text || ' AND wn.country_code = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''country'')))';
    END IF;
    
    IF filters ? 'region' AND jsonb_array_length(filters->'region') > 0 THEN
        query_text := query_text || ' AND wn.region_id = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''region''))::uuid[])';
    END IF;

    IF filters ? 'grape_ids' AND jsonb_array_length(filters->'grape_ids') > 0 THEN
         query_text := query_text || ' AND w.id IN (SELECT wine_id FROM wine_grape_varieties WHERE grape_variety_id = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''grape_ids''))::uuid[]))';
    END IF;

    IF filters ? 'bottle_size_ids' AND jsonb_array_length(filters->'bottle_size_ids') > 0 THEN
        query_text := query_text || ' AND o.bottle_size_id = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''bottle_size_ids''))::uuid[])';
    END IF;

    RETURN QUERY EXECUTE query_text USING filters;
END;
$function$;