# HappyBites - Hệ thống Cơ sở dữ liệu Phân tán

## Tổng quan

HappyBites là hệ thống cơ sở dữ liệu phân tán được thiết kế để quản lý chuỗi tiệm bánh.
Hệ thống bao gồm một cơ sở dữ liệu trung tâm (Master) và ba cơ sở dữ liệu chi nhánh độc lập (Q6, Q7, Q8).

Mỗi cơ sở dữ liệu chi nhánh hoạt động độc lập, xử lý giao dịch và quản lý tồn kho riêng, không truy cập trực tiếp lẫn nhau.

---

## Kiến trúc hệ thống

* HappyBites_DBMaster: Cơ sở dữ liệu trung tâm
* HappyBites_Q6, HappyBites_Q7, HappyBites_Q8: Các cơ sở dữ liệu chi nhánh độc lập
* Các chi nhánh không truy cập trực tiếp lẫn nhau
* Logic nghiệp vụ (trigger, procedure) được xử lý tại từng chi nhánh

---

## Công nghệ sử dụng

* SQL Server
* T-SQL
* Stored Procedures
* Triggers

---

## Tính năng chính

* Thiết kế cơ sở dữ liệu phân tán cho hệ thống nhiều chi nhánh
* Tự động trừ tồn kho nguyên liệu bằng trigger dựa trên công thức sản phẩm
* Đảm bảo toàn vẹn dữ liệu thông qua khóa ngoại và ràng buộc
* Xử lý nghiệp vụ tại từng chi nhánh

---

## Truy vấn phân tán với Linked Server

DBMaster được cấu hình để truy cập dữ liệu từ các cơ sở dữ liệu chi nhánh (Q6, Q7, Q8) thông qua Linked Server.

Điều này cho phép thực hiện các truy vấn tổng hợp và báo cáo tập trung mà không cần can thiệp trực tiếp vào dữ liệu của từng chi nhánh.

### Điểm chính

* DBMaster có thể truy vấn dữ liệu từ các chi nhánh thông qua Linked Server
* Các database chi nhánh vẫn hoạt động độc lập, không liên kết trực tiếp với nhau
* Các truy vấn liên chi nhánh chỉ được thực hiện từ DBMaster

### Ví dụ truy vấn

```sql
SELECT * FROM [LS_Q7].[HappyBites_Q7].dbo.DON_HANG;
```

---

## Thiết lập Linked Server

Dự án cung cấp file SQL để cấu hình Linked Server, giúp DBMaster kết nối với các database chi nhánh.

Vị trí file:

```plaintext
DB_Master/LinkedServer/Create_LinkedServer.sql
```


## Database Design (ERD)

![ERD](HappyBites%203.0/docs/ERD_HappyBites.png)

---


## Cấu trúc dự án

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
│   └── ![ERD](docs/ERD_HappyBites.png)
└── README.md
```

---

## Hướng dẫn cài đặt

1. Tạo và chạy script cho từng database:

   * HappyBites_DBMaster
   * HappyBites_Q6
   * HappyBites_Q7
   * HappyBites_Q8

2. Đảm bảo mỗi database chi nhánh có:

   * Bảng dữ liệu
   * Trigger
   * Stored Procedure

3. Sử dụng các câu lệnh test bên dưới để kiểm tra hệ thống

---

## Kịch bản kiểm thử

Các kịch bản dưới đây minh họa cách hoạt động của trigger và stored procedure trong hệ thống.

---

### 1. Trigger: SetDonGia (Tự động gán đơn giá)

Tự động gán đơn giá khi thêm chi tiết đơn hàng.

```sql
INSERT INTO CHI_TIET_DON_HANG (MaDH, MaSP, Soluong)
VALUES ('DH04', 'SP03', 2);

SELECT * FROM CHI_TIET_DON_HANG WHERE MaDH = 'DH04';
```

**Mô tả:**
`Dongia` được tự động lấy từ `SAN_PHAM.Giaban`.

---

### 2. Trigger: TinhTongTien (Tính tổng tiền đơn hàng)

Tự động cập nhật tổng tiền khi thêm chi tiết đơn hàng.

```sql
SELECT * FROM DON_HANG WHERE MaDH = 'DH04';

INSERT INTO CHI_TIET_DON_HANG VALUES ('DH04', 'SP02', 3);

SELECT * FROM DON_HANG WHERE MaDH = 'DH04';
```

**Mô tả:**
`Tongtien` được cập nhật bằng tổng (`Soluong × Dongia`).

---

### 3. Trigger: CongKho (Tăng tồn kho)

Tăng số lượng tồn kho khi nhập nguyên liệu.

```sql
INSERT INTO NHAP_KHO VALUES ('NK03', GETDATE(), 'NVQ6_01')

SELECT * FROM TON_KHO WHERE MaNL = 'NL01';

INSERT INTO CHI_TIET_NHAP VALUES (15, 'NK03', 5000, 'NL01');

SELECT * FROM TON_KHO WHERE MaNL = 'NL01';
```

**Mô tả:**
`Soluongton` tăng theo số lượng nhập.

---

### 4. Trigger: TruKho (Trừ tồn kho)

Giảm tồn kho dựa trên công thức sản phẩm khi phát sinh đơn hàng.

```sql
SELECT * FROM TON_KHO;

INSERT INTO CHI_TIET_DON_HANG VALUES ('DH04', 'SP01', 2);

SELECT * FROM TON_KHO;
```

**Mô tả:**
Tồn kho giảm theo công thức trong bảng `CONG_THUC`.
Trong trường hợp nguyên liệu không đủ, hệ thống sẽ không cho phép xuất đơn hàng và thông báo hết nguyên liệu.

---

## Stored Procedures

### 5. Procedure: TaoDonHang (Tạo đơn hàng)

```sql
EXEC TaoDonHang 'DH05', 'NVQ6_01', 'KH10';

SELECT * FROM DON_HANG WHERE MaDH = 'DH05';
```

**Mô tả:**
Tạo một đơn hàng mới trong hệ thống.

---

### 6. Procedure: ThemSPVaoDon (Thêm sản phẩm vào đơn)

```sql
EXEC ThemSPVaoDon 'DH05', 'SP10', 2;

SELECT * FROM CHI_TIET_DON_HANG WHERE MaDH = 'DH05';
```

**Mô tả:**
Thêm sản phẩm vào đơn hàng và tự động kích hoạt các trigger liên quan.

---

### 7. Procedure: XemTonKho (Xem tồn kho)

```sql
EXEC XemTonKho;
```

**Mô tả:**
Hiển thị danh sách nguyên liệu và số lượng tồn kho hiện tại.

---

### 8. Procedure: BaoCaoBanHang (Báo cáo bán hàng)

```sql
EXEC BaoCaoBanHang;
```

**Mô tả:**
Trả về dữ liệu tổng hợp phục vụ phân tích doanh thu và bán hàng.

---

### 9. Luồng hoạt động tổng thể

```sql
EXEC TaoDonHang 'DH06', 'NV01', 'KH10';

EXEC ThemSPVaoDon 'DH06', 'SP01', 2;

SELECT * FROM DON_HANG WHERE MaDH = 'DH06';
SELECT * FROM TON_KHO;
```

**Mô tả:**

* Đơn giá được tự động gán
* Tổng tiền được tính tự động
* Tồn kho được cập nhật theo công thức
* Nếu nguyên liệu không đủ, đơn hàng sẽ không được xử lý


## Tác giả

Đoàn Lê Phước Thọ
