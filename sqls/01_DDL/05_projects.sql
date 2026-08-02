-- =============================================
-- 01_DDL/05_projects.sql
-- Bảng: dbo.projects
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.projects', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.projects (
        id          BIGINT          IDENTITY(1, 1) NOT NULL,
        title       NVARCHAR(255)   NOT NULL,
        subtitle    NVARCHAR(255)   NULL,
        client_name NVARCHAR(255)   NULL,
        location    NVARCHAR(255)   NULL,
        category_id BIGINT          NULL,
        description NVARCHAR(MAX)   NULL,
        cover_image NVARCHAR(1024)  NULL,
        status      NVARCHAR(50)    NOT NULL CONSTRAINT DF_projects_status DEFAULT (N'published'),
        created_at  DATETIMEOFFSET  NOT NULL CONSTRAINT DF_projects_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at  DATETIMEOFFSET  NOT NULL CONSTRAINT DF_projects_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_projects PRIMARY KEY (id),
        CONSTRAINT CK_projects_title_not_blank CHECK (LEN(LTRIM(RTRIM(title))) > 0),
        CONSTRAINT CK_projects_status CHECK (status IN (N'draft', N'published', N'archived')),
        CONSTRAINT FK_projects_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id)
    );
    PRINT 'Table projects created.';
END;
GO

IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_projects_category_id' AND object_id = OBJECT_ID(N'dbo.projects'))
BEGIN
    CREATE NONCLUSTERED INDEX IX_projects_category_id ON dbo.projects (category_id);
END;
GO

-- Trigger tự cập nhật updated_at
IF OBJECT_ID(N'TR_projects_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_projects_updated_at
        ON dbo.projects
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE p
            SET p.updated_at = SYSUTCDATETIME()
            FROM dbo.projects AS p
            INNER JOIN inserted AS i ON p.id = i.id;
        END
    ');
END;
GO

