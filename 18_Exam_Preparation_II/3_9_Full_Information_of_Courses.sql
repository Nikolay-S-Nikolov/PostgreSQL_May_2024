SELECT
    a.name AS address,
    CASE
    WHEN EXTRACT(HOUR from c.start) BETWEEN 6 AND 20 THEN 'Day'
    ELSE 'Night'
    END AS day_time,
    C.bill,
    cl.full_name,
    cr.make,
    cr.model,
    cat.name
FROM
    courses AS c
JOIN
        addresses a
ON
    c.from_address_id = a.id
JOIN
    clients AS cl
ON
    cl.id = c.client_id
JOIN
    cars AS cr
ON
    cr.id = c.car_id
JOIN categories AS cat
ON cr.category_id = cat.id
;
