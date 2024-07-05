-- Extract information about all the "players" with their "full_name" (concatenation of "first_name" and "last_name"),
-- "age", and "hire_date". Select only the players whose "first_name" starts with 'M%'. Sort the list by "age" in
-- descending order. If there is more than one player with the same age, the results should be further sorted by their
-- "full_name" in ascending order.

SELECT
    CONCAT(first_name, ' ', last_name) AS full_name,
    age,
    hire_date
FROM players
WHERE first_name LIKE 'M%'
ORDER BY age DESC, full_name