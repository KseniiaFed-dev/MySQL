SELECT
    c.class,
    ca.name AS car_name,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS races_count,
    c.country
FROM
    Results r
JOIN
    Cars ca ON r.car = ca.name
JOIN
    Classes c ON ca.class = c.class
GROUP BY
    c.class, ca.name, c.country
ORDER BY
    AVG(r.position) ASC, ca.name ASC  -- Сначала сортируем по средней позиции, затем по имени
LIMIT 1;
