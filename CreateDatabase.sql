-- ========================================
-- Create DL-Furniture Database on SQL Server
-- ========================================
-- Run this script with sqlcmd:
-- sqlcmd -S localhost -U sa -P your_password -i CreateDatabase.sql

USE master;
GO

-- Create database if not exists
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'DLFurniture')
BEGIN
    CREATE DATABASE DLFurniture;
    PRINT 'Database DLFurniture created successfully.';
END
ELSE
    PRINT 'Database DLFurniture already exists.';
GO

USE DLFurniture;
GO

-- ========================================
-- CREATE TABLES
-- ========================================

SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
GO

-- Categories
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'categories')
BEGIN
    CREATE TABLE categories (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(255) NOT NULL,
      slug NVARCHAR(255) NOT NULL UNIQUE,
      parent_id BIGINT NULL,
      description NVARCHAR(MAX) NULL,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE(),
      CONSTRAINT FK_categories_parent FOREIGN KEY (parent_id) REFERENCES categories(id)
    );
    PRINT 'Table categories created.';
END
GO

-- News categories (separate from product/project categories)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'news_categories')
BEGIN
    CREATE TABLE news_categories (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(255) NOT NULL,
      slug NVARCHAR(255) NOT NULL UNIQUE,
      display_order INT NOT NULL DEFAULT 0,
      is_active BIT NOT NULL DEFAULT 1,
      created_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME(),
      updated_at DATETIME2 NOT NULL DEFAULT SYSUTCDATETIME()
    );
    PRINT 'Table news_categories created.';
END
GO

-- Products
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'products')
BEGIN
    CREATE TABLE products (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      category_id BIGINT NULL,
      sku NVARCHAR(100) NULL,
      slug NVARCHAR(255) NOT NULL UNIQUE,
      name NVARCHAR(255) NOT NULL,
      summary NVARCHAR(MAX) NULL,
      description NVARCHAR(MAX) NULL,
      price DECIMAL(18,2) NULL,
      currency NVARCHAR(10) DEFAULT N'VND',
      main_image NVARCHAR(1024) NULL,
      is_active BIT DEFAULT 1,
      hidden BIT DEFAULT 0,
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE(),
      CONSTRAINT FK_products_category FOREIGN KEY (category_id) REFERENCES categories(id)
    );
    PRINT 'Table products created.';
END
GO

-- Product images
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'product_images')
BEGIN
    CREATE TABLE product_images (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      product_id BIGINT NOT NULL,
      image_url NVARCHAR(1024) NOT NULL,
      caption NVARCHAR(255) NULL,
      sort_order INT DEFAULT 0,
      created_at DATETIME2 DEFAULT GETDATE(),
      CONSTRAINT FK_product_images_product FOREIGN KEY (product_id) REFERENCES products(id)
    );
    PRINT 'Table product_images created.';
END
GO

-- News
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'news')
BEGIN
    CREATE TABLE news (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      news_id NVARCHAR(255) NULL,
      title NVARCHAR(255) NULL,
      summary NVARCHAR(MAX) NULL,
      content NVARCHAR(MAX) NULL,
      news_image NVARCHAR(1024) NULL,
      news_category_id BIGINT NULL,
      tags NVARCHAR(2048) NULL,
      hidden BIT DEFAULT 0,
      del_flag BIT DEFAULT 0,
      created_user NVARCHAR(255) NULL,
      created_date DATETIME2 DEFAULT GETDATE(),
      updated_user NVARCHAR(255) NULL,
      updated_date DATETIME2 DEFAULT GETDATE(),
      CONSTRAINT FK_news_news_categories FOREIGN KEY (news_category_id) REFERENCES news_categories(id)
    );
    PRINT 'Table news created.';
END
GO

