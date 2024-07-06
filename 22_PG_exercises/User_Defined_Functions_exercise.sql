-- Welcome message
DROP FUNCTION IF EXISTS welcome_message(VARCHAR(50));
CREATE OR REPLACE FUNCTION welcome_message(name VARCHAR(50))
RETURNS TEXT
AS
$$
BEGIN
    RETURN CONCAT('Welcome, ', name, '!');
END
$$
LANGUAGE plpgsql;

SELECT welcome_message('Ivan') AS message;

-- Temperature Conversion Fahrenheit to Celsius and Celsius to Fahrenheit

DROP FUNCTION IF EXISTS conv_f_to_c(fahrenheit NUMERIC(10,2));

CREATE OR REPLACE FUNCTION conv_f_to_c(fahrenheit NUMERIC(10,2))
RETURNS NUMERIC(10,2)
AS
$$
BEGIN
    RETURN ((fahrenheit - 32)*5/9)::NUMERIC(10,2);

END
$$
LANGUAGE plpgsql;

SELECT conv_f_to_c(100.4) as celsius;

DROP FUNCTION IF EXISTS conv_c_to_f(celsius NUMERIC(10,2));

CREATE OR REPLACE FUNCTION conv_c_to_f(celsius NUMERIC(10,2))
RETURNS NUMERIC(10,2)
AS
$$
BEGIN
    RETURN ((celsius*9/5)+32)::NUMERIC(10,2);

END
$$
LANGUAGE plpgsql;

SELECT conv_c_to_f(38) as fahrenheit

