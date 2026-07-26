SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRANSACTION;

    DECLARE @categories TABLE (
        name          NVARCHAR(255) NOT NULL,
        slug          NVARCHAR(255) NOT NULL,
        display_order INT           NOT NULL
    );

    INSERT INTO @categories (name, slug, display_order)
    VALUES
        (N'Tin tức gỗ óc chó',      N'go-oc-cho',                1),
        (N'Khai trương',            N'khai-truong',              2),
        (N'Hoàn thiện công trình',  N'hoan-thien-cong-trinh',    3),
        (N'Chia sẻ chuyên môn',     N'chia-se-chuyen-mon',       4),
        (N'Sự kiện',                N'su-kien',                   5);

    UPDATE target
    SET target.name = source.name,
        target.display_order = source.display_order,
        target.is_active = 1,
        target.updated_at = SYSUTCDATETIME()
    FROM dbo.news_categories AS target
    INNER JOIN @categories AS source ON source.slug = target.slug;

    INSERT INTO dbo.news_categories (
        name,
        slug,
        display_order,
        is_active,
        created_at,
        updated_at
    )
    SELECT source.name,
           source.slug,
           source.display_order,
           1,
           SYSUTCDATETIME(),
           SYSUTCDATETIME()
    FROM @categories AS source
    WHERE NOT EXISTS (
        SELECT 1
        FROM dbo.news_categories AS target
        WHERE target.slug = source.slug
    );

    -- Chỉ xóa dữ liệu do các script seed của dự án tạo ra.
    DELETE FROM dbo.news
    WHERE news_id LIKE N'GEN-%'
       OR news_id LIKE N'WALNUT-%'
       OR news_id IN (N'news-001', N'news-002');

    DECLARE @curated_news TABLE (
        news_id       NVARCHAR(255)  NOT NULL,
        title         NVARCHAR(255)  NOT NULL,
        summary       NVARCHAR(MAX)  NOT NULL,
        content       NVARCHAR(MAX)  NOT NULL,
        news_image    NVARCHAR(1024) NOT NULL,
        category_slug NVARCHAR(255)  NOT NULL,
        tags          NVARCHAR(MAX)  NOT NULL,
        publish_date  DATETIME2      NOT NULL
    );

    INSERT INTO @curated_news (
        news_id,
        title,
        summary,
        content,
        news_image,
        category_slug,
        tags,
        publish_date
    )
    VALUES
        (
            N'WALNUT-2026-001',
            N'Xu hướng nội thất gỗ óc chó 2026: Ấm áp, tinh giản và bền vững',
            N'Không gian năm 2026 ưu tiên đường nét gọn, bảng màu ấm và các chi tiết gỗ óc chó được sử dụng có chủ đích.',
            N'Gỗ óc chó tiếp tục được ưa chuộng nhờ sắc nâu trầm, hệ vân tự nhiên và khả năng kết hợp với nhiều vật liệu. Thay vì phủ kín không gian, xu hướng mới dùng gỗ tại các điểm nhấn như vách tivi, bàn ăn và hệ tủ may đo để giữ sự thoáng đãng. Thiết kế bền vững cũng chú trọng kết cấu dễ bảo trì và hoàn thiện bề mặt an toàn cho gia đình.',
            N'/src/assets/img/news/1.jpg',
            N'go-oc-cho',
            N'gỗ-óc-chó,xu-hướng-2026,nội-thất',
            '2026-07-22T09:00:00'
        ),
        (
            N'WALNUT-2026-002',
            N'Cách nhận biết gỗ óc chó Bắc Mỹ đạt chuẩn',
            N'Những dấu hiệu quan trọng giúp phân biệt gỗ óc chó đúng chủng loại trước khi đặt đóng nội thất.',
            N'Gỗ óc chó Bắc Mỹ thường có phần dát gỗ sáng, tâm gỗ nâu socola và đường vân chuyển động mềm mại. Khi kiểm tra vật liệu, cần quan sát cả mặt cắt, độ đồng đều sau sấy và hồ sơ nguồn gốc thay vì chỉ nhìn màu sơn bề mặt. Một mẫu gỗ đạt chuẩn phải ổn định độ ẩm và không có dấu hiệu cong vênh hoặc nứt đầu thanh.',
            N'/src/assets/img/news/2.jpg',
            N'chia-se-chuyen-mon',
            N'gỗ-óc-chó,vật-liệu,kinh-nghiệm',
            '2026-07-10T10:30:00'
        ),
        (
            N'WALNUT-2026-003',
            N'Hoàn thiện biệt thự Ecopark với nội thất gỗ óc chó đồng bộ',
            N'Công trình sử dụng gỗ óc chó xuyên suốt phòng khách, phòng ăn và phòng ngủ nhưng vẫn giữ được sự nhẹ nhàng.',
            N'Đội ngũ thiết kế lựa chọn cùng một tông màu hoàn thiện cho các khu vực chính để tạo mạch không gian thống nhất. Mỗi phòng được điều chỉnh tỷ lệ gỗ, đá và vải khác nhau nhằm tránh cảm giác nặng nề. Hệ tủ và vách trang trí được sản xuất theo kích thước thực tế, giúp các chi tiết tiếp giáp gọn và thuận tiện sử dụng.',
            N'/src/assets/img/news/3.jpg',
            N'hoan-thien-cong-trinh',
            N'biệt-thự,ecopark,gỗ-óc-chó',
            '2026-06-25T08:15:00'
        ),
        (
            N'WALNUT-2026-004',
            N'Phối gỗ óc chó với đá tự nhiên trong phòng bếp',
            N'Cách cân bằng sắc nâu của gỗ với bề mặt đá để căn bếp sang trọng mà không tối.',
            N'Đá sáng màu có vân nhẹ giúp làm nổi bật sắc nâu của cánh tủ gỗ óc chó và tăng độ thoáng cho khu bếp. Với đảo bếp lớn, có thể dùng đá tối hơn ở mặt bàn nhưng cần bổ sung ánh sáng hắt dưới tủ. Các vị trí gần chậu rửa nên ưu tiên veneer hoặc gỗ đã xử lý kỹ, đồng thời thiết kế khe thoáng để hạn chế tích tụ độ ẩm.',
            N'/src/assets/img/news/4.jpg',
            N'chia-se-chuyen-mon',
            N'phòng-bếp,đá-tự-nhiên,phối-màu',
            '2026-06-08T14:00:00'
        ),
        (
            N'WALNUT-2026-005',
            N'Bộ sưu tập bàn ăn gỗ óc chó cạnh cong tự nhiên',
            N'Các mẫu bàn ăn mới khai thác đường cong mềm và vẻ đẹp nguyên bản của hệ vân gỗ óc chó.',
            N'Bộ sưu tập tập trung vào mặt bàn bo cong, chân bàn thanh thoát và tỷ lệ phù hợp với căn hộ hiện đại. Bề mặt được hoàn thiện mờ để giữ cảm giác tự nhiên khi chạm và hạn chế lộ vết xước nhỏ. Khách hàng có thể lựa chọn kích thước từ sáu đến mười ghế cùng nhiều phương án ghế bọc da hoặc vải.',
            N'/src/assets/img/news/5.jpg',
            N'go-oc-cho',
            N'bàn-ăn,bộ-sưu-tập,gỗ-óc-chó',
            '2026-05-21T09:45:00'
        ),
        (
            N'WALNUT-2026-006',
            N'Bàn giao căn hộ Westlake với hệ tủ óc chó may đo',
            N'Hệ tủ âm tường giúp căn hộ tận dụng diện tích mà vẫn giữ được vẻ liền mạch và ấm áp.',
            N'Công trình được khảo sát kỹ các góc tường và đường kỹ thuật trước khi sản xuất để giảm sai số khi lắp đặt. Hệ tủ gỗ óc chó tích hợp lưu trữ, bàn làm việc và khu trưng bày trong cùng một mặt đứng. Tay nắm âm cùng bản lề giảm chấn giúp tổng thể gọn hơn và phù hợp với nhịp sống hằng ngày của gia đình.',
            N'/src/assets/img/news/6.jpg',
            N'hoan-thien-cong-trinh',
            N'căn-hộ,westlake,tủ-may-đo',
            '2026-05-06T16:20:00'
        ),
        (
            N'WALNUT-2026-007',
            N'7 nguyên tắc bảo quản nội thất gỗ óc chó mùa nồm',
            N'Kiểm soát độ ẩm và vệ sinh đúng cách giúp bề mặt gỗ ổn định trong thời tiết nồm ẩm miền Bắc.',
            N'Gia đình nên duy trì thông gió, sử dụng máy hút ẩm khi cần và tránh đặt đồ gỗ sát khu vực thường xuyên đọng nước. Bề mặt chỉ nên lau bằng khăn mềm đã vắt khô, sau đó làm khô ngay bằng khăn sạch. Không tự ý dùng hóa chất tẩy mạnh hoặc dầu bóng không rõ thành phần vì có thể làm thay đổi lớp hoàn thiện.',
            N'/src/assets/img/news/2.jpg',
            N'chia-se-chuyen-mon',
            N'bảo-quản,mùa-nồm,gỗ-óc-chó',
            '2026-04-18T11:00:00'
        ),
        (
            N'WALNUT-2026-008',
            N'D&L Furniture tham gia Tuần lễ Thiết kế Nội thất Hà Nội 2026',
            N'Không gian trưng bày giới thiệu quy trình lựa chọn vật liệu và hoàn thiện nội thất gỗ óc chó.',
            N'Tại sự kiện, D&L Furniture mang đến các mẫu vật liệu theo từng công đoạn từ gỗ thô đến bề mặt hoàn thiện. Khách tham quan có thể so sánh màu sắc, cảm giác chạm và cách gỗ óc chó kết hợp với da, kim loại và đá. Đội ngũ kiến trúc sư cũng chia sẻ kinh nghiệm ứng dụng vật liệu trong căn hộ và biệt thự.',
            N'/src/assets/img/news/1.jpg',
            N'su-kien',
            N'sự-kiện,thiết-kế,Hà-Nội',
            '2026-04-02T13:30:00'
        ),
        (
            N'WALNUT-2026-009',
            N'Thiết kế phòng ngủ gỗ óc chó cho không gian 18 m²',
            N'Bố trí giường, tủ và ánh sáng hợp lý giúp phòng ngủ nhỏ vẫn thoáng và đầy đủ tiện nghi.',
            N'Với diện tích 18 m², hệ giường và tab đầu giường nên có tỷ lệ gọn, tránh các chi tiết trang trí quá dày. Tủ quần áo cao sát trần tăng không gian lưu trữ trong khi cánh phẳng giữ mặt đứng sạch. Gỗ óc chó được dùng tại đầu giường và tay nắm để tạo điểm nhấn, kết hợp màu tường sáng nhằm cân bằng thị giác.',
            N'/src/assets/img/news/2.jpg',
            N'go-oc-cho',
            N'phòng-ngủ,không-gian-nhỏ,gỗ-óc-chó',
            '2026-03-20T09:10:00'
        ),
        (
            N'WALNUT-2026-010',
            N'Hoàn thiện showroom thời trang với quầy trưng bày óc chó',
            N'Gỗ óc chó tạo nền ấm cho sản phẩm thời trang và giúp không gian bán lẻ có bản sắc riêng.',
            N'Quầy thu ngân, kệ trưng bày và các hốc thử đồ được thiết kế theo cùng một ngôn ngữ vật liệu. Ánh sáng tập trung vào sản phẩm trong khi bề mặt gỗ hoàn thiện mờ hạn chế phản xạ gây chói. Toàn bộ module được gia công rời để thuận tiện bảo trì và thay đổi cách trưng bày sau này.',
            N'/src/assets/img/news/3.jpg',
            N'hoan-thien-cong-trinh',
            N'showroom,thời-trang,thi-công',
            '2026-03-05T15:40:00'
        ),
        (
            N'WALNUT-2026-011',
            N'Chọn màu da ghế phù hợp với sofa khung gỗ óc chó',
            N'Bảng màu da trung tính giúp làm nổi bật đường vân gỗ và dễ phối với tổng thể phòng khách.',
            N'Da màu kem tạo cảm giác nhẹ và hợp với căn hộ có nhiều ánh sáng, trong khi nâu cognac mang lại vẻ ấm áp cổ điển. Với không gian hiện đại, màu ghi ấm hoặc xanh olive là lựa chọn có chiều sâu nhưng không lấn át phần khung gỗ. Trước khi đặt sản xuất, nên xem mẫu da cạnh mẫu gỗ dưới đúng điều kiện ánh sáng của căn phòng.',
            N'/src/assets/img/news/4.jpg',
            N'chia-se-chuyen-mon',
            N'sofa,da-bọc,phối-màu',
            '2026-02-19T10:00:00'
        ),
        (
            N'WALNUT-2026-012',
            N'Khai trương khu trải nghiệm vật liệu gỗ óc chó tại Hà Nội',
            N'Khu trải nghiệm mới cho phép khách hàng xem trực tiếp mẫu gỗ, bề mặt sơn và phụ kiện nội thất.',
            N'Không gian được tổ chức như một thư viện vật liệu với các mẫu gỗ óc chó theo quy cách và tông màu khác nhau. Khách hàng có thể đặt mẫu cạnh đá, da và kim loại để hình dung phương án phối hợp trước khi chốt thiết kế. Đội ngũ tư vấn sẽ hỗ trợ lựa chọn giải pháp phù hợp ngân sách và nhu cầu sử dụng.',
            N'/src/assets/img/news/1.jpg',
            N'khai-truong',
            N'khai-trương,showroom,vật-liệu',
            '2026-02-03T08:30:00'
        ),
        (
            N'WALNUT-2026-013',
            N'Gỗ óc chó trong căn hộ phong cách Japandi',
            N'Sắc gỗ trầm kết hợp tinh thần tối giản Nhật Bản tạo nên không gian yên tĩnh và gần gũi.',
            N'Phong cách Japandi đề cao công năng, vật liệu tự nhiên và khoảng trống có chủ đích. Gỗ óc chó nên xuất hiện ở các món chính như bàn ăn, tủ thấp hoặc đầu giường, đi cùng tường màu be và vải thô sáng màu. Những đường bo nhẹ và bề mặt hoàn thiện mờ giúp tổng thể mềm mại hơn.',
            N'/src/assets/img/news/5.jpg',
            N'go-oc-cho',
            N'japandi,căn-hộ,gỗ-óc-chó',
            '2026-01-22T14:15:00'
        ),
        (
            N'WALNUT-2026-014',
            N'Bàn giao phòng khách óc chó tại Vinhomes Riverside',
            N'Phòng khách được hoàn thiện với vách tivi, sofa và bàn trà gỗ óc chó theo cùng tỷ lệ thiết kế.',
            N'Vách tivi sử dụng các mảng gỗ lớn xen kẽ đá sáng để tạo điểm nhìn nhưng không làm căn phòng nặng. Sofa được điều chỉnh chiều sâu ngồi theo thói quen của gia chủ và bố trí để giữ lối lưu thông rộng. Sau lắp đặt, đội ngũ kiểm tra độ phẳng, khe cánh và màu hoàn thiện trước khi bàn giao.',
            N'/src/assets/img/news/6.jpg',
            N'hoan-thien-cong-trinh',
            N'phòng-khách,vinhomes-riverside,bàn-giao',
            '2026-01-08T09:20:00'
        ),
        (
            N'WALNUT-2025-015',
            N'Quy trình 7 bước hoàn thiện bề mặt gỗ óc chó',
            N'Từ chà nhám đến phủ bảo vệ, mỗi công đoạn đều ảnh hưởng trực tiếp đến màu sắc và độ bền của sản phẩm.',
            N'Bề mặt gỗ được kiểm tra khuyết tật, chà nhám theo nhiều cấp độ và làm sạch bụi trước khi lên màu. Lớp sơn lót cần đủ thời gian ổn định trước khi chà tinh và phủ lớp bảo vệ cuối. Quy trình đúng giúp vân gỗ rõ, màu đồng đều và bề mặt dễ bảo dưỡng trong quá trình sử dụng.',
            N'/src/assets/img/news/2.jpg',
            N'chia-se-chuyen-mon',
            N'hoàn-thiện-bề-mặt,kỹ-thuật,gỗ-óc-chó',
            '2025-12-20T10:45:00'
        ),
        (
            N'WALNUT-2025-016',
            N'Bộ sưu tập giường ngủ gỗ óc chó đầu giường bọc da',
            N'Thiết kế kết hợp khung gỗ chắc chắn với đầu giường bọc da êm, phù hợp nhiều diện tích phòng ngủ.',
            N'Các mẫu giường sử dụng kết cấu âm để giữ hình khối gọn và hạn chế lộ phụ kiện. Phần đầu giường có nhiều lựa chọn da, chiều cao và đường may để phù hợp phong cách của từng không gian. Bề mặt gỗ hoàn thiện mờ giúp giữ sắc nâu tự nhiên và tạo cảm giác dễ chịu khi sử dụng lâu dài.',
            N'/src/assets/img/news/5.jpg',
            N'go-oc-cho',
            N'giường-ngủ,bộ-sưu-tập,da-bọc',
            '2025-12-05T09:00:00'
        ),
        (
            N'WALNUT-2025-017',
            N'Hoàn thiện penthouse với vách trang trí óc chó cao 6 mét',
            N'Giải pháp chia module và xử lý vân liên tục giúp mảng tường lớn giữ được tỷ lệ đẹp và an toàn.',
            N'Vách cao sáu mét được chia thành các module có hệ khung chịu lực riêng để thuận tiện vận chuyển và lắp đặt. Đội ngũ lựa chọn veneer cùng lô, ghép vân theo trục đứng nhằm tạo cảm giác liền mạch. Hệ đèn hắt được giấu trong khe kỹ thuật, giúp làm nổi chiều sâu của bề mặt gỗ vào buổi tối.',
            N'/src/assets/img/news/3.jpg',
            N'hoan-thien-cong-trinh',
            N'penthouse,vách-trang-trí,thi-công',
            '2025-11-18T13:00:00'
        ),
        (
            N'WALNUT-2025-018',
            N'Workshop nhận biết veneer óc chó và gỗ tự nhiên',
            N'Buổi chia sẻ giúp khách hàng hiểu điểm khác biệt về cấu tạo, ứng dụng và chi phí của hai vật liệu.',
            N'Người tham dự được quan sát mẫu mặt cắt, cách xử lý cạnh và các phương pháp hoàn thiện thường dùng. Chuyên gia giải thích vị trí phù hợp cho gỗ tự nhiên và veneer để tối ưu độ ổn định cũng như ngân sách. Phần thực hành tập trung vào cách kiểm tra chất lượng bề mặt và nhận biết lỗi sản xuất.',
            N'/src/assets/img/news/1.jpg',
            N'su-kien',
            N'workshop,veneer,vật-liệu',
            '2025-11-03T15:00:00'
        ),
        (
            N'WALNUT-2025-019',
            N'Giải pháp tủ bếp gỗ óc chó chống ẩm cho nhà Việt',
            N'Lựa chọn kết cấu thùng tủ, phụ kiện và thông gió đúng giúp căn bếp bền hơn trong khí hậu nóng ẩm.',
            N'Khu vực gần chậu rửa cần vật liệu lõi chịu ẩm, cạnh được dán kín và chân tủ có khoảng cách an toàn với sàn. Cánh gỗ óc chó hoặc veneer nên được hoàn thiện cả hai mặt để giảm chênh lệch hấp thụ ẩm. Khe thông gió cho máy rửa bát và thiết bị âm tủ cũng cần được tính từ giai đoạn thiết kế.',
            N'/src/assets/img/news/4.jpg',
            N'chia-se-chuyen-mon',
            N'tủ-bếp,chống-ẩm,nhà-Việt',
            '2025-10-16T09:30:00'
        ),
        (
            N'WALNUT-2025-020',
            N'Bàn giao phòng làm việc tại gia bằng gỗ óc chó',
            N'Không gian làm việc kết hợp bàn lớn, tủ sách và góc đọc trong một hệ nội thất thống nhất.',
            N'Bàn làm việc được đặt gần cửa sổ để tận dụng ánh sáng tự nhiên nhưng vẫn có rèm kiểm soát chói. Hệ tủ sách gỗ óc chó tích hợp đèn hắt và khoang kín để cân bằng trưng bày với lưu trữ. Các đường dây điện, mạng và sạc thiết bị được đi âm để mặt bàn luôn gọn.',
            N'/src/assets/img/news/6.jpg',
            N'hoan-thien-cong-trinh',
            N'phòng-làm-việc,tủ-sách,gỗ-óc-chó',
            '2025-09-27T11:20:00'
        ),
        (
            N'WALNUT-2025-021',
            N'Khai trương showroom D&L Furniture với không gian trải nghiệm mới',
            N'Showroom mới tái hiện các khu vực phòng khách, bếp và phòng ngủ bằng nội thất gỗ óc chó.',
            N'Không gian trưng bày được bố trí theo hành trình sử dụng thực tế để khách hàng dễ hình dung tỷ lệ và công năng sản phẩm. Mỗi khu vực giới thiệu một cách phối gỗ óc chó với đá, da, vải và ánh sáng khác nhau. Khu tư vấn vật liệu cho phép xem mẫu và trao đổi trực tiếp cùng kiến trúc sư.',
            N'/src/assets/img/news/1.jpg',
            N'khai-truong',
            N'khai-trương,showroom,D&L-Furniture',
            '2025-09-10T08:00:00'
        ),
        (
            N'WALNUT-2025-022',
            N'So sánh gỗ óc chó tự nhiên và veneer óc chó',
            N'Hai lựa chọn có ưu điểm riêng về kết cấu, thẩm mỹ và ngân sách khi ứng dụng trong nội thất.',
            N'Gỗ tự nhiên phù hợp với các chi tiết chịu lực hoặc cần tạo hình cạnh, trong khi veneer có lợi thế ở những mặt phẳng lớn và yêu cầu ổn định cao. Nếu được xử lý đúng, cả hai đều cho bề mặt vân đẹp và tuổi thọ tốt. Phương án hiệu quả thường kết hợp hai vật liệu theo đúng vị trí thay vì chỉ sử dụng một loại cho toàn bộ công trình.',
            N'/src/assets/img/news/2.jpg',
            N'chia-se-chuyen-mon',
            N'veneer,gỗ-tự-nhiên,so-sánh',
            '2025-08-22T14:10:00'
        ),
        (
            N'WALNUT-2025-023',
            N'Thiết kế cầu thang gỗ óc chó cho nhà phố hiện đại',
            N'Cầu thang có thể trở thành điểm nhấn khi tỷ lệ bậc, tay vịn và ánh sáng được xử lý đồng bộ.',
            N'Mặt bậc gỗ óc chó mang lại cảm giác chắc chắn và ấm hơn so với các vật liệu lạnh. Tay vịn nên được bo vừa tay, liên kết kín và có màu hoàn thiện đồng nhất với mặt bậc. Đèn dẫn hướng đặt thấp giúp tăng an toàn ban đêm đồng thời làm nổi đường vân gỗ.',
            N'/src/assets/img/news/5.jpg',
            N'go-oc-cho',
            N'cầu-thang,nhà-phố,thiết-kế',
            '2025-08-07T10:25:00'
        ),
        (
            N'WALNUT-2025-024',
            N'Hoàn thiện bộ bàn ăn 10 ghế cho biệt thự ngoại ô',
            N'Bộ bàn ăn kích thước lớn được tính toán kết cấu để giữ độ ổn định mà vẫn có hình dáng thanh thoát.',
            N'Mặt bàn được ghép chọn vân và gia cố bằng kết cấu ẩn để hạn chế biến dạng theo thời gian. Chân bàn lùi vào trong tạo khoảng để chân thoải mái cho mười vị trí ngồi. Ghế ăn có tựa cong theo lưng, kết hợp da màu be nhằm cân bằng sắc nâu đậm của gỗ.',
            N'/src/assets/img/news/3.jpg',
            N'hoan-thien-cong-trinh',
            N'bàn-ăn,biệt-thự,đóng-đồ',
            '2025-07-19T09:40:00'
        ),
        (
            N'WALNUT-2025-025',
            N'Ứng dụng ánh sáng để tôn vân gỗ óc chó',
            N'Nhiệt độ màu và góc chiếu phù hợp giúp bề mặt gỗ có chiều sâu mà không bị sai màu.',
            N'Ánh sáng ấm vừa phải thường phù hợp với gỗ óc chó, nhưng cần tránh nguồn sáng quá vàng làm mất sắc nâu tự nhiên. Đèn hắt nên đặt cách bề mặt đủ xa để vùng sáng đều và không lộ điểm LED. Với khu vực trưng bày, góc chiếu xiên nhẹ sẽ nhấn rõ cấu trúc vân hơn ánh sáng chiếu thẳng.',
            N'/src/assets/img/news/4.jpg',
            N'chia-se-chuyen-mon',
            N'ánh-sáng,vân-gỗ,thiết-kế',
            '2025-06-28T16:00:00'
        ),
        (
            N'WALNUT-2025-026',
            N'D&L Furniture đồng hành cùng triển lãm vật liệu nội thất 2025',
            N'Gian trưng bày giới thiệu các cách kết hợp gỗ óc chó với vật liệu hoàn thiện đương đại.',
            N'D&L Furniture mang tới bộ mẫu gỗ, veneer, da và đá được sắp xếp theo từng bảng phối hoàn chỉnh. Khách tham quan có thể trao đổi về độ bền, cách bảo quản và lựa chọn vật liệu theo ngân sách. Sự kiện cũng là dịp kết nối giữa kiến trúc sư, nhà sản xuất và khách hàng quan tâm tới nội thất may đo.',
            N'/src/assets/img/news/1.jpg',
            N'su-kien',
            N'triển-lãm,vật-liệu,nội-thất',
            '2025-06-11T13:15:00'
        ),
        (
            N'WALNUT-2025-027',
            N'Phòng thay đồ gỗ óc chó: Tối ưu lưu trữ và thông gió',
            N'Hệ tủ được phân khu theo thói quen sử dụng, đồng thời duy trì khoảng thoáng để bảo vệ quần áo và bề mặt gỗ.',
            N'Tủ cao sát trần giúp tận dụng thể tích phòng nhưng cần chia khoang hợp lý để dễ tiếp cận. Các cánh kính, ngăn kéo và khoang treo được bố trí theo tần suất sử dụng của gia chủ. Khe thông gió cùng đèn cảm biến bên trong giúp không gian khô thoáng và thuận tiện hơn.',
            N'/src/assets/img/news/6.jpg',
            N'go-oc-cho',
            N'phòng-thay-đồ,lưu-trữ,tủ-óc-chó',
            '2025-05-24T10:10:00'
        ),
        (
            N'WALNUT-2025-028',
            N'Bàn giao căn bếp gỗ óc chó kết hợp đảo đá quartz',
            N'Căn bếp cân bằng giữa bề mặt gỗ ấm, đảo đá sáng và hệ thiết bị âm tủ hiện đại.',
            N'Khu nấu, rửa và lưu trữ được tổ chức theo tam giác công năng để giảm quãng di chuyển. Đảo bếp đá quartz có phần bàn ăn nhanh, ổ cắm âm và khoang chứa đồ phía dưới. Cánh tủ gỗ óc chó hoàn thiện mờ, kết hợp tay nắm âm để giữ mặt đứng liền mạch.',
            N'/src/assets/img/news/4.jpg',
            N'hoan-thien-cong-trinh',
            N'căn-bếp,đảo-bếp,quartz',
            '2025-05-07T09:25:00'
        ),
        (
            N'WALNUT-2025-029',
            N'Khai trương xưởng hoàn thiện nội thất gỗ óc chó',
            N'Xưởng mới bổ sung khu kiểm soát độ ẩm, buồng sơn và dây chuyền lắp thử trước khi giao công trình.',
            N'Quy trình sản xuất được tổ chức theo từng khu vực từ tiếp nhận gỗ, gia công, chà nhám đến hoàn thiện bề mặt. Khu lắp thử giúp kiểm tra kích thước, khe cánh và phụ kiện trước khi vận chuyển tới công trình. Hệ thống hút bụi và kiểm soát độ ẩm góp phần duy trì chất lượng ổn định giữa các lô sản phẩm.',
            N'/src/assets/img/news/3.jpg',
            N'khai-truong',
            N'xưởng-sản-xuất,khai-trương,quy-trình',
            '2025-04-18T08:45:00'
        ),
        (
            N'WALNUT-2025-030',
            N'Vì sao gỗ óc chó phù hợp với khí hậu miền Bắc?',
            N'Vật liệu được sấy và hoàn thiện đúng quy trình có khả năng thích nghi tốt với biến động nhiệt độ, độ ẩm.',
            N'Độ ổn định của nội thất gỗ phụ thuộc lớn vào chất lượng sấy, kết cấu sản phẩm và cách hoàn thiện bề mặt. Gỗ óc chó có đặc tính cơ học tốt, nhưng vẫn cần được đưa về độ ẩm phù hợp trước khi gia công. Khi sử dụng, gia đình nên tránh nắng gắt trực tiếp, nước đọng và thay đổi độ ẩm quá đột ngột.',
            N'/src/assets/img/news/2.jpg',
            N'go-oc-cho',
            N'khí-hậu-miền-Bắc,độ-ẩm,gỗ-óc-chó',
            '2025-03-29T11:30:00'
        );

    IF (SELECT COUNT(*) FROM @curated_news) <> 30
        THROW 50001, N'Bộ dữ liệu tin tức gỗ óc chó phải có đúng 30 bài.', 1;

    INSERT INTO dbo.news (
        news_id,
        title,
        summary,
        content,
        news_image,
        news_category_id,
        tags,
        hidden,
        del_flag,
        created_user,
        created_date,
        updated_user,
        updated_date
    )
    SELECT article.news_id,
           article.title,
           article.summary,
           article.content,
           article.news_image,
           category.id,
           article.tags,
           0,
           0,
           N'content-seed',
           article.publish_date,
           N'content-seed',
           article.publish_date
    FROM @curated_news AS article
    INNER JOIN dbo.news_categories AS category ON category.slug = article.category_slug;

    IF @@ROWCOUNT <> 30
        THROW 50002, N'Không thể gán đầy đủ chuyên mục cho bộ dữ liệu tin tức.', 1;

    COMMIT TRANSACTION;

    SELECT COUNT(*) AS curated_article_count
    FROM dbo.news
    WHERE news_id LIKE N'WALNUT-%'
      AND ISNULL(hidden, 0) = 0
      AND ISNULL(del_flag, 0) = 0;

    SELECT category.name AS category_name,
           COUNT(*) AS article_count
    FROM dbo.news AS article
    INNER JOIN dbo.news_categories AS category ON category.id = article.news_category_id
    WHERE article.news_id LIKE N'WALNUT-%'
      AND ISNULL(article.hidden, 0) = 0
      AND ISNULL(article.del_flag, 0) = 0
    GROUP BY category.name, category.display_order
    ORDER BY category.display_order;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    THROW;
END CATCH;

SET NOCOUNT OFF;
