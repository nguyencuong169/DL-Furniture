-- =============================================
-- 02_DML/02_products.sql
-- Seed: dbo.products
-- =============================================
-- Idempotent: upsert theo slug.
SET NOCOUNT ON;

INSERT INTO dbo.products (category_id, sku, slug, name, summary, description, price, currency, main_image, is_active, hidden)
SELECT category.id, source.sku, source.slug, source.name, source.summary, source.description, source.price, N'VND', source.main_image, 1, 0
FROM (VALUES
    (N'phong-ngu', N'G01', N'giuong-oc-cho-g01', N'Giường Óc Chó - G01', N'Giường óc chó sang trọng', N'Mô tả chi tiết Giường Óc Chó - G01', 11000000.00, N'/src/assets/img/rooms/1.jpg'),
    (N'phong-ngu', N'G02', N'giuong-oc-cho-g02', N'Giường Óc Chó - G02', N'Giường óc chó mẫu 2', N'Mô tả chi tiết G02', 10700000.00, N'/src/assets/img/rooms/2.jpg'),
    (N'phong-ngu', N'G03', N'giuong-oc-cho-g03', N'Giường Óc Chó - G03', N'Giường cao cấp', N'Mô tả chi tiết G03', 25000000.00, N'/src/assets/img/rooms/3.jpg'),
    (N'phong-khach', N'T01', N'tu-oc-cho-t01', N'Tủ Óc Chó - T01', N'Tủ gỗ óc chó', N'Mô tả T01', 15000000.00, N'/src/assets/img/rooms/7.png')
) AS source(category_slug, sku, slug, name, summary, description, price, main_image)
INNER JOIN dbo.categories AS category ON category.slug = source.category_slug
WHERE NOT EXISTS (SELECT 1 FROM dbo.products WHERE slug = source.slug);

UPDATE target
SET target.category_id = category.id,
    target.sku = source.sku,
    target.name = source.name,
    target.summary = source.summary,
    target.description = source.description,
    target.price = source.price,
    target.main_image = source.main_image,
    target.is_active = 1,
    target.hidden = 0,
    target.updated_at = SYSUTCDATETIME()
FROM dbo.products AS target
INNER JOIN (VALUES
    (N'phong-ngu', N'G01', N'giuong-oc-cho-g01', N'Giường Óc Chó - G01', N'Giường óc chó sang trọng', N'Mô tả chi tiết Giường Óc Chó - G01', 11000000.00, N'/src/assets/img/rooms/1.jpg'),
    (N'phong-ngu', N'G02', N'giuong-oc-cho-g02', N'Giường Óc Chó - G02', N'Giường óc chó mẫu 2', N'Mô tả chi tiết G02', 10700000.00, N'/src/assets/img/rooms/2.jpg'),
    (N'phong-ngu', N'G03', N'giuong-oc-cho-g03', N'Giường Óc Chó - G03', N'Giường cao cấp', N'Mô tả chi tiết G03', 25000000.00, N'/src/assets/img/rooms/3.jpg'),
    (N'phong-khach', N'T01', N'tu-oc-cho-t01', N'Tủ Óc Chó - T01', N'Tủ gỗ óc chó', N'Mô tả T01', 15000000.00, N'/src/assets/img/rooms/7.png')
) AS source(category_slug, sku, slug, name, summary, description, price, main_image)
INNER JOIN dbo.categories AS category ON category.slug = source.category_slug
ON target.slug = source.slug;
GO

