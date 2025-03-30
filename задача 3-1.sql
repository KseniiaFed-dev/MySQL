SELECT
    c.name AS customer_name,
    c.email,
    c.phone,
    COUNT(DISTINCT b.ID_booking) AS total_bookings,
    GROUP_CONCAT(DISTINCT h.name ORDER BY h.name SEPARATOR ', ') AS hotels_booked,
    AVG(DATEDIFF(b.check_out_date, b.check_in_date)) AS average_stay_duration
FROM
    Customer c
JOIN
    Booking b ON c.ID_customer = b.ID_customer
JOIN
    Room r ON b.ID_room = r.ID_room
JOIN
    Hotel h ON r.ID_hotel = h.ID_hotel
GROUP BY
    c.ID_customer
HAVING
    COUNT(DISTINCT h.ID_hotel) >= 2  
ORDER BY
    total_bookings DESC;
