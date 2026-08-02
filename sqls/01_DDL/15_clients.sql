-- =============================================
-- 01_DDL/15_clients.sql
-- Bảng: dbo.clients
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.clients', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.clients (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        name          NVARCHAR(255)   NULL,
        logo_url      NVARCHAR(1024)  NULL,
        website_url   NVARCHAR(1024)  NULL,
        display_order INT             NOT NULL CONSTRAINT DF_clients_display_order DEFAULT (0),
        is_active     BIT             NOT NULL CONSTRAINT DF_clients_is_active DEFAULT (1),
        created_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_clients_created_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_clients PRIMARY KEY (id)
    );
    PRINT 'Table clients created.';
END;
GO

