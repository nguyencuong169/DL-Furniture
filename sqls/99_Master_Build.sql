-- =============================================
-- 99. Master Build — DL-Furniture Database
-- =============================================
-- Build TOÀN BỘ database từ đầu (tạo DB -> DDL -> DML).
-- Chạy bằng sqlcmd (bắt buộc, vì dùng lệnh :r):
--   sqlcmd -S localhost -U sa -P "P@ssw0rd!" -b -f 65001 -i sqls\99_Master_Build.sql
--
-- Lưu ý: tất cả file DDL/DML đều idempotent, có thể chạy lại an toàn.

PRINT '============================================';
PRINT 'MASTER BUILD START';
PRINT '============================================';
GO

-- 0. Tạo database
:r 00_CreateDatabase.sql

-- 1. DDL (theo thứ tự phụ thuộc: bảng cha trước, bảng con sau)
:r 01_DDL/00_categories.sql
:r 01_DDL/01_news_categories.sql
:r 01_DDL/02_products.sql
:r 01_DDL/03_product_images.sql
:r 01_DDL/04_news.sql
:r 01_DDL/05_projects.sql
:r 01_DDL/06_project_images.sql
:r 01_DDL/07_gallery_categories.sql
:r 01_DDL/08_gallery_items.sql
:r 01_DDL/09_contact_messages.sql
:r 01_DDL/10_booking_requests.sql
:r 01_DDL/11_services.sql
:r 01_DDL/12_facilities.sql
:r 01_DDL/13_team_members.sql
:r 01_DDL/14_testimonials.sql
:r 01_DDL/15_clients.sql
:r 01_DDL/16_sliders.sql
:r 01_DDL/17_site_settings.sql
:r 01_DDL/18_menus.sql

-- 2. DML (seed theo thứ tự phụ thuộc)
:r 02_DML/00_categories.sql
:r 02_DML/01_news_categories.sql
:r 02_DML/02_products.sql
:r 02_DML/03_product_images.sql
:r 02_DML/04_news.sql
:r 02_DML/05_projects.sql
:r 02_DML/06_project_images.sql
:r 02_DML/07_gallery_categories.sql
:r 02_DML/08_gallery_items.sql
:r 02_DML/09_contact_messages.sql
:r 02_DML/10_booking_requests.sql
:r 02_DML/11_services.sql
:r 02_DML/12_facilities.sql
:r 02_DML/13_team_members.sql
:r 02_DML/14_testimonials.sql
:r 02_DML/15_clients.sql
:r 02_DML/16_sliders.sql
:r 02_DML/17_site_settings.sql
:r 02_DML/18_menus.sql

PRINT '============================================';
PRINT 'MASTER BUILD COMPLETED';
PRINT '============================================';
GO

