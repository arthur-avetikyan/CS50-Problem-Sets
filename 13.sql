SELECT name FROM people
WHERE id IN (SELECT person_id FROM stars
            JOIN movies ON stars.movie_id = movies.id
            WHERE id IN (SELECT movie_id FROM stars
                        JOIN people ON stars.person_id = people.id
                        WHERE name = 'Kevin Bacon' AND birth = 1958))
AND NOT name = 'Kevin Bacon'