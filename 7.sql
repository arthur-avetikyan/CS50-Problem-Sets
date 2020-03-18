SELECT title, ratings.rating
FROM movies
JOIN ratings ON ratings.movie_id = id AND ratings.rating NOT NULL
WHERE movies.year = 2010
ORDER BY ratings.rating DESC, title
