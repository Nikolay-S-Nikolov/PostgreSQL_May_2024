SELECT p.title,
       CASE
           WHEN pi.rating <= 3.50 THEN 'poor'
           WHEN pi.rating <= 8.00 THEN 'good'
           ELSE 'excellent'
           END            AS rating,
       CASE
           WHEN pi.has_subtitles = TRUE THEN 'Bulgarian'
           ELSE 'N/A'
           END            AS subtitles,
       COUNT(pa.actor_id) AS actors_count
FROM productions_info AS pi
         JOIN productions AS p
              ON p.production_info_id = pi.id
         JOIN productions_actors as pa
              ON pa.production_id = p.id
GROUP BY p.title,pi.rating,pi.has_subtitles
ORDER BY rating, actors_count DESC, title;