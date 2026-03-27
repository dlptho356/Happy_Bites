# HappyBites - Hệ thống Cơ sở dữ liệu Phân tán

## Tổng quan

HappyBites là hệ thống cơ sở dữ liệu phân tán được thiết kế để quản lý chuỗi tiệm bánh.
Hệ thống bao gồm một cơ sở dữ liệu trung tâm (Master) và ba cơ sở dữ liệu chi nhánh độc lập (Q6, Q7, Q8).

Mỗi cơ sở dữ liệu chi nhánh hoạt động độc lập, xử lý giao dịch và quản lý tồn kho riêng, không truy cập trực tiếp lẫn nhau.

---

## Kiến trúc hệ thống

* DBMaster: Cơ sở dữ liệu trung tâm
* Q6, Q7, Q8: Các cơ sở dữ liệu chi nhánh độc lập
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

## Cấu trúc dự án

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
│   └── ![ERD](docs/ERD_HappyBites.png)
└── README.md
```

---

## Hướng dẫn cài đặt

1. Tạo và chạy script cho từng database:

   * DBMaster
   * Q6
   * Q7
   * Q8

2. Đảm bảo mỗi database chi nhánh có:

   * Bảng dữ liệu
   * Trigger
   * Stored Procedure

3. Sử dụng các câu lệnh test bên dưới để kiểm tra hệ thống

---

## Kịch bản kiểm thử (Trigger - Trừ tồn kho)

### Bước 1: Kiểm tra tồn kho trước khi tạo đơn

```sql
SELECT * FROM TON_KHO;
```

### Bước 2: Tạo đơn hàng

```sql
INSERT INTO KHACH_HANG VALUES ('KH01', N'Nguyen Van A', '0123456789');

INSERT INTO DON_HANG VALUES ('DH01', GETDATE(), 0, 'NV01', 'KH01');
```

### Bước 3: Thêm chi tiết đơn hàng

```sql
INSERT INTO CHI_TIET_DON_HANG VALUES ('DH01', 'SP01', 2);
```

### Bước 4: Kiểm tra lại tồn kho

```sql
SELECT * FROM TON_KHO;
```

**Kết quả mong đợi:**
Tồn kho nguyên liệu sẽ tự động giảm dựa trên công thức sản phẩm (CONG_THUC) thông qua trigger.

---

## Ghi chú

* Trigger được thiết kế để xử lý insert nhiều dòng
* Mỗi chi nhánh quản lý tồn kho riêng biệt
* Không có truy cập trực tiếp giữa các database chi nhánh

---

## Tác giả

Doan Tho
