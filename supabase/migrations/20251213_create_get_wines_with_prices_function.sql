-- Создание функции get_wines_with_prices для фильтрации вин по цене и другим параметрам
CREATE OR REPLACE FUNCTION get_wines_with_prices(filters jsonb)
RETURNS TABLE(result jsonb)
LANGUAGE plpgsql
AS $$
DECLARE
    query_text TEXT;
BEGIN
    -- Строим динамический SQL запрос на основе фильтров
    query_text := '
        SELECT jsonb_build_object(
            ''id'', w.id,
            ''name'', w.name,
            ''color'', w.color,
            ''type'', w.type,
            ''sugar'', w.sugar,
            ''vintage'', w.vintage,
            ''region'', w.region,
            ''grape_variety'', w.grape_variety,
            ''alcohol_level'', w.alcohol_level,
            ''volume'', MIN(o.bottle_size),
            ''description'', w.description,
            ''image_url'', w.image_url,
            ''average_rating'', w.average_rating,
            ''winery_id'', w.winery_id,
            ''created_at'', w.created_at,
            ''updated_at'', w.updated_at,
            ''is_deleted'', w.is_deleted,
            ''min_price'', MIN(o.price),
            ''max_price'', MAX(o.price),
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
            ''wineries'', jsonb_build_object(
                ''id'', wn.id,
                ''name'', wn.name,
                ''country_code'', wn.country_code,
                ''country'', jsonb_build_object(
                    ''code'', c.code,
                    ''name'', c.name
                )
            )
        ) AS result
        FROM wines w
        INNER JOIN offers o ON w.id = o.wine_id
        LEFT JOIN wineries wn ON w.winery_id = wn.id
        LEFT JOIN countries c ON wn.country_code = c.code
        WHERE TRUE';

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

    -- Добавляем GROUP BY после всех условий
    query_text := query_text || '
        GROUP BY w.id, wn.id, c.code';

    -- Выполняем динамический запрос
    RETURN QUERY EXECUTE query_text USING filters;
END;
$$;