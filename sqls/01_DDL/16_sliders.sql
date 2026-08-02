-- =============================================
-- 01_DDL/16_sliders.sql
-- Bảng: dbo.sliders
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.sliders', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.sliders (
        id                   BIGINT          IDENTITY(1, 1) NOT NULL,
        title                NVARCHAR(255)   NULL,
        subtitle             NVARCHAR(255)   NULL,
        background_image_url NVARCHAR(1024)  NULL,
        button_text          NVARCHAR(255)   NULL,
        button_link          NVARCHAR(1024)  NULL,
        display_order        INT             NOT NULL CONSTRAINT DF_sliders_display_order DEFAULT (0),
        is_active            BIT             NOT NULL CONSTRAINT DF_sliders_is_active DEFAULT (1),
        created_at           DATETIMEOFFSET  NOT NULL CONSTRAINT DF_sliders_created_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_sliders PRIMARY KEY (id)
    );
    PRINT 'Table sliders created.';
END;
GO

