-- Исправляем функцию get_wines_with_prices, заменяя фильтрацию по w.region на фильтрацию по wn.region_id
CREATE OR REPLACE FUNCTION get_wines_with_prices(filters jsonb)
RETURNS TABLE(result jsonb)
LANGUAGE plpgsql
AS $$
DECLARE
    query_text TEXT;
    show_unavailable BOOLEAN;
BEGIN
    -- Проверяем значение show_unavailable из фильтров, по умолчанию false
    show_unavailable := COALESCE((filters->>'show_unavailable')::boolean, false);

    -- Строим динамический SQL запрос на основе фильтров
    IF show_unavailable THEN
        -- Показываем все вина, включая те, у которых нет активных предложений
        query_text := '
            WITH wine_data AS (
                SELECT
                    w.id,
                    w.winery_id,
                    w.name,
                    w.description,
                    w.grape_variety,
                    w.image_url,
                    w.color,
                    w.type,
                    w.sugar,
                    w.vintage,
                    w.alcohol_level,
                    w.average_rating,
                    w.created_at,
                    w.updated_at,
                    w.is_deleted,
                    o.price,
                    wn.id as winery_id_field,
                    wn.name as winery_name,
                    wn.country_code as winery_country_code,
                    wn.region_id as winery_region_id,
                    c.code as country_code,
                    c.name as country_name,
                    r.name as region_name
                FROM wines w
                LEFT JOIN offers o ON w.id = o.wine_id
                LEFT JOIN wineries wn ON w.winery_id = wn.id
                LEFT JOIN countries c ON wn.country_code = c.code AND c.code IS NOT NULL
                LEFT JOIN regions r ON wn.region_id = r.id AND r.id IS NOT NULL
                WHERE TRUE';
    ELSE
        -- Показываем только вина с активными предложениями
        query_text := '
            WITH wine_data AS (
                SELECT
                    w.id,
                    w.winery_id,
                    w.name,
                    w.description,
                    w.grape_variety,
                    w.image_url,
                    w.color,
                    w.type,
                    w.sugar,
                    w.vintage,
                    w.alcohol_level,
                    w.average_rating,
                    w.created_at,
                    w.updated_at,
                    w.is_deleted,
                    o.price,
                    wn.id as winery_id_field,
                    wn.name as winery_name,
                    wn.country_code as winery_country_code,
                    wn.region_id as winery_region_id,
                    c.code as country_code,
                    c.name as country_name,
                    r.name as region_name
                FROM wines w
                INNER JOIN offers o ON w.id = o.wine_id
                LEFT JOIN wineries wn ON w.winery_id = wn.id
                LEFT JOIN countries c ON wn.country_code = c.code AND c.code IS NOT NULL
                LEFT JOIN regions r ON wn.region_id = r.id AND r.id IS NOT NULL
                WHERE TRUE';
    END IF;

    -- Добавляем условия фильтрации по цене, если они указаны
    IF filters ? 'min_price' THEN
        query_text := query_text || ' AND o.price >= ($1->>''min_price'')::numeric';
    END IF;

    IF filters ? 'max_price' THEN
        query_text := query_text || ' AND o.price <= ($1->>''max_price'')::numeric';
    END IF;

    -- Добавляем другие возможные фильтры
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
            query_text := query_text || ' AND w.sugar::text = ($1->>''sugar')';
        END IF;
    END IF;

    IF filters ? 'vintage' THEN
        query_text := query_text || ' AND w.vintage = ($1->>''vintage'')::integer';
    END IF;

    IF filters ? 'min_year' THEN
        query_text := query_text || ' AND w.vintage >= ($1->>''min_year')::integer';
    END IF;

    IF filters ? 'max_year' THEN
        query_text := query_text || ' AND w.vintage <= ($1->>''max_year')::integer';
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

    -- ИСПРАВЛЕНИЕ: Заменяем фильтрацию по w.region на фильтрацию по wn.region_id
    IF filters ? 'region' THEN
        IF jsonb_typeof(filters->'region') = 'array' THEN
            query_text := query_text || ' AND wn.region_id = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''region'')))';
        ELSE
            query_text := query_text || ' AND wn.region_id = ($1->>''region'')';
        END IF;
    END IF;

    IF filters ? 'grape' THEN
        IF jsonb_typeof(filters->'grape') = 'array' THEN
            query_text := query_text || ' AND w.grape_variety = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''grape'')))';
        ELSE
            query_text := query_text || ' AND w.grape_variety = ($1->>''grape'')';
        END IF;
    END IF;

    IF filters ? 'volume' THEN
        IF jsonb_typeof(filters->'volume') = 'array' THEN
            query_text := query_text || ' AND o.bottle_size = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''volume'')))';
        ELSE
            query_text := query_text || ' AND o.bottle_size = ($1->>''volume'')';
        END IF;
    END IF;

    -- Завершаем часть с фильтрацией и переходим к агрегации
    query_text := query_text || '
        ),
        aggregated_wine_data AS (
            SELECT
                id,
                winery_id,
                name,
                description,
                grape_variety,
                image_url,
                color,
                type,
                sugar,
                vintage,
                alcohol_level,
                average_rating,
                created_at,
                updated_at,
                is_deleted,
                MIN(price) as min_price,
                MAX(price) as max_price,
                winery_id_field,
                winery_name,
                winery_country_code,
                winery_region_id,
                country_code,
                country_name,
                region_name
            FROM wine_data
            GROUP BY id, winery_id, name, description, grape_variety, image_url, color, type, sugar, vintage, alcohol_level, average_rating, created_at, updated_at, is_deleted, winery_id_field, winery_name, winery_country_code, winery_region_id, country_code, country_name, region_name
        )
        SELECT jsonb_build_object(
            ''id'', awd.id,
            ''name'', awd.name,
            ''color'', awd.color,
            ''type'', awd.type,
            ''sugar'', awd.sugar,
            ''vintage'', awd.vintage,
            ''region'', awd.region_name,
            ''grape_variety'', awd.grape_variety,
            ''alcohol_level'', awd.alcohol_level,
            ''volume'', MIN(o.bottle_size),
            ''description'', awd.description,
            ''image_url'', awd.image_url,
            ''average_rating'', awd.average_rating,
            ''winery_id'', awd.winery_id,
            ''created_at'', awd.created_at,
            ''updated_at'', awd.updated_at,
            ''is_deleted'', awd.is_deleted,
            ''min_price'', awd.min_price,
            ''max_price'', awd.max_price,
            ''offers'', jsonb_agg(jsonb_build_object(
                ''id'', o.id,
                ''seller_id'', o.seller_id,
                ''wine_id'', o.wine_id,
                ''price'', o.price,
                ''vintage'', o.vintage,
                ''bottle_size'', o.bottle_size,
                ''created_at'', o.created_at,
                ''is_active'', o.is_active
            )) FILTER (WHERE o.id IS NOT NULL),
            ''winery'', jsonb_build_object(
                ''id'', awd.winery_id_field,
                ''name'', awd.winery_name,
                ''country_code'', awd.winery_country_code,
                ''region_id'', awd.winery_region_id,
                ''country'', awd.country_name
            )
        ) AS result
        FROM aggregated_wine_data awd
        LEFT JOIN offers o ON awd.id = o.wine_id';

    -- Добавляем условия для фильтрации по цене и другим параметрам в основной части запроса
    IF filters ? 'min_price' THEN
        query_text := query_text || ' AND o.price >= ($1->>''min_price'')::numeric';
    END IF;

    IF filters ? 'max_price' THEN
        query_text := query_text || ' AND o.price <= ($1->>''max_price'')::numeric';
    END IF;

    -- Добавляем другие возможные фильтры в основной части запроса
    IF filters ? 'color' THEN
        IF jsonb_typeof(filters->'color') = 'array' THEN
            query_text := query_text || ' AND awd.color::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''color')))';
        ELSE
            query_text := query_text || ' AND awd.color::text = ($1->>''color'')';
        END IF;
    END IF;

    IF filters ? 'type' THEN
        IF jsonb_typeof(filters->'type') = 'array' THEN
            query_text := query_text || ' AND awd.type::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''type'')))';
        ELSE
            query_text := query_text || ' AND awd.type::text = ($1->>''type'')';
        END IF;
    END IF;

    IF filters ? 'sugar' THEN
        IF jsonb_typeof(filters->'sugar') = 'array' THEN
            query_text := query_text || ' AND awd.sugar::text = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''sugar'')))';
        ELSE
            query_text := query_text || ' AND awd.sugar::text = ($1->>''sugar')';
        END IF;
    END IF;

    IF filters ? 'vintage' THEN
        query_text := query_text || ' AND awd.vintage = ($1->>''vintage'')::integer';
    END IF;

    IF filters ? 'min_year' THEN
        query_text := query_text || ' AND awd.vintage >= ($1->>''min_year'')::integer';
    END IF;

    IF filters ? 'max_year' THEN
        query_text := query_text || ' AND awd.vintage <= ($1->>''max_year'')::integer';
    END IF;

    IF filters ? 'min_rating' THEN
        query_text := query_text || ' AND awd.average_rating >= ($1->>''min_rating'')::double precision';
    END IF;

    IF filters ? 'max_rating' THEN
        query_text := query_text || ' AND awd.average_rating <= ($1->>''max_rating'')::double precision';
    END IF;

    IF filters ? 'winery_id' THEN
        query_text := query_text || ' AND awd.winery_id = ($1->>''winery_id'')::uuid';
    END IF;

    IF filters ? 'country' THEN
        IF jsonb_typeof(filters->'country') = 'array' THEN
            query_text := query_text || ' AND awd.winery_country_code = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''country'')))';
        ELSE
            query_text := query_text || ' AND awd.winery_country_code = ($1->>''country'')';
        END IF;
    END IF;

    -- ИСПРАВЛЕНИЕ: Заменяем фильтрацию по awd.region на фильтрацию по awd.winery_region_id
    IF filters ? 'region' THEN
        IF jsonb_typeof(filters->'region') = 'array' THEN
            query_text := query_text || ' AND awd.winery_region_id = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''region'')))';
        ELSE
            query_text := query_text || ' AND awd.winery_region_id = ($1->>''region'')';
        END IF;
    END IF;

    IF filters ? 'grape' THEN
        IF jsonb_typeof(filters->'grape') = 'array' THEN
            query_text := query_text || ' AND awd.grape_variety = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''grape'')))';
        ELSE
            query_text := query_text || ' AND awd.grape_variety = ($1->>''grape'')';
        END IF;
    END IF;

    IF filters ? 'volume' THEN
        IF jsonb_typeof(filters->'volume') = 'array' THEN
            query_text := query_text || ' AND o.bottle_size = ANY(ARRAY(SELECT jsonb_array_elements_text($1->''volume'')))';
        ELSE
            query_text := query_text || ' AND o.bottle_size = ($1->>''volume'')';
        END IF;
    END IF;

    -- Добавляем GROUP BY и фильтрацию по is_deleted в конце
    query_text := query_text || '
        WHERE awd.is_deleted = false
        GROUP BY awd.id, awd.winery_id, awd.name, awd.description, awd.grape_variety, awd.image_url, awd.color, awd.type, awd.sugar, awd.vintage, awd.alcohol_level, awd.average_rating, awd.created_at, awd.updated_at, awd.is_deleted, awd.min_price, awd.max_price, awd.winery_id_field, awd.winery_name, awd.winery_country_code, awd.winery_region_id, awd.country_code, awd.country_name, awd.region_name';

    -- Выполняем динамический запрос
    RETURN QUERY EXECUTE query_text USING filters;
END;
$$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION get_wines_with_prices(jsonb) TO anon;
GRANT EXECUTE ON FUNCTION get_wines_with_prices(jsonb) TO authenticated;