-- List of facilities that charge a fee to members, and that fee is less than 1/50th of the monthly maintenance cost?
-- Return the facid, facility name, member cost, and monthly maintenance of the facilities in question.

SELECT facid,
       name,
       membercost,
       monthlymaintenance
FROM cd.facilities
WHERE membercost < (monthlymaintenance / 50)
  AND membercost > 0
;

-- Retrieve the details of facilities with ID 1 and 5
SELECT *
FROM cd.facilities
WHERE facid IN (1, 5)
;

-- List of facilities, with each labelled as
-- 'cheap' or 'expensive' depending on if their monthly maintenance cost is more than $100? Return the
-- name and monthly maintenance of the facilities in question.

SELECT name,
       CASE
           WHEN monthlymaintenance <= 100 THEN 'cheap'
           ELSE 'expensive'
           END AS cost
FROM cd.facilities
;

--  List of members who joined after the start of September 2012? Return the memid, surname, firstname, and joindate of the members in question
SELECT memid,
       surname,
       firstname,
       joindate
FROM cd.members
WHERE joindate > '2012-09-01'
;

-- List of the first 10 surnames in the members table? The list must not contain duplicates.

SELECT DISTINCT (surname)
FROM cd.members
ORDER BY surname
LIMIT 10
;

-- Combined list of all surnames and all facility names.
SELECT surname
FROM cd.members
UNION
SELECT name
FROM cd.facilities
;

-- Get the signup date of your last member

SELECT MAX(joindate) AS latest
FROM cd.members
;

-- Get the first and last name of the last member(s) who signed up

SELECT firstname,
       surname,
       joindate
FROM cd.members
WHERE joindate = (SELECT MAX(joindate) AS latest
                  FROM cd.members)
;
SELECT firstname,
       surname,
       joindate
FROM cd.members
ORDER BY joindate DESC
LIMIT 1
;

-- List of the start times for bookings by members named 'David Farrell'

SELECT starttime
from cd.members AS m
         RIGHT JOIN cd.bookings AS b
                    USING (memid)
WHERE CONCAT(firstname, ' ', surname) = 'David Farrell'
;

-- List of the start times for bookings for tennis courts, for the date '2012-09-21'.
-- Return a list of start time and facility name pairings, ordered by the time.

SELECT b.starttime AS start,
       f.name
FROM cd.bookings AS b
         JOIN cd.facilities AS f
              USING (facid)
WHERE TO_CHAR(b.starttime, 'YYYY-MM-DD') = '2012-09-21'
  AND f.name LIKE '%Tennis%Court%'
ORDER BY b.starttime
;

-- List of all members who have recommended another member.
-- Ensure that there are no duplicates in the list, and that results are ordered by (surname, firstname).
-- Variant 1
SELECT firstname,
       surname
FROM cd.members
WHERE memid IN
      (SELECT recommendedby
       FROM cd.members
       WHERE recommendedby IS NOT NULL)
ORDER BY surname, firstname
;
-- Variant 2

SELECT DISTINCT(r.firstname) AS firstname,
               r.surname
FROM cd.members AS m
         JOIN cd.members AS r
              ON m.recommendedby = r.memid
ORDER BY surname, firstname
;

--  List of all members, including the individual who recommended them (if any).
--  Ensure that results are ordered by (surname, firstname).
-- Variant 1
SELECT m.firstname AS memfname,
       m.surname   AS memsname,
       CASE
           WHEN m.recommendedby IS NULL THEN ''
           ELSE (SELECT mem.firstname FROM cd.members AS mem WHERE memid = m.recommendedby)
           END     AS recfname,
       CASE
           WHEN m.recommendedby IS NULL THEN ''
           ELSE (SELECT mem.surname FROM cd.members AS mem WHERE memid = m.recommendedby)
           END     AS recsname
FROM cd.members AS m
ORDER BY m.surname, m.firstname
;

-- Variant 2

SELECT r.firstname AS memfname,
       r.surname   AS memsname,
       m.firstname AS recfname,
       m.surname   AS recsname
FROM cd.members AS r
         LEFT JOIN cd.members AS m
                   ON m.memid = r.recommendedby
