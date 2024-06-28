-- 01. Booked for Nights ----------------------------------------------------------------

SELECT CONCAT(a.address, ' ', a.address_2) AS apartment_address,
       b.booked_for                        AS nights
FROM apartments AS a
         JOIN bookings AS b
              USING (booking_id)
ORDER BY a.apartment_id;

-- 02. First 10 Apartments Booked At ----------------------------------------------------------------

SELECT a."name",
       a.country,
       b.booked_at::DATE
FROM apartments AS a
         LEFT JOIN bookings AS b
                   USING (booking_id)
LIMIT 10;

-- 03. First 10 Customers with Bookings ----------------------------------------------------------------

SELECT b.booking_id,
       b.starts_at::DATE,
       b.apartment_id,
       c.first_name || ' ' || c.last_name AS customer_name
FROM bookings AS b
         RIGHT JOIN customers AS c
                    USING (customer_id)
ORDER BY customer_name
LIMIT 10;

-- 04. Booking Information ----------------------------------------------------------------

SELECT b.booking_id,
       a.name                             AS apartment_owner,
       a.apartment_id,
       c.first_name || ' ' || c.last_name AS customer_name
FROM bookings AS b
         FULL JOIN apartments AS a
                   USING (booking_id)
         FULL JOIN customers AS c
                   USING (customer_id)

ORDER BY booking_id, apartment_owner, customer_name;

-- 05. Multiplication of Information ----------------------------------------------------------------

SELECT b.booking_id,
       c.first_name AS customer_name
FROM bookings AS b
         CROSS JOIN customers AS c
ORDER BY customer_name

-- 06. Unassigned Apartments ----------------------------------------------------------------

SELECT b.booking_id,
       b.apartment_id,
       c.companion_full_name
FROM bookings AS b
         JOIN customers AS c
              USING (customer_id)
WHERE apartment_id IS NULL;

-- 07. Bookings Made by Lead ----------------------------------------------------------------

SELECT b.apartment_id,
       b.booked_for,
       c.first_name,
       c.country
FROM bookings AS b
         JOIN customers AS c
              USING (customer_id)
WHERE c.job_type = 'Lead';

