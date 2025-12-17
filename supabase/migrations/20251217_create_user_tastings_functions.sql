-- RPC-функция для получения дегустационных заметок пользователя
CREATE OR REPLACE FUNCTION get_user_tastings()
RETURNS TABLE(
    id UUID,
    user_id UUID,
    wine_id UUID,
    tasting_date TIMESTAMPTZ,
    rating NUMERIC,
    notes TEXT,
    photo_url TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    wine JSONB -- Включаем полную информацию о вине
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        ut.id,
        ut.user_id,
        ut.wine_id,
        ut.tasting_date,
        ut.rating,
        ut.notes,
        ut.photo_url,
        ut.created_at,
        ut.updated_at,
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
    FROM user_tastings ut
    INNER JOIN wines w ON ut.wine_id = w.id
    LEFT JOIN wineries wn ON w.winery_id = wn.id
    LEFT JOIN countries c ON wn.country_code = c.code
    WHERE ut.user_id = auth.uid()
    ORDER BY ut.tasting_date DESC;
END;
$$;

-- RPC-функция для добавления дегустационной заметки
CREATE OR REPLACE FUNCTION add_user_tasting(
    p_wine_id UUID,
    p_rating NUMERIC,
    p_notes TEXT DEFAULT NULL,
    p_photo_url TEXT DEFAULT NULL,
    p_tasting_date TIMESTAMPTZ DEFAULT now()
)
RETURNS TABLE(
    id UUID,
    user_id UUID,
    wine_id UUID,
    tasting_date TIMESTAMPTZ,
    rating NUMERIC,
    notes TEXT,
    photo_url TEXT,
    created_at TIMESTAMPTZ,
    updated_at TIMESTAMPTZ,
    wine JSONB
)
LANGUAGE plpgsql
AS $$
DECLARE
    new_tasting_id UUID := gen_random_uuid();
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    INSERT INTO user_tastings (id, user_id, wine_id, tasting_date, rating, notes, photo_url)
    VALUES (new_tasting_id, auth.uid(), p_wine_id, p_tasting_date, p_rating, p_notes, p_photo_url);

    RETURN QUERY
    SELECT
        ut.id,
        ut.user_id,
        ut.wine_id,
        ut.tasting_date,
        ut.rating,
        ut.notes,
        ut.photo_url,
        ut.created_at,
        ut.updated_at,
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
    FROM user_tastings ut
    INNER JOIN wines w ON ut.wine_id = w.id
    LEFT JOIN wineries wn ON w.winery_id = wn.id
    LEFT JOIN countries c ON wn.country_code = c.code
    WHERE ut.id = new_tasting_id;
END;
$$;

-- RPC-функция для удаления дегустационной заметки
CREATE OR REPLACE FUNCTION delete_user_tasting(p_tasting_id UUID)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN
    IF auth.uid() IS NULL THEN
        RAISE EXCEPTION 'User not authenticated';
    END IF;

    DELETE FROM user_tastings
    WHERE id = p_tasting_id AND user_tastings.user_id = auth.uid();

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Tasting note not found or does not belong to user';
    END IF;
END;
$$;
