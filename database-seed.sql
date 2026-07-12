-- Seed data for DL-Furniture
-- Assumes the schema from database-schema.sql is already applied

-- Categories
INSERT INTO categories (id, name, slug, parent_id, description, display_order, is_active)
VALUES
(1, 'Phòng Ngủ', 'phong-ngu', NULL, 'Danh mục phòng ngủ', 1, TRUE),
(2, 'Phòng Khách', 'phong-khach', NULL, 'Danh mục phòng khách', 2, TRUE),
(3, 'Phòng Bếp', 'phong-bep', NULL, 'Danh mục phòng bếp', 3, TRUE);

-- Products
INSERT INTO products (id, category_id, sku, slug, name, summary, description, price, currency, main_image, is_active, hidden)
VALUES
(1, 1, 'G01', 'giuong-oc-cho-g01', 'Giường Óc Chó - G01', 'Giường óc chó sang trọng', 'Mô tả chi tiết Giường Óc Chó - G01', 11000000.00, 'VND', '/src/assets/img/rooms/1.jpg', TRUE, FALSE),
(2, 1, 'G02', 'giuong-oc-cho-g02', 'Giường Óc Chó - G02', 'Giường óc chó mẫu 2', 'Mô tả chi tiết G02', 10700000.00, 'VND', '/src/assets/img/rooms/2.jpg', TRUE, FALSE),
(3, 1, 'G03', 'giuong-oc-cho-g03', 'Giường Óc Chó - G03', 'Giường cao cấp', 'Mô tả chi tiết G03', 25000000.00, 'VND', '/src/assets/img/rooms/3.jpg', TRUE, FALSE),
(4, 2, 'T01', 'tu-oc-cho-t01', 'Tủ Óc Chó - T01', 'Tủ gỗ óc chó', 'Mô tả T01', 15000000.00, 'VND', '/src/assets/img/rooms/7.png', TRUE, FALSE);

-- Product images
INSERT INTO product_images (product_id, image_url, caption, sort_order)
VALUES
(1, '/src/assets/img/rooms/1.jpg', 'Giường G01', 1),
(2, '/src/assets/img/rooms/2.jpg', 'Giường G02', 1),
(3, '/src/assets/img/rooms/3.jpg', 'Giường G03', 1),
(4, '/src/assets/img/rooms/7.png', 'Tủ T01', 1);

-- News (matching model in generated client)
INSERT INTO news (id, news_id, title, summary, content, news_image, category_id, tags, hidden, del_flag, created_user, created_date, updated_user, updated_date)
VALUES
(1, 'news-001', 'Showroom nội thất gỗ óc chó đẳng cấp tại Hà Nội', 'Showroom mới của D&L Furniture tại Hà Nội', 'Nội dung bài viết về showroom...', '/src/assets/img/news/1.jpg', 2, 'Restaurant,Hotel', FALSE, FALSE, 'admin', NOW(), 'admin', NOW()),
(2, 'news-002', 'Mẫu thiết kế phòng ngủ đẹp như mơ', 'Ý tưởng thiết kế phòng ngủ', 'Nội dung bài viết về phòng ngủ...', '/src/assets/img/news/2.jpg', 1, 'Spa,Hotel', FALSE, FALSE, 'editor', NOW(), 'editor', NOW());


-- Projects
INSERT INTO projects (id, title, subtitle, client_name, location, category_id, description, cover_image, status)
VALUES
(1, 'Thiết kế nội thất Saroma Villa', 'Villa cao cấp', 'Anh Tuấn', 'Thủ Thiêm', NULL, 'Thiết kế trọn gói Saroma Villa', '/src/assets/img/slider/4.jpg', 'published'),
(2, 'Thiết kế nội thất biệt thự Vinhomes', 'Biệt thự Vinhomes Grand Park', 'Anh Cường', 'Quận 9', NULL, 'Thiết kế và thi công biệt thự', '/src/assets/img/slider/3.jpg', 'published');

-- Project images
INSERT INTO project_images (project_id, image_url, caption, sort_order)
VALUES
(1, '/src/assets/img/slider/4.jpg', 'Saroma Villa', 1),
(2, '/src/assets/img/slider/3.jpg', 'Vinhomes Grand Park', 1);