ORDER BY r.surname, r.firstname
;

-- List of all members who have used a tennis court?
-- Include in your output the name of the court, and the name of the member formatted as a single column.
-- Ensure no duplicate data, and order by the member name followed by the facility name.

SELECT DISTINCT(CONCAT(m.firstname, ' ', m.surname)) AS member,
               f.name                                AS facility
FROM cd.members AS m
         JOIN cd.bookings b
              USING (memid)
         JOIN cd.facilities AS f
              USING (facid)
WHERE f.name LIKE '%Tennis%Court%'
ORDER BY member, f.name
;

-- List of bookings on the day of 2012-09-14 which will cost the member (or guest) more than $30?
-- Remember that guests have different costs to members (the listed costs are per half-hour 'slot'),and
-- the guest user is always ID 0.
-- Include in your output the name of the facility, the name of the member formatted as a single column, and the cost.
-- Order by descending cost, and do not use any subqueries.
-- Variant 1
SELECT CONCAT(m.firstname, ' ', m.surname) AS member,
       f.name,
       CASE
           WHEN b.memid = 0 THEN b.slots * f.guestcost
           ELSE b.slots * f.membercost
           END                             AS cost
FROM cd.bookings AS b
         LEFT JOIN cd.members as m
                   USING (memid)
         LEFT JOIN cd.facilities AS f
                   USING (facid)
WHERE TO_CHAR(b.starttime, 'YYYY-MM-DD') = '2012-09-14'
  AND (CASE
           WHEN b.memid = 0 THEN b.slots * f.guestcost
           ELSE b.slots * f.membercost
    END) > 30

ORDER BY cost DESC
;

-- Variant 2
SELECT member,
       facility,
       cost
FROM (SELECT CONCAT(m.firstname, ' ', m.surname) AS member,
             f.name                              AS facility,
             CASE
                 WHEN b.memid = 0 THEN b.slots * f.guestcost
                 ELSE b.slots * f.membercost
                 END                             AS cost
      FROM cd.bookings AS b
               LEFT JOIN cd.members as m
                         USING (memid)
               LEFT JOIN cd.facilities AS f
                         USING (facid)
      WHERE TO_CHAR(b.starttime, 'YYYY-MM-DD') = '2012-09-14') AS bookings
WHERE cost > 30
ORDER BY cost DESC
;

-- List of all members, including the individual who recommended them (if any), without using any joins.
-- Ensure that there are no duplicates in the list, and
-- that each firstname + surname pairing is formatted as a column and ordered.

SELECT DISTINCT CONCAT(m.firstname, ' ', m.surname) AS member,
                (SELECT CONCAT(r.firstname, ' ', r.surname) AS recommender
                 FROM cd.members AS r
                 WHERE r.memid = m.recommendedby)
FROM cd.members AS m
ORDER BY member;


-- Add facilities into the table. Use the following values:
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.

INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800)
;

-- Add multiple facilities in one command. Use the following values:
--
-- facid: 9, Name: 'Spa', membercost: 20, guestcost: 30, initialoutlay: 100000, monthlymaintenance: 800.
-- facid: 10, Name: 'Squash Court 2', membercost: 3.5, guestcost: 17.5, initialoutlay: 5000, monthlymaintenance: 80.

INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES (9, 'Spa', 20, 30, 100000, 800),
       (10, 'Squash Court 2', 3.5, 17.5, 5000, 80)
;

--  Add facilities by automatically generate the value for the next facid.
-- Variant 1
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES ((SELECT facid FROM cd.facilities ORDER BY facid DESC LIMIT 1) + 1, 'Spa', 20, 30, 100000, 800)
;

-- Variant 2
INSERT INTO cd.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
VALUES ((SELECT MAX(facid) FROM cd.facilities) + 1, 'Spa', 20, 30, 100000, 800)
;

--  Update initialoutlay to be 10000 for the second tennis court.

UPDATE cd.facilities
SET initialoutlay = 10000
WHERE name = 'Tennis Court 2'
;

-- Increase the price of the tennis courts for both members and guests.
-- Update the costs to be 6 for members, and 30 for guests.

UPDATE cd.facilities
SET guestcost  = 30,
    membercost = 6
