-- =============================================
-- 01_DDL/17_site_settings.sql
-- Bảng: dbo.site_settings
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.site_settings', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.site_settings (
        id         BIGINT          IDENTITY(1, 1) NOT NULL,
        key_name   NVARCHAR(255)   NOT NULL,
        value_text NVARCHAR(MAX)   NULL,
        updated_at DATETIMEOFFSET  NOT NULL CONSTRAINT DF_site_settings_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_site_settings PRIMARY KEY (id),
        CONSTRAINT UQ_site_settings_key_name UNIQUE (key_name),
        CONSTRAINT CK_site_settings_key_name_not_blank CHECK (LEN(LTRIM(RTRIM(key_name))) > 0)
    );
    PRINT 'Table site_settings created.';
END;
GO

-- Trigger tự cập nhật updated_at
IF OBJECT_ID(N'TR_site_settings_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_site_settings_updated_at
        ON dbo.site_settings
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE s
            SET s.updated_at = SYSUTCDATETIME()
            FROM dbo.site_settings AS s
            INNER JOIN inserted AS i ON s.id = i.id;
        END
    ');
END;
GO

