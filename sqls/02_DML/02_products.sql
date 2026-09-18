-- =============================================
-- 02_DML/02_products.sql
-- Seed: dbo.products
-- =============================================
-- Idempotent: upsert theo slug.
SET NOCOUNT ON;

INSERT INTO dbo.products (category_id, sku, slug, name, summary, description, price, currency, main_image, is_active, hidden)
SELECT category.id, source.sku, source.slug, source.name, source.summary, source.description, source.price, N'VND', source.main_image, 1, 0
FROM (VALUES
    (N'phong-ngu', N'G01', N'giuong-oc-cho-g01', N'Giường Óc Chó - G01', N'Giường gỗ óc chó Bắc Mỹ với đầu giường bọc nệm, kết hợp khối gỗ nguyên tấm và vân gỗ tự nhiên.', N'Giường G01 được chế tác từ gỗ óc chó Bắc Mỹ chuẩn FAS, hoàn thiện sơn PU bóng mờ không mùi. Khung giường gia cố thanh giằng chịu lực, đầu giường bọc nệm êm ái.', 11000000.00, N'/media/gallery/villa-bedroom-earth.webp'),
    (N'phong-ngu', N'G02', N'giuong-oc-cho-g02', N'Giường Óc Chó - G02', N'Thiết kế giường thấp hiện đại, đầu giường liền vách ốp gỗ óc chó, phù hợp phòng ngủ tối giản.', N'Giường G02 mang phong cách thấp và tối giản, đầu giường liền vách ốp gỗ óc chó giúp không gian liền mạch. Gỗ được sấy đạt độ ẩm dưới 12%.', 10700000.00, N'/media/gallery/walnut-suite.jpg'),
    (N'phong-ngu', N'G03', N'giuong-oc-cho-g03', N'Giường Óc Chó - G03', N'Giường king-size cao cấp, đầu giường tấm gỗ nguyên khối, điểm nhấn cho phòng ngủ lớn.', N'Giường G03 king-size với đầu giường tấm gỗ óc chó nguyên khối. Mối ghép mộng kín, không lộ đinh vít, sơn PU bóng nổi bật độ sâu vân gỗ.', 25000000.00, N'/media/gallery/villa-bedroom-lounge.webp'),
    (N'phong-khach', N'T01', N'tu-oc-cho-t01', N'Tủ Óc Chó - T01', N'Kệ tivi & tủ trưng bày gỗ óc chó cho phòng khách, kết hợp cánh mở lẫn khoang mở.', N'Tủ T01 kết hợp khoang kín (bản lề giảm chấn) và khoang mở trưng bày. Mặt gỗ óc chó chọn vân liền mạch, hoàn thiện sơn PU không mùi.', 15000000.00, N'/media/gallery/walnut-home-library.webp')
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
    (N'phong-ngu', N'G01', N'giuong-oc-cho-g01', N'Giường Óc Chó - G01', N'Giường gỗ óc chó Bắc Mỹ với đầu giường bọc nệm, kết hợp khối gỗ nguyên tấm và vân gỗ tự nhiên.', N'Giường G01 được chế tác từ gỗ óc chó Bắc Mỹ chuẩn FAS, hoàn thiện sơn PU bóng mờ không mùi. Khung giường gia cố thanh giằng chịu lực, đầu giường bọc nệm êm ái.', 11000000.00, N'/media/gallery/villa-bedroom-earth.webp'),
    (N'phong-ngu', N'G02', N'giuong-oc-cho-g02', N'Giường Óc Chó - G02', N'Thiết kế giường thấp hiện đại, đầu giường liền vách ốp gỗ óc chó, phù hợp phòng ngủ tối giản.', N'Giường G02 mang phong cách thấp và tối giản, đầu giường liền vách ốp gỗ óc chó giúp không gian liền mạch. Gỗ được sấy đạt độ ẩm dưới 12%.', 10700000.00, N'/media/gallery/walnut-suite.jpg'),
    (N'phong-ngu', N'G03', N'giuong-oc-cho-g03', N'Giường Óc Chó - G03', N'Giường king-size cao cấp, đầu giường tấm gỗ nguyên khối, điểm nhấn cho phòng ngủ lớn.', N'Giường G03 king-size với đầu giường tấm gỗ óc chó nguyên khối. Mối ghép mộng kín, không lộ đinh vít, sơn PU bóng nổi bật độ sâu vân gỗ.', 25000000.00, N'/media/gallery/villa-bedroom-lounge.webp'),
    (N'phong-khach', N'T01', N'tu-oc-cho-t01', N'Tủ Óc Chó - T01', N'Kệ tivi & tủ trưng bày gỗ óc chó cho phòng khách, kết hợp cánh mở lẫn khoang mở.', N'Tủ T01 kết hợp khoang kín (bản lề giảm chấn) và khoang mở trưng bày. Mặt gỗ óc chó chọn vân liền mạch, hoàn thiện sơn PU không mùi.', 15000000.00, N'/media/gallery/walnut-home-library.webp')
) AS source(category_slug, sku, slug, name, summary, description, price, main_image)
INNER JOIN dbo.categories AS category ON category.slug = source.category_slug
ON target.slug = source.slug;
GO