-- Gallery feature migration for an existing SQL Server DLFurniture database.
-- Safe to run more than once: schema changes and data inserts are guarded.
-- With sqlcmd on Windows, use `-f 65001` so Vietnamese seed text is read as UTF-8.
SET XACT_ABORT ON;
BEGIN TRANSACTION;

IF OBJECT_ID(N'dbo.gallery_categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.gallery_categories (
        id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
        name          NVARCHAR (255) NOT NULL,
        slug          NVARCHAR (100) NOT NULL UNIQUE,
        display_order INT            NOT NULL DEFAULT 0,
        is_active     BIT            NOT NULL DEFAULT 1,
        CONSTRAINT CK_gallery_categories_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
        CONSTRAINT CK_gallery_categories_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0)
    );
END;

IF OBJECT_ID(N'dbo.gallery_items', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.gallery_items (
        id            BIGINT          IDENTITY (1, 1) PRIMARY KEY,
        category_id   BIGINT          NOT NULL,
        project_id    BIGINT          NULL,
        title         NVARCHAR (255)  NOT NULL,
        description   NVARCHAR (MAX)  NULL,
        media_type    NVARCHAR (20)   NOT NULL,
        media_url     NVARCHAR (1024) NOT NULL,
        thumbnail_url NVARCHAR (1024) NULL,
        alt_text      NVARCHAR (500)  NULL,
        provider      NVARCHAR (30)   NOT NULL DEFAULT N'local',
        duration      NVARCHAR (20)   NULL,
        is_featured   BIT             NOT NULL DEFAULT 0,
        display_order INT             NOT NULL DEFAULT 0,
        is_active     BIT             NOT NULL DEFAULT 1,
        created_at    DATETIMEOFFSET  NOT NULL DEFAULT SYSUTCDATETIME(),
        updated_at    DATETIMEOFFSET  NOT NULL DEFAULT SYSUTCDATETIME(),
        CONSTRAINT FK_gallery_items_category FOREIGN KEY (category_id) REFERENCES dbo.gallery_categories (id),
        CONSTRAINT FK_gallery_items_project FOREIGN KEY (project_id) REFERENCES dbo.projects (id) ON DELETE SET NULL,
        CONSTRAINT CK_gallery_items_media_type CHECK (media_type IN (N'image', N'video')),
        CONSTRAINT CK_gallery_items_provider CHECK (provider IN (N'local', N'youtube', N'vimeo'))
    );

    CREATE INDEX IX_gallery_items_active_type_order
        ON dbo.gallery_items (is_active, media_type, display_order);
END;

IF COL_LENGTH(N'dbo.gallery_items', N'project_id') IS NULL
BEGIN
    ALTER TABLE dbo.gallery_items ADD project_id BIGINT NULL;
END;

GO

IF NOT EXISTS (
    SELECT 1 FROM sys.foreign_keys
    WHERE name = N'FK_gallery_items_project'
      AND parent_object_id = OBJECT_ID(N'dbo.gallery_items')
)
BEGIN
    ALTER TABLE dbo.gallery_items
        ADD CONSTRAINT FK_gallery_items_project
        FOREIGN KEY (project_id) REFERENCES dbo.projects (id) ON DELETE SET NULL;
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_gallery_items_active_type_updated'
      AND object_id = OBJECT_ID(N'dbo.gallery_items')
)
BEGIN
    CREATE INDEX IX_gallery_items_active_type_updated
        ON dbo.gallery_items (is_active, media_type, updated_at DESC, id DESC)
        INCLUDE (category_id);
END;

IF NOT EXISTS (
    SELECT 1 FROM sys.indexes
    WHERE name = N'IX_gallery_items_project_id'
      AND object_id = OBJECT_ID(N'dbo.gallery_items')
)
BEGIN
    CREATE INDEX IX_gallery_items_project_id
        ON dbo.gallery_items (project_id);
END;

