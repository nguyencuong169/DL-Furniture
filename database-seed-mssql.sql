-- Seed data for SQL Server (T-SQL)
-- Assumes `database-schema-mssql.sql` has been run against the target database.

-- Categories (explicit IDs using IDENTITY_INSERT)
SET IDENTITY_INSERT categories ON;
INSERT INTO categories (id, name, slug, parent_id, description, display_order, is_active)
VALUES (1, N'Phòng Ngủ', N'phong-ngu', NULL, N'Danh mục phòng ngủ', 1, 1),
       (2, N'Phòng Khách', N'phong-khach', NULL, N'Danh mục phòng khách', 2, 1),
       (3, N'Phòng Bếp', N'phong-bep', NULL, N'Danh mục phòng bếp', 3, 1);
SET IDENTITY_INSERT categories OFF;

-- News categories are intentionally separate from product/project categories.
SET IDENTITY_INSERT news_categories ON;
INSERT INTO news_categories (id, name, slug, display_order, is_active)
VALUES (1, N'Tin tức gỗ óc chó', N'go-oc-cho', 1, 1),
       (2, N'Khai trương', N'khai-truong', 2, 1),
       (3, N'Hoàn thiện công trình', N'hoan-thien-cong-trinh', 3, 1),
       (4, N'Chia sẻ chuyên môn', N'chia-se-chuyen-mon', 4, 1),
       (5, N'Sự kiện', N'su-kien', 5, 1);
SET IDENTITY_INSERT news_categories OFF;

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
INSERT INTO news (id, news_id, title, summary, content, news_image, news_category_id, tags, hidden, del_flag, created_user, created_date, updated_user, updated_date)
VALUES (1, N'news-001', N'Showroom nội thất gỗ óc chó đẳng cấp tại Hà Nội', N'Showroom mới của D&L Furniture tại Hà Nội', N'Nội dung bài viết về showroom...', N'/src/assets/img/news/1.jpg', 2, N'Showroom,Gỗ óc chó', 0, 0, N'admin', GETDATE(), N'admin', GETDATE()),
       (2, N'news-002', N'Mẫu thiết kế phòng ngủ đẹp như mơ', N'Ý tưởng thiết kế phòng ngủ', N'Nội dung bài viết về phòng ngủ...', N'/src/assets/img/news/2.jpg', 4, N'Phòng ngủ,Thiết kế', 0, 0, N'editor', GETDATE(), N'editor', GETDATE());
SET IDENTITY_INSERT news OFF;


-- Projects
SET IDENTITY_INSERT projects ON;
INSERT INTO projects (id, title, subtitle, client_name, location, category_id, description, cover_image, status)
VALUES (1, N'Thiết kế nội thất Saroma Villa', N'Villa cao cấp', N'Anh Tuấn', N'Thủ Thiêm', NULL, N'Thiết kế trọn gói Saroma Villa', N'/src/assets/img/slider/4.jpg', N'published'),
       (2, N'Thiết kế nội thất biệt thự Vinhomes Grand Park', N'Biệt thự Vinhomes Grand Park', N'Anh Cường', N'Quận 9', NULL, N'Thiết kế và thi công biệt thự', N'/src/assets/img/slider/3.jpg', N'published');
SET IDENTITY_INSERT projects OFF;

INSERT INTO projects (title, subtitle, client_name, location, category_id, description, cover_image, status)
VALUES (N'Thiết kế nội thất biệt thự KĐT Vĩnh Yên', N'Villa cao cấp', N'Chị Hằng', N'Vĩnh Yên', NULL, N'Thiết kế và thi công biệt thự KĐT Vĩnh Yên', N'/src/assets/img/slider/3.jpg', N'published'),
       (N'Thiết kế nội thất căn hộ Vinhomes Metropolis', N'Căn hộ cao cấp', N'Chị Nguyệt', N'Liễu Giai', NULL, N'Thiết kế và thi công căn hộ Vinhomes Metropolis', N'/src/assets/img/slider/2.jpg', N'published');

