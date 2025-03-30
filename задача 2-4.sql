SELECT
    ca.name AS car_name,
    c.class,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS races_count,
    c.country
FROM
    Results r
JOIN
    Cars ca ON r.car = ca.name
JOIN
    Classes c ON ca.class = c.class
WHERE EXISTS (
    SELECT 1
    FROM Cars ca2
    WHERE ca2.class = c.class
    GROUP BY ca2.class
    HAVING COUNT(*) >= 2  -- Ensure there are at least two cars in the class
)
GROUP BY
    ca.name, c.class, c.country
HAVING
    AVG(r.position) < (
        SELECT AVG(r2.position)
        FROM Results r2
        JOIN Cars ca2 ON r2.car = ca2.name
        WHERE ca2.class = c.class
    )
ORDER BY
    c.class, average_position;
