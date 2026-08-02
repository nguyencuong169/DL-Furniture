-- =============================================
-- 02_DML/11_services.sql
-- Seed: dbo.services
-- =============================================
-- Idempotent: sử dụng MERGE.
-- Chuẩn cột theo DB hiện tại (API ServiceItem):
--   name, description, image, category, sort_order, hidden, del_flag,
--   created_user, created_date, updated_user, updated_date.
MERGE INTO dbo.services AS target
USING (VALUES
    (N'Nội thất biệt thự', N'Kiến tạo nên tính thẩm mỹ cá tính với đa phong cách thiết kế', N'/src/assets/img/pricing/1.jpg', N'pricing', 1, 0, 0, N'seed', N'seed'),
    (N'Nội thất chung cư', N'Chuyên thiết kế nội thất chung cư trọn gói', N'/src/assets/img/pricing/2.jpg', N'pricing', 2, 0, 0, N'seed', N'seed'),
    (N'Nội thất văn phòng', N'Cung cấp mẫu thiết kế nội thất văn phòng', N'/src/assets/img/pricing/3.jpg', N'pricing', 3, 0, 0, N'seed', N'seed'),
    (N'Showroom & Trung tâm', N'Xây dựng không gian theo concept riêng', N'/src/assets/img/pricing/4.jpg', N'pricing', 4, 0, 0, N'seed', N'seed')
) AS source (name, description, image, category, sort_order, hidden, del_flag, created_user, updated_user)
ON target.name = source.name
WHEN MATCHED THEN
    UPDATE SET
        target.description = source.description,
        target.image = source.image,
        target.category = source.category,
        target.sort_order = source.sort_order,
        target.hidden = source.hidden,
        target.del_flag = source.del_flag,
        target.updated_user = source.updated_user
WHEN NOT MATCHED THEN
    INSERT (name, description, image, category, sort_order, hidden, del_flag, created_user, updated_user)
    VALUES (source.name, source.description, source.image, source.category, source.sort_order, source.hidden, source.del_flag, source.created_user, source.updated_user);
GO

PRINT 'Seed services: done.';
GO
