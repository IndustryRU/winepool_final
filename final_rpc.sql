CREATE OR REPLACE FUNCTION get_wines_with_filters_and_sorting(
    p_winery_ids UUID[],
    p_country_codes TEXT[],
    p_sugar_values TEXT[],
    p_color_values TEXT[],
    p_type_values TEXT[],
    p_grape_variety_ids UUID[],
    p_region_ids UUID[],
    p_min_price NUMERIC,
    p_max_price NUMERIC,
    p_vintages INT[],
    p_bottle_size_ids UUID[],
    p_min_rating NUMERIC,
    p_sort_option TEXT,
    p_include_deleted BOOLEAN
)
RETURNS TABLE(id UUID) AS $$
BEGIN
    RETURN QUERY
    SELECT w.id
    FROM wines w
    LEFT JOIN wineries ON w.winery_id = wineries.id
    LEFT JOIN (
        SELECT 
            wine_id, 
            MIN(price) as min_price, 
            MAX(price) as max_price
        FROM offers
        GROUP BY wine_id
    ) as offer_agg ON w.id = offer_agg.wine_id
    WHERE
        (p_include_deleted OR w.is_deleted = FALSE) AND
        (p_winery_ids IS NULL OR w.winery_id = ANY(p_winery_ids)) AND
        (p_country_codes IS NULL OR wineries.country_code = ANY(p_country_codes)) AND
        (p_sugar_values IS NULL OR w.sugar = ANY(p_sugar_values::wine_sugar[])) AND
        (p_color_values IS NULL OR w.color = ANY(p_color_values::wine_color[])) AND
        (p_type_values IS NULL OR w.type = ANY(p_type_values::wine_type[])) AND
        (p_min_rating IS NULL OR w.average_rating >= p_min_rating) AND
        (p_grape_variety_ids IS NULL OR EXISTS (
            SELECT 1 FROM wine_grape_varieties wgv WHERE wgv.wine_id = w.id AND wgv.grape_variety_id = ANY(p_grape_variety_ids)
        )) AND
        (p_region_ids IS NULL OR wineries.region_id = ANY(p_region_ids)) AND
        ((p_min_price IS NULL AND p_max_price IS NULL AND p_vintages IS NULL AND p_bottle_size_ids IS NULL) OR EXISTS (
            SELECT 1
            FROM offers o
            WHERE o.wine_id = w.id
              AND (p_min_price IS NULL OR o.price >= p_min_price)
              AND (p_max_price IS NULL OR o.price <= p_max_price)
              AND (p_vintages IS NULL OR o.vintage = ANY(p_vintages))
              AND (p_bottle_size_ids IS NULL OR o.bottle_size_id = ANY(p_bottle_size_ids))
        ))
    ORDER BY
        CASE
            WHEN p_sort_option = 'price_asc' THEN offer_agg.min_price
        END ASC NULLS LAST,
        CASE
            WHEN p_sort_option = 'price_desc' THEN offer_agg.max_price
        END DESC NULLS LAST,
        CASE
            WHEN p_sort_option = 'popular' THEN w.average_rating
        END DESC NULLS LAST,
        CASE
            WHEN p_sort_option = 'rating_desc' THEN w.average_rating
        END DESC NULLS LAST,
        w.created_at DESC;
END;
$$ LANGUAGE plpgsql;