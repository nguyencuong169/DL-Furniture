-- Seed data for SQL Server (T-SQL)
-- Assumes `database-schema-mssql.sql` has been run against the target database.

-- Categories (explicit IDs using IDENTITY_INSERT)
SET IDENTITY_INSERT categories ON;
INSERT INTO categories (id, name, slug, parent_id, description, display_order, is_active)
VALUES (1, N'Phòng Ngủ', N'phong-ngu', NULL, N'Danh mục phòng ngủ', 1, 1),
       (2, N'Phòng Khách', N'phong-khach', NULL, N'Danh mục phòng khách', 2, 1),
       (3, N'Phòng Bếp', N'phong-bep', NULL, N'Danh mục phòng bếp', 3, 1);
SET IDENTITY_INSERT categories OFF;

-- Products
SET IDENTITY_INSERT products ON;
INSERT INTO products (id, category_id, sku, slug, name, summary, description, price, currency, main_image, is_active, hidden)
VALUES (1, 1, N'G01', N'giuong-oc-cho-g01', N'Giường Óc Chó - G01', N'Giường óc chó sang trọng', N'Mô tả chi tiết Giường Óc Chó - G01', 11000000.00, N'VND', N'/src/assets/img/rooms/1.jpg', 1, 0),
       (2, 1, N'G02', N'giuong-oc-cho-g02', N'Giường Óc Chó - G02', N'Giường óc chó mẫu 2', N'Mô tả chi tiết G02', 10700000.00, N'VND', N'/src/assets/img/rooms/2.jpg', 1, 0),
       (3, 1, N'G03', N'giuong-oc-cho-g03', N'Giường Óc Chó - G03', N'Giường cao cấp', N'Mô tả chi tiết G03', 25000000.00, N'VND', N'/src/assets/img/rooms/3.jpg', 1, 0),
       (4, 2, N'T01', N'tu-oc-cho-t01', N'Tủ Óc Chó - T01', N'Tủ gỗ óc chó', N'Mô tả T01', 15000000.00, N'VND', N'/src/assets/img/rooms/7.png', 1, 0);
SET IDENTITY_INSERT products OFF;

-- Product images
INSERT INTO product_images (product_id, image_url, caption, sort_order)
VALUES (1, N'/src/assets/img/rooms/1.jpg', N'Giường G01', 1),
       (2, N'/src/assets/img/rooms/2.jpg', N'Giường G02', 1),
       (3, N'/src/assets/img/rooms/3.jpg', N'Giường G03', 1),
       (4, N'/src/assets/img/rooms/7.png', N'Tủ T01', 1);

-- News
SET IDENTITY_INSERT news ON;
INSERT INTO news (id, news_id, title, summary, content, news_image, category_id, tags, hidden, del_flag, created_user, created_date, updated_user, updated_date)
VALUES (1, N'news-001', N'Showroom nội thất gỗ óc chó đẳng cấp tại Hà Nội', N'Showroom mới của D&L Furniture tại Hà Nội', N'Nội dung bài viết về showroom...', N'/src/assets/img/news/1.jpg', 2, N'Restaurant,Hotel', 0, 0, N'admin', GETDATE(), N'admin', GETDATE()),
       (2, N'news-002', N'Mẫu thiết kế phòng ngủ đẹp như mơ', N'Ý tưởng thiết kế phòng ngủ', N'Nội dung bài viết về phòng ngủ...', N'/src/assets/img/news/2.jpg', 1, N'Spa,Hotel', 0, 0, N'editor', GETDATE(), N'editor', GETDATE());
SET IDENTITY_INSERT news OFF;


-- Projects
SET IDENTITY_INSERT projects ON;
INSERT INTO projects (id, title, subtitle, client_name, location, category_id, description, cover_image, status)
VALUES (1, N'Thiết kế nội thất Saroma Villa', N'Villa cao cấp', N'Anh Tuấn', N'Thủ Thiêm', NULL, N'Thiết kế trọn gói Saroma Villa', N'/src/assets/img/slider/4.jpg', N'published'),
       (2, N'Thiết kế nội thất biệt thự Vinhomes', N'Biệt thự Vinhomes Grand Park', N'Anh Cường', N'Quận 9', NULL, N'Thiết kế và thi công biệt thự', N'/src/assets/img/slider/3.jpg', N'published');
SET IDENTITY_INSERT projects OFF;

-- Project images
INSERT INTO project_images (project_id, image_url, caption, sort_order)
VALUES (1, N'/src/assets/img/slider/4.jpg', N'Saroma Villa', 1),
       (2, N'/src/assets/img/slider/3.jpg', N'Vinhomes Grand Park', 1);

