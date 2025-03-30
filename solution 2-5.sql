WITH LowAvgPositionCars AS (
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
    HAVING
        AVG(r.position) > 3.0
),
ClassCounts AS (
    SELECT
        class,
        COUNT(*) AS low_avg_pos_car_count,
        (SELECT COUNT(*) FROM Results r2 JOIN Cars ca2 ON r2.car = ca2.name WHERE ca2.class = l.class) AS total_races_in_class
    FROM
        LowAvgPositionCars l
    GROUP BY
        class
)
SELECT
    l.car_name,
    l.class,
    l.average_position,
    l.races_count,
    l.country,
    c.total_races_in_class
FROM
    LowAvgPositionCars l
JOIN
    ClassCounts c ON l.class = c.class
ORDER BY
    c.low_avg_pos_car_count DESC;
