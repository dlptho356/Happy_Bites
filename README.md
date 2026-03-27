# HappyBites - Hệ Thống Quản Lý Chuỗi Tiệm Bánh Phân Tán (SQL Server)

HappyBites là giải pháp cơ sở dữ liệu chuyên sâu được xây dựng trên hệ quản trị SQL Server nhằm quản lý chuỗi tiệm bánh đa chi nhánh. Hệ thống giải quyết các bài toán thực tế về quản lý danh mục sản phẩm tập trung, định mức tiêu hao nguyên vật liệu (BOM) và đồng bộ hóa quy trình xuất - nhập kho tự động tại các điểm bán lẻ.

---

## 📌 Tổng Quan Dự Án

Trong ngành F&B (Thực phẩm & Đồ uống), việc kiểm soát nguyên liệu tiêu hao và tính toán tồn kho là bài toán sống còn. Dự án **HappyBites** tận dụng tối đa sức mạnh lập trình cơ sở dữ liệu (Triggers, Stored Procedures) để tự động hóa hoàn toàn việc trừ kho nguyên liệu dựa trên công thức chế biến ngay khi chi nhánh phát sinh đơn hàng bán lẻ.

---

## 🏗️ Kiến Trúc Hệ Thống (Architecture)

Dự án được mô phỏng theo mô hình kiến trúc **Cơ sở dữ liệu phân tán (Distributed Databases)**:

* **`DB_MASTER`**: Đóng vai trò máy chủ trung tâm (Hub), lưu trữ các danh mục dùng chung toàn hệ thống bao gồm: Phân loại bánh, Danh sách sản phẩm niêm yết, Bảng nguyên liệu và Định mức công thức chế biến.
* **`HappyBites_Q6 / Q7 / Q8`**: Cơ sở dữ liệu riêng biệt tại các chi nhánh địa phương (Quận 6, Quận 7, Quận 8). Mỗi chi nhánh tự quản lý thông tin nhân viên trực thuộc, các hóa đơn bán hàng phát sinh nội bộ và số lượng tồn kho nguyên liệu thực tế tại kho của mình.

---

## 🔥 Các Tính Năng Kỹ Thuật Nổi Bật

### 1. Trừ Kho Tự Động Theo Công Thức Chế Biến (`TRG_TruKho`)
Khi một chi tiết đơn hàng được tạo mới, Trigger sẽ tự động:
* Tra cứu định mức tiêu hao nguyên vật liệu của sản phẩm đó trong bảng công thức.
* Kiểm tra số lượng tồn kho tại chi nhánh hiện hành.
* Khấu trừ chính xác số lượng nguyên liệu tiêu hao thực tế (gram, ml...).
* Tự động hoàn tác (Rollback) và báo lỗi hệ thống nếu chi nhánh không đủ nguyên liệu sản xuất.

### 2. Tự Động Tính Đơn Giá Và Tổng Tiền Hóa Đơn (`TRG_SetDonGia`, `TRG_TinhTongTien`)
Nhân viên thu ngân chỉ cần chọn món và số lượng, các Trigger sẽ chịu trách nhiệm:
* Tự động kéo giá bán tiêu chuẩn từ danh mục sản phẩm.
* Tự động tính tích lũy tổng tiền hóa đơn theo thời gian thực (real-time).

### 3. Báo Cáo Phân Tích Bán Hàng (`BaoCaoBanHang`)
Quy trình thống kê được đóng gói sẵn dưới dạng Stored Procedure cho phép truy xuất nhanh tổng số lượng sản phẩm bán ra và doanh thu thực tế để phục vụ công tác báo cáo quản trị.

---

## 🚀 Hướng Dẫn Cài Đặt & Chạy Thử (Deployment)

1. Sao chép (Clone) dự án về máy tính:
   ```bash
   git clone [https://github.com/dlptho356/pokeG_website.git](https://github.com/dlptho356/pokeG_website.git)
