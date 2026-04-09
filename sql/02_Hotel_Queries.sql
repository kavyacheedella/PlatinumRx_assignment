-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part A
-- Hotel Management System: Query Solutions (Q1 to Q5)
-- ============================================================


-- -----------------------------------------------
-- Q1. For every user, get user_id and last booked room_no
-- -----------------------------------------------
-- Logic: Join users -> bookings. For each user, pick the booking
--        with the MAX(booking_date). Use a subquery or window function.
-- -----------------------------------------------
USE platinum_db;
SELECT
    u.user_id,
    u.name,
    b.room_no  AS last_booked_room
FROM users u
JOIN bookings b
    ON b.booking_id = (
        SELECT booking_id
        FROM   bookings
        WHERE  user_id = u.user_id
        ORDER  BY booking_date DESC
        LIMIT  1
    );

-- Alternative using ROW_NUMBER (MySQL 8+ / PostgreSQL):
-- SELECT user_id, name, room_no AS last_booked_room
-- FROM (
--     SELECT u.user_id, u.name, b.room_no,
--            ROW_NUMBER() OVER (PARTITION BY u.user_id ORDER BY b.booking_date DESC) AS rn
--     FROM users u
--     JOIN bookings b ON b.user_id = u.user_id
-- ) ranked
-- WHERE rn = 1;


-- -----------------------------------------------
-- Q2. Get booking_id and total billing amount of every
--     booking created in November 2021
-- -----------------------------------------------
-- Logic: Join bookings -> booking_commercials -> items
--        Filter by YEAR=2021, MONTH=11 on booking_date
--        Total amount = SUM(item_quantity * item_rate)
-- -----------------------------------------------

SELECT
    b.booking_id,
    SUM(bc.item_quantity * i.item_rate)  AS total_billing_amount
FROM bookings b
JOIN booking_commercials bc ON bc.booking_id = b.booking_id
JOIN items i                ON i.item_id     = bc.item_id
WHERE YEAR(b.booking_date)  = 2021
  AND MONTH(b.booking_date) = 11
GROUP BY b.booking_id;


-- -----------------------------------------------
-- Q3. Get bill_id and bill amount of all bills raised
--     in October 2021 having bill amount > 1000
-- -----------------------------------------------
-- Logic: Group booking_commercials by bill_id
--        Filter YEAR=2021, MONTH=10 on bill_date
--        Use HAVING to keep only totals > 1000
-- -----------------------------------------------

SELECT
    bc.bill_id,
    SUM(bc.item_quantity * i.item_rate)  AS bill_amount
FROM booking_commercials bc
JOIN items i ON i.item_id = bc.item_id
WHERE YEAR(bc.bill_date)  = 2021
  AND MONTH(bc.bill_date) = 10
GROUP BY bc.bill_id
HAVING bill_amount > 1000;


-- -----------------------------------------------
-- Q4. Most ordered and least ordered item each month
--     of year 2021
-- -----------------------------------------------
-- Logic: Group by month + item, SUM quantity.
--        Use RANK() OVER (PARTITION BY month ORDER BY qty DESC/ASC)
--        to find rank-1 for most and least.
-- -----------------------------------------------

WITH monthly_item_qty AS (
    SELECT
        MONTH(bc.bill_date)      AS order_month,
        i.item_name,
        SUM(bc.item_quantity)    AS total_qty
    FROM booking_commercials bc
    JOIN items i ON i.item_id = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), i.item_name
),
ranked AS (
    SELECT
        order_month,
        item_name,
        total_qty,
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty DESC) AS rank_desc,
        RANK() OVER (PARTITION BY order_month ORDER BY total_qty ASC)  AS rank_asc
    FROM monthly_item_qty
)
SELECT
    order_month,
    MAX(CASE WHEN rank_desc = 1 THEN item_name END)  AS most_ordered_item,
    MAX(CASE WHEN rank_asc  = 1 THEN item_name END)  AS least_ordered_item
FROM ranked
WHERE rank_desc = 1 OR rank_asc = 1
GROUP BY order_month
ORDER BY order_month;


-- -----------------------------------------------
-- Q5. Customers with the 2nd highest bill value
--     each month of year 2021
-- -----------------------------------------------
-- Logic: Compute per-user per-month total bill.
--        RANK() OVER (PARTITION BY month ORDER BY total DESC)
--        Pick rank = 2.
-- -----------------------------------------------

WITH user_monthly_bill AS (
    SELECT
        MONTH(bc.bill_date)          AS bill_month,
        b.user_id,
        u.name,
        SUM(bc.item_quantity * i.item_rate) AS total_bill
    FROM booking_commercials bc
    JOIN bookings b ON b.booking_id = bc.booking_id
    JOIN users    u ON u.user_id    = b.user_id
    JOIN items    i ON i.item_id    = bc.item_id
    WHERE YEAR(bc.bill_date) = 2021
    GROUP BY MONTH(bc.bill_date), b.user_id, u.name
),
ranked AS (
    SELECT
        bill_month,
        user_id,
        name,
        total_bill,
        DENSE_RANK() OVER (PARTITION BY bill_month ORDER BY total_bill DESC) AS rnk
    FROM user_monthly_bill
)
SELECT
    bill_month,
    user_id,
    name,
    total_bill  AS second_highest_bill
FROM ranked
WHERE rnk = 2
ORDER BY bill_month;
