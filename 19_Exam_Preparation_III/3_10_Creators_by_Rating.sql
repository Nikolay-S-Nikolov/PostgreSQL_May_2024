SELECT c.last_name,
       CEIL(AVG(bg.rating)) AS average_rating,
       p.name               AS publisher_name
FROM creators AS c
         JOIN creators_board_games
              ON c.id = creators_board_games.creator_id
         JOIN
     board_games AS bg
     ON creators_board_games.board_game_id = bg.id
         JOIN publishers AS p
              ON bg.publisher_id = p.id
WHERE p.name = 'Stonemaier Games'
GROUP BY c.last_name,
         p.name
ORDER BY average_rating DESC