WHERE name LIKE '%Tennis%Court%'
;

-- Alter the price of the second tennis court so that it costs 10% more than the first one.
-- Try to do this without using constant values for the prices, so that we can reuse the statement if we want to.

-- Variant 1
UPDATE cd.facilities
SET guestcost  = 1.1 * (SELECT guestcost FROM cd.facilities WHERE name LIKE 'Tennis Court 1'),
    membercost = 1.1 * (SELECT membercost FROM cd.facilities WHERE name LIKE 'Tennis Court 1')
WHERE name LIKE 'Tennis Court 2'
;
-- Variant 2

UPDATE cd.facilities AS f
SET guestcost  = 1.1 * fac.guestcost,
    membercost = 1.1 * fac.membercost
FROM (SELECT * FROM cd.facilities WHERE name LIKE 'Tennis Court 1') AS fac
WHERE f.name LIKE 'Tennis Court 2'
;

-- Remove all members without booking.

-- Variant 1
DELETE
FROM cd.members
WHERE memid NOT IN (SELECT memid FROM cd.bookings)
;
--Variant 2
DELETE
FROM cd.members as m
WHERE NOT EXISTS (SELECT 1 FROM cd.bookings WHERE m.memid = memid)
;

-- Count the number of recommendations each member has made. Order by member ID

SELECT recommendedby,
       COUNT(recommendedby)
FROM cd.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby
;

--List the total slots booked per facility

SELECT facid,
       SUM(slots) AS "Total Slotes"
FROM cd.bookings
GROUP BY facid
ORDER BY facid
;
-- List of the total number of slots booked per facility in the month of September 2012.
-- Produce an output table consisting of facility id and slots, sorted by the number of slots.

SELECT facid,
       SUM(slots) AS "Total Slotes"
FROM cd.bookings
WHERE starttime >= '2012-09-01'
  AND starttime < '2012-10-01'
GROUP BY facid
ORDER BY "Total Slotes"
;

-- List of the total number of slots booked per facility per month in the year of 2012.
-- Produce an output table consisting of facility id and slots, sorted by the id and month.

SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots)                    AS "Total Slotes"
FROM cd.bookings
WHERE EXTRACT(YEAR FROM starttime) = 2012
GROUP BY facid, month
ORDER BY facid, month
;

-- Total number of members (including guests) who have made at least one booking
-- Variant 1
SELECT COUNT(*)
FROM (SELECT COUNT(*)
      FROM cd.bookings
      GROUP BY memid) AS counted_memid;
-- Variant 2
SELECT COUNT(DISTINCT (memid))
FROM cd.bookings;

-- List of facilities with more than 1000 slots booked.
-- Produce an output table consisting of facility id and slots, sorted by facility id.

SELECT facid,
       SUM(slots) AS "Ttal Slots"
FROM cd.bookings
GROUP BY facid
HAVING SUM(slots) > 1000
ORDER BY facid
;

-- List of facilities along with their total revenue.
-- The output table should consist of facility name and revenue, sorted by revenue.
-- Remember that there's a different cost for guests and members!

-- Variant 1
WITH calculated
         AS (SELECT f.name,
                    CASE
                        WHEN b.memid = 0 THEN guestcost * slots
                        ELSE membercost * slots
                        END AS price_paid
             FROM cd.facilities AS f
                      JOIN
                  cd.bookings AS b
                  USING (facid))
SELECT name,
       SUM(price_paid) AS ravenue
FROM calculated
GROUP BY name
ORDER BY ravenue
;
-- Variant 2
SELECT f.name,
       SUM(b.slots *
           CASE
               WHEN b.memid = 0 THEN f.guestcost
               ELSE f.membercost
               END) AS ravenue
FROM cd.facilities AS f
         JOIN
     cd.bookings AS b
     USING (facid)
GROUP BY f.name
ORDER BY ravenue
;

--  list of facilities with a total revenue less than 1000.
--  Produce an output table consisting of facility name and revenue, sorted by revenue.
--  Remember that there's a different cost for guests and members!
-- Variant 1
WITH calculated
         AS (SELECT f.name,
                    CASE
                        WHEN b.memid = 0 THEN guestcost * slots
                        ELSE membercost * slots
                        END AS price_paid
             FROM cd.facilities AS f
                      JOIN
                  cd.bookings AS b
                  USING (facid))
