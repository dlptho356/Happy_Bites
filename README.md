# HappyBites - Distributed Database System

## Overview

HappyBites is a distributed database system designed for managing a bakery chain.
The system consists of one central database (Master) and three independent branch databases (Q6, Q7, Q8).

Each branch operates independently, handling its own transactions and inventory without direct access to other branches.

---

## System Architecture

* HappyBites_DBMaster: Centralized database
* HappyBites_Q6, HappyBites_Q7, HappyBites_Q8: Independent branch databases
* No direct communication between branches
* Business logic (triggers, procedures) is processed locally at each branch

---

## Technologies

* SQL Server
* T-SQL
* Stored Procedures
* Triggers

---

## Key Features

* Distributed database architecture for multi-branch management
* Automatic inventory deduction using triggers based on product recipes
* Data integrity ensured through constraints and foreign keys
* Local processing of business logic at each branch

---

## Database Design (ERD)

![ERD](HappyBites%203.0/docs/ERD_HappyBites.png)

---

## Project Structure

```
HappyBites/
│
├── DBMaster/
│   └── Database/
│       ├── Create_tables.sql
│       └── Insert_data.sql
├── HappyBites_Q6/
│   ├── Database/
│   │   ├── Create_tables.sql
│   │   └── Insert_data.sql
│   ├── Procedure/
│   │   └── Proc.sql
│   └── Trigger/
│       ├── CongKho.sql
│       ├── SetDonGia.sql
│       ├── TinhTongTien.sql
│       └── TruKho.sql
├── HappyBites_Q7/
│   ├── Database/
│   │   ├── Create_tables.sql
│   │   └── Insert_data.sql
│   ├── Procedure/
│   │   └── Proc.sql
│   └── Trigger/
│       ├── CongKho.sql
│       ├── SetDonGia.sql
│       ├── TinhTongTien.sql
│       └── TruKho.sql
├── HappyBites_Q8/
│   ├── Database/
│   │   ├── Create_tables.sql
│   │   └── Insert_data.sql
│   ├── Procedure/
│   │   └── Proc.sql
│   └── Trigger/
│       ├── CongKho.sql
│       ├── SetDonGia.sql
│       ├── TinhTongTien.sql
│       └── TruKho.sql
├── docs/
│   └── ERD_HappyBites.png
└── README.md
```

---

## Setup Instructions

1. Execute scripts for each database:

   * HappyBites_DBMaster
   * HappyBites_Q6
   * HappyBites_Q7
   * HappyBites_Q8

2. Ensure each branch database includes:

   * Tables
   * Triggers
   * Stored Procedures

3. Use the test scenario below to verify system behavior

---

## Test Scenario (Trigger - Inventory Deduction)

### Step 1: Check inventory before order

```sql
SELECT * FROM TON_KHO;
```

### Step 2: Create order

```sql
INSERT INTO KHACH_HANG VALUES ('KH11', N'yourname', 'yournumber');

INSERT INTO DON_HANG VALUES ('DH05', GETDATE(), 0, 'NV01', 'KH11');
```

### Step 3: Insert order details

```sql
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH05', 'SP01', 2);
```

### Step 4: Verify inventory update

```sql
SELECT * FROM TON_KHO;
```

**Expected Result:**
Inventory is automatically reduced based on the product recipe (CONG_THUC) via trigger execution.

---

## Notes

* Triggers are designed to handle multi-row insert operations
* Each branch manages its own inventory independently
* No direct data access between branch databases

---

## Author

Doan Le Phuoc Tho
