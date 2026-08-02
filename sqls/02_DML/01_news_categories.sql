-- =============================================
-- 02_DML/01_news_categories.sql
-- Seed: dbo.news_categories
-- =============================================
-- Idempotent: upsert theo slug.
SET NOCOUNT ON;

INSERT INTO dbo.news_categories (name, slug, display_order, is_active)
SELECT source.name, source.slug, source.display_order, 1
FROM (VALUES
    (N'Tin tức gỗ óc chó',  N'go-oc-cho',             1),
    (N'Khai trương',        N'khai-truong',           2),
    (N'Hoàn thiện công trình', N'hoan-thien-cong-trinh', 3),
    (N'Chia sẻ chuyên môn', N'chia-se-chuyen-mon',    4),
    (N'Sự kiện',            N'su-kien',               5)
) AS source(name, slug, display_order)
WHERE NOT EXISTS (SELECT 1 FROM dbo.news_categories WHERE slug = source.slug);

UPDATE target
SET target.name = source.name,
    target.display_order = source.display_order,
    target.is_active = 1,
    target.updated_at = SYSUTCDATETIME()
FROM dbo.news_categories AS target
INNER JOIN (VALUES
    (N'Tin tức gỗ óc chó',  N'go-oc-cho',             1),
    (N'Khai trương',        N'khai-truong',           2),
    (N'Hoàn thiện công trình', N'hoan-thien-cong-trinh', 3),
    (N'Chia sẻ chuyên môn', N'chia-se-chuyen-mon',    4),
    (N'Sự kiện',            N'su-kien',               5)
) AS source(name, slug, display_order) ON source.slug = target.slug;
GO

