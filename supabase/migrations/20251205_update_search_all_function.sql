-- Update the search_all function to return all necessary fields for WineTile

CREATE OR REPLACE FUNCTION search_all(search_query TEXT)
RETURNS JSONB
LANGUAGE plpgsql
AS $$
DECLARE
    wines_result JSONB;
    wineries_result JSONB;
BEGIN
    -- Search wines by name and grape_variety with all necessary fields
    SELECT jsonb_agg(
        DISTINCT jsonb_build_object(
            'id', w.id,
            'winery_id', w.winery_id,
            'name', w.name,
            'description', w.description,
            'grape_variety', w.grape_variety,
            'image_url', w.image_url,
            'color', w.color,
            'type', w.type,
            'sugar', w.sugar,
            'vintage', w.vintage,
            'alcohol_level', w.alcohol_level,
            'rating', w.rating,
            'average_rating', w.average_rating,
            'reviews_count', w.reviews_count,
            'serving_temperature', w.serving_temperature,
            'sweetness', w.sweetness,
            'acidity', w.acidity,
            'tannins', w.tannins,
            'saturation', w.saturation,
            'created_at', w.created_at,
            'updated_at', w.updated_at,
            'is_deleted', w.is_deleted,
            'wineries', jsonb_build_object(
                'id', wn.id,
                'name', wn.name,
                'description', wn.description,
                'logo_url', wn.logo_url,
                'banner_url', wn.banner_url,
                'winemaker', wn.winemaker,
                'website', wn.website,
                'location_text', wn.location_text,
                'country_code', wn.country_code,
                'region', wn.region
            )
        )
    ) INTO wines_result
    FROM wines w
    LEFT JOIN wineries wn ON w.winery_id = wn.id
    WHERE (w.name ILIKE '%' || search_query || '%'
           OR w.grape_variety ILIKE '%' || search_query || '%')
          AND w.is_deleted = false;

    -- Search wineries by name
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
            'region', wn.region
        )
    ) INTO wineries_result
    FROM wineries wn
    WHERE wn.name ILIKE '%' || search_query || '%';

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