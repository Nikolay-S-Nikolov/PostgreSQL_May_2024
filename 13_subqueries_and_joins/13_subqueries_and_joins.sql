 -- 01. Towns Addresses ----------------------------------------------------------------

 SELECT
	t.town_id,
	t.name AS town_name,
	a.address_text
FROM towns AS t
	JOIN addresses as a
	ON a.town_id = t.town_id
WHERE t.name IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY t.town_id, a.address_id;

-- 02. Managers -- ----------------------------------------------------------------

SELECT
	e.employee_id,
	CONCAT(e.first_name, ' ',e.last_name) AS full_name,
	e.department_id,
	d.name AS department_name
FROM employees AS e JOIN departments AS d
	ON e.employee_id = d.manager_id
ORDER BY e.employee_id
LIMIT 5;

-- 03. Employees Projects-- ----------------------------------------------------------------

SELECT
	e.employee_id,
	CONCAT(e.first_name, ' ',e.last_name) AS full_name,
	p.project_id,
	p.name AS project_name
FROM employees AS e JOIN
		employees_projects
			USING (employee_id)
				JOIN projects AS p
					USING (project_id)
WHERE p.project_id = 1;

-- 04. Higher Salary----------------------------------------------------------------

SELECT
	count(*)
FROM
	employees
WHERE salary >(SELECT avg(salary) FROM employees);

