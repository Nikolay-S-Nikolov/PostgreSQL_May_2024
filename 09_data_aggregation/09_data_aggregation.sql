-- Task 01

SELECT department_id,
       COUNT(*)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Task 02

SELECT
	department_id,
	COUNT(salary)
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Task 03

SELECT
	department_id,
	SUM(salary) AS total_salaries
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Task 04

SELECT
	department_id,
	MAX(salary) AS max_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Task 05

SELECT
	department_id,
	MIN(salary) AS min_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Task 06

SELECT
	department_id,
	AVG(salary) AS avg_salary
FROM employees
GROUP BY department_id
ORDER BY department_id;

-- Task 07

SELECT
	department_id,
	SUM(salary) AS total_salary
FROM employees
GROUP BY department_id
HAVING SUM(salary) < 4200
ORDER BY department_id;

-- Task 08

SELECT
	id,
	first_name,
	last_name,
	TRUNC(salary,2) AS salary,
	department_id,
	CASE department_id
	WHEN 1 THEN 'Management'
	WHEN 2 THEN 'Kitchen Staff'
	WHEN 3 THEN 'Service Staff'
	ELSE 'Other'
	END AS department_name
FROM employees
ORDER BY id;


