-- =============================================
-- 02_DML/00_categories.sql
-- Seed: dbo.categories
-- =============================================
-- Idempotent: upsert theo slug.
SET NOCOUNT ON;

-- Insert nếu chưa có slug
INSERT INTO dbo.categories (
    name,
    slug,
    parent_id,
    description,
    image_url,
    image_alt,
    display_order,
    is_active
)
SELECT
    source.name,
    source.slug,
    NULL,
    source.description,
    source.image_url,
    source.image_alt,
    source.display_order,
    1
FROM (VALUES
    (
        N'Phòng Khách',
        N'phong-khach',
        N'Không gian tiếp khách cân bằng giữa tỷ lệ, tiện nghi và dấu ấn vật liệu.',
        N'/media/gallery/walnut-villa-living.webp',
        N'Phòng khách biệt thự với nội thất gỗ óc chó và cửa kính nhìn ra vườn',
        1
    ),
    (
        N'Phòng Ngủ',
        N'phong-ngu',
        N'Không gian nghỉ ngơi ấm áp, riêng tư và phù hợp với nhịp sống của gia chủ.',
        N'/media/gallery/villa-bedroom-earth.webp',
        N'Phòng ngủ biệt thự với nội thất gỗ và bảng màu nâu đất',
        2
    ),
    (
        N'Phòng Bếp',
        N'phong-bep',
        N'Bếp và bàn ăn được tổ chức liền mạch cho những khoảnh khắc sum họp.',
        N'/media/gallery/walnut-villa-kitchen.webp',
        N'Phòng bếp biệt thự với hệ tủ gỗ, đảo đá và bàn ăn',
        3
    )
) AS source(name, slug, description, image_url, image_alt, display_order)
WHERE NOT EXISTS (SELECT 1 FROM dbo.categories WHERE slug = source.slug);

-- Cập nhật thông tin nếu đã tồn tại
UPDATE target
SET target.name = source.name,
    target.description = source.description,
    target.image_url = source.image_url,
    target.image_alt = source.image_alt,
    target.display_order = source.display_order,
    target.is_active = 1,
    target.updated_at = SYSUTCDATETIME()
FROM dbo.categories AS target
INNER JOIN (VALUES
    (
        N'Phòng Khách',
        N'phong-khach',
        N'Không gian tiếp khách cân bằng giữa tỷ lệ, tiện nghi và dấu ấn vật liệu.',
        N'/media/gallery/walnut-villa-living.webp',
        N'Phòng khách biệt thự với nội thất gỗ óc chó và cửa kính nhìn ra vườn',
        1
    ),
    (
        N'Phòng Ngủ',
        N'phong-ngu',
        N'Không gian nghỉ ngơi ấm áp, riêng tư và phù hợp với nhịp sống của gia chủ.',
        N'/media/gallery/villa-bedroom-earth.webp',
        N'Phòng ngủ biệt thự với nội thất gỗ và bảng màu nâu đất',
        2
    ),
    (
        N'Phòng Bếp',
        N'phong-bep',
        N'Bếp và bàn ăn được tổ chức liền mạch cho những khoảnh khắc sum họp.',
        N'/media/gallery/walnut-villa-kitchen.webp',
        N'Phòng bếp biệt thự với hệ tủ gỗ, đảo đá và bàn ăn',
        3
    )
) AS source(name, slug, description, image_url, image_alt, display_order)
    ON source.slug = target.slug;
GO

