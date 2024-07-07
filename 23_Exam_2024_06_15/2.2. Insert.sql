INSERT INTO addresses
SELECT id,
       username,
       password,
       ip,
       age
FROM accounts
WHERE gender = 'F'