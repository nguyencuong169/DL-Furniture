-- =============================================
-- 02_DML/07_gallery_categories.sql
-- Seed: dbo.gallery_categories
-- =============================================
-- Idempotent: sử dụng MERGE với id cố định.
SET IDENTITY_INSERT dbo.gallery_categories ON;
GO

MERGE INTO dbo.gallery_categories AS target
USING (VALUES
    (1, N'Phòng khách', N'phong-khach', 1, 1),
    (2, N'Phòng bếp', N'phong-bep', 2, 1),
    (3, N'Phòng ngủ', N'phong-ngu', 3, 1),
    (4, N'Xưởng chế tác', N'xuong-che-tac', 4, 1),
    (5, N'Dự án', N'du-an', 5, 1),
    (6, N'Vật liệu', N'vat-lieu', 6, 1)
) AS source (id, name, slug, display_order, is_active)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        target.name = source.name,
        target.slug = source.slug,
        target.display_order = source.display_order,
        target.is_active = source.is_active
WHEN NOT MATCHED THEN
    INSERT (id, name, slug, display_order, is_active)
    VALUES (source.id, source.name, source.slug, source.display_order, source.is_active);
GO

SET IDENTITY_INSERT dbo.gallery_categories OFF;
GO

PRINT 'Seed gallery_categories: done.';
GO
