-- Добавляем поля в таблицу wines для хранения среднего рейтинга и количества отзывов
ALTER TABLE wines 
ADD COLUMN IF NOT EXISTS average_rating DOUBLE PRECISION DEFAULT 0.0,
ADD COLUMN IF NOT EXISTS reviews_count INTEGER DEFAULT 0;

-- Функция для обновления среднего рейтинга и количества отзывов
CREATE OR REPLACE FUNCTION update_wine_stats()
RETURNS TRIGGER AS $$
BEGIN
 IF (TG_OP = 'INSERT') THEN
    -- Обновляем статистику для нового отзыва
    UPDATE wines
    SET 
      average_rating = (
        SELECT COALESCE(AVG(rating), 0.0) 
        FROM reviews 
        WHERE wine_id = NEW.wine_id
      ),
      reviews_count = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE wine_id = NEW.wine_id
      )
    WHERE id = NEW.wine_id;
    RETURN NEW;
  ELSIF (TG_OP = 'UPDATE') THEN
    -- Обновляем статистику при изменении отзыва
    UPDATE wines
    SET 
      average_rating = (
        SELECT COALESCE(AVG(rating), 0.0) 
        FROM reviews 
        WHERE wine_id = OLD.wine_id
      ),
      reviews_count = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE wine_id = OLD.wine_id
      )
    WHERE id = OLD.wine_id;
    RETURN NEW;
  ELSIF (TG_OP = 'DELETE') THEN
    -- Обновляем статистику при удалении отзыва
    UPDATE wines
    SET 
      average_rating = (
        SELECT COALESCE(AVG(rating), 0.0) 
        FROM reviews 
        WHERE wine_id = OLD.wine_id
      ),
      reviews_count = (
        SELECT COUNT(*) 
        FROM reviews 
        WHERE wine_id = OLD.wine_id
      )
    WHERE id = OLD.wine_id;
    RETURN OLD;
  END IF;
  RETURN NULL;
END;
$$ LANGUAGE plpgsql;

-- Создаем триггер для автоматического обновления статистики при изменении отзывов
DROP TRIGGER IF EXISTS trigger_update_wine_stats ON reviews;
CREATE TRIGGER trigger_update_wine_stats
  AFTER INSERT OR UPDATE OR DELETE ON reviews
  FOR EACH ROW EXECUTE FUNCTION update_wine_stats();