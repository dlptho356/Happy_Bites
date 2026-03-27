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

## Distributed Query with Linked Server

The DBMaster is configured to access data from branch databases (Q6, Q7, Q8) using Linked Server.

This allows centralized querying and reporting without direct data modification across branches.

### Key Points

* DBMaster can query data from branch databases via Linked Server
* Branch databases remain independent and do not communicate with each other
* Cross-database queries are executed only from DBMaster

### Example Query

```sql
SELECT * FROM [LS_Q7].[HappyBites_Q7].dbo.DON_HANG;
```

---

## Linked Server Setup

A SQL script is provided to create Linked Servers for connecting DBMaster with branch databases.

Location:

```plaintext
DB_Master/LinkedServer/Create_LinkedServer.sql
```


## Database Design (ERD)

![ERD](HappyBites%203.0/docs/ERD_HappyBites.png)

---

## Project Structure

```
HappyBites/
│
├── DBMaster/
│   ├── Database/
│   │   ├── Create_tables.sql
│   │   └── Insert_data.sql
│   └── LinkedServer/
│       └──Create_LinkedServer.sql
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

## Test Scenarios

The following scenarios demonstrate how triggers and stored procedures operate within the system.

---

### 1. Trigger: SetDonGia (Auto Set Unit Price)

Automatically assigns the unit price when inserting order details.

```sql
INSERT INTO CHI_TIET_DON_HANG (MaDH, MaSP, Soluong)
VALUES ('DH04', 'SP03', 2);

SELECT * FROM CHI_TIET_DON_HANG WHERE MaDH = 'DH04';
```

**Description:**
`Dongia` is automatically retrieved from `SAN_PHAM.Giaban`.

---

### 2. Trigger: TinhTongTien (Calculate Order Total)

Automatically updates the total amount when order details are inserted.

```sql
SELECT * FROM DON_HANG WHERE MaDH = 'DH04';

INSERT INTO CHI_TIET_DON_HANG VALUES ('DH04', 'SP02', 3);

SELECT * FROM DON_HANG WHERE MaDH = 'DH04';
```

**Description:**
`Tongtien` is updated as the sum of (`Soluong × Dongia`).

---

### 3. Trigger: CongKho (Increase Inventory)

Increases inventory when ingredients are imported.

```sql
INSERT INTO NHAP_KHO VALUES('NK03', GETDATE(), 'NVQ6_05')

SELECT * FROM TON_KHO WHERE MaNL = 'NL01';

INSERT INTO CHI_TIET_NHAP VALUES (15, 'NK03', 5000, 'NL01');

SELECT * FROM TON_KHO WHERE MaNL = 'NL01';
```

**Description:**
`Soluongton` increases according to the imported quantity.

---

### 4. Trigger: TruKho (Decrease Inventory)

Decreases inventory based on product recipes when an order is placed.

```sql
SELECT * FROM TON_KHO;

INSERT INTO CHI_TIET_DON_HANG VALUES ('DH04', 'SP01', 2);

SELECT * FROM TON_KHO;
```

**Description:**
Inventory is reduced based on the recipe defined in `CONG_THUC`.
If ingredients are insufficient, the system will prevent order processing and notify that the inventory is out of stock.

---

## Stored Procedures

### 5. Procedure: TaoDonHang (Create Order)

```sql
EXEC TaoDonHang 'DH05', 'NVQ6_01', 'KH10';

SELECT * FROM DON_HANG WHERE MaDH = 'DH05';
```

**Description:**
Creates a new order in the system.

---

### 6. Procedure: ThemSPVaoDon (Add Product to Order)

```sql
EXEC ThemSPVaoDon 'DH05', 'SP10', 2;

SELECT * FROM CHI_TIET_DON_HANG WHERE MaDH = 'DH05';
```

**Description:**
Adds a product to an existing order and automatically triggers related processes.

---

### 7. Procedure: XemTonKho (View Inventory)

```sql
EXEC XemTonKho;
```

**Description:**
Displays the current inventory status.

---

### 8. Procedure: BaoCaoBanHang (Sales Report)

```sql
EXEC BaoCaoBanHang;
```

**Description:**
Returns aggregated data for sales and revenue analysis.

---

### 9. End-to-End Workflow

```sql
EXEC TaoDonHang 'DH06', 'NVQ6_01', 'KH10';

EXEC ThemSPVaoDon 'DH06', 'SP01', 2;

SELECT * FROM DON_HANG WHERE MaDH = 'DH06';
SELECT * FROM TON_KHO;
```

**Description:**

* Unit price is automatically assigned
* Total order value is calculated
* Inventory is updated based on recipes
* If ingredients are insufficient, the order will not be processed

---

## Author

Doan Le Phuoc Tho
