-- Task 1

CREATE VIEW view_river_info
AS
SELECT
	CONCAT_WS(' ','The river',
	river_name,
	'flows into the',
	outflow,
	'and is',
	"length",
	'kilometers long.') AS "River Information"

FROM
	rivers
ORDER BY river_name

SELECT * FROM view_river_info:

-- Task 2

CREATE VIEW view_continents_countries_currencies_details
AS
SELECT
	CONCAT(c.continent_name,
	': ',
	c.continent_code
	) AS continent_details,
	CONCAT_WS(' - ',
	cs.country_name,
	cs.capital,
	cs.area_in_sq_km,
	'km2'
	) AS country_information,
	CONCAT(cr.description,
	' (',cr.currency_code,
	')'
	) AS currencies


FROM
	continents AS c,
	countries AS cs,
	currencies AS cr
WHERE c.continent_code = cs.continent_code AND
	cs.currency_code = cr.currency_code
ORDER BY
	country_information,currencies;
SELECT * FROM view_continents_countries_currencies_details;
DROP VIEW view_continents_countries_currencies_details;

-- Task 3

ALTER TABLE countries
ADD COLUMN
	capital_code CHAR(2);
UPDATE countries
SET capital_code = SUBSTRING(capital,1,2);
SELECT * FROM countries;

-- Task 4

SELECT
	substring(description, 5)
FROM
	currencies;

-- Task 5

SELECT
	(REGEXP_MATCHES("River Information", '([0-9]{1,4})'))[1] AS river_length
FROM
	view_river_info;

-- Task 6

SELECT
	REPLACE(mountain_range, 'a', '@') AS replace_a,
	REPLACE(mountain_range, 'A', '$') AS replace_A
FROM
	mountains

SELECT * FROM mountains`;

-- Task 7

SELECT
	capital,
	TRANSLATE(capital,'áãåçéíñóú', 'aaaceinou') AS translated_name
FROM
	countries;

-- Task 8

SELECT
	continent_name,
	TRIM(LEADING FROM continent_name) AS trim
FROM
	continents;

-- Task 9

SELECT
	continent_name,
	TRIM(TRAILING FROM continent_name) AS trim
FROM
	continents;

-- Task 10

SELECT
	LTRIM(peak_name,'M') AS left_trim,
	RTRIM(peak_name,'m') AS right_trim
FROM
	peaks;

-- Task 11

SELECT
	CONCAT(m.mountain_range, ' ', p.peak_name) AS mountain_information,
	LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS characters_length,
	BIT_LENGTH(CONCAT(m.mountain_range, ' ', p.peak_name)) AS bits_of_a_tring
FROM
	mountains  AS m,
	peaks AS p
WHERE m.id = p.mountain_id;

-- Task 12

SELECT
	population,
	LENGTH(population::VARCHAR) as "length"
FROM
	countries;

-- Task 13

SELECT
	peak_name,
	LEFT(peak_name,4) AS positive_left,
	LEFT(peak_name,-4) AS negative_left
FROM
	peaks;

--  Task 14

SELECT
	peak_name,
	RIGHT(peak_name,4) AS positive_right,
	RIGHT(peak_name,-4) AS negative_right
FROM
	peaks;

--  Task 15

UPDATE countries
	SET iso_code = UPPER(SUBSTRING(country_name,1,3))
WHERE
	iso_code IS NULL;

-- Task 16

UPDATE countries
	SET country_code = LOWER(REVERSE(country_code));

-- Task 17

SELECT
	CONCAT(elevation,' ',REPEAT('-',3), REPEAT('>',2) ,' ', peak_name)
FROM
	peaks
WHERE elevation>=4884;

-- Task 18

CREATE TABLE bookings_calculation
	AS
SELECT
	booked_for,
	(booked_for*50)::NUMERIC  AS multiplication,
	(booked_for%50)::NUMERIC AS modulo
FROM
	bookings
WHERE "apartment_id" = 93;


-- Task 19

SELECT
	latitude,
	ROUND(latitude,2) AS round,
	TRUNC(latitude,2) as trunc
FROM
	apartments;


-- Task 20

SELECT
	longitude,
	ABS(longitude) AS "abs"
FROM
	apartments;

-- Task 21

ALTER TABLE bookings
ADD COLUMN
	billing_day TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP;
SELECT
	TO_CHAR(billing_day,
	'DD "Day" MM "Month" YYYY "Year" HH24:MI:SS'
	) AS "Billing Day"
FROM
	bookings;

-- Task 22

SELECT
	EXTRACT('YEAR' FROM booked_at) AS "YEAR",
	EXTRACT('MONTH' FROM booked_at) AS "MONTH",
	EXTRACT('DAY' FROM booked_at) AS "DAY",
	EXTRACT('HOUR' FROM booked_at) AS "HOUR",
	EXTRACT('MINUTE' FROM booked_at) AS "MINUTE",
	CEILING(EXTRACT('SECOND' FROM booked_at)) AS "SECOND"
FROM
	bookings;

-- Task 23

SELECT
	user_id,
	AGE(starts_at,booked_at) AS "Early Birds"
FROM
	bookings
WHERE
	AGE(starts_at,booked_at)>= INTERVAL '10 mons';

-- Task 24

SELECT
	companion_full_name,
	email
FROM
	users
WHERE
	companion_full_name ILIKE '%aNd%'
	AND
	email NOT LIKE '%@gmail';

-- Task 25

SELECT
	LEFT(first_name,2) AS initials,
	COUNT('initials') AS user_count
FROM
	users
GROUP BY
	initials
ORDER BY
	user_count DESC,
	initials;

-- Task 26

SELECT
	SUM(booked_for) AS total_value
FROM
	bookings
WHERE
	apartment_id = 90;

-- Task 27

SELECT
	AVG(multiplication) AS avarage_value
FROM
	bookings_calculation;
