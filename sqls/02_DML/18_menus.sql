-- =============================================
-- 02_DML/18_menus.sql
-- Seed: dbo.menus
-- =============================================
-- Idempotent: su dung MERGE theo khoa tu nhien (location + label).
-- Cay menu duoc seed 3 tang: root, nhom (con cua "San pham"), la.
-- parent_id tu giai quyet bang subquery theo (location, label).
GO

-- ============ 1. Root (primary + consultation + footer) ============
MERGE INTO dbo.menus AS target
USING (VALUES
    (N'primary', NULL, N'Trang chu', N'/', 10, 0),
    (N'primary', NULL, N'Gioi thieu', N'/gioi-thieu', 20, 0),
    (N'primary', NULL, N'San pham', N'/san-pham', 30, 0),
    (N'primary', NULL, N'Du an', N'/du-an', 40, 0),
    (N'primary', NULL, N'Thu vien', N'/thu-vien', 50, 0),
    (N'primary', NULL, N'Tin tuc', N'/tin-tuc', 60, 0),
    (N'primary', NULL, N'Lien he', N'/lien-he', 70, 0),
    (N'primary', NULL, N'Dat lich tu van', N'/#consultation', 80, 1),
    (N'footer', NULL, N'Trang chu', N'/', 10, 0),
    (N'footer', NULL, N'Gioi thieu', N'/gioi-thieu', 20, 0),
    (N'footer', NULL, N'San pham', N'/san-pham', 30, 0),
    (N'footer', NULL, N'Du an', N'/du-an', 40, 0),
    (N'footer', NULL, N'Lien he', N'/lien-he', 50, 0),
    (N'footer', NULL, N'Cau hoi thuong gap', N'/lien-he#faq', 60, 0)
) AS source (location, parent_id, label, url, sort_order, is_consultation)
ON target.location = source.location AND target.label = source.label
WHEN MATCHED THEN
    UPDATE SET
        target.url = source.url,
        target.sort_order = source.sort_order,
        target.is_consultation = source.is_consultation,
        target.parent_id = NULL,
        target.is_active = 1,
        target.hidden = 0,
        target.del_flag = 0,
        target.updated_user = N'seed'
WHEN NOT MATCHED THEN
    INSERT (location, parent_id, label, url, sort_order, is_consultation, is_active, hidden, del_flag, created_user, updated_user)
    VALUES (source.location, source.parent_id, source.label, source.url, source.sort_order, source.is_consultation, 1, 0, 0, N'seed', N'seed');
GO

PRINT 'Seed menus (roots): done.';
GO

-- ============ 2. Nhom (con cua root "San pham") ============
MERGE INTO dbo.menus AS target
USING (VALUES
    (N'primary', N'Phong khach', N'/san-pham/phong-khach', 10),
    (N'primary', N'Phong ngu', N'/san-pham/phong-ngu', 20),
    (N'primary', N'Phong bep', N'/san-pham/phong-bep', 30)
) AS source (location, label, url, sort_order)
ON target.location = source.location AND target.label = source.label
WHEN MATCHED THEN
    UPDATE SET
        target.url = source.url,
        target.sort_order = source.sort_order,
        target.parent_id = (SELECT TOP 1 id FROM dbo.menus WHERE location = N'primary' AND label = N'San pham' AND parent_id IS NULL ORDER BY id),
        target.is_active = 1,
        target.hidden = 0,
        target.del_flag = 0,
        target.updated_user = N'seed'
WHEN NOT MATCHED THEN
    INSERT (location, parent_id, label, url, sort_order, is_active, hidden, del_flag, created_user, updated_user)
    VALUES (
        source.location,
        (SELECT TOP 1 id FROM dbo.menus WHERE location = N'primary' AND label = N'San pham' AND parent_id IS NULL ORDER BY id),
        source.label, source.url, source.sort_order, 1, 0, 0, N'seed', N'seed');
GO

PRINT 'Seed menus (groups): done.';
GO

-- ============ 3. La (con cua cac nhom) ============
MERGE INTO dbo.menus AS target
USING (VALUES
    (N'primary', N'Phong khach', N'Sofa go', N'/san-pham/phong-khach/sofa', 10),
    (N'primary', N'Phong khach', N'Ban tra', N'/san-pham/phong-khach/ban-tra', 20),
    (N'primary', N'Phong khach', N'Ke ti vi', N'/san-pham/phong-khach/ke-ti-vi', 30),
    (N'primary', N'Phong ngu', N'Giuong ngu', N'/san-pham/phong-ngu/giuong-ngu', 10),
    (N'primary', N'Phong ngu', N'Tu quan ao', N'/san-pham/phong-ngu/tu-quan-ao', 20),
    (N'primary', N'Phong ngu', N'Ke trang diem', N'/san-pham/phong-ngu/ke-trang-diem', 30),
    (N'primary', N'Phong bep', N'Ban an', N'/san-pham/phong-bep/ban-an', 10),
    (N'primary', N'Phong bep', N'Tu bep', N'/san-pham/phong-bep/tu-bep', 20)
) AS source (location, parent_label, label, url, sort_order)
ON target.location = source.location AND target.label = source.label
WHEN MATCHED THEN
    UPDATE SET
        target.url = source.url,
        target.sort_order = source.sort_order,
        target.parent_id = (SELECT TOP 1 id FROM dbo.menus WHERE location = source.location AND label = source.parent_label AND parent_id IS NOT NULL ORDER BY id),
        target.is_active = 1,
        target.hidden = 0,
        target.del_flag = 0,
        target.updated_user = N'seed'
WHEN NOT MATCHED THEN
    INSERT (location, parent_id, label, url, sort_order, is_active, hidden, del_flag, created_user, updated_user)
    VALUES (
        source.location,
        (SELECT TOP 1 id FROM dbo.menus WHERE location = source.location AND label = source.parent_label AND parent_id IS NOT NULL ORDER BY id),
        source.label, source.url, source.sort_order, 1, 0, 0, N'seed', N'seed');
GO

PRINT 'Seed menus (leaves): done.';
GO