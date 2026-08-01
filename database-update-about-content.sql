-- ============================================================
-- Update about-page content (team_members + services) to proper Vietnamese
-- IMPORTANT: run with UTF-8 input code page:
--   sqlcmd -S localhost -U sa -P P@ssw0rd! -d DLFurniture -f 65001 -i database-update-about-content.sql
-- ============================================================
SET NOCOUNT ON;

-- ============================================================
-- 1. TEAM MEMBERS  (6 records, proper Vietnamese)
-- ============================================================
UPDATE dbo.team_members
SET full_name    = N'KTS. Nguyễn Văn Dũng',
    name         = N'KTS. Nguyễn Văn Dũng',
    role         = N'Giám đốc sáng tạo',
    avatar_image = N'/src/assets/img/team/4.jpg',
    image_url    = N'/src/assets/img/team/4.jpg',
    email        = N'dungnv@dl-furniture.com',
    sort_order   = 1
WHERE id = 1;

UPDATE dbo.team_members
SET full_name    = N'KTS. Trần Thị Linh',
    name         = N'KTS. Trần Thị Linh',
    role         = N'Trưởng nhóm thiết kế',
    avatar_image = N'/src/assets/img/team/1.jpg',
    image_url    = N'/src/assets/img/team/1.jpg',
    email        = N'linhtt@dl-furniture.com',
    sort_order   = 2
WHERE id = 2;

UPDATE dbo.team_members
SET full_name    = N'KTS. Phạm Minh Quân',
    name         = N'KTS. Phạm Minh Quân',
    role         = N'Kiến trúc sư nội thất',
    avatar_image = N'/src/assets/img/team/2.jpg',
    image_url    = N'/src/assets/img/team/2.jpg',
    email        = N'quanpm@dl-furniture.com',
    sort_order   = 3
WHERE id = 3;

-- Insert records 4-6 if they don't exist
IF NOT EXISTS (SELECT 1 FROM dbo.team_members WHERE id = 4)
BEGIN
    SET IDENTITY_INSERT dbo.team_members ON;
    INSERT INTO dbo.team_members
        (id, full_name, name, role, avatar_image, image_url, email, sort_order, hidden, del_flag, created_date)
    VALUES
        (4, N'KTS. Lê Thu Hà', N'KTS. Lê Thu Hà', N'Kiến trúc sư nội thất',
         N'/src/assets/img/team/5.jpg', N'/src/assets/img/team/5.jpg', N'halt@dl-furniture.com', 4, 0, 0, SYSDATETIMEOFFSET());
    SET IDENTITY_INSERT dbo.team_members OFF;
    PRINT 'Inserted team member 4.';
END
ELSE
BEGIN
    UPDATE dbo.team_members
    SET full_name = N'KTS. Lê Thu Hà', name = N'KTS. Lê Thu Hà',
        role = N'Kiến trúc sư nội thất',
        avatar_image = N'/src/assets/img/team/5.jpg', image_url = N'/src/assets/img/team/5.jpg',
        email = N'halt@dl-furniture.com', sort_order = 4, hidden = 0, del_flag = 0
    WHERE id = 4;
END

IF NOT EXISTS (SELECT 1 FROM dbo.team_members WHERE id = 5)
BEGIN
    SET IDENTITY_INSERT dbo.team_members ON;
    INSERT INTO dbo.team_members
        (id, full_name, name, role, avatar_image, image_url, email, sort_order, hidden, del_flag, created_date)
    VALUES
        (5, N'KTS. Hoàng Đức Anh', N'KTS. Hoàng Đức Anh', N'Giám sát thi công',
         N'/src/assets/img/team/3.jpg', N'/src/assets/img/team/3.jpg', N'anhhd@dl-furniture.com', 5, 0, 0, SYSDATETIMEOFFSET());
    SET IDENTITY_INSERT dbo.team_members OFF;
    PRINT 'Inserted team member 5.';
