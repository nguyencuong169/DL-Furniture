-- =============================================
-- 02_DML/03_product_images.sql
-- Seed: dbo.product_images
-- =============================================
-- Idempotent: insert nếu chưa có cặp (product_id, image_url).
SET NOCOUNT ON;

INSERT INTO dbo.product_images (product_id, image_url, caption, sort_order)
SELECT product.id, source.image_url, source.caption, source.sort_order
FROM (VALUES
    (N'giuong-oc-cho-g01', N'/media/gallery/villa-bedroom-earth.webp', N'Giường G01', 1),
    (N'giuong-oc-cho-g01', N'/media/gallery/walnut-suite.jpg', N'Không gian phòng ngủ', 2),
    (N'giuong-oc-cho-g01', N'/media/gallery/villa-bedroom-lounge.webp', N'Phòng ngủ lounge', 3),
    (N'giuong-oc-cho-g01', N'/media/gallery/walnut-joinery-detail.webp', N'Chi tiết mối ghép', 4),
    (N'giuong-oc-cho-g02', N'/media/gallery/walnut-suite.jpg', N'Giường G02', 1),
    (N'giuong-oc-cho-g02', N'/media/gallery/villa-bedroom-earth.webp', N'Phòng ngủ gỗ óc chó', 2),
    (N'giuong-oc-cho-g02', N'/media/gallery/villa-bedroom-desk.webp', N'Bàn làm việc liền phòng', 3),
    (N'giuong-oc-cho-g03', N'/media/gallery/villa-bedroom-lounge.webp', N'Giường G03', 1),
    (N'giuong-oc-cho-g03', N'/media/gallery/villa-bedroom-earth.webp', N'Phòng ngủ đất', 2),
    (N'giuong-oc-cho-g03', N'/media/gallery/walnut-suite.jpg', N'Bộ sưu tập phòng ngủ', 3),
    (N'tu-oc-cho-t01', N'/media/gallery/walnut-home-library.webp', N'Tủ T01', 1),
    (N'tu-oc-cho-t01', N'/media/gallery/walnut-villa-living.webp', N'Phòng khách gỗ óc chó', 2),
    (N'tu-oc-cho-t01', N'/media/gallery/arched-dining.jpg', N'Không gian mở', 3),
    (N'tu-oc-cho-t01', N'/media/gallery/quiet-lounge.jpg', N'Khu tiếp khách', 4)
) AS source(product_slug, image_url, caption, sort_order)
INNER JOIN dbo.products AS product ON product.slug = source.product_slug
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.product_images
    WHERE product_id = product.id AND image_url = source.image_url
);
GO