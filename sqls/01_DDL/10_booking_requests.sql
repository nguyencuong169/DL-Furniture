-- =============================================
-- 01_DDL/10_booking_requests.sql
-- Bảng: dbo.booking_requests
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
-- Lưu ý: chuẩn cột theo DB hiện tại (API) — source default = 'consultation_form'.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.booking_requests', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.booking_requests (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        full_name     NVARCHAR(255)   NOT NULL,
        email         NVARCHAR(255)   NOT NULL,
        phone         NVARCHAR(50)    NULL,
        message       NVARCHAR(MAX)   NULL,
        checkin_date  DATE            NULL,
        checkout_date DATE            NULL,
        adults        INT             NULL,
        children      INT             NULL,
        source        NVARCHAR(100)   NOT NULL CONSTRAINT DF_booking_requests_source DEFAULT (N'consultation_form'),
        status        NVARCHAR(50)    NOT NULL CONSTRAINT DF_booking_requests_status DEFAULT (N'pending'),
        created_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_booking_requests_created_at DEFAULT (SYSUTCDATETIME()),
        updated_at    DATETIMEOFFSET  NOT NULL CONSTRAINT DF_booking_requests_updated_at DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_booking_requests PRIMARY KEY (id),
        CONSTRAINT CK_booking_requests_full_name_not_blank CHECK (LEN(LTRIM(RTRIM(full_name))) > 0),
        CONSTRAINT CK_booking_requests_email CHECK (email LIKE '%_@__%.__%'),
        CONSTRAINT CHK_booking_requests_dates CHECK (checkout_date >= checkin_date)
    );
    PRINT 'Table booking_requests created.';
END;
GO

-- Trigger tự cập nhật updated_at
IF OBJECT_ID(N'TR_booking_requests_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_booking_requests_updated_at
        ON dbo.booking_requests
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE b
            SET b.updated_at = SYSUTCDATETIME()
            FROM dbo.booking_requests AS b
            INNER JOIN inserted AS i ON b.id = i.id;
        END
    ');
END;
GO

