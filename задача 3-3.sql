WITH HotelCategories AS (
    SELECT
        h.ID_hotel,
        h.name AS hotel_name,
        AVG(r.price) AS avg_price,
        CASE
            WHEN AVG(r.price) < 175 THEN 'Дешевый'
            WHEN AVG(r.price) BETWEEN 175 AND 300 THEN 'Средний'
            ELSE 'Дорогой'
        END AS hotel_category
    FROM
        Hotel h
    JOIN
        Room r ON h.ID_hotel = r.ID_hotel
    GROUP BY
        h.ID_hotel, h.name
),
CustomerHotelPreferences AS (
    SELECT
        c.ID_customer,
        c.name,
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM Booking b
                JOIN Room r ON b.ID_room = r.ID_room
                JOIN Hotel h ON r.ID_hotel = h.ID_hotel
                JOIN HotelCategories hc ON h.ID_hotel = hc.ID_hotel
                WHERE b.ID_customer = c.ID_customer AND hc.hotel_category = 'Дорогой'
            ) THEN 'Дорогой'
            WHEN EXISTS (
                SELECT 1
                FROM Booking b
                JOIN Room r ON b.ID_room = r.ID_room
                JOIN Hotel h ON r.ID_hotel = h.ID_hotel
                JOIN HotelCategories hc ON h.ID_hotel = hc.ID_hotel
                WHERE b.ID_customer = c.ID_customer AND hc.hotel_category = 'Средний'
            ) THEN 'Средний'
            ELSE 'Дешевый'
        END AS preferred_hotel_type,
         (
            SELECT GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ')
            FROM Booking b2
            JOIN Room r2 ON b2.ID_room = r2.ID_room
            JOIN Hotel h ON r2.ID_hotel = h.ID_hotel
            WHERE b2.ID_customer = c.ID_customer
        ) AS visited_hotels
    FROM
        Customer c
)
SELECT
    chp.ID_customer,
    chp.name,
    chp.preferred_hotel_type,
    chp.visited_hotels
FROM
    CustomerHotelPreferences chp
ORDER BY
    CASE
        WHEN chp.preferred_hotel_type = 'Дешевый' THEN 1
        WHEN chp.preferred_hotel_type = 'Средний' THEN 2
        ELSE 3
    END;
