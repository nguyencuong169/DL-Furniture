# DL-Furniture — SQL Scripts

Thư mục chứa toàn bộ script SQL cho cơ sở dữ liệu `DLFurniture` (SQL Server).

## Cấu trúc

```
sqls/
├── 00_CreateDatabase.sql        # Tạo database DLFurniture (idempotent)
├── 01_DDL/                      # DDL riêng cho từng bảng (18 file)
│   ├── 00_categories.sql
│   ├── 01_news_categories.sql
│   ├── 02_products.sql
│   ├── 03_product_images.sql
│   ├── 04_news.sql
│   ├── 05_projects.sql
│   ├── 06_project_images.sql
│   ├── 07_gallery_categories.sql
│   ├── 08_gallery_items.sql
│   ├── 09_contact_messages.sql
│   ├── 10_booking_requests.sql
│   ├── 11_services.sql
│   ├── 12_facilities.sql
│   ├── 13_team_members.sql
│   ├── 14_testimonials.sql
│   ├── 15_clients.sql
│   ├── 16_sliders.sql
│   └── 17_site_settings.sql
├── 02_DML/                      # DML/seed riêng cho từng bảng (18 file)
│   └── (cùng tên với 01_DDL)
└── 99_Master_Build.sql          # Build toàn bộ từ đầu (sqlcmd :r)
```

## Quy ước

- **Chuẩn định nghĩa**: khi có xung đột giữa các file SQL cũ, lấy định nghĩa
  trong **DB hiện tại** (`DLFurniture.Api` + Models + AppDbContext) làm chuẩn.
- **Datetime**: tất cả cột thời gian dùng `DATETIMEOFFSET`,
  default `SYSUTCDATETIME()`.
- **Idempotent**: tất cả script DDL/DML đều có thể chạy lại an toàn.

## Cách chạy

### Build mới từ đầu (sqlcmd)

> Nên dùng `-f 65001` để đọc đúng tiếng Việt UTF-8 và `-b` để dừng khi có lỗi.

```bash
sqlcmd -S localhost -U sa -P "P@ssw0rd!" -b -f 65001 -i sqls/99_Master_Build.sql
```

### Chạy từng phần

```bash
# 1. Tạo database
sqlcmd -S localhost -U sa -P "P@ssw0rd!" -b -f 65001 -i sqls/00_CreateDatabase.sql

# 2. Tạo schema (18 file DDL, chạy tuần tự theo thứ tự)
sqlcmd -S localhost -U sa -P "P@ssw0rd!" -b -f 65001 -i sqls/01_DDL/00_categories.sql
# ...

# 3. Seed dữ liệu (18 file DML)
sqlcmd -S localhost -U sa -P "P@ssw0rd!" -b -f 65001 -i sqls/02_DML/00_categories.sql
# ...
```
