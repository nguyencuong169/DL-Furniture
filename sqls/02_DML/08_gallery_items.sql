-- =============================================
-- 02_DML/08_gallery_items.sql
-- Seed: dbo.gallery_items
-- =============================================
-- Idempotent: dùng MERGE theo media_url (unique).
-- Lưu ý: cần projects, gallery_categories đã có dữ liệu.
-- 23 items (10 fixed-id + 13 variable).
-- --------------------------------------------------------
-- Helper: lấy project_id nếu project tồn tại
-- --------------------------------------------------------
DECLARE @project1 BIGINT = ISNULL((SELECT id FROM dbo.projects WHERE title = N'Thiết kế nội thất Saroma Villa'), 1);
DECLARE @project2 BIGINT = ISNULL((SELECT id FROM dbo.projects WHERE title = N'Thiết kế nội thất biệt thự Vinhomes Grand Park'), 2);
DECLARE @project3 BIGINT = (SELECT id FROM dbo.projects WHERE title = N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên');
DECLARE @project4 BIGINT = (SELECT id FROM dbo.projects WHERE title = N'Thiết kế nội thất căn hộ Vinhomes Metropolis');
GO

-- --------------------------------------------------------
-- 10 items với id cố định
-- --------------------------------------------------------
SET IDENTITY_INSERT dbo.gallery_items ON;
GO

MERGE INTO dbo.gallery_items AS target
USING (VALUES
    (1,  @project1, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-khach'), N'Walnut Villa — Phòng khách nhiệt đới', N'Không gian sinh hoạt mở với sofa, bàn trà và ghế thư giãn chế tác từ gỗ óc chó.', N'image', N'/media/gallery/walnut-villa-living.webp', N'/media/gallery/walnut-villa-living.webp', N'Phòng khách biệt thự với nội thất gỗ óc chó và cửa kính nhìn ra vườn', N'local', NULL, 1, 1, 1),
    (2,  @project1, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-bep'), N'Bếp mở trong ánh sáng tự nhiên', N'Hệ tủ bếp và bàn ăn đồng bộ, cân bằng giữa vân gỗ ấm và đá tự nhiên.', N'image', N'/media/gallery/walnut-villa-kitchen.webp', N'/media/gallery/walnut-villa-kitchen.webp', N'Bếp biệt thự với tủ gỗ óc chó, đảo đá và bàn ăn sáu ghế', N'local', NULL, 1, 2, 1),
    (3,  @project2, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-ngu'), N'Phòng ngủ Walnut Suite', N'Bảng màu trầm, hệ giường liền bàn và ánh sáng điểm tạo cảm giác riêng tư.', N'image', N'/media/gallery/walnut-suite.jpg', N'/media/gallery/walnut-suite.jpg', N'Phòng ngủ tông trầm với giường và bàn làm việc gỗ óc chó', N'local', NULL, 0, 3, 1),
    (4,  NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'xuong-che-tac'), N'Điểm chạm thủ công', N'Từng đường cong của ghế được hoàn thiện bằng tay để giữ trọn biểu cảm của gỗ.', N'image', N'/media/gallery/artisan-walnut-chair.webp', N'/media/gallery/artisan-walnut-chair.webp', N'Nghệ nhân hoàn thiện thủ công một chi tiết ghế bằng gỗ óc chó', N'local', NULL, 0, 4, 1),
    (5,  @project3, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-khach'), N'Sảnh nghỉ tĩnh lặng', N'Đường nét Á Đông tối giản kết hợp bề mặt gỗ tự nhiên và vật liệu đan.', N'image', N'/media/gallery/quiet-lounge.jpg', N'/media/gallery/quiet-lounge.jpg', N'Sảnh nghỉ tối giản với tủ console gỗ và mảng trang trí thủ công', N'local', NULL, 0, 5, 1),
    (6,  @project3, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-bep'), N'Dining Hall — Ánh sáng và chất liệu', N'Không gian bàn ăn dài với nhịp vòm, ánh sáng ấm và bảng màu đất.', N'image', N'/media/gallery/arched-dining.jpg', N'/media/gallery/arched-dining.jpg', N'Không gian bàn ăn dài dưới trần vòm với đèn thủ công', N'local', NULL, 0, 6, 1),
    (7,  NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'xuong-che-tac'), N'The Art of Furniture Making', N'Góc nhìn sâu vào hành trình biến vật liệu thô thành đồ nội thất có tuổi thọ lâu dài.', N'video', N'https://vimeo.com/573906036', N'/media/gallery/artisan-walnut-chair.webp', N'Video về nghệ thuật chế tác nội thất thủ công', N'vimeo', N'04:18', 1, 7, 1),
    (8,  NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'xuong-che-tac'), N'Nghệ thuật của kỹ thuật ghép mộng', N'Độ chính xác, độ bền và thẩm mỹ gặp nhau trong từng mối ghép.', N'video', N'https://vimeo.com/174156297', N'/media/gallery/walnut-joinery-detail.webp', N'Video về kỹ thuật ghép mộng trong nội thất gỗ', N'vimeo', N'02:42', 0, 8, 1),
    (9,  @project1, (SELECT id FROM dbo.gallery_categories WHERE slug = N'du-an'), N'Từ nhà thiết kế đến người hoàn thiện', N'Hành trình hợp tác giữa thiết kế, chế tác và hoàn thiện một không gian sống độc bản.', N'video', N'https://vimeo.com/82229898', N'/media/gallery/walnut-villa-living.webp', N'Video về quy trình thiết kế và hoàn thiện nội thất', N'vimeo', N'06:34', 0, 9, 1),
    (10, NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'vat-lieu'), N'Di sản của gỗ óc chó', N'Câu chuyện vật liệu, tỷ lệ và ngôn ngữ thiết kế làm nên sức sống bền bỉ của walnut.', N'video', N'https://vimeo.com/340431711', N'/media/gallery/walnut-suite.jpg', N'Video kể câu chuyện về nội thất gỗ óc chó', N'vimeo', N'03:56', 0, 10, 1)
) AS source (id, project_id, category_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
ON target.id = source.id
WHEN MATCHED THEN
    UPDATE SET
        target.project_id = source.project_id,
        target.category_id = source.category_id,
        target.title = source.title,
        target.description = source.description,
        target.media_type = source.media_type,
        target.media_url = source.media_url,
        target.thumbnail_url = source.thumbnail_url,
        target.alt_text = source.alt_text,
        target.provider = source.provider,
        target.duration = source.duration,
        target.is_featured = source.is_featured,
        target.display_order = source.display_order,
        target.is_active = source.is_active
WHEN NOT MATCHED THEN
    INSERT (id, project_id, category_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
    VALUES (source.id, source.project_id, source.category_id, source.title, source.description, source.media_type, source.media_url, source.thumbnail_url, source.alt_text, source.provider, source.duration, source.is_featured, source.display_order, source.is_active);
GO

SET IDENTITY_INSERT dbo.gallery_items OFF;
GO

-- --------------------------------------------------------
-- 13 items với identity tự động
-- --------------------------------------------------------
MERGE INTO dbo.gallery_items AS target
USING (VALUES
    (@project1, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-khach'), N'Thư phòng Walnut Library', N'Hệ tủ sách cao kịch trần, bàn làm việc điêu khắc và ghế da trong ánh sáng dịu.', N'image', N'/media/gallery/walnut-home-library.webp', N'/media/gallery/walnut-home-library.webp', N'Thư phòng biệt thự với hệ tủ sách gỗ óc chó và bàn làm việc', N'local', NULL, 1, 11, 1),
    (@project1, (SELECT id FROM dbo.gallery_categories WHERE slug = N'du-an'), N'Phòng tắm Walnut & Limestone', N'Gỗ óc chó, đá limestone và ánh sáng gián tiếp tạo nên nhịp nghỉ thư thái.', N'image', N'/media/gallery/walnut-stone-bathroom.webp', N'/media/gallery/walnut-stone-bathroom.webp', N'Phòng tắm cao cấp với tủ lavabo gỗ óc chó và bồn tắm đá', N'local', NULL, 1, 12, 1),
    (NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'xuong-che-tac'), N'Mối ghép lưu dấu bàn tay', N'Chi tiết mộng gỗ được căn chỉnh và hoàn thiện thủ công tại xưởng.', N'image', N'/media/gallery/walnut-joinery-detail.webp', N'/media/gallery/walnut-joinery-detail.webp', N'Đôi tay người thợ đang hoàn thiện mối ghép gỗ óc chó', N'local', NULL, 0, 13, 1),
    (@project3, (SELECT id FROM dbo.gallery_categories WHERE slug = N'vat-lieu'), N'Bức tường nghệ thuật trong ánh nắng sớm', N'Một khoảng chuyển tiếp được tiết chế bằng tranh sơn mài, bình gốm và gỗ tối màu.', N'image', N'/media/gallery/villa-art-wall.webp', N'/media/gallery/villa-art-wall.webp', N'Bức tường nghệ thuật và tủ gỗ trong không gian biệt thự', N'local', NULL, 0, 14, 1),
    (@project2, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-ngu'), N'Phòng ngủ sắc đất', N'Bảng màu nâu đất, vải dệt thô và bề mặt gỗ tạo cảm giác ấm, sâu và yên tĩnh.', N'image', N'/media/gallery/villa-bedroom-earth.webp', N'/media/gallery/villa-bedroom-earth.webp', N'Phòng ngủ biệt thự mang bảng màu nâu đất', N'local', NULL, 0, 15, 1),
    (@project2, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-ngu'), N'Bedroom Lounge — Khoảng nghỉ riêng', N'Khu ngồi thư giãn được nối liền với phòng ngủ bằng cùng một ngôn ngữ vật liệu.', N'image', N'/media/gallery/villa-bedroom-lounge.webp', N'/media/gallery/villa-bedroom-lounge.webp', N'Phòng ngủ có khu ghế nghỉ và cửa kính lớn', N'local', NULL, 0, 16, 1),
    (@project4, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-ngu'), N'Góc làm việc trong phòng ngủ', N'Bàn viết gọn, ánh sáng tập trung và hệ tủ liền khối cho căn hộ đô thị.', N'image', N'/media/gallery/villa-bedroom-desk.webp', N'/media/gallery/villa-bedroom-desk.webp', N'Góc làm việc bằng gỗ trong phòng ngủ căn hộ', N'local', NULL, 0, 17, 1),
    (@project4, (SELECT id FROM dbo.gallery_categories WHERE slug = N'phong-bep'), N'Bếp gỗ và mây đan', N'Các bề mặt cứng được làm mềm bằng cánh tủ mây đan và sắc gỗ tự nhiên.', N'image', N'/media/gallery/villa-kitchen-rattan.webp', N'/media/gallery/villa-kitchen-rattan.webp', N'Tủ bếp gỗ kết hợp cánh mây đan', N'local', NULL, 0, 18, 1),
    (@project4, (SELECT id FROM dbo.gallery_categories WHERE slug = N'vat-lieu'), N'Vanity Stone — Đá và gỗ', N'Bàn lavabo gỗ đặt trong lớp nền đá sáng, giữ tinh thần tối giản và sang trọng.', N'image', N'/media/gallery/villa-vanity-stone.webp', N'/media/gallery/villa-vanity-stone.webp', N'Bàn lavabo gỗ trong phòng tắm ốp đá sáng', N'local', NULL, 0, 19, 1),
    (NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'xuong-che-tac'), N'Thiết kế ghế như một tác phẩm', N'Từ phác thảo, tạo dáng đến bọc hoàn thiện một mẫu ghế có cá tính riêng.', N'video', N'https://vimeo.com/213826087', N'/media/gallery/villa-bedroom-lounge.webp', N'Video về thiết kế và chế tác ghế thủ công', N'vimeo', N'03:28', 0, 20, 1),
    (NULL,      (SELECT id FROM dbo.gallery_categories WHERE slug = N'xuong-che-tac'), N'Process — Nhịp điệu của người thợ', N'Một thước phim chậm về triết lý, độ chính xác và niềm vui trong nghề mộc.', N'video', N'https://vimeo.com/247657353', N'/media/gallery/walnut-joinery-detail.webp', N'Video ghi lại quy trình làm đồ gỗ thủ công', N'vimeo', N'05:12', 1, 21, 1),
    (@project2, (SELECT id FROM dbo.gallery_categories WHERE slug = N'vat-lieu'), N'Biểu tượng ghế trong không gian sống', N'Hình khối, vật liệu và tỷ lệ biến một chiếc ghế thành điểm nhấn của căn phòng.', N'video', N'https://vimeo.com/748153633', N'/media/gallery/walnut-home-library.webp', N'Video giới thiệu thiết kế ghế mang tính biểu tượng', N'vimeo', N'01:46', 0, 22, 1),
    (@project4, (SELECT id FROM dbo.gallery_categories WHERE slug = N'du-an'), N'Không gian linh hoạt cho căn hộ đô thị', N'Cách tư duy nội thất thông minh giúp một diện tích gọn vẫn giàu trải nghiệm.', N'video', N'https://vimeo.com/383115350', N'/media/gallery/villa-bedroom-desk.webp', N'Video về giải pháp nội thất linh hoạt cho căn hộ', N'vimeo', N'03:08', 0, 23, 1)
) AS source (project_id, category_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
ON target.media_url = source.media_url
WHEN MATCHED THEN
    UPDATE SET
        target.project_id = source.project_id,
        target.category_id = source.category_id,
        target.title = source.title,
        target.description = source.description,
        target.media_type = source.media_type,
        target.thumbnail_url = source.thumbnail_url,
        target.alt_text = source.alt_text,
        target.provider = source.provider,
        target.duration = source.duration,
        target.is_featured = source.is_featured,
        target.display_order = source.display_order,
        target.is_active = source.is_active
WHEN NOT MATCHED THEN
    INSERT (project_id, category_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
    VALUES (source.project_id, source.category_id, source.title, source.description, source.media_type, source.media_url, source.thumbnail_url, source.alt_text, source.provider, source.duration, source.is_featured, source.display_order, source.is_active);
GO

PRINT 'Seed gallery_items: done.';
GO
