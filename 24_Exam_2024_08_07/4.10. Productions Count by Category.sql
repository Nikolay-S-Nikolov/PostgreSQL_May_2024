DROP FUNCTION IF EXISTS udf_category_productions_count(category_name VARCHAR(50));

CREATE FUNCTION udf_category_productions_count(category_name VARCHAR(50))
    RETURNS VARCHAR(50)
AS
$$
BEGIN
    RETURN
        CONCAT('Found ',
            (SELECT
    COUNT(*)
FROM categories AS c
         JOIN categories_productions AS cp
              ON c.id = cp.category_id
WHERE c.name = category_name),
            ' productions.');

END
$$
    LANGUAGE plpgsql;

SELECT udf_category_productions_count('Nonexistent') AS message_text;


SELECT udf_category_productions_count('History') AS message_text;
