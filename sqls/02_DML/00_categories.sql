-- =============================================
-- 02_DML/00_categories.sql
-- Seed: dbo.categories
-- =============================================
-- Idempotent: upsert theo slug.
SET NOCOUNT ON;

-- Insert nếu chưa có slug
INSERT INTO dbo.categories (name, slug, parent_id, description, display_order, is_active)
SELECT source.name, source.slug, NULL, source.description, source.display_order, 1
FROM (VALUES
    (N'Phòng Ngủ',   N'phong-ngu',   N'Danh mục phòng ngủ',   1),
    (N'Phòng Khách', N'phong-khach', N'Danh mục phòng khách', 2),
    (N'Phòng Bếp',   N'phong-bep',   N'Danh mục phòng bếp',   3)
) AS source(name, slug, description, display_order)
WHERE NOT EXISTS (SELECT 1 FROM dbo.categories WHERE slug = source.slug);

-- Cập nhật thông tin nếu đã tồn tại
UPDATE target
SET target.name = source.name,
    target.description = source.description,
    target.display_order = source.display_order,
    target.is_active = 1,
    target.updated_at = SYSUTCDATETIME()
FROM dbo.categories AS target
INNER JOIN (VALUES
    (N'Phòng Ngủ',   N'phong-ngu',   N'Danh mục phòng ngủ',   1),
    (N'Phòng Khách', N'phong-khach', N'Danh mục phòng khách', 2),
    (N'Phòng Bếp',   N'phong-bep',   N'Danh mục phòng bếp',   3)
) AS source(name, slug, description, display_order) ON source.slug = target.slug;
GO