SELECT name,
       SUM(price_paid) AS ravenue
FROM calculated
GROUP BY name
HAVING SUM(price_paid) < 1000
ORDER BY ravenue
;

-- Variant 2
SELECT name,
       ravenue
FROM (SELECT f.name,
             SUM(b.slots *
                 CASE
                     WHEN b.memid = 0 THEN f.guestcost
                     ELSE f.membercost
                     END) AS ravenue
      FROM cd.facilities AS f
               JOIN
           cd.bookings AS b
           USING (facid)
      GROUP BY f.name) AS aggregated
WHERE ravenue < 1000
ORDER BY ravenue
;

-- Output the facility id that has the highest number of slots booked. Try without a LIMIT clause.
-- Variant 1
WITH final_table
         AS
         (SELECT facid,
                 SUM(slots) AS "Total Slotes"
          FROM cd.bookings
          GROUP BY facid
          ORDER BY facid)
SELECT facid,
       "Total Slotes"
FROM final_table
WHERE "Total Slotes" = (SELECT MAX("Total Slotes") FROM final_table)
;

-- Variant 2
SELECT DISTINCT FIRST_VALUE(facid) OVER ( ORDER BY SUM(slots) DESC)      AS facid,
                FIRST_VALUE(SUM(slots)) OVER ( ORDER BY SUM(slots) DESC) AS "Total Slotes"
FROM cd.bookings
GROUP BY facid
;

-- list of the total number of slots booked per facility per month in the year of 2012.
-- In this version, include output rows containing totals for all months per facility, and
-- a total for all months for all facilities. The output table should consist of facility id, month and
-- slots, sorted by the id and month. When calculating the aggregated values for all months and
-- all facids, return null values in the month and facid columns.

SELECT facid,
       (TO_CHAR(starttime, 'MM'))::INT AS month,
       SUM(slots)                      AS "Total Slotes"
FROM cd.bookings
WHERE starttime >= '2012-01-01'
  AND starttime < '2013-01-01'
GROUP BY ROLLUP (facid, month)
ORDER BY facid, month
;

-- List of the total number of hours booked per facility, remembering that a slot lasts half an hour.
-- The output table should consist of the facility id, name, and hours booked, sorted by facility id.
-- Try formatting the hours to two decimal places.

SELECT f.facid,
       f.name,
       (SUM(slots) / 2.0)::NUMERIC(10, 2) AS "Total Hours"
FROM cd.bookings AS b
         JOIN cd.facilities AS f
              USING (facid)
GROUP BY f.facid
ORDER BY facid
;

-- List of each member name, id, and their first booking after September 1st 2012. Order by member ID.

SELECT m.surname,
       m.firstname,
       m.memid,
       MIN(b.starttime) AS starttime
FROM cd.members AS m
         JOIN cd.bookings AS b
              USING (memid)
WHERE b.starttime > '2012-09-01'
GROUP BY m.memid, m.surname, m.firstname
ORDER BY memid
;

-- List of member names, with each row containing the total member count. Order by join date, and include guest members.
-- Variant 1
SELECT (SELECT COUNT(*) FROM cd.members),
       firstname,
       surname
FROM cd.members
ORDER BY joindate;

-- Variant 2
SELECT COUNT(memid) OVER (),
       firstname,
       surname
FROM cd.members
ORDER BY joindate;

-- Numbered list of members,ordered by their date of joining.
-- Remember that member IDs are not guaranteed to be sequential.

SELECT ROW_NUMBER() OVER (ORDER BY joindate),
       firstname,
       surname
FROM cd.members
ORDER BY joindate;

-- Output the facility id that has the highest number of slots booked.
-- Ensure that in the event of a tie, all tieing results get output.

WITH ranked_by_slots
         AS (SELECT facid,
                    SUM(slots)                             AS total,
                    RANK() OVER (ORDER BY SUM(slots) DESC) AS rank
             FROM cd.bookings
             GROUP BY facid)
SELECT facid,
       total
