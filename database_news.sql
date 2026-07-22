BEGIN TRANSACTION;

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Tin tức gỗ óc chó',
       N'go-oc-cho',
       1,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'go-oc-cho');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Khai trương',
       N'khai-truong',
       2,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'khai-truong');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Hoàn thiện công trình',
       N'hoan-thien-cong-trinh',
       3,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'hoan-thien-cong-trinh');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Chia sẻ chuyên môn',
       N'chia-se-chuyen-mon',
       4,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'chia-se-chuyen-mon');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Sự kiện',
       N'su-kien',
       5,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'su-kien');

COMMIT TRANSACTION;


GO
-- Sinh dữ liệu mẫu cho bảng news, phân bổ đều 2025-2026
SET NOCOUNT ON;

BEGIN TRANSACTION; -- Lấy id các category đã seed

DECLARE @nc_walnut AS BIGINT = (SELECT TOP 1 id
                                FROM   dbo.news_categories
                                WHERE  slug = N'go-oc-cho');

DECLARE @nc_opening AS BIGINT = (SELECT TOP 1 id
                                 FROM   dbo.news_categories
                                 WHERE  slug = N'khai-truong');

DECLARE @nc_completion AS BIGINT = (SELECT TOP 1 id
                                    FROM   dbo.news_categories
                                    WHERE  slug = N'hoan-thien-cong-trinh');

DECLARE @nc_sharing AS BIGINT = (SELECT TOP 1 id
                                 FROM   dbo.news_categories
                                 WHERE  slug = N'chia-se-chuyen-mon');

DECLARE @nc_event AS BIGINT = (SELECT TOP 1 id
                               FROM   dbo.news_categories
                               WHERE  slug = N'su-kien'); -- Mẫu dữ liệu (Unicode)

DECLARE @titles TABLE (
    txt NVARCHAR (400));

INSERT  INTO @titles (txt)
VALUES              (N'Hoàn thiện showroom gỗ óc chó tại Hà Nội'),
(N'Khai trương chi nhánh mới: Gỗ Óc Chó Center'),
(N'Hoàn thành nội thất biệt thự bằng gỗ óc chó'),
(N'Chia sẻ: Quy trình hoàn thiện bề mặt gỗ óc chó'),
(N'Dự án nội thất văn phòng sử dụng gỗ óc chó'),
(N'Bộ sưu tập bàn ăn gỗ óc chó ra mắt'),
(N'Hướng dẫn bảo quản gỗ óc chó cho gia đình'),
(N'Sự kiện: Triển lãm nội thất gỗ óc chó 2026'),
(N'Case study: Hoàn thiện showroom khách hàng A'),
(N'Kinh nghiệm lựa chọn veneer gỗ óc chó'),
(N'Xu hướng thiết kế bếp gỗ ấm áp năm 2026'),
(N'Cầu thang gỗ trở thành điểm nhấn trong nhà phố'),
(N'Không gian phòng ngủ tối giản với vật liệu tự nhiên'),
(N'Nhà phố hẹp vẫn thoáng nhờ nội thất may đo'),
(N'Bí quyết phối ánh sáng để tôn vẻ đẹp nội thất gỗ');

DECLARE @summaries TABLE (
    txt NVARCHAR (1000));

INSERT  INTO @summaries (txt)
VALUES                 (N'Bài viết mô tả quá trình hoàn thiện, lựa chọn vật liệu và đội thợ thi công.'),
(N'Tin tức khai trương chi nhánh mới với bộ sưu tập gỗ óc chó cao cấp.'),
(N'Chia sẻ kỹ thuật xử lý bề mặt, sơn và bảo quản cho đồ gỗ óc chó.'),
(N'Báo cáo tiến độ dự án hoàn thiện nội thất cho khách hàng.'),
(N'Gợi ý phối màu và nội thất khi dùng gỗ óc chó trong không gian sống.'),
(N'Khám phá cách kết hợp gỗ, ánh sáng và màu trung tính cho không gian hiện đại.'),
(N'Những giải pháp nội thất may đo giúp tận dụng diện tích mà vẫn giữ sự thông thoáng.'),
(N'Các nguyên tắc chọn vật liệu bền đẹp, dễ bảo dưỡng cho căn bếp và phòng sinh hoạt.');

DECLARE @contents TABLE (
    txt NVARCHAR (MAX));

INSERT  INTO @contents (txt)
VALUES                (N'Chi tiết công trình: khảo sát, lựa chọn vật liệu, gia công, lắp đặt và hoàn thiện. Bao gồm ảnh thực tế và lời khuyên bảo quản.'),
(N'Bài phỏng vấn chủ dự án và đội thi công, mô tả các bước xử lý bề mặt và sơn hoàn thiện.'),
(N'Hướng dẫn kỹ thuật: cách xử lý mối nối, chống cong vênh, lựa chọn keo và sơn phù hợp cho gỗ óc chó.'),
(N'Bài viết chia sẻ kinh nghiệm thi công showroom, bố trí ánh sáng để tôn vân gỗ và tối ưu trải nghiệm khách hàng.'),
(N'Thông tin sự kiện, chương trình khuyến mãi, và lịch trình tham quan showroom mới.'),
(N'Phân tích cách bố trí ánh sáng tự nhiên và đèn trang trí để làm nổi bật màu sắc, đường vân của đồ gỗ.'),
(N'Gợi ý tổ chức khu bếp, hệ tủ và bề mặt làm việc theo thói quen sử dụng của gia đình Việt.'),
(N'Giải pháp thiết kế cầu thang và đồ nội thất liền tường cho nhà phố có chiều ngang hạn chế.');

DECLARE @images TABLE (
    url NVARCHAR (1024));