-- Services (from PricingComponent)
INSERT INTO services (title, description, image_url, display_order, is_active)
VALUES
('Nội thất biệt thự', 'Kiến tạo nên tính thẩm mỹ cá tính với đa phong cách thiết kế', '/src/assets/img/pricing/1.jpg', 1, TRUE),
('Nội thất chung cư', 'Chuyên thiết kế nội thất chung cư trọn gói', '/src/assets/img/pricing/2.jpg', 2, TRUE),
('Nội thất văn phòng', 'Cung cấp mẫu thiết kế nội thất văn phòng', '/src/assets/img/pricing/3.jpg', 3, TRUE),
('Showroom & Trung tâm', 'Xây dựng không gian theo concept riêng', '/src/assets/img/pricing/4.jpg', 4, TRUE);

-- Facilities (from FaciltiesComponent)
INSERT INTO facilities (title, description, icon_class, display_order, is_active)
VALUES
('Đội ngũ chuyên nghiệp', 'Đội ngũ kiến trúc sư trẻ năng động', 'flaticon-world', 1, TRUE),
('Cập nhật xu hướng', 'Cập nhật xu hướng mới nhất', 'flaticon-car', 2, TRUE),
('Giám sát tiến độ', 'Giám sát tiến độ chính xác', 'flaticon-bed', 3, TRUE);

-- Team members
INSERT INTO team_members (name, role, email, image_url, instagram, twitter, facebook, pinterest, bio, display_order, is_active)
VALUES
('Valentina Karla', 'General Manager', 'valentina@hotel.com', '/src/assets/img/team/4.jpg', '#', '#', '#', '#', 'Giám đốc', 1, TRUE),
('Micheal White', 'Guest Service Department', 'micheal@hotel.com', '/src/assets/img/team/1.jpg', '#', '#', '#', '#', 'Trưởng bộ phận dịch vụ', 2, TRUE),
('Olivia Martin', 'Reservations Manager', 'olivia@hotel.com', '/src/assets/img/team/2.jpg', '#', '#', '#', '#', 'Quản lý đặt phòng', 3, TRUE);

-- Testimonials
INSERT INTO testimonials (author_name, location, content, rating, image_url, is_active)
VALUES
('Chị Nguyễn Thị Thuỳ Linh', 'Hồ Chí Minh', 'Tôi rất ấn tượng với các dịch vụ và sản phẩm của D&L Furniture...', 5, '/src/assets/img/team/4.jpg', TRUE),
('Anh Nguyễn Hùng Cường', 'Hà Nội', 'Sản phẩm luôn mang giá trị thẩm mỹ rất cao...', 5, '/src/assets/img/team/1.jpg', TRUE);

-- Clients
INSERT INTO clients (name, logo_url, website_url, display_order, is_active)
VALUES
('Client A', '/src/assets/img/clients/1.png', '#', 1, TRUE),
('Client B', '/src/assets/img/clients/2.png', '#', 2, TRUE);

-- Sliders
INSERT INTO sliders (title, subtitle, background_image_url, button_text, button_link, display_order, is_active)
VALUES
('Trải nghiệm sống đích thực', 'Không gian tiện nghi đẳng cấp', 'https://dl-furniture.netlify.app/assets/1-b3ntw45g.jpg', 'Khám phá ngay', '#', 1, TRUE),
('Phong cách thiết kế đa dạng', 'Thiết kế & thi công', 'https://dl-furniture.netlify.app/assets/2-bupjuqqy.png', 'Khám phá ngay', '#', 2, TRUE);

-- Site settings
INSERT INTO site_settings (key_name, value_text)
VALUES
('company_name', 'D&L Furniture'),
('phone', '(+84) 961-109-897'),
('email', 'info@dl-furniture.com');

-- Sample contact message
INSERT INTO contact_messages (name, email, phone, subject, message, source, status, created_at)
VALUES
('Nguyen Van A', 'a@example.com', '0901234567', 'Tư vấn thiết kế', 'Xin tư vấn thiết kế phòng khách 30m2', 'contact_form', 'new', NOW());

-- Sample booking request
INSERT INTO booking_requests (full_name, email, phone, message, checkin_date, checkout_date, adults, children, source, status)
VALUES
('Tran Thi B', 'b@example.com', '0912345678', 'Tôi muốn tư vấn nội thất chung cư', NULL, NULL, NULL, NULL, 'booking_form', 'pending');
