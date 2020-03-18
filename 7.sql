SELECT title, ratings.rating
FROM (SELECT * FROM movies WHERE movies.year = 2010)
JOIN ratings
ON ratings.movie_id = id AND ratings.rating NOT NULL
ORDER BY ratings.rating, title
