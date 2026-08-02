-- =============================================
-- 02_DML/16_sliders.sql
-- Seed: dbo.sliders
-- =============================================
-- Idempotent: sử dụng MERGE.
MERGE INTO dbo.sliders AS target
USING (VALUES
    (N'Trải nghiệm sống đích thực', N'Không gian tiện nghi đẳng cấp', N'https://dl-furniture.netlify.app/assets/1-b3ntw45g.jpg', N'Khám phá ngay', N'#', 1, 1),
    (N'Phong cách thiết kế đa dạng', N'Thiết kế & thi công', N'https://dl-furniture.netlify.app/assets/2-bupjuqqy.png', N'Khám phá ngay', N'#', 2, 1)
) AS source (title, subtitle, background_image_url, button_text, button_link, display_order, is_active)
ON target.title = source.title
WHEN MATCHED THEN
    UPDATE SET
        target.subtitle = source.subtitle,
        target.background_image_url = source.background_image_url,
        target.button_text = source.button_text,
        target.button_link = source.button_link,
        target.display_order = source.display_order,
        target.is_active = source.is_active
WHEN NOT MATCHED THEN
    INSERT (title, subtitle, background_image_url, button_text, button_link, display_order, is_active)
    VALUES (source.title, source.subtitle, source.background_image_url, source.button_text, source.button_link, source.display_order, source.is_active);
GO

PRINT 'Seed sliders: done.';
GO
