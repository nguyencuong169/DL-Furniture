-- =============================================
-- 01_DDL/09_contact_messages.sql
-- Bảng: dbo.contact_messages
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.contact_messages', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.contact_messages (
        id         BIGINT          IDENTITY(1, 1) NOT NULL,
        name       NVARCHAR(255)   NOT NULL,
        email      NVARCHAR(255)   NOT NULL,
        phone      NVARCHAR(50)    NULL,
        subject    NVARCHAR(255)   NULL,
        message    NVARCHAR(MAX)   NOT NULL,
        source     NVARCHAR(100)   NOT NULL CONSTRAINT DF_contact_messages_source DEFAULT (N'contact_form'),
        status     NVARCHAR(50)    NOT NULL CONSTRAINT DF_contact_messages_status DEFAULT (N'new'),
        created_at DATETIMEOFFSET  NOT NULL CONSTRAINT DF_contact_messages_created_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_contact_messages PRIMARY KEY (id),
        CONSTRAINT CK_contact_messages_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
        CONSTRAINT CK_contact_messages_email CHECK (email LIKE '%_@__%.__%')
    );
    PRINT 'Table contact_messages created.';
END;
GO

