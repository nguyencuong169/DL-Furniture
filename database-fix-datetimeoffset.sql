-- ============================================================
-- Fix: ALTER DATETIME2 columns to DATETIMEOFFSET
-- Run this against the DLFurniture database directly.
-- ============================================================
SET NOCOUNT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- Testimonials
    IF COL_LENGTH(N'dbo.testimonials', N'created_date') IS NOT NULL
        AND EXISTS (SELECT 1 FROM sys.columns c
                    JOIN sys.types t ON t.user_type_id = c.user_type_id
                    WHERE c.object_id = OBJECT_ID(N'dbo.testimonials')
                      AND c.name = N'created_date'
                      AND t.name = N'datetime2')
        EXEC('ALTER TABLE dbo.testimonials ALTER COLUMN created_date DATETIMEOFFSET NULL');

    IF COL_LENGTH(N'dbo.testimonials', N'updated_date') IS NOT NULL
        AND EXISTS (SELECT 1 FROM sys.columns c
                    JOIN sys.types t ON t.user_type_id = c.user_type_id
                    WHERE c.object_id = OBJECT_ID(N'dbo.testimonials')
                      AND c.name = N'updated_date'
                      AND t.name = N'datetime2')
        EXEC('ALTER TABLE dbo.testimonials ALTER COLUMN updated_date DATETIMEOFFSET NULL');

    -- Team members
    IF COL_LENGTH(N'dbo.team_members', N'created_date') IS NOT NULL
        AND EXISTS (SELECT 1 FROM sys.columns c
                    JOIN sys.types t ON t.user_type_id = c.user_type_id
                    WHERE c.object_id = OBJECT_ID(N'dbo.team_members')
                      AND c.name = N'created_date'
                      AND t.name = N'datetime2')
        EXEC('ALTER TABLE dbo.team_members ALTER COLUMN created_date DATETIMEOFFSET NULL');

    IF COL_LENGTH(N'dbo.team_members', N'updated_date') IS NOT NULL
        AND EXISTS (SELECT 1 FROM sys.columns c
                    JOIN sys.types t ON t.user_type_id = c.user_type_id
                    WHERE c.object_id = OBJECT_ID(N'dbo.team_members')
                      AND c.name = N'updated_date'
                      AND t.name = N'datetime2')
        EXEC('ALTER TABLE dbo.team_members ALTER COLUMN updated_date DATETIMEOFFSET NULL');

    -- Services
    IF COL_LENGTH(N'dbo.services', N'created_date') IS NOT NULL
        AND EXISTS (SELECT 1 FROM sys.columns c
                    JOIN sys.types t ON t.user_type_id = c.user_type_id
                    WHERE c.object_id = OBJECT_ID(N'dbo.services')
                      AND c.name = N'created_date'
                      AND t.name = N'datetime2')
        EXEC('ALTER TABLE dbo.services ALTER COLUMN created_date DATETIMEOFFSET NULL');

    IF COL_LENGTH(N'dbo.services', N'updated_date') IS NOT NULL
        AND EXISTS (SELECT 1 FROM sys.columns c
                    JOIN sys.types t ON t.user_type_id = c.user_type_id
                    WHERE c.object_id = OBJECT_ID(N'dbo.services')
                      AND c.name = N'updated_date'
                      AND t.name = N'datetime2')
        EXEC('ALTER TABLE dbo.services ALTER COLUMN updated_date DATETIMEOFFSET NULL');

    COMMIT TRANSACTION;

    PRINT 'All columns altered successfully.';
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;
    THROW;
END CATCH;
