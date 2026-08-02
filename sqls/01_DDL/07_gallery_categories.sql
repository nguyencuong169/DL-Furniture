-- =============================================
-- 01_DDL/07_gallery_categories.sql
-- Bảng: dbo.gallery_categories
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.gallery_categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.gallery_categories (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        name          NVARCHAR(255)   NOT NULL,
        slug          NVARCHAR(100)   NOT NULL,
        display_order INT             NOT NULL CONSTRAINT DF_gallery_categories_display_order DEFAULT (0),
        is_active     BIT             NOT NULL CONSTRAINT DF_gallery_categories_is_active DEFAULT (1),
        CONSTRAINT PK_gallery_categories PRIMARY KEY (id),
        CONSTRAINT UQ_gallery_categories_slug UNIQUE (slug),
        CONSTRAINT CK_gallery_categories_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
        CONSTRAINT CK_gallery_categories_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0)
    );
    PRINT 'Table gallery_categories created.';
END;
GO

