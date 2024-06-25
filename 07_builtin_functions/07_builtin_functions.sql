SELECT
	title
FROM
	books
WHERE SUBSTRING(title,1,3) = 'The'
ORDER BY id;


SELECT
	REPLACE(title, 'The', '***')
FROM books

WHERE
	LEFT(title,3) = 'The'
ORDER BY id;

SELECT
	id,
	side * height / 2 AS area
from triangles;


SELECT
	title,
	ROUND("cost",3) AS modified_price
FROM books
ORDER BY id;

SELECT
	first_name,
	last_name,
	date_part('year', born) AS year
from
	authors;

SELECT
	first_name,
	last_name,
	EXTRACT(YEAR FROM born) AS year
from
	authors;

SELECT
	first_name,
	last_name,
	to_char(born, 'YYYY') AS year
from
	authors;


SELECT
	last_name AS "Last Name",
	to_char(born, 'DD (Dy) Mon YYYY') AS "Date of Birth"
from
	authors;


SELECT
	title
from
	books
WHERE title LIKE '%Harry Potter%';

