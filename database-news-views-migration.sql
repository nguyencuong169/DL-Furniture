-- Adds persistent view counts for public news articles.
-- Safe to run more than once against an existing SQL Server database.

SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    IF OBJECT_ID(N'dbo.news', N'U') IS NULL
        THROW 50001, 'Table dbo.news does not exist.', 1;

    IF COL_LENGTH(N'dbo.news', N'view_count') IS NULL
    BEGIN
        ALTER TABLE dbo.news
            ADD view_count BIGINT NOT NULL
                CONSTRAINT DF_news_view_count DEFAULT (0) WITH VALUES;
    END
    ELSE
    BEGIN
        EXEC sys.sp_executesql N'
            UPDATE dbo.news
            SET view_count = 0
            WHERE view_count IS NULL;

            ALTER TABLE dbo.news
                ALTER COLUMN view_count BIGINT NOT NULL;
        ';

        IF NOT EXISTS
        (
            SELECT 1
            FROM sys.default_constraints AS defaults
            INNER JOIN sys.columns AS columns
                ON columns.object_id = defaults.parent_object_id
                AND columns.column_id = defaults.parent_column_id
            WHERE defaults.parent_object_id = OBJECT_ID(N'dbo.news')
              AND columns.name = N'view_count'
        )
        BEGIN
            ALTER TABLE dbo.news
                ADD CONSTRAINT DF_news_view_count DEFAULT (0) FOR view_count;
        END
    END

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

SELECT
    columns.name AS column_name,
    types.name AS data_type,
    columns.is_nullable,
    defaults.definition AS default_value
FROM sys.columns AS columns
INNER JOIN sys.types AS types
    ON types.user_type_id = columns.user_type_id
LEFT JOIN sys.default_constraints AS defaults
    ON defaults.parent_object_id = columns.object_id
    AND defaults.parent_column_id = columns.column_id
WHERE columns.object_id = OBJECT_ID(N'dbo.news')
  AND columns.name = N'view_count';
