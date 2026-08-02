-- =============================================
-- 01_DDL/03_product_images.sql
-- Bảng: dbo.product_images
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.product_images', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.product_images (
        id         BIGINT          IDENTITY(1, 1) NOT NULL,
        product_id BIGINT          NOT NULL,
        image_url  NVARCHAR(1024)  NOT NULL,
        caption    NVARCHAR(255)   NULL,
        sort_order INT             NOT NULL CONSTRAINT DF_product_images_sort_order DEFAULT (0),
        created_at DATETIMEOFFSET  NOT NULL CONSTRAINT DF_product_images_created_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_product_images PRIMARY KEY (id),
        CONSTRAINT FK_product_images_product FOREIGN KEY (product_id) REFERENCES dbo.products (id)
    );
    PRINT 'Table product_images created.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_product_images_product_id' AND object_id = OBJECT_ID(N'dbo.product_images'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_product_images_product_id ON dbo.product_images (product_id);
END;
GO

