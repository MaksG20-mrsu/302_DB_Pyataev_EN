# Task02 — ETL для movies_rating.db

## Требования к окружению

Для корректной работы db_init.bat на компьютере должны быть установлены:

- Python 3 (команда python3 или python должна быть доступна в PATH)
- SQLite 3 (команда sqlite3 должна быть доступна в PATH)

## Запуск

    bash db_init.bat

или (если файл исполняемый):

    ./db_init.bat

## Что делает скрипт

1. make_db_init.py читает исходные данные из dataset/ и генерирует SQL-скрипт db_init.sql
   с командами DROP TABLE IF EXISTS, CREATE TABLE и INSERT INTO.
2. sqlite3 movies_rating.db < db_init.sql создаёт (или пересоздаёт) базу movies_rating.db
   и загружает в неё данные.

## Структура файлов

- make_db_init.py — генератор SQL-скрипта
- db_init.bat — shell-скрипт запуска (шебанг #!/bin/bash)
- db_init.sql — сгенерированный SQL-скрипт
- movies_rating.db — итоговая база данных SQLite
- dataset/ — исходные текстовые файлы

## Таблицы

- movies: id, title, year, genres
- ratings: id, user_id, movie_id, rating, timestamp
- tags: id, user_id, movie_id, tag, timestamp
- users: id, name, email, gender, register_date, occupation
