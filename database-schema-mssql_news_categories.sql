-- Additional schema for separating news categories from product categories (SQL Server)
-- Run this after/with existing database-schema-mssql.sql.

/*
  Assumptions:
  - Existing table: news(id, category_id, ...)
  - Existing table: categories(id, ...) for product/project

  Changes:
  - Create news_categories table
  - Add column news_category_id to news
  - (optional) migrate existing news.category_id values -> news_category_id using a mapping table or direct insert

  In this repo seed, we will set news_category_id directly.
*/

-- 1) Create news_categories
IF OBJECT_ID('dbo.news_categories', 'U') IS NULL
BEGIN
    CREATE TABLE dbo.news_categories (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(255) NOT NULL,
      slug NVARCHAR(255) NOT NULL UNIQUE,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE()
    );
END
GO

-- 2) Add news_category_id to news
IF COL_LENGTH('dbo.news', 'news_category_id') IS NULL
BEGIN
    ALTER TABLE dbo.news
      ADD news_category_id BIGINT NULL;
END
GO

-- 3) Add FK
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM sys.foreign_keys WHERE name = 'FK_news_news_categories'
    )
    BEGIN
        ALTER TABLE dbo.news
          ADD CONSTRAINT FK_news_news_categories
          FOREIGN KEY (news_category_id) REFERENCES dbo.news_categories(id);
    END
END
GO

-- NOTE: After this, update backend to use news_category_id.

