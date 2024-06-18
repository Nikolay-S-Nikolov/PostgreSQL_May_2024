CREATE DATABASE gamebar;

CREATE TABLE employees
(
    "id"           serial NOT NULL PRIMARY KEY,
    first_name     VARCHAR(30),
    last_name      VARCHAR(50),
    hiring_date    DATE default '2023-01-01',
    salary         numeric(10, 2),
    devices_number integer
);

CREATE TABLE departments
(
    "id"        serial NOT NULL PRIMARY KEY,
    "name"      varchar(50),
    code        character(3),
    description text
);

CREATE TABLE issues
(
    "id"        serial NOT NULL UNIQUE PRIMARY KEY,
    description varchar(150),
    "date"      date,
    start       timestamp
);


ALTER TABLE employees
    ADD COLUMN middle_name VARCHAR(50);

ALTER TABLE employees
    ALTER COLUMN salary set not null,
    ALTER COLUMN salary set default 0,
    ALTER COLUMN hiring_date set not null;

ALTER TABLE employees
    ALTER COLUMN middle_name TYPE VARCHAR(100);

TRUNCATE TABLE issues;

CREATE TABLE minions(
    id SERIAL PRIMARY KEY,
	name VARCHAR(30),
	age INTEGER
);

