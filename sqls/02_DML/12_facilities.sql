-- =============================================
-- 02_DML/12_facilities.sql
-- Seed: dbo.facilities
-- =============================================
-- Idempotent: sử dụng MERGE.
MERGE INTO dbo.facilities AS target
USING (VALUES
    (N'Đội ngũ chuyên nghiệp', N'Đội ngũ kiến trúc sư trẻ năng động', N'flaticon-world', 1, 1),
    (N'Cập nhật xu hướng', N'Cập nhật xu hướng mới nhất', N'flaticon-car', 2, 1),
    (N'Giám sát tiến độ', N'Giám sát tiến độ chính xác', N'flaticon-bed', 3, 1)
) AS source (title, description, icon_class, display_order, is_active)
ON target.title = source.title
WHEN MATCHED THEN
    UPDATE SET
        target.description = source.description,
        target.icon_class = source.icon_class,
        target.display_order = source.display_order,
        target.is_active = source.is_active
WHEN NOT MATCHED THEN
    INSERT (title, description, icon_class, display_order, is_active)
    VALUES (source.title, source.description, source.icon_class, source.display_order, source.is_active);
GO

PRINT 'Seed facilities: done.';
GO
