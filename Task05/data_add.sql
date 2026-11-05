-- Добавление 5 новых пользователей (без жёстких ID)
-- Дата регистрации — системная
INSERT INTO users (name, email, gender, register_date, occupation_id)
VALUES
    ('Пятаев Егор Николаевич', 'pyataev.en@example.com', 'male', date('now'), (SELECT id FROM occupations WHERE name = 'student' LIMIT 1)),
    ('Иванов Иван Иванович', 'ivanov.ii@example.com', 'male', date('now'), (SELECT id FROM occupations WHERE name = 'student' LIMIT 1)),
    ('Петров Петр Петрович', 'petrov.pp@example.com', 'male', date('now'), (SELECT id FROM occupations WHERE name = 'student' LIMIT 1)),
    ('Сидорова Анна Сергеевна', 'sidorova.as@example.com', 'female', date('now'), (SELECT id FROM occupations WHERE name = 'student' LIMIT 1)),
    ('Кузнецова Мария Алексеевна', 'kuznetsova.ma@example.com', 'female', date('now'), (SELECT id FROM occupations WHERE name = 'student' LIMIT 1));

-- Добавление 3 новых фильмов разных жанров
-- (movieId не указываем — берём максимальный + 1 через подзапрос)
INSERT INTO movies (id, title, year)
SELECT COALESCE(MAX(id), 0) + 1, 'Мой первый фильм', 2025 FROM movies;

INSERT INTO movie_genres (movie_id, genre_id)
SELECT (SELECT MAX(id) FROM movies), (SELECT id FROM genres WHERE name = 'Comedy');

INSERT INTO movies (id, title, year)
SELECT COALESCE(MAX(id), 0) + 1, 'Второй фильм', 2025 FROM movies;

INSERT INTO movie_genres (movie_id, genre_id)
SELECT (SELECT MAX(id) FROM movies), (SELECT id FROM genres WHERE name = 'Drama');

INSERT INTO movies (id, title, year)
SELECT COALESCE(MAX(id), 0) + 1, 'Третий фильм', 2025 FROM movies;

INSERT INTO movie_genres (movie_id, genre_id)
SELECT (SELECT MAX(id) FROM movies), (SELECT id FROM genres WHERE name = 'Action');

-- Добавление 3 отзывов от меня о добавленных фильмах
INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT (SELECT id FROM users WHERE email = 'pyataev.en@example.com'),
       (SELECT id FROM movies WHERE title = 'Мой первый фильм'),
       5.0, strftime('%s', 'now');

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT (SELECT id FROM users WHERE email = 'pyataev.en@example.com'),
       (SELECT id FROM movies WHERE title = 'Второй фильм'),
       4.5, strftime('%s', 'now');

INSERT INTO ratings (user_id, movie_id, rating, timestamp)
SELECT (SELECT id FROM users WHERE email = 'pyataev.en@example.com'),
       (SELECT id FROM movies WHERE title = 'Третий фильм'),
       4.0, strftime('%s', 'now');