INSERT  INTO @images (url)
VALUES              (N'/src/assets/img/news/1.jpg'),
(N'/src/assets/img/news/2.jpg'),
(N'/src/assets/img/news/3.jpg'),
(N'/src/assets/img/news/4.jpg'),
(N'/src/assets/img/news/6.jpg');

DECLARE @tagPool TABLE (
    tag NVARCHAR (200));

INSERT  INTO @tagPool (tag)
VALUES               (N'walnut'),
(N'gỗ-óc-chó'),
(N'showroom'),
(N'hoàn-thiện'),
(N'khai-trương'),
(N'nội-thất'),
(N'thi-công'),
(N'chia-se'),
(N'bảo-quản'),
(N'sự-kiện'); -- Tham số: tổng số bản ghi cần sinh

DECLARE @Total AS INT = 300; -- đổi nếu cần

DECLARE @startDate AS DATE = '2025-01-01';

DECLARE @endDate AS DATE = '2026-12-31';

DECLARE @months AS INT = DATEDIFF(MONTH, @startDate, @endDate) + 1;

DECLARE @perMonth AS INT = CEILING(1.0 * @Total / @months);

DECLARE @currentMonthStart AS DATE = @startDate;

DECLARE @inserted AS INT = 0;

WHILE @currentMonthStart <= @endDate
      AND @inserted < @Total
    BEGIN
        DECLARE @countThisMonth AS INT = @perMonth;
        DECLARE @k AS INT = 1;
        WHILE @k <= @countThisMonth
              AND @inserted < @Total
            BEGIN
                DECLARE @title AS NVARCHAR (400) = (SELECT   TOP 1 txt
                                                    FROM     @titles
                                                    ORDER BY NEWID());
                DECLARE @summary AS NVARCHAR (1000) = (SELECT   TOP 1 txt
                                                       FROM     @summaries
                                                       ORDER BY NEWID());
                DECLARE @content AS NVARCHAR (MAX) = (SELECT   TOP 1 txt
                                                      FROM     @contents
                                                      ORDER BY NEWID());
                DECLARE @image AS NVARCHAR (1024) = (SELECT   TOP 1 url
                                                     FROM     @images
                                                     ORDER BY NEWID());
                DECLARE @categoryId AS BIGINT = @nc_sharing;
                IF @title LIKE N'%Khai trương%'
                   OR @title LIKE N'%chi nhánh%'
                   OR @summary LIKE N'%khai trương%'
                    SET @categoryId = @nc_opening;
                IF @title LIKE N'%Hoàn thiện%'
                   OR @title LIKE N'%Hoàn thành%'
                   OR @summary LIKE N'%Hoàn thiện%'
                    SET @categoryId = @nc_completion;
                IF @title LIKE N'%Sự kiện%'
                   OR @title LIKE N'%Triển lãm%'
                   OR @summary LIKE N'%sự kiện%'
                    SET @categoryId = @nc_event;
                IF @title LIKE N'%gỗ óc chó%'
                   OR @title LIKE N'%óc chó%'
                   OR @summary LIKE N'%gỗ óc chó%'
                    SET @categoryId = @nc_walnut;
                DECLARE @monthStart AS DATETIME2 = DATEFROMPARTS(YEAR(@currentMonthStart), MONTH(@currentMonthStart), 1);
                DECLARE @daysInMonth AS INT = DAY(EOMONTH(@monthStart));
                DECLARE @randDay AS INT = 1 + (ABS(CHECKSUM(NEWID())) % @daysInMonth);
                DECLARE @randHour AS INT = ABS(CHECKSUM(NEWID())) % 24;
                DECLARE @randMin AS INT = ABS(CHECKSUM(NEWID())) % 60;
                DECLARE @created AS DATETIME2 = DATEADD(MINUTE, @randMin, DATEADD(HOUR, @randHour, DATEADD(DAY, @randDay - 1, @monthStart)));
                DECLARE @newsId AS NVARCHAR (50) = N'GEN-' + CONVERT (NVARCHAR (4), YEAR(@created)) + N'-' + RIGHT('00000' + CONVERT (NVARCHAR (10), (ABS(CHECKSUM(NEWID())) % 100000)), 5);
                DECLARE @tag1 AS NVARCHAR (200) = (SELECT   TOP 1 tag
                                                   FROM     @tagPool
                                                   ORDER BY NEWID());
                DECLARE @tag2 AS NVARCHAR (200) = (SELECT   TOP 1 tag
                                                   FROM     @tagPool
                                                   WHERE    tag <> @tag1
                                                   ORDER BY NEWID());
                DECLARE @tags AS NVARCHAR (MAX) = @tag1 + N',' + @tag2;
                INSERT  INTO dbo.news (news_id, title, summary, [content], news_image, news_category_id, tags, hidden, del_flag, created_user, created_date, updated_user, updated_date)
                VALUES               (@newsId, @title, @summary, @content + N' (Bài viết tự động sinh để test phân trang và chi tiết.)', @image, @categoryId, @tags, 0, 0, N'auto', @created, N'auto', @created);
                SET @k = @k + 1;
                SET @inserted = @inserted + 1;
            END
        SET @currentMonthStart = DATEADD(MONTH, 1, @currentMonthStart);
    END

COMMIT TRANSACTION;

SET NOCOUNT OFF; -- Kiểm tra nhanh

SELECT COUNT(*) AS TotalInserted
FROM   dbo.news
WHERE  created_date BETWEEN '2025-01-01' AND '2026-12-31';

SELECT   TOP 20 id,
                news_id,
                title,
                news_category_id,
                tags,
                news_image,
                created_date
FROM     dbo.news
ORDER BY created_date DESC, id DESC;
