SELECT
    a.name
    ,TO_CHAR(a.birthdate,'YYYY')A
    ,t.animal_type
FROM animals AS a
JOIN animal_types t
    ON t.id = a.animal_type_id
WHERE t.animal_type <> 'Birds'
    AND AGE( '01/01/2022',a.birthdate) < '5 years'
    AND a.owner_id IS NULL
ORDER BY a.name