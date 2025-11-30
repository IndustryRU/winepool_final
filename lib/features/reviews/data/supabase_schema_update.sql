-- Изменение типа столбца user_id на uuid
ALTER TABLE reviews ALTER COLUMN user_id TYPE uuid USING user_id::uuid;

-- Добавление внешнего ключа
ALTER TABLE reviews ADD CONSTRAINT fk_reviews_user_id FOREIGN KEY (user_id) REFERENCES profiles(id);