-- =============================================
-- 01_DDL/04_news.sql
-- Bảng: dbo.news
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.news', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.news (
        id              BIGINT          IDENTITY(1, 1) NOT NULL,
        news_id         NVARCHAR(255)   NULL,
        title           NVARCHAR(255)   NULL,
        summary         NVARCHAR(MAX)   NULL,
        content         NVARCHAR(MAX)   NULL,
        news_image      NVARCHAR(1024)  NULL,
        view_count      BIGINT          NOT NULL CONSTRAINT DF_news_view_count DEFAULT (0),
        news_category_id BIGINT         NULL,
        tags            NVARCHAR(2048)  NULL,
        hidden          BIT             NOT NULL CONSTRAINT DF_news_hidden DEFAULT (0),
        del_flag        BIT             NOT NULL CONSTRAINT DF_news_del_flag DEFAULT (0),
        created_user    NVARCHAR(255)   NULL,
        created_date    DATETIMEOFFSET  NULL CONSTRAINT DF_news_created_date DEFAULT (SYSUTCDATETIME()),
        updated_user    NVARCHAR(255)   NULL,
        updated_date    DATETIMEOFFSET  NULL CONSTRAINT DF_news_updated_date DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_news PRIMARY KEY (id),
        CONSTRAINT FK_news_news_categories FOREIGN KEY (news_category_id) REFERENCES dbo.news_categories (id)
    );
    PRINT 'Table news created.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_news_news_category_published' AND object_id = OBJECT_ID(N'dbo.news'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_news_news_category_published
        ON dbo.news (news_category_id, hidden, del_flag)
        INCLUDE (updated_date);
END;
GO

