-- =============================================
-- 01_DDL/02_products.sql
-- Bảng: dbo.products
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.products', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.products (
        id          BIGINT          IDENTITY(1, 1) NOT NULL,
        category_id BIGINT          NULL,
        sku         NVARCHAR(100)   NULL,
        slug        NVARCHAR(255)   NOT NULL,
        name        NVARCHAR(255)   NOT NULL,
        summary     NVARCHAR(MAX)   NULL,
        description NVARCHAR(MAX)   NULL,
        price       DECIMAL(18, 2)  NULL,
        currency    NVARCHAR(10)    NOT NULL CONSTRAINT DF_products_currency DEFAULT (N'VND'),
        main_image  NVARCHAR(1024)  NULL,
        is_active   BIT             NOT NULL CONSTRAINT DF_products_is_active DEFAULT (1),
        hidden      BIT             NOT NULL CONSTRAINT DF_products_hidden DEFAULT (0),
        created_at  DATETIMEOFFSET  NOT NULL CONSTRAINT DF_products_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at  DATETIMEOFFSET  NOT NULL CONSTRAINT DF_products_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_products PRIMARY KEY (id),
        CONSTRAINT UQ_products_slug UNIQUE (slug),
        CONSTRAINT CK_products_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
        CONSTRAINT CK_products_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0),
        CONSTRAINT CHK_products_price CHECK (price >= 0),
        CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id)
    );
    PRINT 'Table products created.';
END;
GO

-- Index hỗ trợ tìm kiếm theo SKU & category
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_products_sku' AND object_id = OBJECT_ID(N'dbo.products'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_products_sku ON dbo.products (sku);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_products_category_id' AND object_id = OBJECT_ID(N'dbo.products'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_products_category_id ON dbo.products (category_id);
END;
GO

-- Trigger tự cập nhật updated_at
IF OBJECT_ID(N'TR_products_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_products_updated_at
        ON dbo.products
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE p
            SET p.updated_at = SYSUTCDATETIME()
            FROM dbo.products AS p
            INNER JOIN inserted AS i ON p.id = i.id;
        END
    ');
END;
GO

