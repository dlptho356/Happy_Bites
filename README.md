# HappyBites - Distributed Database System

## Overview

HappyBites is a distributed database system designed for managing a bakery chain.
The system consists of one central database (Master) and three independent branch databases (Q6, Q7, Q8).

Each branch operates independently, handling its own transactions and inventory without direct access to other branches.

---

## System Architecture

* DBMaster: Centralized database
* Q6, Q7, Q8: Independent branch databases
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

![ERD](docs/ERD.png)

---

## Project Structure

```
HappyBites/
│
├── DBMaster/
├── Q6/
├── Q7/
├── Q8/
├── docs/
│   └── ERD.png
└── README.md
```

---

## Setup Instructions

1. Execute scripts for each database:

   * DBMaster
   * Q6
   * Q7
   * Q8

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
INSERT INTO KHACH_HANG VALUES ('KH01', N'Nguyen Van A', '0123456789');

INSERT INTO DON_HANG VALUES ('DH01', GETDATE(), 0, 'NV01', 'KH01');
```

### Step 3: Insert order details

```sql
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH01', 'SP01', 2);
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

Doan Tho
