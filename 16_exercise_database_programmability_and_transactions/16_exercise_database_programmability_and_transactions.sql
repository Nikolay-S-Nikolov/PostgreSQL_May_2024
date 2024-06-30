-- 01. User-defined Function Full----------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_full_name(first_name VARCHAR(20), last_name VARCHAR(20))
    RETURNS VARCHAR(40)
AS
$$
BEGIN
    IF first_name IS NULL AND last_name IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN INITCAP(CONCAT(TRIM(first_name), ' ', TRIM(last_name)));
END;
$$
    LANGUAGE plpgsql;

-- SELECT
-- 	fn_full_name('fred', 'sanford'),
-- 	fn_full_name('', 'SIMPSONS'),
-- 	fn_full_name('JOHN', ''),
-- 	fn_full_name(NULL, NULL)

--  02. User-defined Function Future Value ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_calculate_future_value(
    initial_sum FLOAT,
    yearly_interest_rate FLOAT,
    number_of_years INT
)
    RETURNS NUMERIC
AS
$$
DECLARE
    future_value NUMERIC;
BEGIN
    future_value := initial_sum * POWER((1 + yearly_interest_rate), number_of_years);
    RETURN TRUNC(future_value, 4);
END;
$$
    LANGUAGE plpgsql;

-- SELECT
-- 	fn_calculate_future_value (1000, 0.1, 5),
-- 	fn_calculate_future_value(2500, 0.30, 2),
-- 	fn_calculate_future_value(500, 0.25, 10)


-- 03. User-defined Function Is Word Comprised ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_is_word_comprised(
    set_of_letters VARCHAR(50),
    word VARCHAR(50)
)
    RETURNS BOOLEAN
AS
$$
DECLARE
    counter INT := 1;
    letter  CHAR(1);
BEGIN
    WHILE counter <= LENGTH(word)
        LOOP
            letter := SUBSTRING(LOWER(word), counter, 1);
            IF POSITION(letter in LOWER(set_of_letters)) = 0 THEN
                RETURN FALSE;
            END IF;
            counter := counter + 1;
        END LOOP;
    RETURN TRUE;
END;
$$
    LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION fn_is_word_comprised(
    set_of_letters VARCHAR(50),
    word VARCHAR(50)
)
    RETURNS BOOLEAN
AS
$$
BEGIN
    RETURN CHAR_LENGTH(TRIM(LOWER(word), LOWER(set_of_letters))) = 0;
END;
$$
    LANGUAGE plpgsql;

-- SELECT * FROM fn_is_word_comprised('bobr', 'Rob');
-- SELECT * FROM fn_is_word_comprised('ois tmiah%f', 'halves')

-- 04. Game Over ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_is_game_over(is_game_over BOOL)
    RETURNS TABLE
            (
                name         VARCHAR(50),
                game_type_id INT,
                is_finished  BOOL
            )
AS
$$
BEGIN
    RETURN QUERY
        SELECT g.name
             , g.game_type_id
             , g.is_finished
        FROM games AS g
        WHERE g.is_finished = is_game_over;

END;
$$
    LANGUAGE plpgsql;

-- SELECT * FROM fn_is_game_over(false)

-- 05. Difficulty Level ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_difficulty_level(level INT)
    RETURNS VARCHAR
AS
$$
DECLARE
    difficulty_level VARCHAR;
BEGIN
    IF level <= 40 THEN
        difficulty_level := 'Normal Difficulty';
    ELSIF level > 40 AND level <= 60 THEN
        difficulty_level := 'Nightmare Difficulty';
    ELSE
        difficulty_level := 'Hell Difficulty';
    END IF;
    RETURN difficulty_level;
END;
$$
    LANGUAGE plpgsql
;
SELECT user_id
     , level
     , cash
     , fn_difficulty_level(level) AS difficulty_level
FROM users_games
ORDER BY user_id
;

-- 06. Cash in User Games Odd Rows ----------------------------------------------------------------

CREATE OR REPLACE FUNCTION fn_cash_in_users_games(game_name VARCHAR(50))
    RETURNS TABLE
            (
                total_cash NUMERIC
            )
AS
$$
BEGIN
    RETURN QUERY
        WITH sorted_table
                 AS
                 (SELECT u.cash
                       , ROW_NUMBER() OVER (ORDER BY cash DESC) AS order_num
                  FROM users_games AS u
                           JOIN
                       games AS g
                       ON
                           g.id = u.game_id
                  WHERE g.name = game_name)
        SELECT TRUNC(SUM(sorted_table.cash), 2) AS total_cash
        FROM sorted_table
        WHERE order_num % 2 <> 0;
END;
$$
    LANGUAGE plpgsql

-- SELECT
-- fn_cash_in_users_games('Love in a mist')
-- fn_cash_in_users_games('Delphinium Pacific Giant')

