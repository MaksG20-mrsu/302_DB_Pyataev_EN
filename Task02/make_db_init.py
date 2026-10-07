#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Утилита для генерации SQL-скрипта db_init.sql.
Создаёт таблицы movies, ratings, tags, users и заполняет их данными
из файлов каталога dataset.
"""

import csv
import os

SQL_FILE = 'db_init.sql'
DATASET = 'dataset'

def esc(s):
    """Экранирование одинарных кавычек для SQL."""
    return str(s).replace("'", "''")

def write_schema(f):
    """Пишет DROP TABLE и CREATE TABLE для всех таблиц."""
    f.write("-- Схема БД movies_rating\n\n")

    f.write("DROP TABLE IF EXISTS movies;\n")
    f.write("DROP TABLE IF EXISTS ratings;\n")
    f.write("DROP TABLE IF EXISTS tags;\n")
    f.write("DROP TABLE IF EXISTS users;\n\n")

    f.write("""CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);\n\n""")

    f.write("""CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL
);\n\n""")

    f.write("""CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT NOT NULL,
    timestamp INTEGER NOT NULL
);\n\n""")

    f.write("""CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);\n\n""")

def write_movies(f):
    """INSERT INTO movies из dataset/movies.csv"""
    f.write("-- Данные movies\n")
    with open(os.path.join(DATASET, 'movies.csv'), encoding='utf-8') as csvf:
        reader = csv.DictReader(csvf)
        for row in reader:
            title = row['title'].strip()
            year = 'NULL'
            # Формат: "Toy Story (1995)" -> title="Toy Story", year=1995
            if title.endswith(')') and '(' in title:
                idx = title.rfind('(')
                y = title[idx+1:-1]
                if y.isdigit():
                    year = y
                    title = title[:idx].strip()
            f.write(
                f"INSERT INTO movies (id, title, year, genres) VALUES "
                f"({row['movieId']}, '{esc(title)}', {year}, '{esc(row['genres'])}');\n"
            )
    f.write("\n")

def write_ratings(f):
    """INSERT INTO ratings из dataset/ratings.csv"""
    f.write("-- Данные ratings\n")
    with open(os.path.join(DATASET, 'ratings.csv'), encoding='utf-8') as csvf:
        reader = csv.DictReader(csvf)
        for row in reader:
            f.write(
                f"INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES "
                f"({row['userId']}, {row['movieId']}, {row['rating']}, {row['timestamp']});\n"
            )
    f.write("\n")

def write_tags(f):
    """INSERT INTO tags из dataset/tags.csv"""
    f.write("-- Данные tags\n")
    with open(os.path.join(DATASET, 'tags.csv'), encoding='utf-8') as csvf:
        reader = csv.DictReader(csvf)
        for row in reader:
            f.write(
                f"INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES "
                f"({row['userId']}, {row['movieId']}, '{esc(row['tag'])}', {row['timestamp']});\n"
            )
    f.write("\n")

def write_users(f):
    """INSERT INTO users из dataset/users.txt (разделитель '|')"""
    f.write("-- Данные users\n")
    with open(os.path.join(DATASET, 'users.txt'), encoding='utf-8') as txtf:
        for line in txtf:
            line = line.strip()
            if not line:
                continue
            parts = line.split('|')
            if len(parts) < 6:
                continue
            uid, name, email, gender, reg_date, occupation = parts[:6]
            f.write(
                f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES "
                f"({uid}, '{esc(name)}', '{esc(email)}', '{esc(gender)}', '{esc(reg_date)}', '{esc(occupation)}');\n"
            )
    f.write("\n")

def main():
    with open(SQL_FILE, 'w', encoding='utf-8') as f:
        write_schema(f)
        f.write("BEGIN TRANSACTION;\n")   
        write_movies(f)
        write_ratings(f)
        write_tags(f)
        write_users(f)
        f.write("COMMIT;\n")              
    print(f"Готово: {SQL_FILE} создан.")

if __name__ == '__main__':
    main()