FROM ranked_by_slots
WHERE rank = 1
;

--  list of members (including guests), along with the number of hours they've booked in facilities, rounded to
--  the nearest ten hours. Rank them by this rounded figure, producing output of first name, surname, rounded
--  hours, rank. Sort by rank, surname, and first name.

SELECT m.firstname,
       m.surname,
       ROUND((SUM(slots) / 2) / 10.0) * 10                             AS hours,
       RANK() OVER (ORDER BY ROUND((SUM(slots) / 2) / 10.0) * 10 DESC) AS rank
FROM cd.bookings AS b
         JOIN cd.members AS m
              USING (memid)
GROUP BY m.memid, m.firstname, m.surname
ORDER BY rank, m.surname, m.firstname
;

--  List of the top three revenue generating facilities (including ties).
--  Output facility name and rank, sorted by rank and facility name.


WITH ranked_facilities
         AS
         (SELECT f.name,
                 RANK() OVER (ORDER BY SUM(slots * (
                     CASE WHEN b.memid = 0 THEN f.guestcost ELSE f.membercost END
                     )) DESC) AS rank
          FROM cd.facilities AS f
                   JOIN cd.bookings AS b
                        USING (facid)
          GROUP BY f.name)
SELECT name,
       rank
FROM ranked_facilities
WHERE rank <= 3
ORDER BY rank, name
;


-- Classify facilities into equally sized groups of high, average, and low based on their revenue.
-- Order by classification and facility name.

WITH ranked_facilities
         AS
         (SELECT f.name,
                 NTILE(3) OVER (ORDER BY SUM(slots * (
                     CASE WHEN b.memid = 0 THEN f.guestcost ELSE f.membercost END
                     )) DESC) AS rank
          FROM cd.facilities AS f
                   JOIN cd.bookings AS b
                        USING (facid)
          GROUP BY f.name)
SELECT name,
       CASE
           WHEN rank = 1 THEN 'high'
           WHEN rank = 2 THEN 'average'
           ELSE 'low' END AS ravenue
FROM ranked_facilities
ORDER BY rank, name
;

-- Based on the 3 complete months of data so far, calculate the amount of time each facility will take to
-- repay its cost of ownership. Remember to take into account ongoing monthly maintenance.
-- Output facility name and payback time in months, order by facility name.
-- Don't worry about differences in month lengths, we're only looking for a rough value here!

WITH facilities_monthly_outcome
         AS
         (SELECT f.name,
                 SUM(slots * (
                     CASE WHEN b.memid = 0 THEN f.guestcost ELSE f.membercost END
                     )) / 3.0 AS monthly_outcome
          FROM cd.facilities AS f
                   JOIN cd.bookings AS b
                        USING (facid)
          GROUP BY f.name)
SELECT r.name,
       f.initialoutlay / (r.monthly_outcome - f.monthlymaintenance) AS months
FROM facilities_monthly_outcome AS r
         JOIN cd.facilities AS f
              USING (name)
ORDER BY r.name
;

-- or each day in August 2012, calculate a rolling average of total revenue over the previous 15 days.
-- Output should contain date and revenue columns, sorted by the date.
-- Remember to account for the possibility of a day having zero revenue.
WITH month_august
         AS
         (SELECT GENERATE_SERIES(
                         '2012-08-01', '2012-08-31', INTERVAL '1 day'
                 )::DATE AS august_day)
SELECT month_august.august_day,
       (SELECT SUM(slots * (
           CASE WHEN b.memid = 0 THEN f.guestcost ELSE f.membercost END
           )) AS ravenue
        FROM cd.bookings AS b
                 JOIN cd.facilities f
                      USING (facid)
        WHERE b.starttime > month_august.august_day - INTERVAL '14 days'
          AND b.starttime < month_august.august_day + INTERVAL '1 day') / 15 AS ravenue
FROM month_august
ORDER BY month_august.august_day
;

--  Number of seconds between the timestamps '2012-08-31 01:00:00' and '2012-09-02 00:00:00'

SELECT (EXTRACT('EPOCH' FROM '2012-09-02 00:00:00'::TIMESTAMP)
    - EXTRACT('EPOCH' FROM '2012-08-31 01:00:00'::TIMESTAMP)):: INT AS date_part;

