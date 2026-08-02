-- =============================================
-- 01_DDL/08_gallery_items.sql
-- Bảng: dbo.gallery_items
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.gallery_items', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.gallery_items (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        category_id   BIGINT          NOT NULL,
        project_id    BIGINT          NULL,
        title         NVARCHAR(255)   NOT NULL,
        description   NVARCHAR(MAX)   NULL,
        media_type    NVARCHAR(20)    NOT NULL,
        media_url     NVARCHAR(1024)  NOT NULL,
        thumbnail_url NVARCHAR(1024)  NULL,
        alt_text      NVARCHAR(500)   NULL,
        provider      NVARCHAR(30)    NOT NULL CONSTRAINT DF_gallery_items_provider DEFAULT (N'local'),
        duration      NVARCHAR(20)    NULL,
        is_featured   BIT             NOT NULL CONSTRAINT DF_gallery_items_is_featured DEFAULT (0),
        display_order INT             NOT NULL CONSTRAINT DF_gallery_items_display_order DEFAULT (0),
        is_active     BIT             NOT NULL CONSTRAINT DF_gallery_items_is_active DEFAULT (1),
        created_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_gallery_items_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_gallery_items_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_gallery_items PRIMARY KEY (id),
        CONSTRAINT CK_gallery_items_media_type CHECK (media_type IN (N'image', N'video')),
        CONSTRAINT CK_gallery_items_provider CHECK (provider IN (N'local', N'youtube', N'vimeo')),
        CONSTRAINT FK_gallery_items_category FOREIGN KEY (category_id) REFERENCES dbo.gallery_categories (id),
        CONSTRAINT FK_gallery_items_project FOREIGN KEY (project_id) REFERENCES dbo.projects (id) ON DELETE SET NULL
    );
    PRINT 'Table gallery_items created.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_gallery_items_active_type_order' AND object_id = OBJECT_ID(N'dbo.gallery_items'))
BEGIN
    CREATE INDEX IX_gallery_items_active_type_order
        ON dbo.gallery_items (is_active, media_type, display_order);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_gallery_items_active_type_updated' AND object_id = OBJECT_ID(N'dbo.gallery_items'))
BEGIN
    CREATE INDEX IX_gallery_items_active_type_updated
        ON dbo.gallery_items (is_active, media_type, updated_at DESC, id DESC)
        INCLUDE (category_id);
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_gallery_items_project_id' AND object_id = OBJECT_ID(N'dbo.gallery_items'))
BEGIN
    CREATE INDEX IX_gallery_items_project_id
        ON dbo.gallery_items (project_id);
END;
GO

