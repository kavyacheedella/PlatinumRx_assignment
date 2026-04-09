# PlatinumRx Data Analyst Assignment

## Folder Structure
```
Data_Analyst_Assignment/
├── SQL/
│   ├── 01_Hotel_Schema_Setup.sql
│   ├── 02_Hotel_Queries.sql
│   ├── 03_Clinic_Schema_Setup.sql
│   └── 04_Clinic_Queries.sql
├── Spreadsheets/
│   └── Ticket_Analysis.xlsx
├── Python/
│   ├── 01_Time_Converter.py
│   └── 02_Remove_Duplicates.py
└── README.md
```

---

## Phase 1 — SQL

### Part A: Hotel Management System

**Schema:** `users`, `bookings`, `items`, `booking_commercials`

| Q# | Question | Approach |
|----|----------|----------|
| Q1 | Last booked room per user | Correlated subquery with `ORDER BY booking_date DESC LIMIT 1`; also shown with `ROW_NUMBER()` |
| Q2 | Total billing per booking — November 2021 | JOIN all three tables, `SUM(item_quantity * item_rate)`, filter `YEAR=2021 MONTH=11` |
| Q3 | Bills > 1000 in October 2021 | GROUP BY `bill_id`, HAVING `SUM > 1000` |
| Q4 | Most & least ordered item per month | CTE + `RANK() OVER (PARTITION BY month ORDER BY qty DESC/ASC)` |
| Q5 | Customer with 2nd highest bill per month | CTE + `DENSE_RANK() OVER (PARTITION BY month ORDER BY total DESC)`, pick rank = 2 |

### Part B: Clinic Management System

**Schema:** `clinics`, `customer`, `clinic_sales`, `expenses`

| Q# | Question | Approach |
|----|----------|----------|
| Q1 | Revenue by sales channel | `GROUP BY sales_channel`, `SUM(amount)` |
| Q2 | Top 10 customers | JOIN customer, `GROUP BY uid`, `ORDER BY SUM DESC LIMIT 10` |
| Q3 | Monthly revenue / expense / profit / status | Two CTEs for revenue & expense aggregated by month, UNION-based FULL JOIN, `CASE WHEN profit >= 0` |
| Q4 | Most profitable clinic per city per month | Profit CTE + `RANK() OVER (PARTITION BY city ORDER BY profit DESC)` |
| Q5 | 2nd least profitable clinic per state | Profit CTE + `DENSE_RANK() OVER (PARTITION BY state ORDER BY profit ASC)`, pick rank = 2 |

---

## Phase 2 — Spreadsheets

**File:** `Spreadsheets/Ticket_Analysis.xlsx`  
**Sheets:** `ticket`, `feedbacks`, `Analysis`, `Formula Notes`

### Q1 — Populate `ticket_created_at`
Used **INDEX-MATCH** instead of VLOOKUP because the lookup column (`cms_id`) is to the **right** of the return column (`created_at`) in the ticket sheet — VLOOKUP cannot look left.

```
=IFERROR(INDEX(ticket!$B:$B, MATCH(A3, ticket!$E:$E, 0)), "Not Found")
```

### Q2a — Same Day Count per Outlet
Helper column: `=IF(INT(created_at) = INT(closed_at), "Yes", "No")`  
`INT()` strips the time, leaving only the date serial for comparison.  
Summary: `=COUNTIFS(outlet_col, outlet_id, sameday_col, "Yes")`

### Q2b — Same Hour Count per Outlet
Helper column: `=IF(AND(INT(created_at)=INT(closed_at), HOUR(created_at)=HOUR(closed_at)), "Yes", "No")`  
Summary: `=COUNTIFS(outlet_col, outlet_id, samehour_col, "Yes")`

---

## Phase 3 — Python

### Script 1: `01_Time_Converter.py`
Converts integer minutes → human-readable string.
```python
hours = total_minutes // 60
remaining = total_minutes % 60
# Output: "2 hrs 10 minutes"
```

### Script 2: `02_Remove_Duplicates.py`
Removes duplicate characters using a `for` loop and a running result string.
```python
result = ""
for char in input_string:
    if char not in result:
        result += char
```

---

## Tools Used
- **SQL:** MySQL 8.x (compatible with PostgreSQL with minor syntax changes)
- **Spreadsheets:** Microsoft Excel / Google Sheets (openpyxl for generation)
- **Python:** Python 3.x
