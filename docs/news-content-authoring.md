# Quy ước nội dung chi tiết tin tức

Trường `news.content` chấp nhận văn bản thuần hoặc HTML. Văn bản thuần sẽ tự được chia thành
đoạn; HTML được render theo hệ editorial của trang chi tiết.

## Cấu trúc bài viết đề xuất

1. Mở bài bằng 2–3 đoạn ngắn.
2. Chia nội dung bằng `h2`/`h3`, tránh một khối chữ dài.
3. Sau mỗi 2–3 đoạn nên có một điểm nghỉ thị giác: hình, trích dẫn, video hoặc gallery.
4. Mỗi media cần `alt`/`title` và chú thích rõ nguồn.

### Hình đơn có chú thích

```html
<figure>
  <img
    src="/media/gallery/walnut-villa-living.webp"
    alt="Phòng khách gỗ óc chó với ánh sáng tự nhiên"
    loading="lazy"
  />
  <figcaption>Không gian phòng khách hoàn thiện bởi D&amp;L Furniture.</figcaption>
</figure>
```

### Gallery kéo ngang

```html
<div class="news-media-gallery" aria-label="Các góc nhìn của công trình">
  <figure>
    <img src="/media/gallery/walnut-villa-living.webp" alt="Toàn cảnh phòng khách" />
    <figcaption>Toàn cảnh</figcaption>
  </figure>
  <figure>
    <img src="/media/gallery/walnut-joinery-detail.webp" alt="Chi tiết ghép mộng" />
    <figcaption>Chi tiết chế tác</figcaption>
  </figure>
  <figure>
    <img src="/media/gallery/walnut-villa-kitchen.webp" alt="Không gian bếp liên thông" />
    <figcaption>Không gian liên thông</figcaption>
  </figure>
</div>
```

### Lưới hình

```html
<div class="news-story-grid">
  <figure>
    <img src="/media/gallery/villa-bedroom-earth.webp" alt="Phòng ngủ tông màu đất" />
  </figure>
  <figure>
    <img src="/media/gallery/villa-bedroom-desk.webp" alt="Góc làm việc trong phòng ngủ" />
  </figure>
</div>
```

### Video

Video nội bộ dùng thẻ `video`; YouTube/Vimeo dùng URL embed chính thức. Renderer chỉ cho phép
iframe từ YouTube, YouTube No-Cookie và Vimeo.

```html
<video controls playsinline poster="/media/gallery/artisan-walnut-chair.webp">
  <source src="/media/news/quy-trinh-che-tac.mp4" type="video/mp4" />
</video>

<iframe
  src="https://player.vimeo.com/video/573906036"
  title="Nghệ thuật chế tác nội thất"
  loading="lazy"
  allow="autoplay; fullscreen; picture-in-picture"
  allowfullscreen
></iframe>
```

Không chèn `script`, inline event (`onclick`, `onload`), form hoặc iframe từ domain khác; frontend
sẽ tự loại bỏ các phần này trước khi hiển thị.
