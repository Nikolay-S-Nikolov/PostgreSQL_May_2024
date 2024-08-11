INSERT INTO actors (first_name,
                    last_name,
                    birthdate,
                    height,
                    awards,
                    country_id)
SELECT REVERSE(first_name),
       REVERSE(last_name),
       (birthdate - INTERVAL '2 DAYS')::DATE,
       COALESCE(height + 10, 10),
       country_id                                        AS awards,
       (SELECT id FROM countries WHERE name = 'Armenia') as country_id
FROM actors
WHERE id BETWEEN 10 AND 20
ORDER BY id;