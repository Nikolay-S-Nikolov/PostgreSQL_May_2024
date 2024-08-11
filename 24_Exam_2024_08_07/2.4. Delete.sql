DELETE
FROM countries
WHERE id in (SELECT c.id
             FROM countries AS c
                      LEFT JOIN productions AS p
                                on c.id = p.country_id
             WHERE p.id IS NULL
             ORDER BY c.id)
  AND id in (SELECT c.id
             FROM countries AS c
                      LEFT JOIN actors AS a
                                on c.id = a.country_id
             WHERE a.id IS NULL);