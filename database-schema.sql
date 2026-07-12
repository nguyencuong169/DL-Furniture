-- ========================================================
-- Database schema for DL-Furniture site (T-SQL Version)
-- ========================================================
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

DROP TABLE IF EXISTS dbo.product_images;

DROP TABLE IF EXISTS dbo.products;

DROP TABLE IF EXISTS dbo.categories;


GO
-- --------------------------------------------------------
-- 2. TẠO CÁC BẢNG DỮ LIỆU
-- --------------------------------------------------------
CREATE TABLE dbo.categories (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255) NOT NULL,
    slug          VARCHAR (255)  NOT NULL UNIQUE,
    parent_id     BIGINT         NULL,
    description   NVARCHAR (MAX) NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE(),
    updated_at    DATETIME       DEFAULT GETDATE(),
    CONSTRAINT FK_categories_parent FOREIGN KEY (parent_id) REFERENCES dbo.categories (id)
);

CREATE TABLE dbo.products (
    id          BIGINT          IDENTITY (1, 1) PRIMARY KEY,
    category_id BIGINT          NULL,
    sku         VARCHAR (100)   NULL,
    slug        VARCHAR (255)   NOT NULL UNIQUE,
    name        NVARCHAR (255)  NOT NULL,
    summary     NVARCHAR (MAX)  NULL,
    description NVARCHAR (MAX)  NULL,
    price       DECIMAL (14, 2) NULL,
    currency    NVARCHAR (10)   DEFAULT N'VND',
    main_image  VARCHAR (1024)  NULL,
    is_active   BIT             DEFAULT 1,
    hidden      BIT             DEFAULT 0,
    created_at  DATETIME        DEFAULT GETDATE(),
    updated_at  DATETIME        DEFAULT GETDATE(),
    CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id)
);

CREATE TABLE dbo.product_images (
    id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    product_id BIGINT         NOT NULL,
    image_url  VARCHAR (1024) NOT NULL,
    caption    NVARCHAR (255) NULL,
    sort_order INT            DEFAULT 0,
    created_at DATETIME       DEFAULT GETDATE(),
    CONSTRAINT FK_product_images_product FOREIGN KEY (product_id) REFERENCES dbo.products (id)
);

CREATE TABLE dbo.news (
    id           BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    news_id      VARCHAR (255)  NULL,
    title        NVARCHAR (255) NULL,
    summary      NVARCHAR (MAX) NULL,
    content      NVARCHAR (MAX) NULL,
    news_image   VARCHAR (1024) NULL,
    category_id  BIGINT         NULL,
    tags         NVARCHAR (MAX) NULL,
    hidden       BIT            DEFAULT 0,
    del_flag     BIT            DEFAULT 0,
    created_user NVARCHAR (255) NULL,
    created_date DATETIME       NULL,
    updated_user NVARCHAR (255) NULL,
    updated_date DATETIME       NULL,
    CONSTRAINT FK_news_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id)
);

CREATE TABLE dbo.projects (
    id          BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    title       NVARCHAR (255) NOT NULL,
    subtitle    NVARCHAR (255) NULL,
    client_name NVARCHAR (255) NULL,
    location    NVARCHAR (255) NULL,
    category_id BIGINT         NULL,
    description NVARCHAR (MAX) NULL,
    cover_image VARCHAR (1024) NULL,
    status      VARCHAR (50)   DEFAULT 'published',
    created_at  DATETIME       DEFAULT GETDATE(),
    updated_at  DATETIME       DEFAULT GETDATE(),
    CONSTRAINT FK_projects_category FOREIGN KEY (category_id) REFERENCES dbo.categories (id)
);

CREATE TABLE dbo.project_images (
    id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    project_id BIGINT         NOT NULL,
    image_url  VARCHAR (1024) NOT NULL,
    caption    NVARCHAR (255) NULL,
    sort_order INT            DEFAULT 0,
    created_at DATETIME       DEFAULT GETDATE(),
    CONSTRAINT FK_project_images_project FOREIGN KEY (project_id) REFERENCES dbo.projects (id)
);