IF EXISTS (SELECT 1 FROM dbo.projects WHERE id = 2)
BEGIN
    UPDATE dbo.projects
    SET title = N'Thiết kế nội thất biệt thự Vinhomes Grand Park'
    WHERE id = 2;
END;

IF EXISTS (SELECT 1 FROM dbo.projects WHERE id = 3)
BEGIN
    UPDATE dbo.projects
    SET title = N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên',
        subtitle = N'Villa cao cấp', client_name = N'Chị Hằng', location = N'Vĩnh Yên',
        description = N'Thiết kế và thi công biệt thự KĐT Vĩnh Yên',
        cover_image = N'/src/assets/img/slider/3.jpg', status = N'published'
    WHERE id = 3;
END
ELSE IF NOT EXISTS (SELECT 1 FROM dbo.projects WHERE title = N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên')
BEGIN
    INSERT INTO dbo.projects (title, subtitle, client_name, location, description, cover_image, status)
    VALUES (N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên', N'Villa cao cấp', N'Chị Hằng', N'Vĩnh Yên',
            N'Thiết kế và thi công biệt thự KĐT Vĩnh Yên', N'/src/assets/img/slider/3.jpg', N'published');
END;

IF EXISTS (SELECT 1 FROM dbo.projects WHERE id = 4)
BEGIN
    UPDATE dbo.projects
    SET title = N'Thiết kế nội thất căn hộ Vinhomes Metropolis',
        subtitle = N'Căn hộ cao cấp', client_name = N'Chị Nguyệt', location = N'Liễu Giai',
        description = N'Thiết kế và thi công căn hộ Vinhomes Metropolis',
        cover_image = N'/src/assets/img/slider/2.jpg', status = N'published'
    WHERE id = 4;
END
ELSE IF NOT EXISTS (SELECT 1 FROM dbo.projects WHERE title = N'Thiết kế nội thất căn hộ Vinhomes Metropolis')
BEGIN
    INSERT INTO dbo.projects (title, subtitle, client_name, location, description, cover_image, status)
    VALUES (N'Thiết kế nội thất căn hộ Vinhomes Metropolis', N'Căn hộ cao cấp', N'Chị Nguyệt', N'Liễu Giai',
            N'Thiết kế và thi công căn hộ Vinhomes Metropolis', N'/src/assets/img/slider/2.jpg', N'published');
END;

DECLARE @categories TABLE (
    name NVARCHAR(255),
    slug NVARCHAR(100),
    display_order INT
);

INSERT INTO @categories (name, slug, display_order)
VALUES (N'Phòng khách', N'phong-khach', 1),
       (N'Phòng bếp', N'phong-bep', 2),
       (N'Phòng ngủ', N'phong-ngu', 3),
       (N'Xưởng chế tác', N'xuong-che-tac', 4),
       (N'Dự án', N'du-an', 5),
       (N'Vật liệu', N'vat-lieu', 6);

UPDATE target
SET target.name = source.name,
    target.display_order = source.display_order,
    target.is_active = 1
FROM dbo.gallery_categories target
INNER JOIN @categories source ON source.slug = target.slug;

INSERT INTO dbo.gallery_categories (name, slug, display_order, is_active)
SELECT source.name, source.slug, source.display_order, 1
FROM @categories source
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.gallery_categories target WHERE target.slug = source.slug
);

