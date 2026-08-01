-- ============================================================
-- About-page API migration (testimonials / team_members / services)
-- Adds the audit & soft-delete columns expected by the EF Core
-- entities in DLFurniture.Api while preserving existing data.
--
-- Safe to run more than once: all schema changes are guarded.
-- With sqlcmd on Windows, use `-f 65001` so Vietnamese seed text
-- is read as UTF-8.
-- ============================================================
SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    -- ============================================================
    -- 1. TESTIMONIALS
    -- ============================================================
    IF OBJECT_ID(N'dbo.testimonials', N'U') IS NOT NULL
    BEGIN
        -- customer_name <- author_name
        IF COL_LENGTH(N'dbo.testimonials', N'customer_name') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD customer_name NVARCHAR(255) NOT NULL
                    CONSTRAINT DF_testimonials_customer_name DEFAULT (N'');
        END;

        IF COL_LENGTH(N'dbo.testimonials', N'customer_name') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.testimonials
                SET customer_name = author_name
                WHERE customer_name = N'''';';
        END;

        -- avatar_image <- image_url
        IF COL_LENGTH(N'dbo.testimonials', N'avatar_image') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD avatar_image NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.testimonials', N'avatar_image') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.testimonials
                SET avatar_image = image_url
                WHERE avatar_image IS NULL;';
        END;

        -- sort_order (defaults to 0; can be refined later)
        IF COL_LENGTH(N'dbo.testimonials', N'sort_order') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD sort_order INT NOT NULL
                    CONSTRAINT DF_testimonials_sort_order DEFAULT (0);
        END;

        -- hidden <- !is_active
        IF COL_LENGTH(N'dbo.testimonials', N'hidden') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD hidden BIT NOT NULL
                    CONSTRAINT DF_testimonials_hidden DEFAULT (0);
        END;

        IF COL_LENGTH(N'dbo.testimonials', N'hidden') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.testimonials
                SET hidden = CASE WHEN is_active = 0 THEN 1 ELSE 0 END
                WHERE hidden = 0 AND is_active = 0;';
        END;

        -- del_flag
        IF COL_LENGTH(N'dbo.testimonials', N'del_flag') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD del_flag BIT NOT NULL
                    CONSTRAINT DF_testimonials_del_flag DEFAULT (0);
        END;

        -- created_user
        IF COL_LENGTH(N'dbo.testimonials', N'created_user') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD created_user NVARCHAR(255) NULL;
        END;

        -- created_date <- created_at
        IF COL_LENGTH(N'dbo.testimonials', N'created_date') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD created_date DATETIMEOFFSET NULL;
        END;

        IF COL_LENGTH(N'dbo.testimonials', N'created_date') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.testimonials
                SET created_date = CAST(created_at AS DATETIMEOFFSET)
                WHERE created_date IS NULL;';
        END;

        -- updated_user
        IF COL_LENGTH(N'dbo.testimonials', N'updated_user') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD updated_user NVARCHAR(255) NULL;
        END;

        -- updated_date
        IF COL_LENGTH(N'dbo.testimonials', N'updated_date') IS NULL
        BEGIN
            ALTER TABLE dbo.testimonials
                ADD updated_date DATETIMEOFFSET NULL;
        END;
    END;

    -- ============================================================
    -- 2. TEAM_MEMBERS
    -- ============================================================
    IF OBJECT_ID(N'dbo.team_members', N'U') IS NOT NULL
    BEGIN
        -- full_name <- name
        IF COL_LENGTH(N'dbo.team_members', N'full_name') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD full_name NVARCHAR(255) NOT NULL
                    CONSTRAINT DF_team_members_full_name DEFAULT (N'');
        END;

        IF COL_LENGTH(N'dbo.team_members', N'full_name') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET full_name = name
                WHERE full_name = N'''';';
        END;

        -- avatar_image <- image_url
        IF COL_LENGTH(N'dbo.team_members', N'avatar_image') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD avatar_image NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.team_members', N'avatar_image') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET avatar_image = image_url
                WHERE avatar_image IS NULL;';
        END;

        -- facebook_url <- facebook
        IF COL_LENGTH(N'dbo.team_members', N'facebook_url') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD facebook_url NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.team_members', N'facebook_url') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET facebook_url = facebook
                WHERE facebook_url IS NULL;';
        END;

        -- twitter_url <- twitter
        IF COL_LENGTH(N'dbo.team_members', N'twitter_url') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD twitter_url NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.team_members', N'twitter_url') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET twitter_url = twitter
                WHERE twitter_url IS NULL;';
        END;

        -- instagram_url <- instagram
        IF COL_LENGTH(N'dbo.team_members', N'instagram_url') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD instagram_url NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.team_members', N'instagram_url') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET instagram_url = instagram
                WHERE instagram_url IS NULL;';
        END;

        -- pinterest_url <- pinterest
        IF COL_LENGTH(N'dbo.team_members', N'pinterest_url') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD pinterest_url NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.team_members', N'pinterest_url') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET pinterest_url = pinterest
                WHERE pinterest_url IS NULL;';
        END;

        -- sort_order <- display_order
        IF COL_LENGTH(N'dbo.team_members', N'sort_order') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD sort_order INT NOT NULL
                    CONSTRAINT DF_team_members_sort_order DEFAULT (0);
        END;

        IF COL_LENGTH(N'dbo.team_members', N'sort_order') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET sort_order = ISNULL(display_order, 0)
                WHERE sort_order = 0;';
        END;

        -- hidden <- !is_active
        IF COL_LENGTH(N'dbo.team_members', N'hidden') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD hidden BIT NOT NULL
                    CONSTRAINT DF_team_members_hidden DEFAULT (0);
        END;

        IF COL_LENGTH(N'dbo.team_members', N'hidden') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET hidden = CASE WHEN is_active = 0 THEN 1 ELSE 0 END
                WHERE hidden = 0 AND is_active = 0;';
        END;

        -- del_flag
        IF COL_LENGTH(N'dbo.team_members', N'del_flag') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD del_flag BIT NOT NULL
                    CONSTRAINT DF_team_members_del_flag DEFAULT (0);
        END;

        -- created_user
        IF COL_LENGTH(N'dbo.team_members', N'created_user') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD created_user NVARCHAR(255) NULL;
        END;

        -- created_date <- created_at
        IF COL_LENGTH(N'dbo.team_members', N'created_date') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD created_date DATETIMEOFFSET NULL;
        END;

        IF COL_LENGTH(N'dbo.team_members', N'created_date') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.team_members
                SET created_date = CAST(created_at AS DATETIMEOFFSET)
                WHERE created_date IS NULL;';
        END;

        -- updated_user
        IF COL_LENGTH(N'dbo.team_members', N'updated_user') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD updated_user NVARCHAR(255) NULL;
        END;

        -- updated_date
        IF COL_LENGTH(N'dbo.team_members', N'updated_date') IS NULL
        BEGIN
            ALTER TABLE dbo.team_members
                ADD updated_date DATETIMEOFFSET NULL;
        END;
    END;

    -- ============================================================
    -- 3. SERVICES
    -- ============================================================
    IF OBJECT_ID(N'dbo.services', N'U') IS NOT NULL
    BEGIN
        -- name <- title
        IF COL_LENGTH(N'dbo.services', N'name') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD name NVARCHAR(255) NOT NULL
                    CONSTRAINT DF_services_name DEFAULT (N'');
        END;

        IF COL_LENGTH(N'dbo.services', N'name') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.services
                SET name = title
                WHERE name = N'''';';
        END;

        -- image <- image_url
        IF COL_LENGTH(N'dbo.services', N'image') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD image NVARCHAR(1024) NULL;
        END;

        IF COL_LENGTH(N'dbo.services', N'image') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.services
                SET image = image_url
                WHERE image IS NULL;';
        END;

        -- category (no source column; keep NULL / default)
        IF COL_LENGTH(N'dbo.services', N'category') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD category NVARCHAR(255) NULL;
        END;

        -- sort_order <- display_order
        IF COL_LENGTH(N'dbo.services', N'sort_order') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD sort_order INT NOT NULL
                    CONSTRAINT DF_services_sort_order DEFAULT (0);
        END;

        IF COL_LENGTH(N'dbo.services', N'sort_order') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.services
                SET sort_order = ISNULL(display_order, 0)
                WHERE sort_order = 0;';
        END;

        -- hidden <- !is_active
        IF COL_LENGTH(N'dbo.services', N'hidden') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD hidden BIT NOT NULL
                    CONSTRAINT DF_services_hidden DEFAULT (0);
        END;

        IF COL_LENGTH(N'dbo.services', N'hidden') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.services
                SET hidden = CASE WHEN is_active = 0 THEN 1 ELSE 0 END
                WHERE hidden = 0 AND is_active = 0;';
        END;

        -- del_flag
        IF COL_LENGTH(N'dbo.services', N'del_flag') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD del_flag BIT NOT NULL
                    CONSTRAINT DF_services_del_flag DEFAULT (0);
        END;

        -- created_user
        IF COL_LENGTH(N'dbo.services', N'created_user') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD created_user NVARCHAR(255) NULL;
        END;

        -- created_date <- created_at
        IF COL_LENGTH(N'dbo.services', N'created_date') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD created_date DATETIMEOFFSET NULL;
        END;

        IF COL_LENGTH(N'dbo.services', N'created_date') IS NOT NULL
        BEGIN
            EXEC sys.sp_executesql N'
                UPDATE dbo.services
                SET created_date = CAST(created_at AS DATETIMEOFFSET)
                WHERE created_date IS NULL;';
        END;

        -- updated_user
        IF COL_LENGTH(N'dbo.services', N'updated_user') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD updated_user NVARCHAR(255) NULL;
        END;

        -- updated_date
        IF COL_LENGTH(N'dbo.services', N'updated_date') IS NULL
        BEGIN
            ALTER TABLE dbo.services
                ADD updated_date DATETIMEOFFSET NULL;
        END;
    END;

    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

-- ============================================================
-- Verification output
-- ============================================================
SELECT t.name AS table_name, c.name AS column_name, ty.name AS data_type
FROM sys.tables t
JOIN sys.columns c ON c.object_id = t.object_id
JOIN sys.types ty ON ty.user_type_id = c.user_type_id
WHERE t.name IN ('testimonials', 'team_members', 'services')
ORDER BY t.name, c.column_id;

