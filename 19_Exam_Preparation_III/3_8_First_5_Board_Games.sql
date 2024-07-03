SELECT g.name,
       g.rating,
       c.name AS category_name
FROM board_games AS g
         JOIN players_ranges AS pr
              ON g.players_range_id = pr.id
         JOIN categories AS c
              ON g.category_id = c.id
WHERE
    (g.rating > 7.00 AND g.name ILIKE '%a%')
   OR (g.rating > 7.50 AND min_players >= 2 AND max_players <= 5)
ORDER BY g.name,
         g.rating DESC
LIMIT 5;