CREATE OR REPLACE PROCEDURE udp_awarded_production(
    production_title VARCHAR(70)
)
AS
$$
BEGIN
    UPDATE actors
    SET awards = awards + 1
    WHERE id IN (SELECT pa.actor_id
                 FROM productions_actors AS pa
                    JOIN productions as p
                        ON pa.production_id = p.id
                 WHERE p.title = production_title);

END
$$
    LANGUAGE plpgsql;

CALL udp_awarded_production('Tea For Two');

SELECT *
FROM actors
WHERE id IN (SELECT pa.actor_id
             FROM productions_actors AS pa
                      JOIN productions as p
                           ON pa.production_id = p.id
             WHERE p.title = 'Tea For Two');

