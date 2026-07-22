-- ========================================================
-- Database schema for DL-Furniture site (T-SQL Version)
-- Compatibility: SQL Server 2016+
-- ========================================================
SET ANSI_NULLS ON;

SET QUOTED_IDENTIFIER ON;


GO
-- --------------------------------------------------------
-- 1. XÓA BẢNG NẾU ĐÃ TỒN TẠI (Theo thứ tự từ con đến cha)
-- --------------------------------------------------------
DROP TABLE IF EXISTS dbo.site_settings;

DROP TABLE IF EXISTS dbo.sliders;

DROP TABLE IF EXISTS dbo.clients;

DROP TABLE IF EXISTS dbo.testimonials;

DROP TABLE IF EXISTS dbo.team_members;

DROP TABLE IF EXISTS dbo.facilities;

DROP TABLE IF EXISTS dbo.services;

DROP TABLE IF EXISTS dbo.booking_requests;

DROP TABLE IF EXISTS dbo.contact_messages;

DROP TABLE IF EXISTS dbo.project_images;

DROP TABLE IF EXISTS dbo.projects;

DROP TABLE IF EXISTS dbo.news;

DROP TABLE IF EXISTS dbo.news_categories;

DROP TABLE IF EXISTS dbo.product_images;

DROP TABLE IF EXISTS dbo.products;

DROP TABLE IF EXISTS dbo.categories;


GO
-- --------------------------------------------------------
-- 2. KHỞI TẠO CÁC BẢNG DỮ LIỆU
-- --------------------------------------------------------
-- Categories
CREATE TABLE dbo.categories (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255) NOT NULL,
    slug          NVARCHAR (255) NOT NULL UNIQUE,
    parent_id     BIGINT         NULL,
    description   NVARCHAR (MAX) NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME2      DEFAULT GETDATE(),
    updated_at    DATETIME2      DEFAULT GETDATE(),
    CONSTRAINT FK_categories_parent FOREIGN KEY (parent_id) REFERENCES dbo.categories (id)
); -- News categories (separate from product/project categories)

CREATE TABLE dbo.news_categories (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255) NOT NULL,
    slug          NVARCHAR (255) NOT NULL UNIQUE,
    display_order INT            NOT NULL DEFAULT 0,
    is_active     BIT            NOT NULL DEFAULT 1,
    created_at    DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    updated_at    DATETIME2      NOT NULL DEFAULT SYSUTCDATETIME(),
    CONSTRAINT CK_news_categories_name_not_blank CHECK (LEN(LTRIM(RTRIM(name))) > 0),
    CONSTRAINT CK_news_categories_slug_not_blank CHECK (LEN(LTRIM(RTRIM(slug))) > 0)
); -- Products

CREATE TABLE dbo.products (
    id          BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    category_id BIGINT          NULL,
    sku         NVARCHAR (100)  NULL,
    slug        NVARCHAR (255)  NOT NULL UNIQUE,
    name        NVARCHAR (255)  NOT NULL,
    summary     NVARCHAR (MAX)  NULL,
    description NVARCHAR (MAX)  NULL,
    price       DECIMAL (18, 2) NULL,
    currency    NVARCHAR (10)   DEFAULT N'VND',
    main_image  NVARCHAR (1024) NULL,
    is_active   BIT             DEFAULT 1,
    hidden      BIT             DEFAULT 0,
    created_at  DATETIME2       DEFAULT GETDATE(),
    updated_at  DATETIME2       DEFAULT GETDATE(),
    CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id),
    CONSTRAINT CHK_products_price CHECK (price >= 0)
); -- Product images

CREATE TABLE dbo.product_images (
    id         BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    product_id BIGINT          NOT NULL,
    image_url  NVARCHAR (1024) NOT NULL,
    caption    NVARCHAR (255)  NULL,
    sort_order INT             DEFAULT 0,
    created_at DATETIME2       DEFAULT GETDATE(),
    CONSTRAINT FK_product_images_product FOREIGN KEY (product_id) REFERENCES dbo.products (id)
); -- News

CREATE TABLE dbo.news (
    id           BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    news_id      NVARCHAR (255)  NULL,
    title        NVARCHAR (255)  NULL,
    summary      NVARCHAR (MAX)  NULL,
    content      NVARCHAR (MAX)  NULL,
    news_image   NVARCHAR (1024) NULL,
    news_category_id BIGINT      NULL,
    tags         NVARCHAR (MAX)  NULL,
    hidden       BIT             DEFAULT 0,
    del_flag     BIT             DEFAULT 0,
    created_user NVARCHAR (255)  NULL,
    created_date DATETIME2       DEFAULT GETDATE(),
    updated_user NVARCHAR (255)  NULL,
    updated_date DATETIME2       DEFAULT GETDATE(),
    CONSTRAINT FK_news_news_categories FOREIGN KEY (news_category_id) REFERENCES dbo.news_categories (id)
); -- Projects

