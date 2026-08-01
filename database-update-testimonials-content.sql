-- ============================================================
-- Testimonials: fix Vietnamese content + EF-mapped columns
-- IMPORTANT: run with UTF-8 input code page:
--   sqlcmd -S localhost -U sa -P P@ssw0rd! -d DLFurniture -f 65001 -i database-update-testimonials-content.sql
-- ============================================================
SET NOCOUNT ON;

-- Record 1 - Chị Nguyễn Thị Thuỳ Linh
UPDATE dbo.testimonials
SET customer_name = N'Chị Nguyễn Thị Thuỳ Linh',
    author_name   = N'Chị Nguyễn Thị Thuỳ Linh',
    location      = N'Hồ Chí Minh',
    content       = N'Tôi rất ấn tượng với các dịch vụ và sản phẩm của Nội thất D&L Furniture. Từ tư vấn thiết kế đến thi công, lắp đặt đều chuyên nghiệp, chính vì vậy nên gia đình tôi rất hài lòng khi lựa chọn. Không gian sống của chúng tôi thực sự đã thay đổi hoàn toàn sau khi được D&L Furniture tư vấn và thiết kế lại toàn bộ nội thất phòng khách và phòng ngủ.',
    avatar_image  = N'/src/assets/img/team/4.jpg',
    image_url     = N'/src/assets/img/team/4.jpg'
WHERE id = 1;

-- Record 2 - Anh Nguyễn Hùng Cường
UPDATE dbo.testimonials
SET customer_name = N'Anh Nguyễn Hùng Cường',
    author_name   = N'Anh Nguyễn Hùng Cường',
    location      = N'Hà Nội',
    content       = N'Tất cả những sản phẩm nội thất gỗ óc chó của D&L Furniture luôn mang giá trị thẩm mỹ rất cao, chất lượng và công năng hoàn hảo. Tôi đã mua rất nhiều sản phẩm từ D&L Furniture và chưa bao giờ thất vọng về chất lượng cũng như dịch vụ chăm sóc khách hàng tận tình.',
    avatar_image  = N'/src/assets/img/team/1.jpg',
    image_url     = N'/src/assets/img/team/1.jpg'
WHERE id = 2;

-- Record 3 - Chị Nguyễn Thị Nguyệt (fix empty customer_name / null avatar_image)
IF NOT EXISTS (SELECT 1 FROM dbo.testimonials WHERE id = 3)
BEGIN
    SET IDENTITY_INSERT dbo.testimonials ON;
    INSERT INTO dbo.testimonials
        (id, customer_name, author_name, location, content, rating, avatar_image, image_url, is_active, hidden, del_flag, created_date)
    VALUES
        (3, N'Chị Nguyễn Thị Nguyệt', N'Chị Nguyễn Thị Nguyệt', N'Hà Nội',
         N'Đội ngũ D&L Furniture đã hỗ trợ tôi rất tận tình từ khâu tư vấn, lên bản vẽ đến hoàn thiện thi công. Sản phẩm bàn giao đúng tiến độ, đúng thiết kế. Tôi sẽ tiếp tục sử dụng dịch vụ của D&L Furniture cho các dự án nội thất sau này và giới thiệu cho bạn bè, người thân.',
         5, N'/src/assets/img/team/5.jpg', N'/src/assets/img/team/5.jpg', 1, 0, 0, SYSDATETIMEOFFSET());
    SET IDENTITY_INSERT dbo.testimonials OFF;
    PRINT 'Inserted record 3.';
END
ELSE
BEGIN
    UPDATE dbo.testimonials
    SET customer_name = N'Chị Nguyễn Thị Nguyệt',
        author_name   = N'Chị Nguyễn Thị Nguyệt',
        location      = N'Hà Nội',
        content       = N'Đội ngũ D&L Furniture đã hỗ trợ tôi rất tận tình từ khâu tư vấn, lên bản vẽ đến hoàn thiện thi công. Sản phẩm bàn giao đúng tiến độ, đúng thiết kế. Tôi sẽ tiếp tục sử dụng dịch vụ của D&L Furniture cho các dự án nội thất sau này và giới thiệu cho bạn bè, người thân.',
        avatar_image  = N'/src/assets/img/team/5.jpg',
        image_url     = N'/src/assets/img/team/5.jpg',
        rating        = 5,
        hidden        = 0,
        del_flag      = 0
    WHERE id = 3;
    PRINT 'Updated record 3.';
END

PRINT 'Done.';
GO

