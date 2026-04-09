-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part B
-- Clinic Management System: Query Solutions (Q1 to Q5)
-- ============================================================



-- -----------------------------------------------
-- Q1. Revenue from each sales channel in a given year
-- -----------------------------------------------
-- Logic: Simple GROUP BY on sales_channel with SUM(amount).
--        Filter by YEAR(datetime).
-- -----------------------------------------------

SELECT
    sales_channel,
    SUM(amount)  AS total_revenue
FROM clinic_sales
WHERE YEAR(datetime) = 2021        -- Change year as needed
GROUP BY sales_channel
ORDER BY total_revenue DESC;


-- -----------------------------------------------
-- Q2. Top 10 most valuable customers for a given year
-- -----------------------------------------------
-- Logic: GROUP BY customer uid, SUM(amount).
--        Join customer table for names.
--        ORDER BY total DESC, LIMIT 10.
-- -----------------------------------------------

SELECT
    cs.uid,
    c.name,
    c.mobile,
    SUM(cs.amount)  AS total_spend
FROM clinic_sales cs
JOIN customer c ON c.uid = cs.uid
WHERE YEAR(cs.datetime) = 2021     -- Change year as needed
GROUP BY cs.uid, c.name, c.mobile
ORDER BY total_spend DESC
LIMIT 10;


-- -----------------------------------------------
-- Q3. Month-wise revenue, expense, profit and
--     profit/loss status for a given year
-- -----------------------------------------------
-- Logic:
--   - Aggregate revenue per month from clinic_sales
--   - Aggregate expenses per month from expenses
--   - FULL JOIN (or LEFT JOIN + UNION) on month
--   - Profit = Revenue - Expense
--   - Status = CASE WHEN profit >= 0 THEN 'Profitable' ELSE 'Not-Profitable'
-- -----------------------------------------------

WITH monthly_revenue AS (
    SELECT
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
),
monthly_expense AS (
    SELECT
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021
    GROUP BY MONTH(datetime)
)
SELECT
    COALESCE(r.month_num, e.month_num)  AS month_number,
    COALESCE(r.revenue,  0)             AS total_revenue,
    COALESCE(e.expense,  0)             AS total_expense,
    COALESCE(r.revenue,  0) - COALESCE(e.expense, 0)  AS profit,
    CASE
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) >= 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END  AS status
FROM monthly_revenue  r
LEFT  JOIN monthly_expense e ON e.month_num = r.month_num
UNION
SELECT
    COALESCE(r.month_num, e.month_num),
    COALESCE(r.revenue,  0),
    COALESCE(e.expense,  0),
    COALESCE(r.revenue,  0) - COALESCE(e.expense, 0),
    CASE
        WHEN COALESCE(r.revenue, 0) - COALESCE(e.expense, 0) >= 0
        THEN 'Profitable'
        ELSE 'Not-Profitable'
    END
FROM monthly_expense  e
LEFT  JOIN monthly_revenue  r ON r.month_num = e.month_num
ORDER BY month_number;


-- -----------------------------------------------
-- Q4. For each city, find the most profitable clinic
--     for a given month
-- -----------------------------------------------
-- Logic:
--   - Join clinic_sales + expenses per clinic per month
--   - Calculate profit = revenue - expense per clinic
--   - RANK() OVER (PARTITION BY city ORDER BY profit DESC)
--   - Pick rank = 1
-- -----------------------------------------------

WITH clinic_revenue AS (
    SELECT
        cid,
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 10   -- Change month as needed
    GROUP BY cid, MONTH(datetime)
),
clinic_expense AS (
    SELECT
        cid,
        MONTH(datetime)  AS month_num,
        SUM(amount)      AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 10
    GROUP BY cid, MONTH(datetime)
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)  AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON r.cid = cl.cid
    LEFT JOIN clinic_expense e ON e.cid = cl.cid
),
ranked AS (
    SELECT
        *,
        RANK() OVER (PARTITION BY city ORDER BY profit DESC) AS rnk
    FROM clinic_profit
)
SELECT
    city,
    cid,
    clinic_name,
    state,
    profit  AS highest_profit
FROM ranked
WHERE rnk = 1
ORDER BY city;


-- -----------------------------------------------
-- Q5. For each state, find the second least profitable
--     clinic for a given month
-- -----------------------------------------------
-- Logic: Same as Q4 but:
--        RANK() OVER (PARTITION BY state ORDER BY profit ASC)
--        Pick rank = 2 (second least)
-- -----------------------------------------------

WITH clinic_revenue AS (
    SELECT
        cid,
        SUM(amount)  AS revenue
    FROM clinic_sales
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 10   -- Change month as needed
    GROUP BY cid
),
clinic_expense AS (
    SELECT
        cid,
        SUM(amount)  AS expense
    FROM expenses
    WHERE YEAR(datetime) = 2021 AND MONTH(datetime) = 10
    GROUP BY cid
),
clinic_profit AS (
    SELECT
        cl.cid,
        cl.clinic_name,
        cl.city,
        cl.state,
        COALESCE(r.revenue, 0) - COALESCE(e.expense, 0)  AS profit
    FROM clinics cl
    LEFT JOIN clinic_revenue r ON r.cid = cl.cid
    LEFT JOIN clinic_expense e ON e.cid = cl.cid
),
ranked AS (
    SELECT
        *,
        DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC) AS rnk
    FROM clinic_profit
)
SELECT
    state,
    cid,
    clinic_name,
    city,
    profit  AS second_least_profit
FROM ranked
WHERE rnk = 2
ORDER BY state;
