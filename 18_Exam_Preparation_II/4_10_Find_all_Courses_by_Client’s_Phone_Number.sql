CREATE OR REPLACE FUNCTION fn_courses_by_client(
    phone_num VARCHAR(20)
)
RETURNS INT
AS
$$
    BEGIN
        RETURN COALESCE((SELECT
                    COUNT(*)
                FROM
                    clients AS cl
                JOIN
                    courses c
                ON
                    cl.id = c.client_id
                WHERE cl.phone_number = phone_num
                GROUP BY
                    cl.id),0);

    END;
$$
LANGUAGE plpgsql;

-- select fn_courses_by_client('(803) 6386812')
-- select fn_courses_by_client('(831) 1391236')
-- select fn_courses_by_client('(704) 2502909')
