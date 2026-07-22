-- Đồng bộ chuyên mục tin tức cho SQL Server.
-- Có thể chạy lại an toàn: không ghi đè bài đã được gán chuyên mục hợp lệ.

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.news', N'U') IS NULL
        THROW 50001, N'Không tìm thấy bảng dbo.news.', 1;

    IF OBJECT_ID(N'dbo.news_categories', N'U') IS NULL
    BEGIN
        CREATE TABLE dbo.news_categories (
            id            BIGINT         IDENTITY(1, 1) NOT NULL,
            name          NVARCHAR(255)  NOT NULL,
            slug          NVARCHAR(255)  NOT NULL,
            display_order INT            NOT NULL CONSTRAINT DF_news_categories_display_order DEFAULT (0),
            is_active     BIT            NOT NULL CONSTRAINT DF_news_categories_is_active DEFAULT (1),
            created_at    DATETIME2      NOT NULL CONSTRAINT DF_news_categories_created_at DEFAULT (SYSUTCDATETIME()),
            updated_at    DATETIME2      NOT NULL CONSTRAINT DF_news_categories_updated_at DEFAULT (SYSUTCDATETIME()),
            CONSTRAINT PK_news_categories PRIMARY KEY (id),
            CONSTRAINT UQ_news_categories_slug UNIQUE (slug),
            CONSTRAINT CK_news_categories_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
            CONSTRAINT CK_news_categories_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0)
        );
    END;

    IF COL_LENGTH(N'dbo.news', N'news_category_id') IS NULL
        ALTER TABLE dbo.news ADD news_category_id BIGINT NULL;

    DECLARE @categories TABLE (
        name NVARCHAR(255) NOT NULL,
        slug NVARCHAR(255) NOT NULL,
        legacy_slug NVARCHAR(255) NULL,
        display_order INT NOT NULL
    );

    INSERT INTO @categories (name, slug, legacy_slug, display_order)
    VALUES
        (N'Tin tức gỗ óc chó', N'go-oc-cho', N'news-wood-walnut', 1),
        (N'Khai trương', N'khai-truong', N'news-opening', 2),
        (N'Hoàn thiện công trình', N'hoan-thien-cong-trinh', N'news-completion', 3),
        (N'Chia sẻ chuyên môn', N'chia-se-chuyen-mon', N'news-sharing', 4),
        (N'Sự kiện', N'su-kien', N'news-event', 5);

    -- Giữ nguyên id khi database chỉ có slug cũ để các liên kết hiện tại không bị đổi.
    UPDATE legacy
    SET legacy.slug = source.slug,
        legacy.updated_at = SYSUTCDATETIME()
    FROM dbo.news_categories AS legacy
    INNER JOIN @categories AS source ON source.legacy_slug = legacy.slug
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.news_categories AS canonical
        WHERE canonical.slug = source.slug
    );

    UPDATE target
    SET target.name = source.name,
        target.display_order = source.display_order,
        target.is_active = 1,
        target.updated_at = SYSUTCDATETIME()
    FROM dbo.news_categories AS target
    INNER JOIN @categories AS source ON source.slug = target.slug;

    INSERT INTO dbo.news_categories (name, slug, display_order, is_active)
    SELECT source.name, source.slug, source.display_order, 1
    FROM @categories AS source
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.news_categories AS target
        WHERE target.slug = source.slug
    );

    -- Nếu cả slug cũ và mới cùng tồn tại, gom bài về bản canonical rồi ẩn alias cũ.
    UPDATE news
    SET news.news_category_id = canonical.id
    FROM dbo.news AS news
    INNER JOIN dbo.news_categories AS legacy ON legacy.id = news.news_category_id
    INNER JOIN @categories AS source ON source.legacy_slug = legacy.slug
    INNER JOIN dbo.news_categories AS canonical ON canonical.slug = source.slug
    WHERE legacy.id <> canonical.id;

    UPDATE legacy
    SET legacy.is_active = 0,
        legacy.updated_at = SYSUTCDATETIME()
    FROM dbo.news_categories AS legacy
    INNER JOIN @categories AS source ON source.legacy_slug = legacy.slug
    WHERE EXISTS (
        SELECT 1
        FROM dbo.news_categories AS canonical
        WHERE canonical.slug = source.slug
          AND canonical.id <> legacy.id
    );

    -- Dọn khóa chuyên mục không còn hợp lệ trước khi tạo foreign key.
    UPDATE news
    SET news.news_category_id = NULL
    FROM dbo.news AS news
    LEFT JOIN dbo.news_categories AS category ON category.id = news.news_category_id
    WHERE news.news_category_id IS NOT NULL
      AND category.id IS NULL;

    DECLARE @walnutCategoryId BIGINT = (SELECT id FROM dbo.news_categories WHERE slug = N'go-oc-cho');
    DECLARE @openingCategoryId BIGINT = (SELECT id FROM dbo.news_categories WHERE slug = N'khai-truong');
    DECLARE @completionCategoryId BIGINT = (SELECT id FROM dbo.news_categories WHERE slug = N'hoan-thien-cong-trinh');
    DECLARE @sharingCategoryId BIGINT = (SELECT id FROM dbo.news_categories WHERE slug = N'chia-se-chuyen-mon');
    DECLARE @eventCategoryId BIGINT = (SELECT id FROM dbo.news_categories WHERE slug = N'su-kien');

    -- Backfill có thứ tự ưu tiên: sự kiện/khai trương/hoàn thiện trước chủ đề vật liệu.
    ;WITH uncategorized AS (
        SELECT news.id,
               LOWER(CONCAT(
                   COALESCE(news.title, N''), N' ',
                   COALESCE(news.summary, N''), N' ',
                   COALESCE(news.content, N'')
               )) AS searchable_text
        FROM dbo.news AS news
        WHERE news.news_category_id IS NULL
    )
    UPDATE news
    SET news.news_category_id = CASE
        WHEN source.searchable_text LIKE N'%sự kiện%'
          OR source.searchable_text LIKE N'%triển lãm%'
          OR source.searchable_text LIKE N'%hội chợ%'
          OR source.searchable_text LIKE N'%workshop%'
            THEN @eventCategoryId
        WHEN source.searchable_text LIKE N'%khai trương%'
          OR source.searchable_text LIKE N'%showroom mới%'
          OR source.searchable_text LIKE N'%chi nhánh mới%'
            THEN @openingCategoryId
        WHEN source.searchable_text LIKE N'%hoàn thiện%'
          OR source.searchable_text LIKE N'%hoàn thành%'
          OR source.searchable_text LIKE N'%bàn giao%'
          OR source.searchable_text LIKE N'%công trình%'
            THEN @completionCategoryId
        WHEN source.searchable_text LIKE N'%gỗ óc chó%'
          OR source.searchable_text LIKE N'%walnut%'
            THEN @walnutCategoryId
        ELSE @sharingCategoryId
    END
    FROM dbo.news AS news
    INNER JOIN uncategorized AS source ON source.id = news.id;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.foreign_keys
        WHERE name = N'FK_news_news_categories'
          AND parent_object_id = OBJECT_ID(N'dbo.news')
    )
    BEGIN
        ALTER TABLE dbo.news WITH CHECK
            ADD CONSTRAINT FK_news_news_categories
            FOREIGN KEY (news_category_id) REFERENCES dbo.news_categories(id);
        ALTER TABLE dbo.news CHECK CONSTRAINT FK_news_news_categories;
    END;

    IF NOT EXISTS (
        SELECT 1
        FROM sys.indexes
        WHERE name = N'IX_news_news_category_published'
          AND object_id = OBJECT_ID(N'dbo.news')
    )
    BEGIN
        CREATE NONCLUSTERED INDEX IX_news_news_category_published
            ON dbo.news (news_category_id, hidden, del_flag)
            INCLUDE (updated_date);
    END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;

SELECT category.id,
       category.name,
       category.slug,
       COUNT(news.id) AS published_count
FROM dbo.news_categories AS category
LEFT JOIN dbo.news AS news
    ON news.news_category_id = category.id
   AND ISNULL(news.hidden, 0) = 0
   AND ISNULL(news.del_flag, 0) = 0
WHERE category.is_active = 1
GROUP BY category.id, category.name, category.slug, category.display_order
ORDER BY category.display_order, category.name;

SET NOCOUNT OFF;
