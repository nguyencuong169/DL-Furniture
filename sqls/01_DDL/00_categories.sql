-- =============================================
-- 01_DDL/00_categories.sql
-- Bảng: dbo.categories
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.categories', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.categories (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        name          NVARCHAR(255)   NOT NULL,
        slug          NVARCHAR(255)   NOT NULL,
        parent_id     BIGINT          NULL,
        description   NVARCHAR(MAX)   NULL,
        display_order INT             NOT NULL CONSTRAINT DF_categories_display_order DEFAULT (0),
        is_active     BIT             NOT NULL CONSTRAINT DF_categories_is_active DEFAULT (1),
        created_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_categories_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_categories_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_categories PRIMARY KEY (id),
        CONSTRAINT UQ_categories_slug UNIQUE (slug),
        CONSTRAINT CK_categories_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
        CONSTRAINT CK_categories_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0),
        CONSTRAINT FK_categories_parent FOREIGN KEY (parent_id) REFERENCES dbo.categories (id)
    );
    PRINT 'Table categories created.';
END;
GO

-- Trigger tự cập nhật updated_at
IF OBJECT_ID(N'TR_categories_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_categories_updated_at
        ON dbo.categories
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE c
            SET c.updated_at = SYSUTCDATETIME()
            FROM dbo.categories AS c
            INNER JOIN inserted AS i ON c.id = i.id;
        END
    ');
END;
GO