SELECT EXTRACT(EPOCH FROM (TIMESTAMP '2012-09-02 00:00:00' - '2012-08-31 01:00:00'))::INT AS date_part;

-- For each month of the year in 2012, output the number of days in that month.
-- Format the output as an integer column containing the month of the year, and
-- a second column containing an interval data type.

WITH months_of_2012
         AS
             (SELECT GENERATE_SERIES(1, 12, 1) AS month_of_2012)
SELECT month_of_2012,
       CASE
           WHEN month_of_2012 = 12 THEN
               CONCAT('2013-', '01', '-01')::TIMESTAMP - CONCAT('2012-', month_of_2012, '-01')::TIMESTAMP
           ELSE
               CONCAT('2012-', month_of_2012 + 1, '-01')::TIMESTAMP - CONCAT('2012-', month_of_2012, '-01')::TIMESTAMP
           END AS length
FROM months_of_2012
;


-- For any given timestamp, work out the number of days remaining in the month.
-- The current day should count as a whole day, regardless of the time.
-- Use '2012-02-11 01:00:00' as an example timestamp for the purposes of making the answer.
-- Format the output as a single interval value.

-- Variant 1
CREATE OR REPLACE FUNCTION fn_days_remaining_in_month(from_date TIMESTAMP)
    RETURNS INTERVAL AS
$$
BEGIN
    RETURN
        DATE_TRUNC('days',
                   (SELECT CONCAT(TO_CHAR(from_date, 'YYYY'), TO_CHAR(from_date + INTERVAL '1 month', 'MM'),
                                  '02')::TIMESTAMP) - from_date);

END;
$$
    LANGUAGE plpgsql;

-- Variant2

SELECT fn_days_remaining_in_month('2012-02-11 01:00:00');

WITH selected_day
         AS
             (SELECT ('2012-02-11 01:00:00')::TIMESTAMP AS from_date)

SELECT DATE_TRUNC('days',
                  (SELECT CONCAT(TO_CHAR(from_date, 'YYYY'), TO_CHAR(from_date + INTERVAL '1 month', 'MM'),
                                 '02')::TIMESTAMP) - from_date)
FROM selected_day
;

-- Variant 3

WITH selected_day
         AS
             (SELECT ('2012-02-11 01:00:00')::TIMESTAMP AS from_date)

SELECT (DATE_TRUNC('Month', from_date) + INTERVAL '1 month') - DATE_TRUNC('Days', from_date)

FROM selected_day
;

--List of the start and end time of the last 10 bookings (ordered by the time at which they end, followed by
-- the time at which they start) in the system.

SELECT starttime,
       starttime + slots * (INTERVAL '30 minutes') AS endtime
FROM cd.bookings
ORDER BY endtime DESC, starttime DESC
LIMIT 10
;

-- Count of bookings for each month, sorted by month

SELECT DATE_TRUNC('MONTH', starttime) AS month,
       COUNT(*)

FROM cd.bookings
GROUP BY month
ORDER BY month
;
-- Utilisation percentage for each facility by month, sorted by name and month, rounded to 1 decimal place.
-- Opening time is 8am, closing time is 8.30pm. You can treat every month as a full month, regardless of if there
-- were some dates the club was not open.
-- NOTE: 8am to 8.30pm are 25 slots

WITH aggregated_table AS
         (SELECT f.name,
                 DATE_TRUNC('MONTH', b.starttime) AS month,
                 SUM(b.slots)                     AS slots_per_month
          FROM cd.bookings AS b
                   JOIN cd.facilities AS f
                        USING (facid)
          GROUP BY month, f.name
          ORDER BY f.name, month)
SELECT name,
       month,
       ROUND((slots_per_month * 100) / (
           25 * (((month + INTERVAL '1 month')::date - month::date)::NUMERIC)
           ), 1) AS utilisation
FROM aggregated_table
;

-- Output the names of all members, formatted as 'Surname, Firstname'
SELECT CONCAT(Surname, ', ', firstname)
FROM cd.members;

