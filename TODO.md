# TODO — Rà soát & Polish toàn bộ SQL → thư mục /sqls

## Mục tiêu

- Rà soát & polish tất cả file SQL.
- Tạo file DDL + DML riêng cho từng table trong `/sqls`.
- Merge tất cả feature-fixed SQL thành 1 file.
- Mọi trường datetime → `datetimeoffset`.
- Conflict → lấy định nghĩa DB hiện tại (API `DLFurniture.Api` + Models) làm chuẩn.
- Xóa các file SQL thừa ở root.

## Các bước

- [x] 1. Rà soát toàn bộ file SQL + Models/AppDbContext (đã xong)
- [x] 2. Tạo `sqls/00_CreateDatabase.sql`
- [x] 3. Tạo 18 file DDL trong `sqls/01_DDL/` (mỗi bảng 1 file, datetime → datetimeoffset, kèm index + trigger)
- [x] 4. Tạo 18 file DML trong `sqls/02_DML/` (mỗi bảng 1 file seed, theo cột DB hiện tại)
- [x] 5. ~~Tạo `sqls/03_FeatureFixes.sql` (merge 4 script feature)~~ — Không cần, DDL đã là trạng thái mới nhất
- [x] 6. Tạo `sqls/99_Master_Build.sql` + `sqls/README.md`
- [x] 7. Xóa 11 file SQL cũ ở root
- [x] 8. Kiểm tra tổng thể & hướng dẫn chạy
