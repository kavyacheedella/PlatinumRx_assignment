-- ============================================================
-- PlatinumRx Assignment | Phase 1 - Part A
-- Hotel Management System: Schema Setup & Sample Data
-- ============================================================

-- Drop tables if they already exist (for clean re-runs)
USE platinum_db;
DROP TABLE IF EXISTS booking_commercials;
DROP TABLE IF EXISTS items;
DROP TABLE IF EXISTS bookings;
DROP TABLE IF EXISTS users;

-- -----------------------------------------------
-- TABLE: users
-- -----------------------------------------------
CREATE TABLE users (
    user_id         VARCHAR(50) PRIMARY KEY,
    name            VARCHAR(100),
    phone_number    VARCHAR(15),
    mail_id         VARCHAR(100),
    billing_address VARCHAR(255)
);

-- -----------------------------------------------
-- TABLE: bookings
-- -----------------------------------------------
CREATE TABLE bookings (
    booking_id   VARCHAR(50) PRIMARY KEY,
    booking_date DATETIME,
    room_no      VARCHAR(50),
    user_id      VARCHAR(50),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- -----------------------------------------------
-- TABLE: items
-- -----------------------------------------------
CREATE TABLE items (
    item_id   VARCHAR(50) PRIMARY KEY,
    item_name VARCHAR(100),
    item_rate DECIMAL(10, 2)
);

-- -----------------------------------------------
-- TABLE: booking_commercials
-- -----------------------------------------------
CREATE TABLE booking_commercials (
    id            VARCHAR(50) PRIMARY KEY,
    booking_id    VARCHAR(50),
    bill_id       VARCHAR(50),
    bill_date     DATETIME,
    item_id       VARCHAR(50),
    item_quantity DECIMAL(10, 2),
    FOREIGN KEY (booking_id) REFERENCES bookings(booking_id),
    FOREIGN KEY (item_id)    REFERENCES items(item_id)
);

-- ============================================================
-- SAMPLE DATA INSERTS
-- ============================================================

INSERT INTO users VALUES
('u-001', 'John Doe',   '9700000001', 'john.doe@example.com',   '10, Street A, Mumbai'),
('u-002', 'Jane Smith', '9700000002', 'jane.smith@example.com', '22, Street B, Delhi'),
('u-003', 'Ravi Kumar', '9700000003', 'ravi.k@example.com',     '5, Street C, Hyderabad'),
('u-004', 'Priya Nair', '9700000004', 'priya.n@example.com',    '8, Street D, Chennai');

INSERT INTO items VALUES
('itm-001', 'Tawa Paratha',  18.00),
('itm-002', 'Mix Veg',       89.00),
('itm-003', 'Paneer Tikka', 220.00),
('itm-004', 'Dal Makhani',  150.00),
('itm-005', 'Biryani',      280.00),
('itm-006', 'Cold Coffee',   80.00),
('itm-007', 'Masala Tea',    30.00),
('itm-008', 'Fried Rice',   160.00);

INSERT INTO bookings VALUES
('bk-001', '2021-09-15 10:00:00', 'rm-101', 'u-001'),
('bk-002', '2021-09-23 07:36:48', 'rm-102', 'u-001'),
('bk-003', '2021-10-05 14:00:00', 'rm-103', 'u-002'),
('bk-004', '2021-10-18 09:30:00', 'rm-104', 'u-003'),
('bk-005', '2021-11-02 11:00:00', 'rm-101', 'u-002'),
('bk-006', '2021-11-14 15:00:00', 'rm-105', 'u-004'),
('bk-007', '2021-11-28 08:00:00', 'rm-102', 'u-001'),
('bk-008', '2021-12-01 12:00:00', 'rm-106', 'u-003'),
('bk-009', '2021-12-20 16:00:00', 'rm-107', 'u-004'),
('bk-010', '2021-10-25 10:00:00', 'rm-103', 'u-001');

INSERT INTO booking_commercials VALUES
-- bk-001 | bl-001 | Sep 2021
('bc-001', 'bk-001', 'bl-001', '2021-09-15 12:00:00', 'itm-001', 4),
('bc-002', 'bk-001', 'bl-001', '2021-09-15 12:00:00', 'itm-002', 2),

-- bk-002 | bl-002 | Sep 2021
('bc-003', 'bk-002', 'bl-002', '2021-09-23 12:03:22', 'itm-001', 3),
('bc-004', 'bk-002', 'bl-002', '2021-09-23 12:03:22', 'itm-002', 1),
('bc-005', 'bk-002', 'bl-003', '2021-09-23 12:05:37', 'itm-003', 0.5),

-- bk-003 | bl-004 | Oct 2021
('bc-006', 'bk-003', 'bl-004', '2021-10-05 20:00:00', 'itm-003', 3),
('bc-007', 'bk-003', 'bl-004', '2021-10-05 20:00:00', 'itm-004', 2),
('bc-008', 'bk-003', 'bl-004', '2021-10-05 20:00:00', 'itm-005', 2),

-- bk-004 | bl-005 | Oct 2021
('bc-009', 'bk-004', 'bl-005', '2021-10-18 19:00:00', 'itm-005', 4),
('bc-010', 'bk-004', 'bl-005', '2021-10-18 19:00:00', 'itm-006', 3),

-- bk-010 | bl-006 | Oct 2021  (bill > 1000)
('bc-011', 'bk-010', 'bl-006', '2021-10-25 21:00:00', 'itm-003', 3),
('bc-012', 'bk-010', 'bl-006', '2021-10-25 21:00:00', 'itm-005', 3),

-- bk-005 | bl-007 | Nov 2021
('bc-013', 'bk-005', 'bl-007', '2021-11-02 13:00:00', 'itm-001', 5),
('bc-014', 'bk-005', 'bl-007', '2021-11-02 13:00:00', 'itm-007', 4),

-- bk-006 | bl-008 | Nov 2021
('bc-015', 'bk-006', 'bl-008', '2021-11-14 18:00:00', 'itm-005', 2),
('bc-016', 'bk-006', 'bl-008', '2021-11-14 18:00:00', 'itm-003', 1),

-- bk-007 | bl-009 | Nov 2021
('bc-017', 'bk-007', 'bl-009', '2021-11-28 12:00:00', 'itm-008', 3),
('bc-018', 'bk-007', 'bl-009', '2021-11-28 12:00:00', 'itm-004', 2),

-- bk-008 | bl-010 | Dec 2021
('bc-019', 'bk-008', 'bl-010', '2021-12-01 20:00:00', 'itm-005', 3),
('bc-020', 'bk-008', 'bl-010', '2021-12-01 20:00:00', 'itm-003', 2),

-- bk-009 | bl-011 | Dec 2021
('bc-021', 'bk-009', 'bl-011', '2021-12-20 19:00:00', 'itm-008', 4),
('bc-022', 'bk-009', 'bl-011', '2021-12-20 19:00:00', 'itm-006', 2);
