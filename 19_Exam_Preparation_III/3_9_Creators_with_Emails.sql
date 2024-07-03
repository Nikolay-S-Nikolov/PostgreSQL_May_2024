SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    c.email,
    MAX(bg.rating) AS rating
FROM
    creators AS c
JOIN creators_board_games
        ON c.id = creators_board_games.creator_id
JOIN
        board_games AS bg
ON creators_board_games.board_game_id = bg.id

WHERE c.email LIKE '%.com'
GROUP BY full_name,
    c.email
ORDER BY full_name
