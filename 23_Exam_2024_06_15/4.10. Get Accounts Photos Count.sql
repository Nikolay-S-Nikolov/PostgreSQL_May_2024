CREATE FUNCTION udf_accounts_photos_count(account_username VARCHAR(30))
RETURNS INT
AS
$$
BEGIN
    RETURN (SELECT
    COUNT(ap.account_id)
FROM
    accounts AS a
LEFT JOIN accounts_photos AS ap
ON a.id = ap.account_id
WHERE a.username = account_username
GROUP BY a.id);
END;
$$
LANGUAGE plpgsql;


SELECT udf_accounts_photos_count('ssantryd') AS photos_count;


CREATE OR REPLACE PROCEDURE udp_modify_account(address_street VARCHAR(30), address_town VARCHAR(30))
AS
$$
BEGIN
    UPDATE accounts
SET job_title = CONCAT('(Remote) ',job_title)
WHERE id IN (SELECT
    account_id
FROM addresses AS a
WHERE a.street = address_street AND a.town = address_town);

END;
$$
LANGUAGE plpgsql;























