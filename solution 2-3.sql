WITH ClassAveragePositions AS (
    SELECT
        c.class,
        AVG(r.position) AS avg_position
    FROM
        Results r
    JOIN
        Cars ca ON r.car = ca.name
    JOIN
        Classes c ON ca.class = c.class
    GROUP BY
        c.class
),
MinAveragePosition AS (
    SELECT
        MIN(avg_position) AS min_avg_position
    FROM
        ClassAveragePositions
)
SELECT
    ca.name AS car_name,
    AVG(r.position) AS average_position,
    COUNT(r.race) AS races_count,
    c.country,
    (SELECT COUNT(*) FROM Results r2 JOIN Cars ca2 ON r2.car = ca2.name JOIN Classes c2 ON ca2.class = c2.class WHERE c2.class = cap.class) AS total_races_in_class
FROM
    Results r
JOIN
    Cars ca ON r.car = ca.name
JOIN
    Classes c ON ca.class = c.class
JOIN
    ClassAveragePositions cap ON c.class = cap.class
JOIN
    MinAveragePosition map ON cap.avg_position = map.min_avg_position
GROUP BY
    ca.name, c.class, c.country, cap.class
ORDER BY
    average_position;
