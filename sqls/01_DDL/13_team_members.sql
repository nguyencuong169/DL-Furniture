-- =============================================
-- 01_DDL/13_team_members.sql
-- Bảng: dbo.team_members
-- =============================================
-- Idempotent: tạo bảng nếu chưa tồn tại.
-- Chuẩn cột theo DB hiện tại (API TeamMember):
--   full_name, role, avatar_image, email, facebook_url, twitter_url,
--   instagram_url, pinterest_url, sort_order, hidden, del_flag,
--   created_user, created_date, updated_user, updated_date.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.team_members', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.team_members (
        id            BIGINT          IDENTITY(1, 1) NOT NULL,
        full_name     NVARCHAR(255)   NOT NULL,
        role          NVARCHAR(255)   NULL,
        avatar_image  NVARCHAR(1024)  NULL,
        email         NVARCHAR(255)   NULL,
        facebook_url  NVARCHAR(1024)  NULL,
        twitter_url   NVARCHAR(1024)  NULL,
        instagram_url NVARCHAR(1024)  NULL,
        pinterest_url NVARCHAR(1024)  NULL,
        sort_order    INT             NOT NULL CONSTRAINT DF_team_members_sort_order DEFAULT (0),
        hidden        BIT             NOT NULL CONSTRAINT DF_team_members_hidden DEFAULT (0),
        del_flag      BIT             NOT NULL CONSTRAINT DF_team_members_del_flag DEFAULT (0),
        created_user  NVARCHAR(255)   NULL,
        created_date  DATETIMEOFFSET  NULL CONSTRAINT DF_team_members_created_date DEFAULT (SYSUTCDATETIME()),
        updated_user  NVARCHAR(255)   NULL,
        updated_date  DATETIMEOFFSET  NULL CONSTRAINT DF_team_members_updated_date DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_team_members PRIMARY KEY (id),
        CONSTRAINT CK_team_members_full_name_not_blank CHECK (LEN(LTRIM(RTRIM(full_name))) > 0)
    );
    PRINT 'Table team_members created.';
END;
GO

-- Trigger tự cập nhật updated_date
IF OBJECT_ID(N'TR_team_members_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_team_members_updated_at
        ON dbo.team_members
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE t
            SET t.updated_date = SYSUTCDATETIME()
            FROM dbo.team_members AS t
            INNER JOIN inserted AS i ON t.id = i.id;
        END
    ');
END;
GO