CREATE TABLE dbo.contact_messages (
    id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name       NVARCHAR (255) NOT NULL,
    email      VARCHAR (255)  NOT NULL,
    phone      VARCHAR (50)   NULL,
    subject    NVARCHAR (255) NULL,
    message    NVARCHAR (MAX) NOT NULL,
    source     VARCHAR (100)  DEFAULT 'contact_form',
    status     VARCHAR (50)   DEFAULT 'new',
    created_at DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.booking_requests (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    full_name     NVARCHAR (255) NOT NULL,
    email         VARCHAR (255)  NOT NULL,
    phone         VARCHAR (50)   NULL,
    message       NVARCHAR (MAX) NULL,
    checkin_date  DATE           NULL,
    checkout_date DATE           NULL,
    adults        INT            NULL,
    children      INT            NULL,
    source        VARCHAR (100)  DEFAULT 'booking_form',
    status        VARCHAR (50)   DEFAULT 'pending',
    created_at    DATETIME       DEFAULT GETDATE(),
    updated_at    DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.services (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    title         NVARCHAR (255) NOT NULL,
    description   NVARCHAR (MAX) NULL,
    image_url     VARCHAR (1024) NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE(),
    updated_at    DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.facilities (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    title         NVARCHAR (255) NOT NULL,
    description   NVARCHAR (MAX) NULL,
    icon_class    VARCHAR (255)  NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1
);

CREATE TABLE dbo.team_members (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255) NOT NULL,
    role          NVARCHAR (255) NULL,
    email         VARCHAR (255)  NULL,
    image_url     VARCHAR (1024) NULL,
    instagram     VARCHAR (255)  NULL,
    twitter       VARCHAR (255)  NULL,
    facebook      VARCHAR (255)  NULL,
    pinterest     VARCHAR (255)  NULL,
    bio           NVARCHAR (MAX) NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE(),
    updated_at    DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.testimonials (
    id          BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    author_name NVARCHAR (255) NOT NULL,
    location    NVARCHAR (255) NULL,
    content     NVARCHAR (MAX) NOT NULL,
    rating      INT            DEFAULT 5,
    image_url   VARCHAR (1024) NULL,
    is_active   BIT            DEFAULT 1,
    created_at  DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.clients (
    id            BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    name          NVARCHAR (255) NULL,
    logo_url      VARCHAR (1024) NULL,
    website_url   VARCHAR (1024) NULL,
    display_order INT            DEFAULT 0,
    is_active     BIT            DEFAULT 1,
    created_at    DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.sliders (
    id                   BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    title                NVARCHAR (255) NULL,
    subtitle             NVARCHAR (255) NULL,
    background_image_url VARCHAR (1024) NULL,
    button_text          NVARCHAR (255) NULL,
    button_link          VARCHAR (1024) NULL,
    display_order        INT            DEFAULT 0,
    is_active            BIT            DEFAULT 1,
    created_at           DATETIME       DEFAULT GETDATE()
);

CREATE TABLE dbo.site_settings (
    id         BIGINT         IDENTITY (1, 1) PRIMARY KEY,
    key_name   VARCHAR (255)  NOT NULL UNIQUE,
    value_text NVARCHAR (MAX) NULL,
    updated_at DATETIME       DEFAULT GETDATE()
);


GO
-- --------------------------------------------------------
-- 3. TẠO TRIGGERS TỰ ĐỘNG CẬP NHẬT BIẾN `updated_at`
-- --------------------------------------------------------
CREATE TRIGGER TR_Categories_Update
    ON dbo.categories
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.categories
           SET    updated_at = GETDATE()
           FROM   dbo.categories AS c
                  INNER JOIN
                  inserted AS i
                  ON c.id = i.id;
       END


GO
CREATE TRIGGER TR_Products_Update
    ON dbo.products
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.products
           SET    updated_at = GETDATE()
           FROM   dbo.products AS p
                  INNER JOIN
                  inserted AS i
                  ON p.id = i.id;
       END


GO
CREATE TRIGGER TR_Projects_Update
    ON dbo.projects
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.projects
           SET    updated_at = GETDATE()
           FROM   dbo.projects AS p
                  INNER JOIN
                  inserted AS i
                  ON p.id = i.id;
       END


GO
CREATE TRIGGER TR_BookingRequests_Update
    ON dbo.booking_requests
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.booking_requests
           SET    updated_at = GETDATE()
           FROM   dbo.booking_requests AS b
                  INNER JOIN
                  inserted AS i
                  ON b.id = i.id;
       END


GO
CREATE TRIGGER TR_Services_Update
    ON dbo.services
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.services
           SET    updated_at = GETDATE()
           FROM   dbo.services AS s
                  INNER JOIN
                  inserted AS i
                  ON s.id = i.id;
       END


GO
CREATE TRIGGER TR_TeamMembers_Update
    ON dbo.team_members
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.team_members
           SET    updated_at = GETDATE()
           FROM   dbo.team_members AS t
                  INNER JOIN
                  inserted AS i
                  ON t.id = i.id;
       END


GO
CREATE TRIGGER TR_SiteSettings_Update
    ON dbo.site_settings
    AFTER UPDATE
    AS BEGIN
           UPDATE dbo.site_settings
           SET    updated_at = GETDATE()
           FROM   dbo.site_settings AS s
                  INNER JOIN
                  inserted AS i
                  ON s.id = i.id;
       END