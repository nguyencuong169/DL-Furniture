-- =============================================
-- 01_DDL/11_services.sql
-- Bảng: dbo.services
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
-- Chuẩn cột theo DB hiện tại (API ServiceItem):
--   name, description, image, category, sort_order, hidden, del_flag,
--   created_user, created_date, updated_user, updated_date.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.services', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.services (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        name          NVARCHAR(255)   NOT NULL,
        description   NVARCHAR(MAX)   NULL,
        image         NVARCHAR(1024)  NULL,
        category      NVARCHAR(255)   NULL,
        sort_order    INT             NOT NULL CONSTRAINT DF_services_sort_order DEFAULT (0),
        hidden        BIT             NOT NULL CONSTRAINT DF_services_hidden DEFAULT (0),
        del_flag      BIT             NOT NULL CONSTRAINT DF_services_del_flag DEFAULT (0),
        created_user  NVARCHAR(255)   NULL,
        created_date  DATETIMEOFFSET  NULL CONSTRAINT DF_services_created_date DEFAULT (SYSUTCDATETIME()),
        updated_user  NVARCHAR(255)   NULL,
        updated_date  DATETIMEOFFSET  NULL CONSTRAINT DF_services_updated_date DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_services PRIMARY KEY (id),
        CONSTRAINT CK_services_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0)
    );
    PRINT 'Table services created.';
END;
GO

-- Trigger tự cập nhật updated_date
IF OBJECT_ID(N'TR_services_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_services_updated_at
        ON dbo.services
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE s
            SET s.updated_date = SYSUTCDATETIME()
            FROM dbo.services AS s
            INNER JOIN inserted AS i ON s.id = i.id;
        END
    ');
END;
GO

