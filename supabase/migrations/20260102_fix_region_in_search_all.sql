-- Fix the search_all function to use region_id instead of region and join with regions table

CREATE OR REPLACE FUNCTION search_all(search_query TEXT, search_categories TEXT[] DEFAULT ARRAY['wines_name', 'wines_grape_variety', 'wineries_name'])
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    wines_result JSONB;
    wineries_result JSONB;
    search_wines_name BOOLEAN;
    search_wines_grape_variety BOOLEAN;
    search_wineries_name BOOLEAN;
BEGIN
    -- Check which search categories are enabled
    search_wines_name := 'wines_name' = ANY(search_categories);
    search_wines_grape_variety := 'wines_grape_variety' = ANY(search_categories);
    search_wineries_name := 'wineries_name' = ANY(search_categories);

    -- Search wines by name and grape_variety with all necessary fields
    WITH wine_data AS (
        SELECT
            w.id,
            w.winery_id,
            w.name,
            w.description,
            jsonb_agg(DISTINCT gv.name) FILTER (WHERE gv.name IS NOT NULL) as grape_varieties,
            w.image_url,
            w.color,
            w.type,
            w.sugar,
            w.vintage,
            w.alcohol_level,
            w.average_rating,
            w.reviews_count,
            w.serving_temperature,
            w.sweetness,
            w.acidity,
            w.tannins,
            w.saturation,
            w.created_at,
            w.updated_at,
            w.is_deleted,
            o.price,
            wn.id as winery_id_field,
            wn.name as winery_name,
            wn.description as winery_description,
            wn.logo_url as winery_logo_url,
            wn.banner_url as winery_banner_url,
            wn.winemaker as winery_winemaker,
            wn.website as winery_website,
            wn.location_text as winery_location_text,
            wn.country_code as winery_country_code,
            COALESCE(c.name, wn.country_code::TEXT) as country_name,
            r.name as winery_region
        FROM wines w
        LEFT JOIN wineries wn ON w.winery_id = wn.id
        LEFT JOIN regions r ON wn.region_id = r.id
        LEFT JOIN countries c ON wn.country_code = c.code AND c.code IS NOT NULL
        LEFT JOIN offers o ON w.id = o.wine_id
        LEFT JOIN wine_grape_varieties wgv ON w.id = wgv.wine_id
        LEFT JOIN grape_varieties gv ON wgv.grape_variety_id = gv.id
        WHERE (
            (search_wines_name AND w.name ILIKE '%' || search_query || '%')
            OR
            (search_wines_grape_variety AND gv.name ILIKE '%' || search_query || '%')
        )
        AND w.is_deleted = false
        GROUP BY w.id, w.winery_id, w.name, w.description, w.image_url, w.color, w.type, w.sugar, w.vintage, w.alcohol_level, w.average_rating, w.reviews_count, w.serving_temperature, w.sweetness, w.acidity, w.tannins, w.saturation, w.created_at, w.updated_at, w.is_deleted, o.price, wn.id, wn.name, wn.description, wn.logo_url, wn.banner_url, wn.winemaker, wn.website, wn.location_text, wn.country_code, c.name, r.name
    ),
    aggregated_wine_data AS (
        SELECT
            id,
            winery_id,
            name,
            description,
            grape_varieties,
            image_url,
            color,
            type,
            sugar,
            vintage,
            alcohol_level,
            average_rating,
            reviews_count,
            serving_temperature,
            sweetness,
            acidity,
            tannins,
            saturation,
            created_at,
            updated_at,
            is_deleted,
            MIN(price) as min_price,
            MAX(price) as max_price,
            winery_id_field,
            winery_name,
            winery_description,
            winery_logo_url,
            winery_banner_url,
            winery_winemaker,
            winery_website,
            winery_location_text,
            winery_country_code,
            country_name,
            winery_region
        FROM wine_data
        GROUP BY id, winery_id, name, description, grape_varieties, image_url, color, type, sugar, vintage, alcohol_level, average_rating, reviews_count, serving_temperature, sweetness, acidity, tannins, saturation, created_at, updated_at, is_deleted, winery_id_field, winery_name, winery_description, winery_logo_url, winery_banner_url, winery_winemaker, winery_website, winery_location_text, winery_country_code, country_name, winery_region
    )
    SELECT jsonb_agg(
        DISTINCT jsonb_build_object(
            'id', awd.id,
            'winery_id', awd.winery_id,
            'name', awd.name,
            'description', awd.description,
            'grape_variety', awd.grape_varieties,
            'image_url', awd.image_url,
            'color', awd.color,
            'type', awd.type,
            'sugar', awd.sugar,
            'vintage', awd.vintage,
            'alcohol_level', awd.alcohol_level,
            'average_rating', awd.average_rating,
            'reviews_count', awd.reviews_count,
            'serving_temperature', awd.serving_temperature,
            'sweetness', awd.sweetness,
            'acidity', awd.acidity,
            'tannins', awd.tannins,
            'saturation', awd.saturation,
            'created_at', awd.created_at,
            'updated_at', awd.updated_at,
            'is_deleted', awd.is_deleted,
            'min_price', awd.min_price,
            'max_price', awd.max_price,
            'wineries', jsonb_build_object(
                'id', awd.winery_id_field,
                'name', awd.winery_name,
                'description', awd.winery_description,
                'logo_url', awd.winery_logo_url,
                'banner_url', awd.winery_banner_url,
                'winemaker', awd.winery_winemaker,
                'website', awd.winery_website,
                'location_text', awd.winery_location_text,
                'country_code', awd.winery_country_code,
                'country', awd.country_name,
                'region', awd.winery_region
            )
        )
    )
    FROM aggregated_wine_data awd
    INTO wines_result;

    -- Search wineries by name with region join
    SELECT jsonb_agg(
        DISTINCT jsonb_build_object(
            'id', wn.id,
            'name', wn.name,
            'description', wn.description,
            'logo_url', wn.logo_url,
            'banner_url', wn.banner_url,
            'winemaker', wn.winemaker,
            'website', wn.website,
            'location_text', wn.location_text,
            'country_code', wn.country_code,
            'country', COALESCE(c.name, wn.country_code::TEXT),
            'region', r.name
        )
    ) INTO wineries_result
    FROM wineries wn
    LEFT JOIN regions r ON wn.region_id = r.id
    LEFT JOIN countries c ON wn.country_code = c.code AND c.code IS NOT NULL
    WHERE search_wineries_name AND wn.name ILIKE '%' || search_query || '%';

    -- If no results, return empty arrays
    IF wines_result IS NULL THEN
        wines_result := '[]'::jsonb;
    END IF;
    IF wineries_result IS NULL THEN
        wineries_result := '[]'::jsonb;
    END IF;

    -- Return JSONB object
    RETURN jsonb_build_object('wines', wines_result, 'wineries', wineries_result);
END;
$$;