-- Project images
INSERT INTO project_images (project_id, image_url, caption, sort_order)
VALUES (1, N'/src/assets/img/slider/4.jpg', N'Saroma Villa', 1),
       (2, N'/src/assets/img/slider/3.jpg', N'Vinhomes Grand Park', 1);

-- Gallery categories
SET IDENTITY_INSERT gallery_categories ON;
INSERT INTO gallery_categories (id, name, slug, display_order, is_active)
VALUES (1, N'Phòng khách', N'phong-khach', 1, 1),
       (2, N'Phòng bếp', N'phong-bep', 2, 1),
       (3, N'Phòng ngủ', N'phong-ngu', 3, 1),
       (4, N'Xưởng chế tác', N'xuong-che-tac', 4, 1),
       (5, N'Dự án', N'du-an', 5, 1),
       (6, N'Vật liệu', N'vat-lieu', 6, 1);
SET IDENTITY_INSERT gallery_categories OFF;

-- Gallery images and films
SET IDENTITY_INSERT gallery_items ON;
INSERT INTO gallery_items
    (id, category_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
VALUES
    (1, 1, N'Walnut Villa — Phòng khách nhiệt đới', N'Không gian sinh hoạt mở với sofa, bàn trà và ghế thư giãn chế tác từ gỗ óc chó.', N'image', N'/media/gallery/walnut-villa-living.webp', N'/media/gallery/walnut-villa-living.webp', N'Phòng khách biệt thự với bộ sofa gỗ óc chó và cửa kính nhìn ra vườn', N'local', NULL, 1, 1, 1),
    (2, 2, N'Bếp mở trong ánh sáng tự nhiên', N'Hệ tủ bếp và bàn ăn đồng bộ, cân bằng giữa vân gỗ ấm và đá tự nhiên.', N'image', N'/media/gallery/walnut-villa-kitchen.webp', N'/media/gallery/walnut-villa-kitchen.webp', N'Bếp biệt thự với tủ gỗ óc chó, đảo đá và bàn ăn sáu ghế', N'local', NULL, 1, 2, 1),
    (3, 3, N'Phòng ngủ Walnut Suite', N'Bảng màu trầm, hệ giường liền bàn và ánh sáng điểm tạo cảm giác riêng tư.', N'image', N'/media/gallery/walnut-suite.jpg', N'/media/gallery/walnut-suite.jpg', N'Phòng ngủ tông trầm với giường và bàn làm việc gỗ óc chó', N'local', NULL, 0, 3, 1),
    (4, 4, N'Điểm chạm thủ công', N'Từng đường cong của ghế được hoàn thiện bằng tay để giữ trọn biểu cảm của gỗ.', N'image', N'/media/gallery/artisan-walnut-chair.webp', N'/media/gallery/artisan-walnut-chair.webp', N'Nghệ nhân bào thủ công một chi tiết ghế bằng gỗ óc chó', N'local', NULL, 0, 4, 1),
    (5, 1, N'Sảnh nghỉ tĩnh lặng', N'Đường nét Á Đông tối giản kết hợp bề mặt gỗ tự nhiên và vật liệu đan.', N'image', N'/media/gallery/quiet-lounge.jpg', N'/media/gallery/quiet-lounge.jpg', N'Sảnh nghỉ tối giản với tủ console gỗ và mảng trang trí thủ công', N'local', NULL, 0, 5, 1),
    (6, 2, N'Dining Hall — Ánh sáng và chất liệu', N'Không gian bàn ăn dài với nhịp vòm, ánh sáng ấm và bảng màu đất.', N'image', N'/media/gallery/arched-dining.jpg', N'/media/gallery/arched-dining.jpg', N'Không gian bàn ăn dài dưới trần vòm với đèn thủ công', N'local', NULL, 0, 6, 1),
    (7, 4, N'The Art of Furniture Making', N'Một góc nhìn sâu vào quá trình biến vật liệu thô thành đồ nội thất có tuổi thọ lâu dài.', N'video', N'https://vimeo.com/573906036', N'/media/gallery/artisan-walnut-chair.webp', N'Video về nghệ thuật chế tác nội thất thủ công', N'vimeo', N'04:18', 1, 7, 1),
    (8, 4, N'Nghệ thuật của kỹ thuật ghép mộng', N'Theo dõi cách người thợ kết nối thẩm mỹ, độ chính xác và độ bền trong từng mối ghép.', N'video', N'https://vimeo.com/174156297', N'/media/gallery/walnut-villa-kitchen.webp', N'Video về nghệ thuật ghép mộng trong nội thất gỗ', N'vimeo', N'02:42', 0, 8, 1),
    (9, 5, N'Từ nhà thiết kế đến người hoàn thiện', N'Hành trình hợp tác giữa thiết kế, chế tác và hoàn thiện một món đồ nội thất độc bản.', N'video', N'https://vimeo.com/82229898', N'/media/gallery/walnut-villa-living.webp', N'Video về quy trình thiết kế và hoàn thiện nội thất', N'vimeo', N'06:34', 0, 9, 1),
    (10, 6, N'Di sản của gỗ óc chó', N'Câu chuyện vật liệu, tỷ lệ và ngôn ngữ thiết kế làm nên sức sống bền bỉ của walnut.', N'video', N'https://vimeo.com/340431711', N'/media/gallery/walnut-suite.jpg', N'Video kể câu chuyện về nội thất gỗ óc chó', N'vimeo', N'03:56', 0, 10, 1);
SET IDENTITY_INSERT gallery_items OFF;

INSERT INTO gallery_items
    (category_id, project_id, title, description, media_type, media_url, thumbnail_url, alt_text, provider, duration, is_featured, display_order, is_active)
VALUES
    (1, 1, N'Thư phòng Walnut Library', N'Hệ tủ sách cao kịch trần, bàn làm việc điêu khắc và ghế da trong ánh sáng dịu.', N'image', N'/media/gallery/walnut-home-library.webp', N'/media/gallery/walnut-home-library.webp', N'Thư phòng biệt thự với hệ tủ sách gỗ óc chó và bàn làm việc', N'local', NULL, 1, 11, 1),
    (5, 1, N'Phòng tắm Walnut & Limestone', N'Gỗ óc chó, đá limestone và ánh sáng gián tiếp tạo nên nhịp nghỉ thư thái.', N'image', N'/media/gallery/walnut-stone-bathroom.webp', N'/media/gallery/walnut-stone-bathroom.webp', N'Phòng tắm cao cấp với tủ lavabo gỗ óc chó và bồn tắm đá', N'local', NULL, 1, 12, 1),
    (4, NULL, N'Mối ghép lưu dấu bàn tay', N'Chi tiết mộng gỗ được căn chỉnh và hoàn thiện thủ công tại xưởng.', N'image', N'/media/gallery/walnut-joinery-detail.webp', N'/media/gallery/walnut-joinery-detail.webp', N'Đôi tay người thợ đang hoàn thiện mối ghép gỗ óc chó', N'local', NULL, 0, 13, 1),
    (6, 3, N'Bức tường nghệ thuật trong ánh nắng sớm', N'Một khoảng chuyển tiếp được tiết chế bằng tranh sơn mài, bình gốm và gỗ tối màu.', N'image', N'/media/gallery/villa-art-wall.webp', N'/media/gallery/villa-art-wall.webp', N'Bức tường nghệ thuật và tủ gỗ trong không gian biệt thự', N'local', NULL, 0, 14, 1),
    (3, 2, N'Phòng ngủ sắc đất', N'Bảng màu nâu đất, vải dệt thô và bề mặt gỗ tạo cảm giác ấm, sâu và yên tĩnh.', N'image', N'/media/gallery/villa-bedroom-earth.webp', N'/media/gallery/villa-bedroom-earth.webp', N'Phòng ngủ biệt thự mang bảng màu nâu đất', N'local', NULL, 0, 15, 1),
    (3, 2, N'Bedroom Lounge — Khoảng nghỉ riêng', N'Khu ngồi thư giãn được nối liền với phòng ngủ bằng cùng một ngôn ngữ vật liệu.', N'image', N'/media/gallery/villa-bedroom-lounge.webp', N'/media/gallery/villa-bedroom-lounge.webp', N'Phòng ngủ có khu ghế nghỉ và cửa kính lớn', N'local', NULL, 0, 16, 1),
    (3, 4, N'Góc làm việc trong phòng ngủ', N'Bàn viết gọn, ánh sáng tập trung và hệ tủ liền khối cho căn hộ đô thị.', N'image', N'/media/gallery/villa-bedroom-desk.webp', N'/media/gallery/villa-bedroom-desk.webp', N'Góc làm việc bằng gỗ trong phòng ngủ căn hộ', N'local', NULL, 0, 17, 1),
    (2, 4, N'Bếp gỗ và mây đan', N'Các bề mặt cứng được làm mềm bằng cánh tủ mây đan và sắc gỗ tự nhiên.', N'image', N'/media/gallery/villa-kitchen-rattan.webp', N'/media/gallery/villa-kitchen-rattan.webp', N'Tủ bếp gỗ kết hợp cánh mây đan', N'local', NULL, 0, 18, 1),
    (6, 4, N'Vanity Stone — Đá và gỗ', N'Bàn lavabo gỗ đặt trong lớp nền đá sáng, giữ tinh thần tối giản và sang trọng.', N'image', N'/media/gallery/villa-vanity-stone.webp', N'/media/gallery/villa-vanity-stone.webp', N'Bàn lavabo gỗ trong phòng tắm ốp đá sáng', N'local', NULL, 0, 19, 1),
    (4, NULL, N'Thiết kế ghế như một tác phẩm', N'Từ phác thảo, tạo dáng đến bọc hoàn thiện một mẫu ghế có cá tính riêng.', N'video', N'https://vimeo.com/213826087', N'/media/gallery/villa-bedroom-lounge.webp', N'Video về thiết kế và chế tác ghế thủ công', N'vimeo', N'03:28', 0, 20, 1),
    (4, NULL, N'Process — Nhịp điệu của người thợ', N'Một thước phim chậm về triết lý, độ chính xác và niềm vui trong nghề mộc.', N'video', N'https://vimeo.com/247657353', N'/media/gallery/walnut-joinery-detail.webp', N'Video ghi lại quy trình làm đồ gỗ thủ công', N'vimeo', N'05:12', 1, 21, 1),
    (6, 2, N'Biểu tượng ghế trong không gian sống', N'Hình khối, vật liệu và tỷ lệ biến một chiếc ghế thành điểm nhấn của căn phòng.', N'video', N'https://vimeo.com/748153633', N'/media/gallery/walnut-home-library.webp', N'Video giới thiệu thiết kế ghế mang tính biểu tượng', N'vimeo', N'01:46', 0, 22, 1),
    (5, 4, N'Không gian linh hoạt cho căn hộ đô thị', N'Cách tư duy nội thất thông minh giúp một diện tích gọn vẫn giàu trải nghiệm.', N'video', N'https://vimeo.com/383115350', N'/media/gallery/villa-bedroom-desk.webp', N'Video về giải pháp nội thất linh hoạt cho căn hộ', N'vimeo', N'03:08', 0, 23, 1);

UPDATE gallery_items
SET project_id = CASE id
    WHEN 1 THEN 1 WHEN 2 THEN 1 WHEN 3 THEN 2 WHEN 5 THEN 3 WHEN 6 THEN 3 WHEN 9 THEN 1
    ELSE project_id
END
WHERE id IN (1, 2, 3, 5, 6, 9);

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
