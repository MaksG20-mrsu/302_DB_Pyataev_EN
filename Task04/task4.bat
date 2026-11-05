#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Найти все пары пользователей, оценивших один и тот же фильм. Устранить дубликаты, проверить отсутствие пар с самим собой. Для каждой пары должны быть указаны имена пользователей и название фильма, который они ценили. В списке оставить первые 100 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT u1.name AS user1, u2.name AS user2, m.title FROM ratings r1 JOIN ratings r2 ON r1.movie_id = r2.movie_id AND r1.user_id < r2.user_id JOIN users u1 ON u1.id = r1.user_id JOIN users u2 ON u2.id = r2.user_id JOIN movies m ON m.id = r1.movie_id ORDER BY u1.name, u2.name, m.title LIMIT 100;"
echo " "

echo "2. Найти 10 самых свежих оценок от разных пользователей, вывести названия фильмов, имена пользователей, оценку, дату отзыва в формате ГГГГ-ММ-ДД."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, u.name, r.rating, date(r.timestamp, 'unixepoch') AS rating_date FROM ratings r JOIN users u ON u.id = r.user_id JOIN movies m ON m.id = r.movie_id WHERE r.timestamp IN (SELECT MAX(timestamp) FROM ratings GROUP BY user_id) ORDER BY r.timestamp DESC LIMIT 10;"
echo " "

echo "3. Вывести в одном списке все фильмы с максимальным средним рейтингом и все фильмы с минимальным средним рейтингом. Общий список отсортировать по году выпуска и названию фильма. В зависимости от рейтинга в колонке 'Рекомендуем' для фильмов должно быть написано 'Да' или 'Нет'."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH avg_ratings AS (SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON r.movie_id = m.id GROUP BY m.id), min_max AS (SELECT MAX(avg_rating) AS max_avg, MIN(avg_rating) AS min_avg FROM avg_ratings) SELECT ar.title, ar.year, ar.avg_rating, CASE WHEN ar.avg_rating = mm.max_avg THEN 'Да' ELSE 'Нет' END AS 'Рекомендуем' FROM avg_ratings ar, min_max mm WHERE ar.avg_rating = mm.max_avg OR ar.avg_rating = mm.min_avg ORDER BY ar.year, ar.title;"
echo " "

echo "4. Вычислить количество оценок и среднюю оценку, которую дали фильмам пользователи-женщины в период с 2010 по 2012 год."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT COUNT(*) AS total_ratings, AVG(r.rating) AS avg_rating FROM ratings r JOIN users u ON u.id = r.user_id WHERE u.gender = 'female' AND r.timestamp >= strftime('%s', '2010-01-01') AND r.timestamp < strftime('%s', '2013-01-01');"
echo " "

echo "5. Составить список фильмов с указанием их средней оценки и места в рейтинге по средней оценке. Полученный список отсортировать по году выпуска и названиям фильмов. В списке оставить первые 20 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH avg_ratings AS (SELECT m.id, m.title, m.year, AVG(r.rating) AS avg_rating FROM movies m JOIN ratings r ON r.movie_id = m.id GROUP BY m.id) SELECT title, year, avg_rating, RANK() OVER (ORDER BY avg_rating DESC) AS rank FROM avg_ratings ORDER BY year, title LIMIT 20;"
echo " "

echo "6. Вывести список из 10 последних зарегистрированных пользователей в формате 'Фамилия Имя|Дата регистрации' (сначала фамилия, потом имя)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT SUBSTR(name, INSTR(name, ' ') + 1) || ' ' || SUBSTR(name, 1, INSTR(name, ' ') - 1) || '|' || register_date AS 'Фамилия Имя|Дата регистрации' FROM users ORDER BY register_date DESC LIMIT 10;"
echo " "

echo "7. С помощью рекурсивного CTE составить таблицу умножения для чисел от 1 до 10."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE nums AS (SELECT 1 AS n UNION ALL SELECT n + 1 FROM nums WHERE n < 10) SELECT a.n || 'x' || b.n || '=' || (a.n * b.n) AS multiplication FROM nums a CROSS JOIN nums b ORDER BY a.n, b.n;"
echo " "

echo "8. С помощью рекурсивного CTE выделить все жанры фильмов, имеющиеся в таблице movies (каждый жанр в отдельной строке)."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "WITH RECURSIVE split_genres AS (SELECT id, genres, '' AS genre, genres || '|' AS rest FROM movies UNION ALL SELECT id, genres, SUBSTR(rest, 1, INSTR(rest, '|') - 1), SUBSTR(rest, INSTR(rest, '|') + 1) FROM split_genres WHERE rest <> '') SELECT DISTINCT genre FROM split_genres WHERE genre <> '' ORDER BY genre;"
echo " "
