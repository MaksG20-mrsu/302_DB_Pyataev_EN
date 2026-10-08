#!/bin/bash
chcp 65001

sqlite3 movies_rating.db < db_init.sql

echo "1. Составить список фильмов, имеющих хотя бы одну оценку. Список фильмов отсортировать по году выпуска и по названиям. В списке оставить первые 10 фильмов."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.id, m.title, m.year FROM movies m WHERE EXISTS (SELECT 1 FROM ratings r WHERE r.movie_id = m.id) ORDER BY m.year, m.title LIMIT 10;"
echo " "

echo "2. Вывести список всех пользователей, фамилии (не имена!) которых начинаются на букву 'A'. Полученный список отсортировать по дате регистрации. В списке оставить первых 5 пользователей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT id, name, register_date FROM users WHERE name LIKE '% A%' ORDER BY register_date LIMIT 5;"
echo " "

echo "3. Написать запрос, возвращающий информацию о рейтингах в более читаемом формате: имя и фамилия эксперта, название фильма, год выпуска, оценка и дата оценки в формате ГГГГ-ММ-ДД. Отсортировать данные по имени эксперта, затем названию фильма и оценке. В списке оставить первые 50 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT u.name AS expert, m.title, m.year, r.rating, date(r.timestamp, 'unixepoch') AS rating_date FROM ratings r JOIN users u ON u.id = r.user_id JOIN movies m ON m.id = r.movie_id ORDER BY u.name, m.title, r.rating LIMIT 50;"
echo " "

echo "4. Вывести список фильмов с указанием тегов, которые были им присвоены пользователями. Сортировать по году выпуска, затем по названию фильма, затем по тегу. В списке оставить первые 40 записей."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, t.tag FROM tags t JOIN movies m ON m.id = t.movie_id ORDER BY m.year, m.title, t.tag LIMIT 40;"
echo " "

echo "5. Вывести список самых свежих фильмов. В список должны войти все фильмы последнего года выпуска, имеющиеся в базе данных. Запрос должен быть универсальным, не зависящим от исходных данных."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT id, title, year FROM movies WHERE year = (SELECT MAX(year) FROM movies) ORDER BY title;"
echo " "

echo "6. Найти все комедии, выпущенные после 2000 года, которые понравились мужчинам (оценка не ниже 4.5). Для каждого фильма вывести название, год выпуска и количество таких оценок. Результат отсортировать по году выпуска и названию фильма."
echo --------------------------------------------------
sqlite3 movies_rating.db -box -echo "SELECT m.title, m.year, COUNT(*) AS rating_count FROM movies m JOIN ratings r ON r.movie_id = m.id JOIN users u ON u.id = r.user_id WHERE m.genres LIKE '%Comedy%' AND m.year > 2000 AND u.gender = 'male' AND r.rating >= 4.5 GROUP BY m.id, m.title, m.year ORDER BY m.year, m.title;"
echo " "

echo "7. Провести анализ занятий (профессий) пользователей - вывести количество пользователей для каждого рода занятий. Найти самую распространённую и самую редкую профессию посетителей сайта."
echo --------------------------------------------------
echo "Количество пользователей по профессиям:"
sqlite3 movies_rating.db -box -echo "SELECT occupation, COUNT(*) AS user_count FROM users GROUP BY occupation ORDER BY user_count DESC;"
echo " "
echo "Самая распространённая профессия:"
sqlite3 movies_rating.db -box -echo "SELECT occupation, COUNT(*) AS user_count FROM users GROUP BY occupation ORDER BY user_count DESC LIMIT 1;"
echo " "
echo "Самая редкая профессия:"
sqlite3 movies_rating.db -box -echo "SELECT occupation, COUNT(*) AS user_count FROM users GROUP BY occupation ORDER BY user_count ASC LIMIT 1;"
echo " "
