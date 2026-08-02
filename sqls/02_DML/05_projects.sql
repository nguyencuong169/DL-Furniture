-- =============================================
-- 02_DML/05_projects.sql
-- Seed: dbo.projects
-- =============================================
-- Idempotent: sử dụng MERGE để tránh trùng lặp khi chạy lại.
-- Chú ý: 2 project đầu có id cố định (1, 2) để gallery_items có thể tham chiếu.
-- 2 project sau không có id cố định (dùng identity).
SET IDENTITY_INSERT dbo.projects ON;
GO

MERGE INTO dbo.projects AS target
USING (VALUES
    (1, N'Thiết kế nội thất Saroma Villa', N'Villa cao cấp', N'Anh Tuấn', N'Thủ Thiêm', NULL, N'Thiết kế trọn gói Saroma Villa', N'/src/assets/img/slider/4.jpg', N'published'),
    (2, N'Thiết kế nội thất biệt thự Vinhomes Grand Park', N'Biệt thự Vinhomes Grand Park', N'Anh Cường', N'Quận 9', NULL, N'Thiết kế và thi công biệt thự', N'/src/assets/img/slider/3.jpg', N'published')
) AS source (id, title, subtitle, client_name, location, category_id, description, cover_image, status)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        target.title = source.title,
        target.subtitle = source.subtitle,
        target.client_name = source.client_name,
        target.location = source.location,
        target.description = source.description,
        target.cover_image = source.cover_image,
        target.status = source.status
WHEN NOT MATCHED THEN
    INSERT (id, title, subtitle, client_name, location, category_id, description, cover_image, status)
    VALUES (source.id, source.title, source.subtitle, source.client_name, source.location, source.category_id, source.description, source.cover_image, source.status);
GO

SET IDENTITY_INSERT dbo.projects OFF;
GO

-- Thêm 2 project không có id cố định
MERGE INTO dbo.projects AS target
USING (VALUES
    (N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên', N'Villa cao cấp', N'Chị Hằng', N'Vĩnh Yên', NULL, N'Thiết kế và thi công biệt thự KĐT Vĩnh Yên', N'/src/assets/img/slider/3.jpg', N'published'),
    (N'Thiết kế nội thất căn hộ Vinhomes Metropolis', N'Căn hộ cao cấp', N'Chị Nguyệt', N'Liễu Giai', NULL, N'Thiết kế và thi công căn hộ Vinhomes Metropolis', N'/src/assets/img/slider/2.jpg', N'published')
) AS source (title, subtitle, client_name, location, category_id, description, cover_image, status)
ON target.title = source.title
WHEN NOT MATCHED THEN
    INSERT (title, subtitle, client_name, location, category_id, description, cover_image, status)
    VALUES (source.title, source.subtitle, source.client_name, source.location, source.category_id, source.description, source.cover_image, source.status);
GO

PRINT 'Seed projects: done.';
GO
