WITH final_table AS
    (WITH likes_table
              AS
              (SELECT p.id,
                      COUNT(l.photo_id) AS likes_count
               FROM photos AS p
                        LEFT JOIN likes AS l
                                  on p.id = l.photo_id
               GROUP BY p.id
               ORDER BY likes_count)

     SELECT p.id              AS photo_id,
            lt.likes_count    AS likes_count,
            COUNT(c.photo_id) AS comments_count
     FROM photos AS p
              LEFT JOIN likes_table AS lt
                        ON p.id = lt.id
              LEFT JOIN comments AS c
                        on p.id = c.photo_id
     GROUP BY p.id, lt.likes_count)
SELECT photo_id,
       likes_count,
       comments_count
FROM final_table
ORDER BY likes_count DESC, comments_count DESC, photo_id;

