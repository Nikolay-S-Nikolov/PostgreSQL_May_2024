CREATE TABLE IF NOT EXISTS search_results
    (
        id            SERIAL PRIMARY KEY,
        address_name  VARCHAR(50),
        full_name     VARCHAR(100),
        level_of_bill VARCHAR(20),
        make          VARCHAR(30),
        condition     CHAR(1),
        category_name VARCHAR(50)
    );


CREATE OR REPLACE PROCEDURE sp_courses_by_address(
    address_name VARCHAR(100)
)
AS
$$
BEGIN
    TRUNCATE TABLE search_results;
    INSERT INTO search_results (address_name, full_name, level_of_bill, make, condition, category_name)
    SELECT a.name          AS address_name,
           clients.full_name,
           CASE
               WHEN courses.bill <= 20 THEN 'Low'
               WHEN courses.bill > 30 THEN 'High'
               ELSE 'Medium'
               END         AS level_of_bill,
           cars.make,
           cars.condition,
           categories.name AS category_name
    FROM addresses AS a
             JOIN
         courses
         ON a.id = courses.from_address_id
             JOIN
         cars
         ON
             courses.car_id = cars.id
             JOIN
         categories
         ON
             cars.category_id = categories.id
             JOIN
         clients
         ON courses.client_id = clients.id
    WHERE a.name = address_name
    ORDER BY cars.make, clients.full_name;
END;
$$
    LANGUAGE plpgsql;


CALL sp_courses_by_address('700 Monterey Avenue');

SELECT * FROM search_results;

CALL sp_courses_by_address('66 Thompson Drive');

SELECT * FROM search_results;
DROP TABLE search_results;