-- Projects
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'projects')
BEGIN
    CREATE TABLE projects (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      title NVARCHAR(255) NOT NULL,
      subtitle NVARCHAR(255) NULL,
      client_name NVARCHAR(255) NULL,
      location NVARCHAR(255) NULL,
      category_id BIGINT NULL,
      description NVARCHAR(MAX) NULL,
      cover_image NVARCHAR(1024) NULL,
      status NVARCHAR(50) DEFAULT N'published',
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE(),
      CONSTRAINT FK_projects_category FOREIGN KEY (category_id) REFERENCES categories(id)
    );
    PRINT 'Table projects created.';
END
GO

-- Project images
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'project_images')
BEGIN
    CREATE TABLE project_images (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      project_id BIGINT NOT NULL,
      image_url NVARCHAR(1024) NOT NULL,
      caption NVARCHAR(255) NULL,
      sort_order INT DEFAULT 0,
      created_at DATETIME2 DEFAULT GETDATE(),
      CONSTRAINT FK_project_images_project FOREIGN KEY (project_id) REFERENCES projects(id)
    );
    PRINT 'Table project_images created.';
END
GO

-- Contact messages
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'contact_messages')
BEGIN
    CREATE TABLE contact_messages (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(255) NOT NULL,
      email NVARCHAR(255) NOT NULL,
      phone NVARCHAR(50) NULL,
      subject NVARCHAR(255) NULL,
      message NVARCHAR(MAX) NOT NULL,
      source NVARCHAR(100) DEFAULT N'contact_form',
      status NVARCHAR(50) DEFAULT N'new',
      created_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table contact_messages created.';
END
GO

-- Booking requests
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'booking_requests')
BEGIN
    CREATE TABLE booking_requests (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      full_name NVARCHAR(255) NOT NULL,
      email NVARCHAR(255) NOT NULL,
      phone NVARCHAR(50) NULL,
      message NVARCHAR(MAX) NULL,
      checkin_date DATE NULL,
      checkout_date DATE NULL,
      adults INT NULL,
      children INT NULL,
      source NVARCHAR(100) DEFAULT N'booking_form',
      status NVARCHAR(50) DEFAULT N'pending',
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table booking_requests created.';
END
GO

-- Services
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'services')
BEGIN
    CREATE TABLE services (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      title NVARCHAR(255) NOT NULL,
      description NVARCHAR(MAX) NULL,
      image_url NVARCHAR(1024) NULL,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table services created.';
END
GO

-- Facilities
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'facilities')
BEGIN
    CREATE TABLE facilities (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      title NVARCHAR(255) NOT NULL,
      description NVARCHAR(MAX) NULL,
      icon_class NVARCHAR(255) NULL,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1
    );
    PRINT 'Table facilities created.';
END
GO

