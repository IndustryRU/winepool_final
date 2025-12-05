-- Добавление столбца country_code в таблицу wineries
ALTER TABLE wineries ADD COLUMN country_code VARCHAR(2);

-- Установка внешнего ключа на таблицу countries
ALTER TABLE wineries ADD CONSTRAINT fk_wineries_country_code 
    FOREIGN KEY (country_code) REFERENCES countries(code);