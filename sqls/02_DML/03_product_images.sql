-- =============================================
-- 02_DML/03_product_images.sql
-- Seed: dbo.product_images
-- =============================================
-- Idempotent: insert nếu chưa có cặp (product_id, image_url).
SET NOCOUNT ON;

INSERT INTO dbo.product_images (product_id, image_url, caption, sort_order)
SELECT product.id, source.image_url, source.caption, source.sort_order
FROM (VALUES
    (N'giuong-oc-cho-g01', N'/src/assets/img/rooms/1.jpg', N'Giường G01', 1),
    (N'giuong-oc-cho-g02', N'/src/assets/img/rooms/2.jpg', N'Giường G02', 1),
    (N'giuong-oc-cho-g03', N'/src/assets/img/rooms/3.jpg', N'Giường G03', 1),
    (N'tu-oc-cho-t01',     N'/src/assets/img/rooms/7.png', N'Tủ T01',     1)
) AS source(product_slug, image_url, caption, sort_order)
INNER JOIN dbo.products AS product ON product.slug = source.product_slug
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.product_images
    WHERE product_id = product.id AND image_url = source.image_url
);
GO