-- 07. Retrieving Account Holders --------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_retrieving_holders_with_balance_higher_than(
    searched_balance NUMERIC
)
AS
$$
DECLARE
    holder_info RECORD;
BEGIN
    FOR holder_info IN
        SELECT CONCAT(ah.first_name, ' ', ah.last_name) AS full_name,
               SUM(a.balance)                           AS total_balance
        FROM account_holders AS ah
                 JOIN
             accounts AS a
             ON
                 ah.id = a.account_holder_id
        GROUP BY full_name
        HAVING SUM(a.balance) > searched_balance
        ORDER BY full_name
        LOOP
            RAISE NOTICE '% - %',holder_info.full_name,holder_info.total_balance;
        END LOOP;
END;
$$
    LANGUAGE plpgsql;

CALL sp_retrieving_holders_with_balance_higher_than(200000);

-- 08. Deposit Money ----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_deposit_money(account_id INT, money_amount NUMERIC(1000, 4))
AS
$$
BEGIN
    UPDATE accounts
    SET balance = balance + money_amount
    WHERE id = account_id;
END;
$$
    LANGUAGE plpgsql;

-- CALL sp_deposit_money(10,500);

-- 09. Withdraw Money ----------------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_withdraw_money(account_id INT, money_amount NUMERIC(1000, 4))
AS
$$
DECLARE
    new_balance NUMERIC;
BEGIN
    UPDATE accounts
    SET balance = balance - money_amount
    WHERE id = account_id;
    SELECT balance FROM accounts WHERE id = account_id INTO new_balance;
    IF new_balance < 0
    THEN
        RAISE NOTICE 'Insufficient balance to withdraw %', money_amount;
        ROLLBACK;
    END IF;
END;
$$
    LANGUAGE plpgsql;

-- CALL sp_withdraw_money(6,5437.0000);
-- SELECT * FROM accounts WHERE ID = 6;

-- 10. Money Transfer --------------------------------------------------------

CREATE OR REPLACE PROCEDURE sp_transfer_money(
	sender_id INT,
	receiver_id INT,
	amount NUMERIC(1000,4)
) AS
$$
DECLARE
	old_ballance NUMERIC;
	current_ballance NUMERIC;
BEGIN
	SELECT balance FROM accounts WHERE id = sender_id INTO old_ballance;
	CALL sp_withdraw_money(sender_id,amount);
	SELECT balance FROM accounts WHERE id = sender_id INTO current_ballance;
	CALL sp_deposit_money(receiver_id, amount);
	IF old_ballance = current_ballance THEN ROLLBACK;
	END IF;
END;
$$
LANGUAGE plpgsql;

-- CALL sp_transfer_money(10,2,1043.9000);

-- 11. Delete Procedure ----------------------------------------------------------------

DROP PROCEDURE sp_retrieving_holders_with_balance_higher_than;

-- 12. Log Accounts Trigger ----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS logs(
	id SERIAL PRIMARY KEY
	,account_id INT
	,old_sum NUMERIC(19,4)
	,new_sum NUMERIC(19,4)
);

CREATE OR REPLACE FUNCTION trigger_fn_insert_new_entry_into_logs()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO logs(
	account_id
	,old_sum
	,new_sum)
	VALUES(
	new.id
	,old.balance
	,new.balance);
	RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_account_balance_change
AFTER UPDATE OF balance ON accounts
FOR EACH ROW
WHEN (NEW.balance <> OLD.balance)
EXECUTE PROCEDURE trigger_fn_insert_new_entry_into_logs();

-- CALL sp_transfer_money(5,4,5)

-- SELECT * FROM logs
-- SELECT * FROM accounts

-- 13. Notification Email on Balance Change ----------------------------------------------------------------

CREATE TABLE IF NOT EXISTS notification_emails(
	id SERIAL PRIMARY KEY
	,recipient_id INT
	,subject VARCHAR(255)
	,body TEXT
);

CREATE OR REPLACE FUNCTION trigger_fn_send_email_on_balance_change()
RETURNS TRIGGER AS
$$
BEGIN
	INSERT INTO notification_emails(
		recipient_id
		,subject
		,body
		)
	VALUES(
		new.account_id
		,CONCAT('Balance change for account: ', new.account_id)
		,CONCAT('On ', CURRENT_DATE,' your balance was changed from ', new.old_sum,' to ', new.new_sum,'.')
		);
	RETURN new;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER tr_send_email_on_balance_change
AFTER UPDATE ON logs
FOR EACH ROW
WHEN (OLD.new_sum <> NEW.new_sum OR OLD.old_sum <> NEW.old_sum )
EXECUTE PROCEDURE trigger_fn_send_email_on_balance_change();


UPDATE logs
	SET new_sum = 100
WHERE
	account_id =11;

SELECT * FROM notification_emails;
SELECT * FROM logs;