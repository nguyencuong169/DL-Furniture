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
    (N'Nội thất biệt thự', N'Thiết kế & thi công không gian biệt thự sang trọng từ gỗ óc chó, cân chỉnh tỷ lệ và chi tiết theo kiến trúc của gia chủ.', N'/src/assets/img/pricing/1.jpg', N'pricing', 1, 0, 0, N'seed', N'seed'),
    (N'Nội thất chung cư', N'Trọn gói từ khảo sát hiện trường đến lắp đặt: tối ưu công năng, lưu trữ và thẩm mỹ cho diện tích căn hộ.', N'/src/assets/img/pricing/2.jpg', N'pricing', 2, 0, 0, N'seed', N'seed'),
    (N'Văn phòng & Showroom', N'Thiết kế không gian làm việc và trưng bày theo concept riêng, đồng bộ thương hiệu và nhu cầu vận hành của doanh nghiệp.', N'/src/assets/img/pricing/3.jpg', N'pricing', 3, 0, 0, N'seed', N'seed'),
    (N'Nội thất theo yêu cầu', N'Đóng tủ, vách, bàn ghế gỗ óc chó từ đo đạc hiện trường; đồng hành từ chọn phôi đến hoàn thiện tại công trình.', N'/src/assets/img/pricing/4.jpg', N'pricing', 4, 0, 0, N'seed', N'seed')
) AS source (name, description, image, category, sort_order, hidden, del_flag, created_user, updated_user)
ON target.sort_order = source.sort_order
WHEN MATCHED THEN
    UPDATE SET
        target.name = source.name,
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
