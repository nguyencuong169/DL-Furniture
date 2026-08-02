-- =============================================
-- 02_DML/14_testimonials.sql
-- Seed: dbo.testimonials
-- =============================================
-- Idempotent: sử dụng MERGE.
-- Chuẩn cột theo DB hiện tại (API Testimonial):
--   customer_name, location, content, avatar_image, rating, sort_order,
--   hidden, del_flag, created_user, created_date, updated_user, updated_date.
MERGE INTO dbo.testimonials AS target
USING (VALUES
    (N'Chị Nguyễn Thị Thuỳ Linh', N'Hồ Chí Minh', N'Tôi rất ấn tượng với các dịch vụ và sản phẩm của D&L Furniture. Từ tư vấn thiết kế đến thi công, lắp đặt đều chuyên nghiệp, gia đình tôi rất hài lòng.', N'/src/assets/img/team/4.jpg', 5, 0, 0, 0, N'seed', N'seed'),
    (N'Anh Nguyễn Hùng Cường', N'Hà Nội', N'Sản phẩm luôn mang giá trị thẩm mỹ rất cao, chất lượng và công năng hoàn hảo.', N'/src/assets/img/team/1.jpg', 5, 1, 0, 0, N'seed', N'seed')
) AS source (customer_name, location, content, avatar_image, rating, sort_order, hidden, del_flag, created_user, updated_user)
ON target.customer_name = source.customer_name AND target.location = source.location
WHEN MATCHED THEN
    UPDATE SET
        target.content = source.content,
        target.avatar_image = source.avatar_image,
        target.rating = source.rating,
        target.sort_order = source.sort_order,
        target.hidden = source.hidden,
        target.del_flag = source.del_flag,
        target.updated_user = source.updated_user
WHEN NOT MATCHED THEN
    INSERT (customer_name, location, content, avatar_image, rating, sort_order, hidden, del_flag, created_user, updated_user)
    VALUES (source.customer_name, source.location, source.content, source.avatar_image, source.rating, source.sort_order, source.hidden, source.del_flag, source.created_user, source.updated_user);
GO

PRINT 'Seed testimonials: done.';
GO
