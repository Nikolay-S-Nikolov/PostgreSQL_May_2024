-- 01. Count Employees by Town----------------------------------------------------------------

CREATE OR REPLACE FUNCTION
    fn_count_employees_by_town(town_name VARCHAR(20))
    RETURNS BIGINT
AS
$$
DECLARE
    emp_count BIGINT;
BEGIN
    SELECT COUNT(*) AS emploies_count
    INTO emp_count
    FROM employees
             LEFT JOIN
         addresses
         USING
             (address_id)
             LEFT JOIN
         towns AS t
         USING
             (town_id)
    WHERE t.name = town_name
    GROUP BY t.name;
    RETURN emp_count;

END;
$$
    LANGUAGE plpgsql;

-- 02. Employees Promotion --------------------------------------------------------

CREATE PROCEDURE sp_increase_salaries(department_name VARCHAR(50))
AS
$$
BEGIN
    UPDATE employees
    SET salary = salary * 1.05
    WHERE department_id = (SELECT department_id
                           FROM departments
                           WHERE name = department_name);
END;
$$
    LANGUAGE plpgsql;

-- 03. Employees Promotion By ID --------------------------------------------------------

CREATE PROCEDURE sp_increase_salary_by_id(id INT)
AS
$$
BEGIN
    IF (SELECT salary FROM employees WHERE employee_id = id) IS NULL
    THEN
        ROLLBACK;
    END IF;
    UPDATE employees
    SET salary = salary * 1.05
    WHERE employee_id = id;
END;

$$
    LANGUAGE plpgsql;

--  04. Triggered ------------------------------------------------------------------------

CREATE TABLE deleted_employees
(
    employee_id   SERIAL PRIMARY KEY,
    first_name    VARCHAR(20),
    last_name     VARCHAR(20),
    middle_name   VARCHAR(20),
    job_title     VARCHAR(50),
    department_id INT,
    salary        NUMERIC(19, 4)
);

CREATE OR REPLACE FUNCTION fn_deleted_employess()
    RETURNS TRIGGER AS
$$
BEGIN
    INSERT INTO deleted_employees (first_name,
                                   last_name,
                                   middle_name,
                                   job_title,
                                   department_id,
                                   salary)
    VALUES (old.first_name,
            old.last_name,
            old.middle_name,
            old.job_title,
            old.department_id,
            old.salary);
    RETURN NULL;
END;
$$
    LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER deleted_employees_trigger
    AFTER DELETE
    ON employees
    FOR EACH ROW
EXECUTE PROCEDURE fn_deleted_employess();