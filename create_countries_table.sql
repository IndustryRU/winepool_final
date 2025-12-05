-- Создание таблицы countries
CREATE TABLE IF NOT EXISTS countries (
    code VARCHAR(2) PRIMARY KEY,
    name TEXT NOT NULL
);