END
ELSE
BEGIN
    UPDATE dbo.team_members
    SET full_name = N'KTS. Hoàng Đức Anh', name = N'KTS. Hoàng Đức Anh',
        role = N'Giám sát thi công',
        avatar_image = N'/src/assets/img/team/3.jpg', image_url = N'/src/assets/img/team/3.jpg',
        email = N'anhhd@dl-furniture.com', sort_order = 5, hidden = 0, del_flag = 0
    WHERE id = 5;
END

IF NOT EXISTS (SELECT 1 FROM dbo.team_members WHERE id = 6)
BEGIN
    SET IDENTITY_INSERT dbo.team_members ON;
    INSERT INTO dbo.team_members
        (id, full_name, name, role, avatar_image, image_url, email, sort_order, hidden, del_flag, created_date)
    VALUES
        (6, N'KTS. Vũ Ngọc Mai', N'KTS. Vũ Ngọc Mai', N'Chuyên viên vật liệu & màu sắc',
         N'/src/assets/img/team/6.jpg', N'/src/assets/img/team/6.jpg', N'maivn@dl-furniture.com', 6, 0, 0, SYSDATETIMEOFFSET());
    SET IDENTITY_INSERT dbo.team_members OFF;
    PRINT 'Inserted team member 6.';
END
ELSE
BEGIN
    UPDATE dbo.team_members
    SET full_name = N'KTS. Vũ Ngọc Mai', name = N'KTS. Vũ Ngọc Mai',
        role = N'Chuyên viên vật liệu & màu sắc',
        avatar_image = N'/src/assets/img/team/6.jpg', image_url = N'/src/assets/img/team/6.jpg',
        email = N'maivn@dl-furniture.com', sort_order = 6, hidden = 0, del_flag = 0
    WHERE id = 6;
END

-- ============================================================
-- 2. SERVICES  (full descriptions + category)
-- ============================================================
UPDATE dbo.services
SET name = N'Nội thất biệt thự',
    title = N'Nội thất biệt thự',
    description = N'Kiến tạo nên tính thẩm mỹ cá tính với đa phong cách thiết kế và cung cấp những tiện ích sống xứng tầm đẳng cấp cho không gian biệt thự của bạn.',
    image = N'/src/assets/img/pricing/1.jpg',
    image_url = N'/src/assets/img/pricing/1.jpg',
    category = N'Thi công',
    sort_order = 1
WHERE id = 1;

UPDATE dbo.services
SET name = N'Nội thất chung cư',
    title = N'Nội thất chung cư',
    description = N'Chuyên thiết kế nội thất chung cư trọn gói, chuyên nghiệp với nhiều phong cách thiết kế khác nhau, tối ưu diện tích và công năng sử dụng.',
    image = N'/src/assets/img/pricing/2.jpg',
    image_url = N'/src/assets/img/pricing/2.jpg',
    category = N'Thi công',
    sort_order = 2
WHERE id = 2;

UPDATE dbo.services
SET name = N'Nội thất văn phòng',
    title = N'Nội thất văn phòng',
    description = N'Cung cấp các mẫu thiết kế nội thất văn phòng đa dạng diện tích và phong cách, tạo nên vẻ đẹp và phong cách riêng cho không gian làm việc.',
    image = N'/src/assets/img/pricing/3.jpg',
    image_url = N'/src/assets/img/pricing/3.jpg',
    category = N'Thi công',
    sort_order = 3
WHERE id = 3;

UPDATE dbo.services
SET name = N'Showroom & Trung tâm',
    title = N'Showroom & Trung tâm',
    description = N'Xây dựng không gian theo concept riêng, môi trường trưng bày chuẩn mực và đẹp mắt cho từng đối tượng khách hàng khác nhau.',
    image = N'/src/assets/img/pricing/4.jpg',
    image_url = N'/src/assets/img/pricing/4.jpg',
    category = N'Thi công',
    sort_order = 4
WHERE id = 4;

PRINT 'Done.';
GO

