-- =============================================
-- 01_DDL/18_menus.sql
-- Bang: dbo.menus
-- =============================================
-- Idempotent: tao bang neu chua ton tai.
-- Cot theo chuan DB hien tai (Models/Menu.cs + AppDbContext):
--   parent_id, label, url, location, sort_order, is_consultation,
--   is_active, hidden, del_flag, created_user, created_date,
--   updated_user, updated_date.
SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

IF OBJECT_ID(N'dbo.menus', N'U') IS NULL
BEGIN
    CREATE TABLE dbo.menus (
        id               BIGINT          IDENTITY(1, 1) NOT NULL,
        parent_id        BIGINT          NULL,
        label            NVARCHAR(255)   NOT NULL,
        url              NVARCHAR(1024)  NOT NULL,
        location         NVARCHAR(20)    NOT NULL CONSTRAINT DF_menus_location DEFAULT (N'primary'),
        sort_order       INT             NOT NULL CONSTRAINT DF_menus_sort_order DEFAULT (0),
        is_consultation BIT             NOT NULL CONSTRAINT DF_menus_is_consultation DEFAULT (0),
        is_active        BIT             NOT NULL CONSTRAINT DF_menus_is_active DEFAULT (1),
        hidden           BIT             NOT NULL CONSTRAINT DF_menus_hidden DEFAULT (0),
        del_flag         BIT             NOT NULL CONSTRAINT DF_menus_del_flag DEFAULT (0),
        created_user     NVARCHAR(255)   NULL,
        created_date     DATETIMEOFFSET  NULL CONSTRAINT DF_menus_created_date DEFAULT (SYSUTCDATETIME()),
        updated_user     NVARCHAR(255)   NULL,
        updated_date     DATETIMEOFFSET  NULL CONSTRAINT DF_menus_updated_date DEFAULT (SYSUTCDATETIME()),
        CONSTRAINT PK_menus PRIMARY KEY (id),
        CONSTRAINT CK_menus_label_not_blank CHECK (LEN(LTRIM(RTRIM(label))) > 0),
        CONSTRAINT CK_menus_location_valid CHECK (location IN (N'primary', N'footer'))
    );
    PRINT 'Table menus created.';
END;
GO

-- Khoa ngoai tu tham chieu (parent_id to id)
IF NOT EXISTS (SELECT 1 FROM sys.foreign_keys WHERE name = N'FK_menus_parent')
BEGIN
    ALTER TABLE dbo.menus ADD CONSTRAINT FK_menus_parent
        FOREIGN KEY (parent_id) REFERENCES dbo.menus (id);
    PRINT 'FK_menus_parent created.';
END;
GO

-- Index truy van theo vi tri + thu tu
IF NOT EXISTS (SELECT 1 FROM sys.indexes WHERE name = N'IX_menus_location_sort')
BEGIN
    CREATE INDEX IX_menus_location_sort ON dbo.menus (location, sort_order, id);
    PRINT 'IX_menus_location_sort created.';
END;
GO

-- Trigger tu cap nhat updated_date
IF OBJECT_ID(N'TR_menus_updated_at', N'TR') IS NULL
BEGIN
    EXEC (N'
        CREATE TRIGGER TR_menus_updated_at
        ON dbo.menus
        AFTER UPDATE
        AS BEGIN
            SET NOCOUNT ON;
            UPDATE m
            SET m.updated_date = SYSUTCDATETIME()
            FROM dbo.menus AS m
            INNER JOIN inserted AS i ON m.id = i.id;
        END
    ');
END;
GO