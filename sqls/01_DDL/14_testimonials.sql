-- =============================================
-- 01_DDL/14_testimonials.sql
-- Bảng: dbo.testimonials
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
-- Chuẩn cột theo DB hiện tại (API Testimonial):
--   customer_name, location, content, avatar_image, rating, sort_order,
--   hidden, del_flag, created_user, created_date, updated_user, updated_date.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.testimonials', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.testimonials (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        customer_name NVARCHAR(255)   NOT NULL,
        location      NVARCHAR(255)   NULL,
        content       NVARCHAR(MAX)   NOT NULL,
        avatar_image  NVARCHAR(1024)  NULL,
        rating        INT             NOT NULL CONSTRAINT DF_testimonials_rating DEFAULT (5),
        sort_order    INT             NOT NULL CONSTRAINT DF_testimonials_sort_order DEFAULT (0),
        hidden        BIT             NOT NULL CONSTRAINT DF_testimonials_hidden DEFAULT (0),
        del_flag      BIT             NOT NULL CONSTRAINT DF_testimonials_del_flag DEFAULT (0),
        created_user  NVARCHAR(255)   NULL,
        created_date  DATETIMEOFFSET  NULL CONSTRAINT DF_testimonials_created_date DEFAULT (SYSUTCDATETIME()),
        updated_user  NVARCHAR(255)   NULL,
        updated_date  DATETIMEOFFSET  NULL CONSTRAINT DF_testimonials_updated_date DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_testimonials PRIMARY KEY (id),
        CONSTRAINT CK_testimonials_customer_name_not_blank CHECK (LEN(LTRIM(RTRIM(customer_name))) > 0),
        CONSTRAINT CHK_testimonials_rating CHECK (rating BETWEEN 1 AND 5)
    );
    PRINT 'Table testimonials created.';
END;
GO

-- Trigger tự cập nhật updated_date
IF OBJECT_ID(N'TR_testimonials_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_testimonials_updated_at
        ON dbo.testimonials
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE t
            SET t.updated_date = SYSUTCDATETIME()
            FROM dbo.testimonials AS t
            INNER JOIN inserted AS i ON t.id = i.id;
        END
    ');
END;
GO

