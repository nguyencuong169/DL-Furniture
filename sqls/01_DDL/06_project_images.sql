-- =============================================
-- 01_DDL/06_project_images.sql
-- Bảng: dbo.project_images
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.project_images', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.project_images (
        id         BIGINT          IDENTITY(1, 1) NOT NULL,
        project_id BIGINT          NOT NULL,
        image_url  NVARCHAR(1024)  NOT NULL,
        caption    NVARCHAR(255)   NULL,
        sort_order INT             NOT NULL CONSTRAINT DF_project_images_sort_order DEFAULT (0),
        created_at DATETIMEOFFSET  NOT NULL CONSTRAINT DF_project_images_created_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_project_images PRIMARY KEY (id),
        CONSTRAINT FK_project_images_project FOREIGN KEY (project_id) REFERENCES dbo.projects (id)
    );
    PRINT 'Table project_images created.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_project_images_project_id' AND object_id = OBJECT_ID(N'dbo.project_images'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_project_images_project_id ON dbo.project_images (project_id);
END;
GO

