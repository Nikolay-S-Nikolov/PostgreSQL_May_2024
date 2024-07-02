SELECT
    cl.full_name,
    COUNT(c.car_id) AS count_of_cars,
    SUM(c.bill) AS total_sum
FROM
    clients AS cl
RIGHT JOIN courses AS c
ON cl.id = c.client_id
WHERE cl.full_name LIKE '_a%'
GROUP BY cl.full_name
HAVING COUNT(c.car_id)>1
ORDER BY cl.full_name
;