CREATE TABLE dbo.projects (
    id          BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    title       NVARCHAR (255)  NOT NULL,
    subtitle    NVARCHAR (255)  NULL,
    client_name NVARCHAR (255)  NULL,
    location    NVARCHAR (255)  NULL,
    category_id BIGINT          NULL,
    description NVARCHAR (MAX)  NULL,
    cover_image NVARCHAR (1024) NULL,
    status      NVARCHAR (50)   DEFAULT N'published',
    created_at  DATETIME2       DEFAULT GETDATE(),
    updated_at  DATETIME2       DEFAULT GETDATE(),
    CONSTRAINT FK_projects_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id)
); -- Project images

CREATE TABLE dbo.project_images (
    id         BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    project_id BIGINT          NOT NULL,
    image_url  NVARCHAR (1024) NOT NULL,
    caption    NVARCHAR (255)  NULL,
    sort_order INT             DEFAULT 0,
    created_at DATETIME2       DEFAULT GETDATE(),
    CONSTRAINT FK_project_images_project FOREIGN KEY (project_id) REFERENCES dbo.projects (id)
); -- Contact messages

CREATE TABLE dbo.contact_messages (
    id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name       NVARCHAR (255) NOT NULL,
    email      NVARCHAR (255) NOT NULL,
    phone      NVARCHAR (50)  NULL,
    subject    NVARCHAR (255) NULL,
    message    NVARCHAR (MAX) NOT NULL,
    source     NVARCHAR (100) DEFAULT N'contact_form',
    status     NVARCHAR (50)  DEFAULT N'new',
    created_at DATETIME2      DEFAULT GETDATE(),
    CONSTRAINT CHK_contact_messages_email CHECK (email LIKE '%_@__%.__%')
); -- Booking requests

CREATE TABLE dbo.booking_requests (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    full_name     NVARCHAR (255) NOT NULL,
    email         NVARCHAR (255) NOT NULL,
    phone         NVARCHAR (50)  NULL,
    message       NVARCHAR (MAX) NULL,
    checkin_date  DATE           NULL,
    checkout_date DATE           NULL,
    adults        INT            NULL,
    children      INT            NULL,
    source        NVARCHAR (100) DEFAULT N'booking_form',
    status        NVARCHAR (50)  DEFAULT N'pending',
    created_at    DATETIME2      DEFAULT GETDATE(),
    updated_at    DATETIME2      DEFAULT GETDATE(),
    CONSTRAINT CHK_booking_requests_dates CHECK (checkout_date >= checkin_date),
    CONSTRAINT CHK_booking_requests_email CHECK (email LIKE '%_@__%.__%')
); -- Services

CREATE TABLE dbo.services (
    id            BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    title         NVARCHAR (255)  NOT NULL,
    description   NVARCHAR (MAX)  NULL,
    image_url     NVARCHAR (1024) NULL,
    display_order INT             DEFAULT 0,
    is_active     BIT             DEFAULT 1,
    created_at    DATETIME2       DEFAULT GETDATE(),
    updated_at    DATETIME2       DEFAULT GETDATE()
); -- Facilities

CREATE TABLE dbo.facilities (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    title         NVARCHAR (255) NOT NULL,
    description   NVARCHAR (MAX) NULL,
    icon_class    NVARCHAR (255) NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1
); -- Team members

CREATE TABLE dbo.team_members (
    id            BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255)  NOT NULL,
    role          NVARCHAR (255)  NULL,
    email         NVARCHAR (255)  NULL,
    image_url     NVARCHAR (1024) NULL,
    instagram     NVARCHAR (255)  NULL,
    twitter       NVARCHAR (255)  NULL,
    facebook      NVARCHAR (255)  NULL,
    pinterest     NVARCHAR (255)  NULL,
    bio           NVARCHAR (MAX)  NULL,
    display_order INT             DEFAULT 0,
    is_active     BIT             DEFAULT 1,
    created_at    DATETIME2       DEFAULT GETDATE(),
    updated_at    DATETIME2       DEFAULT GETDATE()
); -- Testimonials

