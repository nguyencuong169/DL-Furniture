BEGIN TRANSACTION;

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Tin tức gỗ óc chó',
       N'news-wood-walnut',
       1,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'news-wood-walnut');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Khai trương',
       N'news-opening',
       2,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'news-opening');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Hoàn thiện công trình',
       N'news-completion',
       3,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'news-completion');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Chia sẻ chuyên môn',
       N'news-sharing',
       4,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'news-sharing');

INSERT INTO dbo.news_categories (name, slug, display_order, is_active, created_at, updated_at)
SELECT N'Sự kiện',
       N'news-event',
       5,
       1,
       SYSUTCDATETIME(),
       SYSUTCDATETIME()
WHERE  NOT EXISTS (SELECT 1
                   FROM   dbo.news_categories
                   WHERE  slug = N'news-event');

COMMIT TRANSACTION;


GO
-- Sinh dữ liệu mẫu cho bảng news, phân bổ đều 2025-2026
SET NOCOUNT ON;

BEGIN TRANSACTION; -- Lấy id các category đã seed

DECLARE @nc_walnut AS BIGINT = (SELECT TOP 1 id
                                FROM   dbo.news_categories
                                WHERE  slug = N'news-wood-walnut');

DECLARE @nc_opening AS BIGINT = (SELECT TOP 1 id
                                 FROM   dbo.news_categories
                                 WHERE  slug = N'news-opening');

DECLARE @nc_completion AS BIGINT = (SELECT TOP 1 id
                                    FROM   dbo.news_categories
                                    WHERE  slug = N'news-completion');

DECLARE @nc_sharing AS BIGINT = (SELECT TOP 1 id
                                 FROM   dbo.news_categories
                                 WHERE  slug = N'news-sharing');

DECLARE @nc_event AS BIGINT = (SELECT TOP 1 id
                               FROM   dbo.news_categories
                               WHERE  slug = N'news-event'); -- Mẫu dữ liệu (Unicode)

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
(N'Kinh nghiệm lựa chọn veneer gỗ óc chó');

DECLARE @summaries TABLE (
    txt NVARCHAR (1000));

INSERT  INTO @summaries (txt)
VALUES                 (N'Bài viết mô tả quá trình hoàn thiện, lựa chọn vật liệu và đội thợ thi công.'),
(N'Tin tức khai trương chi nhánh mới với bộ sưu tập gỗ óc chó cao cấp.'),
(N'Chia sẻ kỹ thuật xử lý bề mặt, sơn và bảo quản cho đồ gỗ óc chó.'),
(N'Báo cáo tiến độ dự án hoàn thiện nội thất cho khách hàng.'),
(N'Gợi ý phối màu và nội thất khi dùng gỗ óc chó trong không gian sống.');

DECLARE @contents TABLE (
    txt NVARCHAR (MAX));

INSERT  INTO @contents (txt)
VALUES                (N'Chi tiết công trình: khảo sát, lựa chọn vật liệu, gia công, lắp đặt và hoàn thiện. Bao gồm ảnh thực tế và lời khuyên bảo quản.'),
(N'Bài phỏng vấn chủ dự án và đội thi công, mô tả các bước xử lý bề mặt và sơn hoàn thiện.'),
(N'Hướng dẫn kỹ thuật: cách xử lý mối nối, chống cong vênh, lựa chọn keo và sơn phù hợp cho gỗ óc chó.'),
(N'Bài viết chia sẻ kinh nghiệm thi công showroom, bố trí ánh sáng để tôn vân gỗ và tối ưu trải nghiệm khách hàng.'),
(N'Thông tin sự kiện, chương trình khuyến mãi, và lịch trình tham quan showroom mới.');

DECLARE @images TABLE (
    url NVARCHAR (1024));

INSERT  INTO @images (url)
VALUES              (N'https://images.unsplash.com/photo-1600585154340-be6161a56a0c?auto=format&fit=crop&w=1200&q=80'),
(N'https://images.unsplash.com/photo-1524758631624-e2822e304c36?auto=format&fit=crop&w=1200&q=80'),
(N'https://images.unsplash.com/photo-1519710164239-da123dc03ef4?auto=format&fit=crop&w=1200&q=80'),
(N'https://images.unsplash.com/photo-1540574163026-643ea20ade25?auto=format&fit=crop&w=1200&q=80'),
(N'https://images.unsplash.com/photo-1582582422129-3a1f1b8f1a2b?auto=format&fit=crop&w=1200&q=80'),
(N'https://images.unsplash.com/photo-1555041469-a586c61ea9bc?auto=format&fit=crop&w=1200&q=80');

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
                INSERT  INTO dbo.news (news_id, title, summary, [content], news_image, category_id, tags, hidden, del_flag, created_user, created_date, updated_user, updated_date)
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
                category_id,
                tags,
                news_image,
                created_date
FROM     dbo.news
ORDER BY created_date DESC, id DESC;