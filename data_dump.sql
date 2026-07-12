-- data_dump.sql
-- SQL Server seed data for the D&L Furniture Vue project

SET NOCOUNT ON;
GO

CREATE TABLE dbo.menus (
  id INT IDENTITY(1,1) PRIMARY KEY,
  parent_id INT NULL,
  title NVARCHAR(200) NOT NULL,
  slug NVARCHAR(200) NULL,
  url NVARCHAR(500) NULL,
  sort_order INT DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.page_banners (
  id INT IDENTITY(1,1) PRIMARY KEY,
  page_key NVARCHAR(100) NOT NULL,
  title NVARCHAR(200) NULL,
  subtitle NVARCHAR(200) NULL,
  image_url NVARCHAR(1000) NULL,
  overlay_dark INT DEFAULT 0,
  created_at DATETIME2 DEFAULT GETDATE()
);
GO

CREATE TABLE dbo.sliders (
  id INT IDENTITY(1,1) PRIMARY KEY,
  image_url NVARCHAR(1000) NOT NULL,
  headline NVARCHAR(500) NULL,
  subheadline NVARCHAR(1000) NULL,
  overlay_dark INT DEFAULT 0,
  link_text NVARCHAR(200) NULL
);
GO

CREATE TABLE dbo.products (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(300) NOT NULL,
  price NVARCHAR(100) NULL,
  price_amount DECIMAL(12,2) DEFAULT 0.00,
  currency CHAR(3) DEFAULT 'VND',
  image_path NVARCHAR(500) NULL,
  detail_url NVARCHAR(500) NULL,
  category NVARCHAR(100) NULL
);
GO

CREATE TABLE dbo.product_details (
  id INT IDENTITY(1,1) PRIMARY KEY,
  product_id INT NULL,
  title NVARCHAR(300) NULL,
  slug NVARCHAR(300) NULL,
  description NVARCHAR(MAX) NULL,
  hero_image NVARCHAR(500) NULL,
  gallery_images NVARCHAR(1000) NULL,
  features NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.services (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(300) NULL,
  image_path NVARCHAR(500) NULL,
  description NVARCHAR(MAX) NULL,
  cta_text NVARCHAR(100) NULL,
  cta_url NVARCHAR(500) NULL
);
GO

CREATE TABLE dbo.facilities (
  id INT IDENTITY(1,1) PRIMARY KEY,
  title NVARCHAR(300) NULL,
  description NVARCHAR(MAX) NULL,
  icon_class NVARCHAR(100) NULL
);
GO

CREATE TABLE dbo.testimonials (
  id INT IDENTITY(1,1) PRIMARY KEY,
  author NVARCHAR(200) NULL,
  location NVARCHAR(200) NULL,
  photo_path NVARCHAR(500) NULL,
  content NVARCHAR(MAX) NULL
);
GO

CREATE TABLE dbo.team_members (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(200) NULL,
  role NVARCHAR(200) NULL,
  photo_path NVARCHAR(500) NULL,
  email NVARCHAR(200) NULL,
  social_links NVARCHAR(1000) NULL
);
GO

CREATE TABLE dbo.news_items (
  id INT IDENTITY(1,1) PRIMARY KEY,
  title NVARCHAR(500) NULL,
  summary NVARCHAR(MAX) NULL,
  image_path NVARCHAR(500) NULL,
  tag NVARCHAR(100) NULL,
  category NVARCHAR(100) NULL,
  publish_date DATE NULL,
  detail_url NVARCHAR(500) NULL
);
GO

CREATE TABLE dbo.gallery (
  id INT IDENTITY(1,1) PRIMARY KEY,
  image_path NVARCHAR(500) NULL,
  caption NVARCHAR(500) NULL,
  type NVARCHAR(50) DEFAULT N'image'
);
GO

CREATE TABLE dbo.clients (
  id INT IDENTITY(1,1) PRIMARY KEY,
  name NVARCHAR(200) NULL,
  logo_path NVARCHAR(500) NULL,
  url NVARCHAR(500) NULL
);
GO

CREATE TABLE dbo.contacts (
  id INT IDENTITY(1,1) PRIMARY KEY,
  label NVARCHAR(200) NULL,
  value NVARCHAR(500) NULL
);
GO

-- Menus
INSERT INTO dbo.menus (parent_id, title, slug, url, sort_order) VALUES
(NULL, N'Trang chủ', N'home', N'/', 1),
(NULL, N'Giới thiệu', N'about', N'/gioi-thieu', 2),
(NULL, N'Sản phẩm', N'product', N'/san-pham', 3),
(3, N'Phòng khách', N'phong-khach', N'/san-pham/phong-khach', 1),
(4, N'Sofa gỗ', N'sofa', N'/san-pham/phong-khach/sofa', 1),
(4, N'Bàn trà', N'ban-tra', N'/san-pham/phong-khach/ban-tra', 2),
(4, N'Kệ ti vi', N'ke-ti-vi', N'/san-pham/phong-khach/ke-ti-vi', 3),
(3, N'Phòng ngủ', N'phong-ngu', N'/san-pham/phong-ngu', 2),
(8, N'Giường ngủ', N'giuong-ngu', N'/san-pham/phong-ngu/giuong-ngu', 1),
(8, N'Tủ quần áo', N'tu-quan-ao', N'/san-pham/phong-ngu/tu-quan-ao', 2),
(8, N'Kệ trang điểm', N'ke-trang-diem', N'/san-pham/phong-ngu/ke-trang-diem', 3),
(3, N'Phòng bếp', N'phong-bep', N'/san-pham/phong-bep', 3),
(12, N'Bàn ăn', N'ban-an', N'/san-pham/phong-bep/ban-an', 1),
(12, N'Tủ bếp', N'tu-bep', N'/san-pham/phong-bep/tu-bep', 2),
(NULL, N'Dự án', N'project', N'/du-an', 4),
(NULL, N'Thư viện', N'gallery', N'/thu-vien', 5),
(NULL, N'Tin tức', N'news', N'/tin-tuc', 6),
(NULL, N'Liên hệ', N'contacts', N'/lien-he', 7);
GO

-- Page banners
INSERT INTO dbo.page_banners (page_key, title, subtitle, image_url, overlay_dark) VALUES
(N'about', N'Về chúng tôi', N'D&L Furniture', N'https://dl-furniture.netlify.app/assets/1-vdnilppx.jpg', 4),
(N'contact', N'Liên hệ với chúng tôi', N'GET IN TOUCH', N'https://dl-furniture.netlify.app/assets/1-vdnilppx.jpg', 4),
(N'gallery', N'Thư viện', N'Images & Videos', N'https://dl-furniture.netlify.app/assets/3-notwsuvf.jpg', 4),
(N'news', N'Tin tức nội thất', N'D&L Furniture', N'https://dl-furniture.netlify.app/assets/7-jvnrfz_x.jpg', 4),
(N'product_detail', N'Giường óc chó', N'D&L Furniture', N'/src/assets/img/slider/3.jpg', 3);
GO

-- Sliders
INSERT INTO dbo.sliders (image_url, headline, subheadline, overlay_dark, link_text) VALUES
(N'https://dl-furniture.netlify.app/assets/1-b3ntw45g.jpg', N'Trải nghiệm sống đích thực', N'Không gian tiện nghi đẳng cấp', 2, N'Khám phá ngay'),
(N'https://dl-furniture.netlify.app/assets/2-bupjuqqy.png', N'Thiết kế & thi công', N'Phong cách thiết kế đa dạng', 2, N'Khám phá ngay'),
(N'https://dl-furniture.netlify.app/assets/3-1hki4eyd.png', N'Sựa lựa chọn tốt nhất', N'Biến ước mơ thành hiện thực', 2, N'Khám phá ngay');
GO

-- Products
INSERT INTO dbo.products (name, price, price_amount, currency, image_path, detail_url, category) VALUES
(N'Giường Óc Chó - G01', N'11.000.000 VND', 11000000.00, N'VND', N'assets/img/rooms/1.jpg', N'/san-pham/detail/1', N'Giường'),
(N'Giường Óc Chó - G02', N'10.700.000 VND', 10700000.00, N'VND', N'assets/img/rooms/2.jpg', N'/san-pham/detail/1', N'Giường'),
(N'Giường Óc Chó - G03', N'25.000.000', 25000000.00, N'VND', N'assets/img/rooms/3.jpg', N'/san-pham/detail/1', N'Giường'),
(N'Giường Nhập Khẩu - G04', N'30.000.000 VNĐ', 30000000.00, N'VND', N'assets/img/rooms/4.png', N'/san-pham/detail/1', N'Giường'),
(N'Tủ Óc Chó - T01', N'15.000.000', 15000000.00, N'VND', N'assets/img/rooms/7.png', N'/san-pham/detail/1', N'Tủ');
GO

-- Product details
INSERT INTO dbo.product_details (product_id, title, slug, description, hero_image, gallery_images, features) VALUES
(1, N'Giường óc chó', N'giuong-oc-cho', N'Nét cuốn hút của các đường vân gỗ cùng sắc nâu sang trọng của gỗ óc chó chắc chắn sẽ khiến căn phòng tỏa sáng hơn bao giờ hết.', N'/src/assets/img/slider/3.jpg', N'/src/assets/img/slider/2.jpg,/src/assets/img/slider/5.jpg', N'Tư vấn thiết kế miễn phí;Thi công chính xác;Bảo hành dài hạn');
GO

-- Services / pricing
INSERT INTO dbo.services (name, image_path, description, cta_text, cta_url) VALUES
(N'Nội thất biệt thự', N'assets/img/pricing/1.jpg', N'Kiến tạo nên tính thẩm mỹ cá tính với đa phong cách thiết kế và cung cấp những tiện ích sống xứng tầm đẳng cấp', N'Khám phá ngay', N'/san-pham'),
(N'Nội thất chung cư', N'assets/img/pricing/2.jpg', N'Chuyên thiết kế nội thất chung cư trọn gói, chuyên nghiệp với nhiều phong cách thiết kế khác nhau', N'Khám phá ngay', N'/san-pham'),
(N'Nội thất văn phòng', N'assets/img/pricing/3.jpg', N'Cung cấp các mẫu thiết kế nội thất văn phòng đa dạng diện tích và phong cách tạo nên vẻ đẹp và phong cách riêng', N'Khám phá ngay', N'/san-pham'),
(N'Showroom & Trung tâm', N'assets/img/pricing/4.jpg', N'Xây dựng không gian theo concept riêng, môi trường học tập chuẩn mực, đẹp mắt cho từng đối tượng khác nhau', N'Khám phá ngay', N'/san-pham');
GO

-- Facilities
INSERT INTO dbo.facilities (title, description, icon_class) VALUES
(N'Đội ngũ nhân viên và kiến trúc sư chuyên nghiệp', N'Đội ngũ kiến trúc sư trẻ năng động và sáng tạo, cùng với công nhân sản xuất lành nghề, nhiều kinh nghiệm được tuyển chọn.', N'flaticon-world'),
(N'Cập nhật xu hướng mới nhất hiện đại', N'D&L Furniture mang đến cho ngôi nhà bạn những xu thế thiết kế mới nhất, vật liệu và phương pháp thi công hiện đại nhất.', N'flaticon-car'),
(N'Giám sát tiến độ chính xác tới khách hàng', N'Luôn cố gắng hoàn thành dự án một cách chính xác, nhanh chóng, chuyên nghiệp nhất và tiết kiệm chi phí thời gian cho bạn và gia đình.', N'flaticon-bed'),
(N'Bảo hành công trình lâu dài', N'Luôn đồng hành cùng quý khách trong suốt quá trình sử dụng. Bảo hành 2 năm và bảo trì 3 năm, 5 năm và hơn thế nữa.', N'flaticon-swimming'),
(N'Giá cả hợp lý phải chăng', N'Với lợi thế về xưởng sản xuất và kinh nghiệm lâu năm, chúng tôi cam kết đem lại giá trị tốt nhất cho khách hàng và phù hợp nhất về chất lượng.', N'flaticon-wifi'),
(N'Hỗ trợ tư vấn miễn phí 24/7', N'Thời gian có mặt nhanh chóng, luôn sẵn sàng phục vụ tư vấn miễn phí khách hàng 24/24.', N'flaticon-breakfast');
GO

-- Testimonials
INSERT INTO dbo.testimonials (author, location, photo_path, content) VALUES
(N'Chị Nguyễn Thị Thuỳ Linh', N'Hồ Chí Minh', N'assets/img/team/4.jpg', N'Tôi rất ấn tượng với các dịch vụ và sản phẩm của Nội thất D&L Furniture. Từ tư vấn thiết kế đến thi công, lắp đặt đều chuyên nghiệp, gia đình tôi rất hài lòng.'),
(N'Anh Nguyễn Hùng Cường', N'Hà Nội', N'assets/img/team/1.jpg', N'Tất cả những sản phẩm nội thất gỗ óc chó của D&L Furniture luôn mang giá trị thẩm mỹ rất cao, chất lượng và công năng hoàn hảo.'),
(N'Chị Nguyễn Thị Nguyệt', N'Hà Nội', N'assets/img/team/5.jpg', N'Tôi rất ấn tượng với các dịch vụ và sản phẩm của Nội thất D&L Furniture. Từ tư vấn thiết kế đến thi công, lắp đặt đều chuyên nghiệp.');
GO

-- Team members
INSERT INTO dbo.team_members (name, role, photo_path, email, social_links) VALUES
(N'Valentina Karla', N'General Manager', N'assets/img/team/4.jpg', N'valentina@dl-furniture.com', N'instagram,twitter,facebook'),
(N'Micheal White', N'Guest Service Department', N'assets/img/team/1.jpg', N'micheal@dl-furniture.com', N'instagram,twitter,facebook'),
(N'Olivia Martin', N'Reservations Manager', N'assets/img/team/2.jpg', N'olivia@dl-furniture.com', N'instagram,twitter,facebook'),
(N'Mariana Dana', N'F&B Manager', N'assets/img/team/5.jpg', N'mariana@dl-furniture.com', N'instagram,twitter,facebook'),
(N'Enrico Brown', N'Head Chef', N'assets/img/team/3.jpg', N'enrico@dl-furniture.com', N'instagram,twitter,facebook'),
(N'Victoria Dan', N'Meetings and Events Manager', N'assets/img/team/6.jpg', N'victoria@dl-furniture.com', N'instagram,twitter,facebook');
GO

-- News items
INSERT INTO dbo.news_items (title, summary, image_path, tag, category, publish_date, detail_url) VALUES
(N'Showroom nội thất gỗ óc chó đẳng cấp tại Hà Nội', N'Không gian showroom hiện đại, phong cách và đẳng cấp dành cho khách hàng tìm kiếm giải pháp nội thất cao cấp.', N'assets/img/news/1.jpg', N'SHOWROOM', N'Design', '2024-12-02', N'/tin-tuc/post/1'),
(N'Mẫu thiết kế phòng ngủ đẹp như mơ', N'Phong cách hiện đại, tối ưu công năng cho không gian ngủ thư giãn và sang trọng.', N'assets/img/news/2.jpg', N'Spa', N'Interior', '2024-12-04', N'/tin-tuc/post/2'),
(N'Hotel Bathroom Collections', N'Thiết kế phòng tắm hiện đại, tinh tế và bền bỉ theo thời gian.', N'assets/img/news/3.jpg', N'Bathrooms', N'Interior', '2024-12-06', N'/tin-tuc/post/3'),
(N'Weight Loss with Fitness Health Club', N'Tạo phong cách sống khỏe mạnh và đẹp mắt cho từng không gian nội thất.', N'assets/img/news/4.jpg', N'Health', N'Wellness', '2024-12-08', N'/tin-tuc/post/4'),
(N'Retro Lighting Design in The Hotels', N'Ý tưởng ánh sáng và màu sắc tạo nên không gian sang trọng và ấm cúng.', N'assets/img/news/6.jpg', N'Design', N'Lighting', '2024-12-08', N'/tin-tuc/post/5'),
(N'Benefits of Swimming for Your Health', N'Sự kết hợp giữa không gian nghỉ dưỡng và tiện nghi cho gia đình.', N'assets/img/news/5.jpg', N'Health', N'Wellness', '2024-12-08', N'/tin-tuc/post/6');
GO

-- Gallery
INSERT INTO dbo.gallery (image_path, caption, type) VALUES
(N'assets/img/slider/7.jpg', NULL, N'image'),
(N'assets/img/slider/5.jpg', NULL, N'image'),
(N'assets/img/slider/4.jpg', NULL, N'image'),
(N'assets/img/slider/2.jpg', NULL, N'image'),
(N'assets/img/slider/1.jpg', NULL, N'image'),
(N'assets/img/rooms/8.jpg', NULL, N'image'),
(N'assets/img/rooms/5.jpg', NULL, N'image'),
(N'assets/img/rooms/10.jpg', NULL, N'image');
GO

-- Clients
INSERT INTO dbo.clients (name, logo_path, url) VALUES
(N'Client 1', N'assets/img/clients/1.png', N'#'),
(N'Client 2', N'assets/img/clients/2.png', N'#'),
(N'Client 3', N'assets/img/clients/3.png', N'#'),
(N'Client 4', N'assets/img/clients/4.png', N'#'),
(N'Client 5', N'assets/img/clients/5.png', N'#'),
(N'Client 6', N'assets/img/clients/6.png', N'#');
GO

-- Contacts
INSERT INTO dbo.contacts (label, value) VALUES
(N'Tư vấn thiết kế', N'(+84) 961-109-897'),
(N'Email', N'info@dl-furniture.com'),
(N'Địa chỉ', N'Đường Cầu Liêu, Thạch Xá - Thạch Thất - Hà Nội');
GO
