SELECT CONCAT(a.first_name, ' ', a.last_name) AS full_name,
       CONCAT(
               LOWER(LEFT(a.first_name, 1)),
               LOWER(RIGHT(a.last_name, 2)),
               CHAR_LENGTH(a.last_name),
               '@sm-cast.com'
       )                                      AS email,
       awards
FROM actors AS a
         LEFT JOIN productions_actors as pa
                   on a.id = pa.actor_id
WHERE pa.actor_id IS NULL
ORDER BY awards DESC, id;