-- Find all facilities whose name begins with 'Tennis'. Retrieve all columns.
SELECT *
FROM cd.facilities
WHERE name LIKE 'Tennis%';

-- find all the telephone numbers that contain parentheses, returning the member ID and
-- telephone number sorted by member ID.

SELECT memid,
       telephone
FROM cd.members
WHERE telephone ~ '\(.*\)'
;

SELECT memid,
       telephone
FROM cd.members
WHERE telephone LIKE '%(%)%'
;

-- The zip codes in our example dataset have had leading zeroes removed from them by virtue of being stored as a
-- numeric type. Retrieve all zip codes from the members table, padding any zip codes less than 5 characters long with
-- leading zeroes. Order by the new zip code.

SELECT LPAD(zipcode::CHAR(5), 5, '0') AS zip
FROM cd.members
ORDER BY zip
;

-- count of how many members you have whose surname starts with each letter of the alphabet.
-- Sort by the letter, and don't worry about printing out a letter if the count is 0.

SELECT SUBSTRING(surname, 1, 1) AS letter,
       COUNT(*)
FROM cd.members
GROUP BY letter
ORDER BY letter
;

SELECT LEFT(surname, 1) AS letter,
       COUNT(*)
FROM cd.members
GROUP BY letter
ORDER BY letter
;

-- The telephone numbers in the database are very inconsistently formatted.
-- You'd like to print a list of member ids and numbers that have had '-','(',')', and ' ' characters removed.
-- Order by member id.
SELECT memid,
       TRANSLATE(telephone, '()- ', '') AS telefone
FROM cd.members
WHERE telephone LIKE '%-%'
   OR telephone LIKE '%(%)%'
ORDER BY memid
;

SELECT memid,
       REGEXP_REPLACE(telephone, '[^0-9]', '', 'g') AS telefone
FROM cd.members
WHERE telephone LIKE '%-%'
   OR telephone LIKE '%(%)%'
ORDER BY memid
;

-- Find the upward recommendation chain for member ID 27: that is, the member who recommended them, and
-- the member who recommended that member, and so on. Return member ID, first name, and surname.
-- Order by descending member id.

WITH RECURSIVE recommendation_chain AS
                   (SELECT recommendedby
                    FROM cd.members
                    WHERE memid = 27

                    UNION ALL

                    SELECT m.recommendedby
                    FROM recommendation_chain AS rc
                             JOIN cd.members AS m
                                  ON m.memid = rc.recommendedby)
SELECT me.memid,
       me.firstname,
       me.surname
FROM recommendation_chain AS r
         JOIN cd.members AS me
              ON me.memid = r.recommendedby
ORDER BY memid DESC;


-- Find the downward recommendation chain for member ID 1: that is, the members they recommended, the
-- members those members recommended, and so on. Return member ID and name, and order by ascending member id.

WITH RECURSIVE recomnded_by AS
                   (SELECT memid AS recomended
                    FROM cd.members
                    WHERE recommendedby = 1

                    UNION ALL

                    SELECT m.memid
                    FROM cd.members AS m
                             JOIN recomnded_by AS r ON m.recommendedby = r.recomended)
SELECT mem.memid,
       mem.firstname,
       mem.surname
FROM recomnded_by AS rec
         JOIN cd.members AS mem
              ON rec.recomended = mem.memid
ORDER BY memid
;

-- Produce a CTE that can return the upward recommendation chain for any member.
-- You should be able to select recommender from recommenders where member=x.
-- Demonstrate it by getting the chains for members 12 and 22. Results table should have member and recommender.
-- Ordered by member ascending, recommender descending.

WITH RECURSIVE recommendation_chain AS
                   (SELECT recommendedby,
                           memid
                    FROM cd.members
                    UNION ALL

                    SELECT m.recommendedby,
                           rc.memid

                    FROM recommendation_chain AS rc
                             JOIN cd.members AS m
                                  ON m.memid = rc.recommendedby)
SELECT r.memid         AS member,
       r.recommendedby AS recomender,
       me.firstname,
       me.surname
FROM recommendation_chain AS r
         JOIN cd.members AS me
              ON me.memid = r.recommendedby
WHERE r.memid IN (12, 22)
ORDER BY member, recomender DESC
;







