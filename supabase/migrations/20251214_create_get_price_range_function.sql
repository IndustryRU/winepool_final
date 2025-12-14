-- Create RPC function to get min/max price range based on filters
CREATE OR REPLACE FUNCTION get_price_range(filters jsonb DEFAULT '{}')
RETURNS TABLE(min_price DECIMAL, max_price DECIMAL) 
LANGUAGE plpgsql
AS $$
DECLARE
    query_text TEXT;
BEGIN
    -- Build dynamic SQL query based on filters
    query_text := '
        SELECT 
            MIN(o.price)::DECIMAL AS min_price,
            MAX(o.price)::DECIMAL AS max_price
        FROM wines w
        INNER JOIN offers o ON w.id = o.wine_id
        LEFT JOIN wineries wn ON w.winery_id = wn.id
        LEFT JOIN countries c ON wn.country_code = c.code
        WHERE w.is_deleted = FALSE 
          AND o.price IS NOT NULL';

    -- Add filter conditions if specified
    IF filters ? 'color' THEN
        IF jsonb_typeof(filters->'color') = 'array' THEN
            query_text := query_text || ' AND w.color::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''color'')))';
        ELSE
            query_text := query_text || ' AND w.color::text = ($1->>''color'')';
        END IF;
    END IF;

    IF filters ? 'type' THEN
        IF jsonb_typeof(filters->'type') = 'array' THEN
            query_text := query_text || ' AND w.type::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''type'')))';
        ELSE
            query_text := query_text || ' AND w.type::text = ($1->>''type'')';
        END IF;
    END IF;

    IF filters ? 'sugar' THEN
        IF jsonb_typeof(filters->'sugar') = 'array' THEN
            query_text := query_text || ' AND w.sugar::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''sugar'')))';
        ELSE
            query_text := query_text || ' AND w.sugar::text = ($1->>''sugar'')';
        END IF;
    END IF;

    IF filters ? 'vintage' THEN
        query_text := query_text || ' AND w.vintage = ($1->>''vintage'')::integer';
    END IF;

    IF filters ? 'min_year' THEN
        query_text := query_text || ' AND w.vintage >= ($1->>''min_year'')::integer';
    END IF;

    IF filters ? 'max_year' THEN
        query_text := query_text || ' AND w.vintage <= ($1->>''max_year'')::integer';
    END IF;

    IF filters ? 'min_rating' THEN
        query_text := query_text || ' AND w.average_rating >= ($1->>''min_rating'')::double precision';
    END IF;

    IF filters ? 'max_rating' THEN
        query_text := query_text || ' AND w.average_rating <= ($1->>''max_rating'')::double precision';
    END IF;

    IF filters ? 'winery_id' THEN
        query_text := query_text || ' AND w.winery_id = ($1->>''winery_id'')::uuid';
    END IF;

    IF filters ? 'country' THEN
        IF jsonb_typeof(filters->'country') = 'array' THEN
            query_text := query_text || ' AND wn.country_code = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''country'')))';
        ELSE
            query_text := query_text || ' AND wn.country_code = ($1->>''country'')';
        END IF;
    END IF;

    IF filters ? 'region' THEN
        IF jsonb_typeof(filters->'region') = 'array' THEN
            query_text := query_text || ' AND w.region = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''region'')))';
        ELSE
            query_text := query_text || ' AND w.region = ($1->>''region'')';
        END IF;
    END IF;

    IF filters ? 'grape' THEN
        IF jsonb_typeof(filters->'grape') = 'array' THEN
            query_text := query_text || ' AND w.grape_variety = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''grape'')))';
        ELSE
            query_text := query_text || ' AND w.grape_variety = ($1->>''grape')';
        END IF;
    END IF;

    IF filters ? 'volume' THEN
        IF jsonb_typeof(filters->'volume') = 'array' THEN
            query_text := query_text || ' AND o.bottle_size = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''volume'')))';
        ELSE
            query_text := query_text || ' AND o.bottle_size = ($1->>''volume'')';
        END IF;
    END IF;

    -- Execute dynamic query
    RETURN QUERY EXECUTE query_text USING filters;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_price_range(jsonb) TO anon;
GRANT EXECUTE ON FUNCTION get_price_range(jsonb) TO authenticated;