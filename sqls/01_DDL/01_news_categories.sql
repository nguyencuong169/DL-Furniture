-- =============================================
-- 01_DDL/01_news_categories.sql
-- Bảng: dbo.news_categories
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.news_categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.news_categories (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        name          NVARCHAR(255)   NOT NULL,
        slug          NVARCHAR(255)   NOT NULL,
        display_order INT             NOT NULL CONSTRAINT DF_news_categories_display_order DEFAULT (0),
        is_active     BIT             NOT NULL CONSTRAINT DF_news_categories_is_active DEFAULT (1),
        created_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_news_categories_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_news_categories_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_news_categories PRIMARY KEY (id),
        CONSTRAINT UQ_news_categories_slug UNIQUE (slug),
        CONSTRAINT CK_news_categories_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
        CONSTRAINT CK_news_categories_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0)
    );
    PRINT 'Table news_categories created.';
END;
GO

