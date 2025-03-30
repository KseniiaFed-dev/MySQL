SELECT
    c.class,
    ca.name AS car_name,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS races_count
FROM
    Results r
JOIN
    Cars ca ON r.car = ca.name
JOIN
    Classes c ON ca.class = c.class
GROUP BY
    c.class, ca.name
HAVING
    AVG(r.position) <= ALL (  -- Это подзапрос определяет минимальную среднюю позицию для каждого класса
        SELECT AVG(position)
        FROM Results r2
        JOIN Cars ca2 ON r2.car = ca2.name
        WHERE ca2.class = c.class
        GROUP BY ca2.name
    )
ORDER BY
    average_position;
