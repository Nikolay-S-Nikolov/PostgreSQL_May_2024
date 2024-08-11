SELECT p.id AS id,
       p.title AS title,
       pi.duration AS duration,
       ROUND(pi.budget, 1)::NUMERIC(10,1) AS budget,
       TO_CHAR(pi.release_date, 'MM-YY') AS release_date
FROM productions AS p
         JOIN productions_info AS pi
              ON p.production_info_id = pi.id
WHERE DATE_PART('Year', pi.release_date) IN ('2023', '2024')
  AND pi.budget > 1500000.00
ORDER BY budget, duration DESC , p.id
LIMIT 3;
