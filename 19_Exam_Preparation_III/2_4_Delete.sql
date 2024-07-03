DELETE FROM board_games
WHERE publisher_id in
(SELECT
     id
FROM publishers
WHERE
    address_id in
        (SELECT
            id
        FROM
            addresses
        WHERE
            town LIKE 'L%'));

DELETE FROM publishers
WHERE
     address_id in
        (SELECT
            id
        FROM
            addresses
        WHERE
            town LIKE 'L%');

DELETE FROM addresses
        WHERE
            town LIKE 'L%';