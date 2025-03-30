WITH HighSpendingCustomers AS (
    SELECT
        c.ID_customer,
        c.name,
        SUM(r.price) AS total_spent,
        COUNT(DISTINCT b.ID_booking) AS total_bookings
    FROM
        Customer c
    JOIN
        Booking b ON c.ID_customer = b.ID_customer
    JOIN
        Room r ON b.ID_room = r.ID_room
    GROUP BY
        c.ID_customer, c.name
    HAVING
        SUM(r.price) > 500
),
MultiHotelBookers AS (
    SELECT
        c.ID_customer,
        c.name,
        COUNT(DISTINCT b.ID_booking) AS total_bookings,
        COUNT(DISTINCT h.ID_hotel) AS total_unique_hotels,
        SUM(r.price) AS total_spent
    FROM
        Customer c
    JOIN
        Booking b ON c.ID_customer = b.ID_customer
    JOIN
        Room r ON b.ID_room = r.ID_room
    JOIN
        Hotel h ON r.ID_hotel = h.ID_hotel
    GROUP BY
        c.ID_customer, c.name
    HAVING
        COUNT(DISTINCT b.ID_booking) > 2 AND COUNT(DISTINCT h.ID_hotel) > 1
)
SELECT
    mhb.ID_customer,
    mhb.name,
    mhb.total_bookings,
    hsc.total_spent,
    mhb.total_unique_hotels
FROM
    MultiHotelBookers mhb
JOIN
    HighSpendingCustomers hsc ON mhb.ID_customer = hsc.ID_customer
ORDER BY
    hsc.total_spent ASC;