-- 08. Hahn`s Bookings ----------------------------------------------------------------

SELECT count(*)
FROM bookings AS b
         JOIN customers AS c
              USING (customer_id)
WHERE c.last_name = 'Hahn';

-- 09. Total Sum of Nights ----------------------------------------------------------------

SELECT a.name,
       SUM(b.booked_for)
FROM apartments AS a
         JOIN
     bookings AS b
     USING
         (apartment_id)
GROUP BY name
ORDER by name;

-- 10. Popular Vacation Destination ----------------------------------------------------------------

SELECT a.country,
       COUNT(b.booking_id) AS booking_count
FROM apartments AS a
         JOIN
     bookings AS b
     USING
         (apartment_id)
WHERE booked_at > '2021-05-18 07:52:09.904+03'
  AND booked_at < '2021-09-17 19:48:02.147+03'
GROUP BY country
ORDER by booking_count DESC;

-- 11. Bulgaria's Peaks Higher than ----------------------------------------------------------------

SELECT mc.country_code,
       m.mountain_range,
       p.peak_name,
       p.elevation
FROM mountains AS m
         JOIN
     peaks AS p
     ON m.id = p.mountain_id
         JOIN
     mountains_countries AS mc
     ON mc.mountain_id = m.id
WHERE p.elevation > 2835
  AND mc.country_code = 'BG'
ORDER BY elevation DESC;

-- 12. Count Mountain Ranges ----------------------------------------------------------------------

SELECT mc.country_code,
       COUNT(DISTINCT (m.mountain_range)) AS mountain_range_count
FROM mountains AS m
         JOIN
     mountains_countries AS mc
     ON
         mc.mountain_id = m.id
WHERE mc.country_code IN ('US', 'RU', 'BG')
GROUP BY mc.country_code
ORDER BY mountain_range_count DESC;

-- 13. Rivers in Africa -- ----------------------------------------------------------------------------

SELECT c.country_name,
       r.river_name
FROM countries AS c
         LEFT JOIN
     countries_rivers AS cr
     USING
         (country_code)
         LEFT JOIN
     rivers AS r
     ON
         r.id = cr.river_id
WHERE c.continent_code = 'AF'
ORDER BY c.country_name
LIMIT 5;

-- 14. Minimum Average Area Across ----------------------------------------------------------------

SELECT MIN(average_area) AS min_average_area
FROM (SELECT AVG(area_in_sq_km) AS average_area
      FROM countries
      GROUP BY continent_code) AS a;

-- 15. Countries Without Any ----------------------------------------------------------------

SELECT COUNT(*)
FROM countries
         LEFT JOIN
     mountains_countries AS mc
     USING
         (country_code)
WHERE mc.mountain_id IS NULL;

-- 16. Monasteries by Country ----------------------------------------------------------------

CREATE TABLE monasteries
(
    id             SERIAL PRIMARY KEY,
    monastery_name VARCHAR(255),
    country_code   CHAR(2)
);
INSERT INTO monasteries(monastery_name, country_code)
VALUES ('Rila Monastery "St. Ivan of Rila"', 'BG'),
       ('Bachkovo Monastery "Virgin Mary"', 'BG'),
       ('Troyan Monastery "Holy Mother''s Assumption"', 'BG'),
       ('Kopan Monastery', 'NP'),
       ('Thrangu Tashi Yangtse Monastery', 'NP'),
       ('Shechen Tennyi Dargyeling Monastery', 'NP'),
       ('Benchen Monastery', 'NP'),
       ('Southern Shaolin Monastery', 'CN'),
       ('Dabei Monastery', 'CN'),
       ('Wa Sau Toi', 'CN'),
       ('Lhunshigyia Monastery', 'CN'),
       ('Rakya Monastery', 'CN'),
       ('Monasteries of Meteora', 'GR'),
       ('The Holy Monastery of Stavronikita', 'GR'),
       ('Taung Kalat Monastery', 'MM'),
       ('Pa-Auk Forest Monastery', 'MM'),
       ('Taktsang Palphug Monastery', 'BT'),
       ('Sümela Monastery', 'TR');

ALTER TABLE monasteries
    ADD COLUMN three_rivers BOOLEAN DEFAULT FALSE;

UPDATE monasteries
SET three_rivers = TRUE
WHERE country_code
          IN (SELECT country_code
              FROM countries_rivers
              GROUP BY country_code
              HAVING COUNT(country_code) >= 3);

SELECT m.monastery_name,
       c.country_name AS country
FROM monasteries AS m
         JOIN
     countries AS c
     USING
         (country_code)
WHERE m.three_rivers = FALSE
ORDER BY m.monastery_name;

-- 17. Monasteries by Continents and Countries -- ----------------------------------------------------------------

UPDATE countries
SET country_name = 'Burma'
WHERE country_name = 'Myanmar';

INSERT INTO monasteries(monastery_name, country_code)
VALUES ('Hanga Abbey',
        (SELECT country_code
         FROM countries
         WHERE country_name = 'Tanzania'));

SELECT c.continent_name,
       cs.country_name,
       count(m.country_code) AS monasteries_count
FROM continents AS c
         RIGHT JOIN
     countries AS cs
     USING
         (continent_code)
         LEFT JOIN
     monasteries AS m
     USING
         (country_code)
WHERE cs.three_rivers IS NOT TRUE
GROUP BY cs.country_name,
         c.continent_name
ORDER BY monasteries_count DESC,
         country_name;

-- 18. Retrieving Information about Indexes ----------------------------------------------------------------

SELECT tablename,
       indexname,
       indexdef
FROM pg_indexes
WHERE schemaname = 'public'
ORDER BY tablename,
         indexname;

-- 19. Continents and Currencies ----------------------------------------------------------------

CREATE VIEW continent_currency_usage
AS
SELECT ft.continent_code,
       ft.currency_code,
       ft.currency_usage
FROM (SELECT ct.continent_code,
             ct.currency_code,
             ct.currency_usage,
             DENSE_RANK() OVER ( PARTITION BY ct.continent_code ORDER BY ct.currency_usage DESC) as ranked_by_usage

      FROM (SELECT continent_code,
                   currency_code,
                   COUNT(currency_code) AS currency_usage
            FROM countries
            GROUP BY continent_code,
                     currency_code
            HAVING COUNT(*) > 1) AS ct) AS ft
WHERE ft.ranked_by_usage = 1
ORDER BY ft.currency_usage DESC;

-- 20. The Highest Peak in Each Country ----------------------------------------------------------------

WITH "row_number"
         AS
         (SELECT c.country_name,
                 COALESCE(p.peak_name, '(no highest peak)')                                AS highest_peak_name,
                 COALESCE(p.elevation, 0)                                                  AS highest_peak_elevation,
                 COALESCE(m.mountain_range, '(no mountain)')                               AS mountain,
                 ROW_NUMBER() OVER (PARTITION BY c.country_name ORDER BY p.elevation DESC) AS row_num
          FROM countries AS c
                   LEFT JOIN
               mountains_countries AS mc
               USING
                   (country_code)
                   LEFT JOIN
               peaks AS p
               USING
                   (mountain_id)
                   LEFT JOIN
               mountains AS m
               ON
                   m.id = p.mountain_id)

SELECT country_name,
       highest_peak_name,
       highest_peak_elevation,
       mountain
FROM "row_number"
WHERE row_num = 1
ORDER BY country_name,
         highest_peak_elevation DESC
;