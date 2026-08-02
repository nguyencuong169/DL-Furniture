-- =============================================
-- 01_DDL/12_facilities.sql
-- Bảng: dbo.facilities
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.facilities', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.facilities (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        title         NVARCHAR(255)   NOT NULL,
        description   NVARCHAR(MAX)   NULL,
        icon_class    NVARCHAR(255)   NULL,
        display_order INT             NOT NULL CONSTRAINT DF_facilities_display_order DEFAULT (0),
        is_active     BIT             NOT NULL CONSTRAINT DF_facilities_is_active DEFAULT (1),
        CONSTRAINT PK_facilities PRIMARY KEY (id),
        CONSTRAINT CK_facilities_title_not_blank CHECK (LEN(LTRIM(RTRIM(title))) > 0)
    );
    PRINT 'Table facilities created.';
END;
GO