CREATE TABLE dbo.testimonials (
    id          BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    author_name NVARCHAR (255)  NOT NULL,
    location    NVARCHAR (255)  NULL,
    content     NVARCHAR (MAX)  NOT NULL,
    rating      INT             DEFAULT 5,
    image_url   NVARCHAR (1024) NULL,
    is_active   BIT             DEFAULT 1,
    created_at  DATETIME2       DEFAULT GETDATE(),
    CONSTRAINT CHK_testimonials_rating CHECK (rating BETWEEN 1 AND 5)
); -- Clients

CREATE TABLE dbo.clients (
    id            BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255)  NULL,
    logo_url      NVARCHAR (1024) NULL,
    website_url   NVARCHAR (1024) NULL,
    display_order INT             DEFAULT 0,
    is_active     BIT             DEFAULT 1,
    created_at    DATETIME2       DEFAULT GETDATE()
); -- Sliders

CREATE TABLE dbo.sliders (
    id                   BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    title                NVARCHAR (255)  NULL,
    subtitle             NVARCHAR (255)  NULL,
    background_image_url NVARCHAR (1024) NULL,
    button_text          NVARCHAR (255)  NULL,
    button_link          NVARCHAR (1024) NULL,
    display_order        INT             DEFAULT 0,
    is_active            BIT             DEFAULT 1,
    created_at           DATETIME2       DEFAULT GETDATE()
); -- Site settings

CREATE TABLE dbo.site_settings (
    id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    key_name   NVARCHAR (255) NOT NULL UNIQUE,
    value_text NVARCHAR (MAX) NULL,
    updated_at DATETIME2      DEFAULT GETDATE()
);


GO
-- --------------------------------------------------------
-- 3. TẠO INDEXES TỐI ƯU HÓA TRUY VẤN (Khóa ngoại & Tìm kiếm nhanh)
-- --------------------------------------------------------
CREATE NONCLUSTERED INDEX IX_products_sku
    ON dbo.products(sku);

CREATE NONCLUSTERED INDEX IX_products_category_id
    ON dbo.products(category_id);

CREATE NONCLUSTERED INDEX IX_product_images_product_id
    ON dbo.product_images(product_id);

CREATE NONCLUSTERED INDEX IX_news_news_category_published
    ON dbo.news(news_category_id, hidden, del_flag)
    INCLUDE (updated_date);

CREATE NONCLUSTERED INDEX IX_projects_category_id
    ON dbo.projects(category_id);

CREATE NONCLUSTERED INDEX IX_project_images_project_id
    ON dbo.project_images(project_id);


GO
-- --------------------------------------------------------
-- 4. TẠO TRIGGERS TỰ ĐỘNG CẬP NHẬT BIẾN `updated_at` KHI SỬA
-- --------------------------------------------------------
CREATE TRIGGER TR_categories_updated_at
    ON dbo.categories
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.categories
           SET    updated_at = GETDATE()
           FROM   dbo.categories AS c
                  INNER JOIN
                  inserted AS i
                  ON c.id = i.id;
       END


GO
CREATE TRIGGER TR_products_updated_at
    ON dbo.products
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.products
           SET    updated_at = GETDATE()
           FROM   dbo.products AS p
                  INNER JOIN
                  inserted AS i
                  ON p.id = i.id;
       END


GO
CREATE TRIGGER TR_projects_updated_at
    ON dbo.projects
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.projects
           SET    updated_at = GETDATE()
           FROM   dbo.projects AS p
                  INNER JOIN
                  inserted AS i
                  ON p.id = i.id;
       END


GO
CREATE TRIGGER TR_booking_requests_updated_at
    ON dbo.booking_requests
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.booking_requests
           SET    updated_at = GETDATE()
           FROM   dbo.booking_requests AS b
                  INNER JOIN
                  inserted AS i
                  ON b.id = i.id;
       END


GO
CREATE TRIGGER TR_services_updated_at
    ON dbo.services
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.services
           SET    updated_at = GETDATE()
           FROM   dbo.services AS s
                  INNER JOIN
                  inserted AS i
                  ON s.id = i.id;
       END


GO
CREATE TRIGGER TR_team_members_updated_at
    ON dbo.team_members
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.team_members
           SET    updated_at = GETDATE()
           FROM   dbo.team_members AS t
                  INNER JOIN
                  inserted AS i
                  ON t.id = i.id;
       END


GO
CREATE TRIGGER TR_site_settings_updated_at
    ON dbo.site_settings
    AFTER UPDATE
    AS BEGIN
           SET NOCOUNT ON;
           UPDATE dbo.site_settings
           SET    updated_at = GETDATE()
           FROM   dbo.site_settings AS s
                  INNER JOIN
                  inserted AS i
                  ON s.id = i.id;
       END