-- Team members
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'team_members')
BEGIN
    CREATE TABLE team_members (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(255) NOT NULL,
      role NVARCHAR(255) NULL,
      email NVARCHAR(255) NULL,
      image_url NVARCHAR(1024) NULL,
      instagram NVARCHAR(255) NULL,
      twitter NVARCHAR(255) NULL,
      facebook NVARCHAR(255) NULL,
      pinterest NVARCHAR(255) NULL,
      bio NVARCHAR(MAX) NULL,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE(),
      updated_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table team_members created.';
END
GO

-- Testimonials
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'testimonials')
BEGIN
    CREATE TABLE testimonials (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      author_name NVARCHAR(255) NOT NULL,
      location NVARCHAR(255) NULL,
      content NVARCHAR(MAX) NOT NULL,
      rating INT DEFAULT 5,
      image_url NVARCHAR(1024) NULL,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table testimonials created.';
END
GO

-- Clients
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'clients')
BEGIN
    CREATE TABLE clients (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      name NVARCHAR(255) NULL,
      logo_url NVARCHAR(1024) NULL,
      website_url NVARCHAR(1024) NULL,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table clients created.';
END
GO

-- Sliders
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sliders')
BEGIN
    CREATE TABLE sliders (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      title NVARCHAR(255) NULL,
      subtitle NVARCHAR(255) NULL,
      background_image_url NVARCHAR(1024) NULL,
      button_text NVARCHAR(255) NULL,
      button_link NVARCHAR(1024) NULL,
      display_order INT DEFAULT 0,
      is_active BIT DEFAULT 1,
      created_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table sliders created.';
END
GO

-- Site settings
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'site_settings')
BEGIN
    CREATE TABLE site_settings (
      id BIGINT IDENTITY(1,1) PRIMARY KEY,
      key_name NVARCHAR(255) NOT NULL UNIQUE,
      value_text NVARCHAR(MAX) NULL,
      updated_at DATETIME2 DEFAULT GETDATE()
    );
    PRINT 'Table site_settings created.';
END
GO

-- ========================================
-- SEED DATA
-- ========================================

-- Insert news items
INSERT INTO news_categories (name, slug, display_order, is_active)
SELECT source.name, source.slug, source.display_order, 1
FROM (VALUES
  (N'Tin tức gỗ óc chó', N'go-oc-cho', 1),
  (N'Khai trương', N'khai-truong', 2),
  (N'Hoàn thiện công trình', N'hoan-thien-cong-trinh', 3),
  (N'Chia sẻ chuyên môn', N'chia-se-chuyen-mon', 4),
  (N'Sự kiện', N'su-kien', 5)
) AS source(name, slug, display_order)
WHERE NOT EXISTS (SELECT 1 FROM news_categories WHERE slug = source.slug);

INSERT INTO news (news_id, title, summary, content, news_image, news_category_id, tags, hidden, del_flag, created_user, created_date, updated_user, updated_date)
VALUES 
  (N'news-001', N'Showroom nội thất gỗ óc chó đẳng cấp tại Hà Nội', 
   N'Không gian showroom hiện đại, phong cách và đẳng cấp dành cho khách hàng tìm kiếm giải pháp nội thất cao cấp.', 
   N'D&L Furniture mang đến showroom nội thất gỗ óc chó đẳng cấp với phong cách hiện đại, bền đẹp và tối ưu công năng.', 
   N'/src/assets/img/news/1.jpg', (SELECT id FROM news_categories WHERE slug = N'khai-truong'), N'Showroom,Gỗ óc chó', 0, 0, N'admin', '2024-12-02', N'admin', '2024-12-02'),
  
  (N'news-002', N'Mẫu thiết kế phòng ngủ đẹp như mơ', 
   N'Phong cách hiện đại, tối ưu công năng cho không gian ngủ thư giãn và sang trọng.', 
   N'Mỗi chi tiết trong phòng ngủ được thiết kế để mang lại cảm giác thư giãn và đẳng cấp.', 
   N'/src/assets/img/news/2.jpg', (SELECT id FROM news_categories WHERE slug = N'chia-se-chuyen-mon'), N'Phòng ngủ,Thiết kế', 0, 0, N'admin', '2024-12-04', N'admin', '2024-12-04'),
  
  (N'news-003', N'Hotel Bathroom Collections', 
   N'Thiết kế phòng tắm hiện đại, tinh tế và bền bỉ theo thời gian.', 
   N'Những bộ sưu tập phòng tắm cao cấp giúp nâng tầm trải nghiệm nghỉ dưỡng tại gia.', 
   N'/src/assets/img/news/3.jpg', (SELECT id FROM news_categories WHERE slug = N'chia-se-chuyen-mon'), N'Phòng tắm,Thiết kế', 0, 0, N'admin', '2024-12-06', N'admin', '2024-12-06');

PRINT 'Seed data inserted successfully.';
GO

-- Verify data
SELECT 'News items count:' AS Info, COUNT(*) FROM news;
SELECT * FROM news ORDER BY updated_date DESC;
GO

PRINT '========================================';
PRINT 'Database setup completed successfully!';
PRINT '========================================';
