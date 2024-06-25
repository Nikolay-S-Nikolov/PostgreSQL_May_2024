-- Task 1

CREATE TABLE mountains
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR(50)
);
CREATE TABLE peaks
(
    id          SERIAL PRIMARY KEY,
    name        VARCHAR(50),
    mountain_id INT,
    CONSTRAINT fk_peaks_mountains
        FOREIGN KEY (mountain_id)
            REFERENCES mountains (id)
);

--Task 2

SELECT v.driver_id,
       v.vehicle_type,
       CONCAT(c.first_name, ' ', c.last_name) AS driver_name
FROM vehicles AS v
         JOIN campers AS c ON v.driver_id = c.id;

-- Task 3

SELECT
	r.start_point,
	r.end_point,
	r.leader_id,
	CONCAT(c.first_name, ' ', c.last_name) AS leader_name
FROM routes AS r JOIN campers AS c ON c.id = r.leader_id;

-- Task 4

CREATE TABLE mountains(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50)
);
CREATE TABLE peaks(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50),
	mountain_id INT,
	CONSTRAINT fk_mountain_id
		FOREIGN KEY(mountain_id)
			REFERENCES mountains(id)
				ON DELETE CASCADE
);


