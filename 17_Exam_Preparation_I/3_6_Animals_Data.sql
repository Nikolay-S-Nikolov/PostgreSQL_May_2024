SELECT
    a.name
    ,t.animal_type
    ,TO_CHAR(a.birthdate,'DD.MM.YYYY') as birthdate
FROM animals as a
    JOIN public.animal_types t
        ON t.id = a.animal_type_id
ORDER BY a.name
;