-- RPC-функция для получения "погребка" пользователя
CREATE OR REPLACE FUNCTION get_user_storage()
RETURNS TABLE(
    id UUID,
    user_id UUID,
    wine_id UUID,
    quantity INTEGER,
    purchase_price NUMERIC,
    purchase_date TIMESTAMPTZ,
    ideal_drink_from INTEGER,
    ideal_drink_to INTEGER,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    wine JSONB -- Включаем полную информацию о вине
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        us.id,
        us.user_id,
        us.wine_id,
        us.quantity,
        us.purchase_price,
        us.purchase_date,
        us.ideal_drink_from,
        us.ideal_drink_to,
        us.created_at,
        us.updated_at,
        jsonb_build_object(
            'id', w.id,
            'name', w.name,
            'description', w.description,
            'image_url', w.image_url,
            'color', w.color,
            'type', w.type,
            'sugar', w.sugar,
            'vintage', w.vintage,
            'alcohol_level', w.alcohol_level,
            'average_rating', w.average_rating,
            'reviews_count', w.reviews_count,
            'grape_variety', w.grape_variety,
            'region', w.region,
            'pairing', w.pairing,
            'aroma', w.aroma,
            'serving_temperature', w.serving_temperature,
            'acidity', w.acidity,
            'tannins', w.tannins,
            'saturation', w.saturation,
            'sweetness', w.sweetness,
            'is_deleted', w.is_deleted,
            'created_at', w.created_at,
            'updated_at', w.updated_at,
            'wineries', jsonb_build_object(
                'id', wn.id,
                'name', wn.name,
                'description', wn.description,
                'logo_url', wn.logo_url,
                'banner_url', wn.banner_url,
                'winemaker', wn.winemaker,
                'website', wn.website,
                'location_text', wn.location_text,
                'region', wn.region,
                'country_code', wn.country_code,
                'country', jsonb_build_object(
                    'code', c.code,
                    'name', c.name
                )
            )
        ) AS wine
    FROM user_storage us
    INNER JOIN wines w ON us.wine_id = w.id
    LEFT JOIN wineries wn ON w.winery_id = wn.id
    LEFT JOIN countries c ON wn.country_code = c.code
    WHERE us.user_id = auth.uid()
    ORDER BY us.created_at DESC;
END;
$$;

-- RPC-функция для добавления/обновления вина в "погребке"
CREATE OR REPLACE FUNCTION add_to_user_storage(
    p_wine_id UUID,
    p_quantity INTEGER,
    p_purchase_price NUMERIC DEFAULT NULL,
    p_purchase_date TIMESTAMPTZ DEFAULT NULL,
    p_ideal_drink_from INTEGER DEFAULT NULL,
    p_ideal_drink_to INTEGER DEFAULT NULL
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    wine_id UUID,
    quantity INTEGER,
    purchase_price NUMERIC,
    purchase_date TIMESTAMPTZ,
    ideal_drink_from INTEGER,
    ideal_drink_to INTEGER,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    wine JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    existing_item_id UUID;
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    SELECT user_storage.id INTO existing_item_id
    FROM user_storage
    WHERE user_storage.user_id = auth.uid() AND user_storage.wine_id = p_wine_id;

    IF existing_item_id IS NOT NULL THEN
        UPDATE user_storage
        SET quantity = user_storage.quantity + p_quantity,
            updated_at = now()
        WHERE user_storage.id = existing_item_id;
    ELSE
        INSERT INTO user_storage (user_id, wine_id, quantity, purchase_price, purchase_date, ideal_drink_from, ideal_drink_to)
        VALUES (auth.uid(), p_wine_id, p_quantity, p_purchase_price, p_purchase_date, p_ideal_drink_from, p_ideal_drink_to);
    END IF;

    RETURN QUERY
    SELECT * FROM get_user_storage();
END;
$$;

-- RPC-функция для обновления количества
CREATE OR REPLACE FUNCTION update_storage_item_quantity(
    p_item_id UUID,
    p_new_quantity INTEGER
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    IF p_new_quantity <= 0 THEN
       DELETE FROM user_storage
       WHERE user_storage.id = p_item_id AND user_storage.user_id = auth.uid();
    ELSE
       UPDATE user_storage
       SET quantity = p_new_quantity,
           updated_at = now()
       WHERE user_storage.id = p_item_id AND user_storage.user_id = auth.uid();
    END IF;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Storage item not found or does not belong to user';
    END IF;
END;
$$;
