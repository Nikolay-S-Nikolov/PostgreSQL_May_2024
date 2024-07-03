SELECT id,
       CONCAT(first_name, ' ', last_name) AS creator_name,
       email

FROM creators
         LEFT JOIN creators_board_games
                   ON creators.id = creators_board_games.creator_id
WHERE creators_board_games.board_game_id is NULL
ORDER BY creator_name