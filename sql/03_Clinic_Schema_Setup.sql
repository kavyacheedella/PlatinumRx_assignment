-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part B
-- Clinic Management System: Schema Setup & Sample Data
-- ============================================================

DROP TABLE IF EXISTS expenses;
DROP TABLE IF EXISTS clinic_sales;
DROP TABLE IF EXISTS customer;
DROP TABLE IF EXISTS clinics;

-- -----------------------------------------------
-- TABLE: clinics
-- -----------------------------------------------
CREATE TABLE clinics (
    cid         VARCHAR(50) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city        VARCHAR(50),
    state       VARCHAR(50),
    country     VARCHAR(50)
);

-- -----------------------------------------------
-- TABLE: customer
-- -----------------------------------------------
CREATE TABLE customer (
    uid    VARCHAR(50) PRIMARY KEY,
    name   VARCHAR(100),
    mobile VARCHAR(15)
);

-- -----------------------------------------------
-- TABLE: clinic_sales
-- -----------------------------------------------
CREATE TABLE clinic_sales (
    oid          VARCHAR(50) PRIMARY KEY,
    uid          VARCHAR(50),
    cid          VARCHAR(50),
    amount       DECIMAL(10, 2),
    datetime     DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- -----------------------------------------------
-- TABLE: expenses
-- -----------------------------------------------
CREATE TABLE expenses (
    eid         VARCHAR(50) PRIMARY KEY,
    cid         VARCHAR(50),
    description VARCHAR(200),
    amount      DECIMAL(10, 2),
    datetime    DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO clinics VALUES
('cnc-001', 'HealthPlus Clinic',    'Mumbai',    'Maharashtra', 'India'),
('cnc-002', 'MediCare Clinic',      'Pune',      'Maharashtra', 'India'),
('cnc-003', 'CareFirst Clinic',     'Hyderabad', 'Telangana',   'India'),
('cnc-004', 'WellNess Clinic',      'Warangal',  'Telangana',   'India'),
('cnc-005', 'LifeLine Clinic',      'Chennai',   'Tamil Nadu',  'India'),
('cnc-006', 'SunRise Clinic',       'Coimbatore','Tamil Nadu',  'India');

INSERT INTO customer VALUES
('cust-001', 'Ravi Kumar',   '9800000001'),
('cust-002', 'Anjali Sharma','9800000002'),
('cust-003', 'Priya Nair',   '9800000003'),
('cust-004', 'Deepak Reddy', '9800000004'),
('cust-005', 'Sita Devi',    '9800000005'),
('cust-006', 'Arjun Rao',    '9800000006'),
('cust-007', 'Meera Das',    '9800000007'),
('cust-008', 'Vikram Singh', '9800000008'),
('cust-009', 'Lakshmi Bai',  '9800000009'),
('cust-010', 'Suresh Patel', '9800000010'),
('cust-011', 'Kiran Raj',    '9800000011');

INSERT INTO clinic_sales VALUES
('ord-001','cust-001','cnc-001',24999,'2021-01-10 10:00:00','online'),
('ord-002','cust-002','cnc-001',15000,'2021-01-15 11:00:00','offline'),
('ord-003','cust-003','cnc-002',18500,'2021-02-05 09:00:00','online'),
('ord-004','cust-004','cnc-002',22000,'2021-02-20 10:30:00','partner'),
('ord-005','cust-005','cnc-003',9500, '2021-03-12 14:00:00','online'),
('ord-006','cust-006','cnc-003',13000,'2021-03-25 15:30:00','offline'),
('ord-007','cust-001','cnc-001',30000,'2021-04-08 10:00:00','online'),
('ord-008','cust-007','cnc-004',11000,'2021-04-18 11:00:00','partner'),
('ord-009','cust-008','cnc-005',25000,'2021-05-03 09:00:00','online'),
('ord-010','cust-009','cnc-005',17000,'2021-05-20 13:00:00','offline'),
('ord-011','cust-010','cnc-006',8000, '2021-06-06 10:00:00','online'),
('ord-012','cust-011','cnc-006',21000,'2021-06-22 14:00:00','partner'),
('ord-013','cust-001','cnc-003',35000,'2021-07-14 10:00:00','online'),
('ord-014','cust-002','cnc-004',14000,'2021-07-28 11:00:00','offline'),
('ord-015','cust-003','cnc-001',19500,'2021-08-09 09:00:00','online'),
('ord-016','cust-004','cnc-002',27000,'2021-08-22 15:00:00','partner'),
('ord-017','cust-005','cnc-005',16000,'2021-09-05 10:00:00','online'),
('ord-018','cust-006','cnc-006',12500,'2021-09-19 12:00:00','offline'),
('ord-019','cust-007','cnc-001',23000,'2021-10-07 10:00:00','online'),
('ord-020','cust-008','cnc-002',18000,'2021-10-21 11:00:00','partner'),
('ord-021','cust-009','cnc-003',29000,'2021-11-03 09:00:00','online'),
('ord-022','cust-010','cnc-004',9000, '2021-11-17 14:00:00','offline'),
('ord-023','cust-011','cnc-005',31000,'2021-12-01 10:00:00','online'),
('ord-024','cust-001','cnc-006',22000,'2021-12-18 11:00:00','partner');

INSERT INTO expenses VALUES
('exp-001','cnc-001','Salaries',         8000, '2021-01-31 00:00:00'),
('exp-002','cnc-001','Medical Supplies',  3000, '2021-02-28 00:00:00'),
('exp-003','cnc-002','Rent',             5000, '2021-02-28 00:00:00'),
('exp-004','cnc-002','Utilities',        2000, '2021-03-31 00:00:00'),
('exp-005','cnc-003','First-Aid Supplies',557, '2021-03-31 00:00:00'),
('exp-006','cnc-003','Salaries',         7000, '2021-04-30 00:00:00'),
('exp-007','cnc-004','Rent',             4000, '2021-04-30 00:00:00'),
('exp-008','cnc-005','Equipment',        6000, '2021-05-31 00:00:00'),
('exp-009','cnc-005','Utilities',        1500, '2021-06-30 00:00:00'),
('exp-010','cnc-006','Salaries',         5500, '2021-06-30 00:00:00'),
('exp-011','cnc-001','Maintenance',      2500, '2021-07-31 00:00:00'),
('exp-012','cnc-002','Medical Supplies', 3500, '2021-08-31 00:00:00'),
('exp-013','cnc-003','Rent',             4500, '2021-09-30 00:00:00'),
('exp-014','cnc-004','Utilities',        1800, '2021-10-31 00:00:00'),
('exp-015','cnc-005','Salaries',         7500, '2021-11-30 00:00:00'),
('exp-016','cnc-006','Equipment',        4000, '2021-12-31 00:00:00');