-- Services
INSERT INTO services (title, description, image_url, display_order, is_active)
VALUES (N'Nội thất biệt thự', N'Kiến tạo nên tính thẩm mỹ cá tính với đa phong cách thiết kế', N'/src/assets/img/pricing/1.jpg', 1, 1),
       (N'Nội thất chung cư', N'Chuyên thiết kế nội thất chung cư trọn gói', N'/src/assets/img/pricing/2.jpg', 2, 1),
       (N'Nội thất văn phòng', N'Cung cấp mẫu thiết kế nội thất văn phòng', N'/src/assets/img/pricing/3.jpg', 3, 1),
       (N'Showroom & Trung tâm', N'Xây dựng không gian theo concept riêng', N'/src/assets/img/pricing/4.jpg', 4, 1);

-- Facilities
INSERT INTO facilities (title, description, icon_class, display_order, is_active)
VALUES (N'Đội ngũ chuyên nghiệp', N'Đội ngũ kiến trúc sư trẻ năng động', N'flaticon-world', 1, 1),
       (N'Cập nhật xu hướng', N'Cập nhật xu hướng mới nhất', N'flaticon-car', 2, 1),
       (N'Giám sát tiến độ', N'Giám sát tiến độ chính xác', N'flaticon-bed', 3, 1);

-- Team members
INSERT INTO team_members (name, role, email, image_url, instagram, twitter, facebook, pinterest, bio, display_order, is_active)
VALUES (N'Valentina Karla', N'General Manager', N'valentina@hotel.com', N'/src/assets/img/team/4.jpg', N'#', N'#', N'#', N'#', N'Giám đốc', 1, 1),
       (N'Micheal White', N'Guest Service Department', N'micheal@hotel.com', N'/src/assets/img/team/1.jpg', N'#', N'#', N'#', N'#', N'Trưởng bộ phận dịch vụ', 2, 1),
       (N'Olivia Martin', N'Reservations Manager', N'olivia@hotel.com', N'/src/assets/img/team/2.jpg', N'#', N'#', N'#', N'#', N'Quản lý đặt phòng', 3, 1);

-- Testimonials
INSERT INTO testimonials (author_name, location, content, rating, image_url, is_active)
VALUES (N'Chị Nguyễn Thị Thuỳ Linh', N'Hồ Chí Minh', N'Tôi rất ấn tượng với các dịch vụ và sản phẩm của D&L Furniture...', 5, N'/src/assets/img/team/4.jpg', 1),
       (N'Anh Nguyễn Hùng Cường', N'Hà Nội', N'Sản phẩm luôn mang giá trị thẩm mỹ rất cao...', 5, N'/src/assets/img/team/1.jpg', 1);

-- Clients
INSERT INTO clients (name, logo_url, website_url, display_order, is_active)
VALUES (N'Client A', N'/src/assets/img/clients/1.png', N'#', 1, 1),
       (N'Client B', N'/src/assets/img/clients/2.png', N'#', 2, 1);

-- Sliders
INSERT INTO sliders (title, subtitle, background_image_url, button_text, button_link, display_order, is_active)
VALUES (N'Trải nghiệm sống đích thực', N'Không gian tiện nghi đẳng cấp', N'https://dl-furniture.netlify.app/assets/1-b3ntw45g.jpg', N'Khám phá ngay', N'#', 1, 1),
       (N'Phong cách thiết kế đa dạng', N'Thiết kế & thi công', N'https://dl-furniture.netlify.app/assets/2-bupjuqqy.png', N'Khám phá ngay', N'#', 2, 1);

-- Site settings
INSERT INTO site_settings (key_name, value_text)
VALUES (N'company_name', N'D&L Furniture'),
       (N'phone', N'(+84) 961-109-897'),
       (N'email', N'info@dl-furniture.com');

-- Sample contact message
INSERT INTO contact_messages (name, email, phone, subject, message, source, status, created_at)
VALUES (N'Nguyen Van A', N'a@example.com', N'0901234567', N'Tư vấn thiết kế', N'Xin tư vấn thiết kế phòng khách 30m2', N'contact_form', N'new', GETDATE());

-- Sample booking request
INSERT INTO booking_requests (full_name, email, phone, message, checkin_date, checkout_date, adults, children, source, status)
VALUES (N'Tran Thi B', N'b@example.com', N'0912345678', N'Tôi muốn tư vấn nội thất chung cư', NULL, NULL, NULL, NULL, N'booking_form', N'pending');
