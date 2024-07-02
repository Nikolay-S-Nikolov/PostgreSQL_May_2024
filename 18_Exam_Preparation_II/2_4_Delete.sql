DELETE FROM clients
WHERE
    id  IN (SELECT
    c.id
FROM
    clients AS c
LEFT JOIN
    courses AS cr
ON
    c.id = cr.client_id
WHERE
    cr.id IS NULL
    and CHAR_LENGTH(c.full_name)>3);