DECLARE @project1 BIGINT = (SELECT TOP (1) id FROM dbo.projects WHERE id = 1 OR title = N'Thiết kế nội thất Saroma Villa' ORDER BY CASE WHEN id = 1 THEN 0 ELSE 1 END);
DECLARE @project2 BIGINT = (SELECT TOP (1) id FROM dbo.projects WHERE id = 2 OR title LIKE N'%Vinhomes Grand Park%' ORDER BY CASE WHEN id = 2 THEN 0 ELSE 1 END);
DECLARE @project3 BIGINT = (SELECT TOP (1) id FROM dbo.projects WHERE title = N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên');
DECLARE @project4 BIGINT = (SELECT TOP (1) id FROM dbo.projects WHERE title = N'Thiết kế nội thất căn hộ Vinhomes Metropolis');

DECLARE @items TABLE (
    category_slug NVARCHAR(100),
    project_id BIGINT NULL,
    title NVARCHAR(255),
    description NVARCHAR(MAX),
    media_type NVARCHAR(20),
    media_url NVARCHAR(1024),
    thumbnail_url NVARCHAR(1024),
    alt_text NVARCHAR(500),
    provider NVARCHAR(30),
    duration NVARCHAR(20),
    is_featured BIT,
    display_order INT
);

INSERT INTO @items
    (category_slug, project_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order)
VALUES
    (N'phong-khach', @project1, N'Walnut Villa — Phòng khách nhiệt đới', N'Không gian sinh hoạt mở với sofa, bàn trà và ghế thư giãn chế tác từ gỗ óc chó.', N'image', N'/media/gallery/walnut-villa-living.webp', N'/media/gallery/walnut-villa-living.webp', N'Phòng khách biệt thự với nội thất gỗ óc chó và cửa kính nhìn ra vườn', N'local', NULL, 1, 1),
    (N'phong-bep', @project1, N'Bếp mở trong ánh sáng tự nhiên', N'Hệ tủ bếp và bàn ăn đồng bộ, cân bằng giữa vân gỗ ấm và đá tự nhiên.', N'image', N'/media/gallery/walnut-villa-kitchen.webp', N'/media/gallery/walnut-villa-kitchen.webp', N'Bếp biệt thự với tủ gỗ óc chó, đảo đá và bàn ăn sáu ghế', N'local', NULL, 1, 2),
    (N'phong-ngu', @project2, N'Phòng ngủ Walnut Suite', N'Bảng màu trầm, hệ giường liền bàn và ánh sáng điểm tạo cảm giác riêng tư.', N'image', N'/media/gallery/walnut-suite.jpg', N'/media/gallery/walnut-suite.jpg', N'Phòng ngủ tông trầm với giường và bàn làm việc gỗ óc chó', N'local', NULL, 0, 3),
    (N'xuong-che-tac', NULL, N'Điểm chạm thủ công', N'Từng đường cong của ghế được hoàn thiện bằng tay để giữ trọn biểu cảm của gỗ.', N'image', N'/media/gallery/artisan-walnut-chair.webp', N'/media/gallery/artisan-walnut-chair.webp', N'Nghệ nhân hoàn thiện thủ công một chi tiết ghế bằng gỗ óc chó', N'local', NULL, 0, 4),
    (N'phong-khach', @project3, N'Sảnh nghỉ tĩnh lặng', N'Đường nét Á Đông tối giản kết hợp bề mặt gỗ tự nhiên và vật liệu đan.', N'image', N'/media/gallery/quiet-lounge.jpg', N'/media/gallery/quiet-lounge.jpg', N'Sảnh nghỉ tối giản với tủ console gỗ và mảng trang trí thủ công', N'local', NULL, 0, 5),
    (N'phong-bep', @project3, N'Dining Hall — Ánh sáng và chất liệu', N'Không gian bàn ăn dài với nhịp vòm, ánh sáng ấm và bảng màu đất.', N'image', N'/media/gallery/arched-dining.jpg', N'/media/gallery/arched-dining.jpg', N'Không gian bàn ăn dài dưới trần vòm với đèn thủ công', N'local', NULL, 0, 6),
    (N'xuong-che-tac', NULL, N'The Art of Furniture Making', N'Góc nhìn sâu vào hành trình biến vật liệu thô thành đồ nội thất có tuổi thọ lâu dài.', N'video', N'https://vimeo.com/573906036', N'/media/gallery/artisan-walnut-chair.webp', N'Video về nghệ thuật chế tác nội thất thủ công', N'vimeo', N'04:18', 1, 7),
    (N'xuong-che-tac', NULL, N'Nghệ thuật của kỹ thuật ghép mộng', N'Độ chính xác, độ bền và thẩm mỹ gặp nhau trong từng mối ghép.', N'video', N'https://vimeo.com/174156297', N'/media/gallery/walnut-joinery-detail.webp', N'Video về kỹ thuật ghép mộng trong nội thất gỗ', N'vimeo', N'02:42', 0, 8),
    (N'du-an', @project1, N'Từ nhà thiết kế đến người hoàn thiện', N'Hành trình hợp tác giữa thiết kế, chế tác và hoàn thiện một không gian sống độc bản.', N'video', N'https://vimeo.com/82229898', N'/media/gallery/walnut-villa-living.webp', N'Video về quy trình thiết kế và hoàn thiện nội thất', N'vimeo', N'06:34', 0, 9),
    (N'vat-lieu', NULL, N'Di sản của gỗ óc chó', N'Câu chuyện vật liệu, tỷ lệ và ngôn ngữ thiết kế làm nên sức sống bền bỉ của walnut.', N'video', N'https://vimeo.com/340431711', N'/media/gallery/walnut-suite.jpg', N'Video kể câu chuyện về nội thất gỗ óc chó', N'vimeo', N'03:56', 0, 10),
    (N'phong-khach', @project1, N'Thư phòng Walnut Library', N'Hệ tủ sách cao kịch trần, bàn làm việc điêu khắc và ghế da trong ánh sáng dịu.', N'image', N'/media/gallery/walnut-home-library.webp', N'/media/gallery/walnut-home-library.webp', N'Thư phòng biệt thự với hệ tủ sách gỗ óc chó và bàn làm việc', N'local', NULL, 1, 11),
    (N'du-an', @project1, N'Phòng tắm Walnut & Limestone', N'Gỗ óc chó, đá limestone và ánh sáng gián tiếp tạo nên nhịp nghỉ thư thái.', N'image', N'/media/gallery/walnut-stone-bathroom.webp', N'/media/gallery/walnut-stone-bathroom.webp', N'Phòng tắm cao cấp với tủ lavabo gỗ óc chó và bồn tắm đá', N'local', NULL, 1, 12),
    (N'xuong-che-tac', NULL, N'Mối ghép lưu dấu bàn tay', N'Chi tiết mộng gỗ được căn chỉnh và hoàn thiện thủ công tại xưởng.', N'image', N'/media/gallery/walnut-joinery-detail.webp', N'/media/gallery/walnut-joinery-detail.webp', N'Đôi tay người thợ đang hoàn thiện mối ghép gỗ óc chó', N'local', NULL, 0, 13),
    (N'vat-lieu', @project3, N'Bức tường nghệ thuật trong ánh nắng sớm', N'Một khoảng chuyển tiếp được tiết chế bằng tranh sơn mài, bình gốm và gỗ tối màu.', N'image', N'/media/gallery/villa-art-wall.webp', N'/media/gallery/villa-art-wall.webp', N'Bức tường nghệ thuật và tủ gỗ trong không gian biệt thự', N'local', NULL, 0, 14),
    (N'phong-ngu', @project2, N'Phòng ngủ sắc đất', N'Bảng màu nâu đất, vải dệt thô và bề mặt gỗ tạo cảm giác ấm, sâu và yên tĩnh.', N'image', N'/media/gallery/villa-bedroom-earth.webp', N'/media/gallery/villa-bedroom-earth.webp', N'Phòng ngủ biệt thự mang bảng màu nâu đất', N'local', NULL, 0, 15),
    (N'phong-ngu', @project2, N'Bedroom Lounge — Khoảng nghỉ riêng', N'Khu ngồi thư giãn được nối liền với phòng ngủ bằng cùng một ngôn ngữ vật liệu.', N'image', N'/media/gallery/villa-bedroom-lounge.webp', N'/media/gallery/villa-bedroom-lounge.webp', N'Phòng ngủ có khu ghế nghỉ và cửa kính lớn', N'local', NULL, 0, 16),
    (N'phong-ngu', @project4, N'Góc làm việc trong phòng ngủ', N'Bàn viết gọn, ánh sáng tập trung và hệ tủ liền khối cho căn hộ đô thị.', N'image', N'/media/gallery/villa-bedroom-desk.webp', N'/media/gallery/villa-bedroom-desk.webp', N'Góc làm việc bằng gỗ trong phòng ngủ căn hộ', N'local', NULL, 0, 17),
    (N'phong-bep', @project4, N'Bếp gỗ và mây đan', N'Các bề mặt cứng được làm mềm bằng cánh tủ mây đan và sắc gỗ tự nhiên.', N'image', N'/media/gallery/villa-kitchen-rattan.webp', N'/media/gallery/villa-kitchen-rattan.webp', N'Tủ bếp gỗ kết hợp cánh mây đan', N'local', NULL, 0, 18),
    (N'vat-lieu', @project4, N'Vanity Stone — Đá và gỗ', N'Bàn lavabo gỗ đặt trong lớp nền đá sáng, giữ tinh thần tối giản và sang trọng.', N'image', N'/media/gallery/villa-vanity-stone.webp', N'/media/gallery/villa-vanity-stone.webp', N'Bàn lavabo gỗ trong phòng tắm ốp đá sáng', N'local', NULL, 0, 19),
    (N'xuong-che-tac', NULL, N'Thiết kế ghế như một tác phẩm', N'Từ phác thảo, tạo dáng đến bọc hoàn thiện một mẫu ghế có cá tính riêng.', N'video', N'https://vimeo.com/213826087', N'/media/gallery/villa-bedroom-lounge.webp', N'Video về thiết kế và chế tác ghế thủ công', N'vimeo', N'03:28', 0, 20),
    (N'xuong-che-tac', NULL, N'Process — Nhịp điệu của người thợ', N'Một thước phim chậm về triết lý, độ chính xác và niềm vui trong nghề mộc.', N'video', N'https://vimeo.com/247657353', N'/media/gallery/walnut-joinery-detail.webp', N'Video ghi lại quy trình làm đồ gỗ thủ công', N'vimeo', N'05:12', 1, 21),
    (N'vat-lieu', @project2, N'Biểu tượng ghế trong không gian sống', N'Hình khối, vật liệu và tỷ lệ biến một chiếc ghế thành điểm nhấn của căn phòng.', N'video', N'https://vimeo.com/748153633', N'/media/gallery/walnut-home-library.webp', N'Video giới thiệu thiết kế ghế mang tính biểu tượng', N'vimeo', N'01:46', 0, 22),
    (N'du-an', @project4, N'Không gian linh hoạt cho căn hộ đô thị', N'Cách tư duy nội thất thông minh giúp một diện tích gọn vẫn giàu trải nghiệm.', N'video', N'https://vimeo.com/383115350', N'/media/gallery/villa-bedroom-desk.webp', N'Video về giải pháp nội thất linh hoạt cho căn hộ', N'vimeo', N'03:08', 0, 23);

UPDATE target
SET target.category_id = category.id,
    target.project_id = source.project_id,
    target.title = source.title,
    target.description = source.description,
    target.thumbnail_url = source.thumbnail_url,
    target.alt_text = source.alt_text,
    target.provider = source.provider,
    target.duration = source.duration,
    target.is_featured = source.is_featured,
    target.display_order = source.display_order,
    target.is_active = 1,
    target.updated_at = SYSUTCDATETIME()
FROM dbo.gallery_items target
INNER JOIN @items source ON source.media_url = target.media_url
INNER JOIN dbo.gallery_categories category ON category.slug = source.category_slug;

INSERT INTO dbo.gallery_items
    (category_id, project_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
SELECT category.id, source.project_id, source.title, source.description, source.media_type, source.media_url,
       source.thumbnail_url, source.alt_text, source.provider, source.duration,
       source.is_featured, source.display_order, 1
FROM @items source
INNER JOIN dbo.gallery_categories category ON category.slug = source.category_slug
WHERE NOT EXISTS (
    SELECT 1 FROM dbo.gallery_items target WHERE target.media_url = source.media_url
);

COMMIT TRANSACTION;
