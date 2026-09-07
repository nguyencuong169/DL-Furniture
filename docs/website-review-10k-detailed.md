# 📋 GIẢI THÍCH CHI TIẾT ĐÁNH GIÁ WEBSITE $10K & KẾ HOẠCH POLISH

> Tài liệu này giải thích **từng tiêu chí đánh giá có ý nghĩa gì**, **tại sao website của bạn bị trừ điểm**, và **cụ thể phải polish thế nào** — để bạn xác nhận trước khi triển khai sửa.
>
> Ngày đánh giá: 06/09/2026
> Đối tượng: `http://localhost:5173/` (D&L Furniture — Vue 3) so với `https://noithatlacgia.vn/` (WordPress)

---

## A. GIẢI THÍCH 10 TIÊU CHÍ — Ý NGHĨA & CÁCH CHẤM

### 1️⃣ Thiết kế & UX/UI — trọng số 15% — Điểm: 8.5/10

**Ý nghĩa:** Website $10K không chỉ "đẹp" — nó phải dẫn dắt người xem theo một mạch tâm lý có chủ đích (design intent): thu hút → tạo niềm tin → chứng minh năng lực → xóa nghi ngờ → kêu gọi hành động. Đây là thứ phân biệt website "đẹp bề ngoài" (template mua về) với website được thiết kế bởi agency.

**Cách chấm của tôi:** Tôi đọc `src/views/HomeView.vue` — thứ tự component của bạn:
```
Slider → About → Collection → Projects → Statement → Craft
→ Facilities → Testimonials → Services → Pricing → News → Booking CTA
```
và có comment thiết kế rõ ràng:
```
<!-- Mạch: chất liệu & cam kết → bằng chứng xã hội → quy trình
     hợp tác → phạm vi + báo giá → tin tức → CTA. KHÔNG đảo thứ tự -->
```
Đây là **conversion funnel đúng chuẩn agency** — nhiều website $10K thật còn không có comment thiết kế như vậy. So với noithatlacgia.vn (trang chủ chỉ là slider + 2 khối giới thiệu + lưới sản phẩm rời rạc), bạn tốt hơn rõ rệt.

**Vì sao không chấm 10:** Vì tôi mới đánh giá qua code + cấu trúc, chưa audit visual thực tế (màu sắc, spacing, typography, animation thực tế trên trình duyệt) — đây là hạn chế của việc review không có browser render đầy đủ.

---

### 2️⃣ Hiệu năng (Core Web Vitals) — trọng số 15% — Điểm: 5/10

**Ý nghĩa:** Google đo 3 chỉ số quyết định thứ hạng và trải nghiệm:
- **LCP** (Largest Contentful Paint): ảnh/heading lớn nhất hiển thị trong < 2.5s
- **INP** (Interaction to Next Paint): phản hồi tương tác < 200ms
- **CLS** (Cumulative Layout Shift): trang không "nhảy" khi load

**Tại sao quan trọng:** Mỗi giây load chậm thêm → tỷ lệ thoát tăng ~30%. Khách hàng nội thất cao cấp thường vào từ quảng cáo Facebook/TikTok trên điện thoại 4G — nếu chậm, tiền quảng cáo đổ ra sông.

**Bằng chứng trừ điểm của bạn (`index.html`):**
```
src/assets/js/jquery-3.6.3.min.js          ← ~90KB
src/assets/js/jquery-migrate-3.0.0.min.js  ← chỉ để fix lỗi cũ
src/assets/js/jquery.magnific-popup.js     ← popup, Vue làm được
src/assets/js/bootstrap.min.js             ← bạn dùng Bootstrap 3 JS
src/assets/js/scrollIt.min.js              ← scroll, Vue làm được
src/assets/js/jquery.waypoints.min.js      ← scroll animation, Vue làm được
src/assets/js/owl.carousel.min.js          ← slider, Swiper Vue thay được
src/assets/js/custom.js                    ← JS theme gốc
```
→ **~350–400KB JavaScript legacy chạy song song với Vue.** Vue không cần jQuery — đây là nợ kỹ thuật từ theme HTML gốc bạn convert sang.

**So sánh:** noithatlacgia.vn cũng jQuery nhưng họ là server-render (WordPress) nên First Paint nhanh hơn bạn dù code xấu hơn.

---

### 3️⃣ SEO kỹ thuật — trọng số 15% — Điểm: 4/10 ⚠️ (KHOẢNG TRỐNG LỚN NHẤT)

**Ý nghĩa:** SEO kỹ thuật = khả năng công cụ tìm kiếm & crawler "đọc hiểu" website của bạn mà không cần chạy JavaScript.

**Bằng chứng — tôi đã fetch trực tiếp localhost:5173:**
```
Kích thước HTML trả về: 2,201 bytes (2.2KB)
vs noithatlacgia.vn: 111,876 bytes (112KB)
```
Cả nội dung, tiêu đề sản phẩm, giá trị đề xuất (value proposition), schema... **đều KHÔNG có trong HTML ban đầu** — chỉ có `<div id="app"></div>` rỗng.

**Hậu quả cụ thể:**

| Tình huống | Kết quả với website hiện tại |
|---|---|
| Googlebot index trang | ⚠️ Được (Google render JS được, nhưng chậm & tốn ngân sách crawl) |
| **Facebook share link** | ❌ KHÔNG có ảnh, mô tả — fb crawler không chạy JS |
| **Zalo/TikTok/Messenger share** | ❌ Tương tự — mất preview |
| Bing, Yandex, AI crawlers (ChatGPT, Perplexity) | ⚠️ Không ổn định |
| Sitemap gửi Google Search Console | ❌ Không có sitemap |

Ngoài ra: meta tags được inject trong `onMounted()` của `HomeView.vue` — tức là phải **chờ Vue mount xong** mới có title/mô tả → Googlebot đôi khi chụp snapshot trước khi mount xong.

**Tại sao đối thủ được 8/10 ở mục này:** WordPress server-render sẵn toàn bộ HTML + Yoast sinh schema đầy đủ. Đó là lợi thế cấu trúc, không phải chất lượng code.

---

### 4️⃣ Conversion & CTA — trọng số 15% — Điểm: 8/10

**Ý nghĩa:** Website $10K phải biến khách truy cập thành khách hàng tiềm năng (lead): form, hotline, booking, báo giá...

**Điểm mạnh của bạn:** Có đủ chuỗi thuyết phục:
- `11_BookingFormComponent` — form đặt lịch khảo sát (CTA cuối trang, đúng vị trí)
- `05_PricingComponent` — bảng giá (xóa lo lắng về chi phí)
- `08_TestimonialsComponent` — đánh giá khách hàng (bằng chứng xã hội)
- `09_ServicesComponent` — quy trình dịch vụ

**Vì sao mất 2 điểm:** Bạn có form nhưng **không có tracking** → không biết bao nhiêu % người xem điền form, nguồn nào chuyển đổi tốt. Một website $10K thật phải đo được: "1,000 visit → 30 form → 5 hợp đồng". Hiện tại bạn đang "mù" hoàn toàn về số liệu.

---

### 5️⃣ Mobile-first & Responsive — trọng số 10% — Điểm: 7.5/10

**Ý nghĩa:** Google index theo phiên bản mobile trước (mobile-first indexing). ~75% traffic nội thất VN đến từ mobile/quảng cáo MXH.

**Điểm cộng có bằng chứng** (`index.html` dòng 11-12):
```html
<!-- Không dùng maximum-scale=1: giữ pinch-zoom cho người dùng
     kém thị lực (WCAG 1.4.4) -->
<meta name="viewport" content="width=device-width, initial-scale=1" />
```
→ Bạn đã chặn lỗi phổ biến (khóa zoom làm mất khả năng tiếp cận) và có ý thức về WCAG — hiếm website nào làm được.

**Vì sao chưa 9-10:** Cần audit visual đa thiết bị thực tế (breakpoints 320/375/768/1024/1440px), kiểm tra tap-target ≥ 44px, font-size ≥ 16px trên mobile.

---

### 6️⃣ Bảo mật — trọng số 10% — Điểm: 7/10

**Ý nghĩa:** Website bị hack = mất thứ hạng SEO + mất uy tín thương hiệu + chi phí khắc phục.

**Bạn được điểm cao hơn đối thủ vì:**
- SPA tĩnh trên Netlify/CDN — **không có PHP, không có database, không có wp-admin** → bề mặt tấn công gần như bằng 0
- Đối thủ: lộ `WordPress 6.3.10` (cho hacker biết phiên bản có lỗ hổng nào), mở `xmlrpc.php` (tấn công brute-force), mở `wp-json` (dò user)

**Bạn vẫn mất 3 điểm vì:**
- Chưa cấu hình **security headers** trên Netlify: CSP, X-Frame-Options, HSTS, X-Content-Type-Options
- Chưa thấy cơ chế làm sạch input ở form (nếu form gửi API backend)

---

### 7️⃣ Chất lượng code & Maintainability — trọng số 10% — Điểm: 9/10

**Ý nghĩa:** Website $10K phải có thể bảo trì/scale trong 2-3 năm mà không phải viết lại. Đây là thứ khách hàng "không nhìn thấy" nhưng quyết định chi phí dài hạn.

**Bằng chứng điểm 9 của bạn:**
| Yếu tố | Trạng thái |
|---|---|
| TypeScript | ✅ Toàn bộ `src/` là `.ts` |
| ESLint + Prettier + Stylelint | ✅ Có config đầy đủ |
| Unit test (Vitest) | ✅ Có setup |
| Route lazy-loading | ✅ `() => import(...)` trong router |
| Kiến trúc component | ✅ Tách template/ views/ components/ rõ nghĩa |
| Code splitting | ✅ Router-level |

**Mất 1 điểm:** jQuery trộn lẫn Vue (nêu ở mục 2) + `ThuocLoBanView.vue` là dead code (file tồn tại nhưng không đăng ký trong router).

---

### 8️⃣ Analytics & Đo lường — trọng số 5% — Điểm: 2/10

**Ý nghĩa:** "Bạn không thể tối ưu thứ mà bạn không đo được." Website $10K luôn gắn GA4 + GTM + Pixel và track conversion events.

**Bằng chứng:** Quét toàn bộ `src/` và `index.html` — **không có bất kỳ script analytics nào.** Trong khi đối thủ có: GA4 + GTM + Meta Pixel (kèm Conversions API) + TikTok Pixel.

**Hệ quả thực tế:** Khi bạn chạy quảng cáo, sẽ KHÔNG thể: (a) retarget người đã xem trang, (b) tạo lookalike audience, (c) đo ROAS của từng chiến dịch.

---

### 9️⃣ Nội dung & Hình ảnh — trọng số 5% — Điểm: 6/10

**Ý nghĩa:** Nội dung là "nhiên liệu" của SEO và niềm tin. Ảnh chất lượng quyết định doanh số ngành nội thất (khách MUA BẰNG MẮT).

**Điểm cộng:** Có `docs/news-content-authoring.md` — quy trình viết bài chuẩn hóa. Có `IMAGE_REPLACEMENT_GUIDE.md` và scripts xử lý ảnh (`scripts/download-walnut-images.ps1`...). Đây là tư duy hệ thống hóa nội dung tốt.

**Vì sao 6/10:** Nội dung thật trên site cần: ảnh sản phẩm chụp chuyên nghiệp (không phải ảnh mạng), bài viết ≥ 1,500 từ có từ khóa, hình dự án thi công thật trước/sau. Cần kiểm tra `public/media/` để xác nhận khối lượng ảnh thật đã sẵn sàng.

---

### 🔟 Shareability (Khả năng chia sẻ MXH) — trọng số 5% — Điểm: 3/10

**Ý nghĩa:** Khi khách share link sản phẩm lên Facebook/Zalo, preview (ảnh + tiêu đề + mô tả) quyết định người xem có bấm hay không. Trong ngành nội thất — nơi khách đến từ MXH — đây là mất mát doanh số trực tiếp.

**Bằng chứng:** OG tags của bạn nằm trong `updateHomeSeo()` chạy bằng JavaScript → crawler FB/Zalo (không chạy JS) thấy HTML trống trơn → preview trắng.

---

## B. KẾ HOẠCH POLISH CHI TIẾT — ĐỂ BẠN XÁC NHẬN

### 🔴 NHÓM 1 — Ưu tiên P0 (làm ngay, tác động lớn nhất)

#### 1.1. Prerender toàn bộ route (SSG) — sửa SEO + Shareability
- **Vấn đề:** HTML shell 2.2KB, nội dung chỉ xuất hiện sau khi JS chạy.
- **Phương án A (khuyến nghị — ít thay đổi code):** Thêm `vite-plugin-prerender` hoặc `vite-ssg`. Build tĩnh HTML đầy đủ cho các route: `/`, `/gioi-thieu`, `/thu-vien`, `/san-pham/*`, `/tin-tuc`, `/lien-he`. Kết quả: HTML trả về chứa sẵn title/meta/OG/nội dung.
- **Phương án B (mạnh hơn — tốn công hơn):** Chuyển sang Nuxt 3 (SSR/SSG chính thức của Vue).
- **Tác động dự kiến:** Điểm SEO 4 → 8, Shareability 3 → 8.
- **Rủi ro:** Phương án A cần đảm bảo các component không phụ thuộc `window` lúc build; jQuery plugin init cần chạy sau mount.

#### 1.2. Thêm `robots.txt` + `sitemap.xml` vào `public/`
```
public/robots.txt
→ User-agent: *
   Allow: /
   Disallow: /admin
   Sitemap: https://your-domain.com/sitemap.xml

public/sitemap.xml
→ Liệt kê tất cả route tĩnh; route động (product detail) sinh tự động từ danh sách sản phẩm bằng script build.
```
- **Tác động:** SEO +0.5. Công sức: ~1 giờ.

#### 1.3. Chuyển favicon sang `public/`
- **Vấn đề:** `<link rel="shortcut icon" href="src/assets/img/favicon.png">` — đường dẫn `src/` **không tồn tại sau khi build** → 404 favicon, tab trình duyệt không có icon.
- **Fix:** Copy ảnh vào `public/favicon.ico` (hoặc `.png`) và đổi href thành `/favicon.png`.
- **Công sức: 5 phút.**

#### 1.4. Gắn GA4 + GTM + Meta Pixel
- **Fix:** Thêm script GTM/GA4 vào `index.html` (hoặc qua composable chỉ chạy production); thêm event tracking: `generate_lead` khi submit BookingForm, `click_phone` khi bấm hotline, `view_item` khi xem sản phẩm.
- **Tác động:** Analytics 2 → 9. Mở khóa khả năng chạy quảng cáo có đo lường.

### 🟠 NHÓM 2 — Ưu tiên P1 (tuần 2)

#### 2.1. Loại bỏ jQuery/Bootstrap legacy
- **Fix từng plugin:**
  | Hiện tại | Thay bằng | Lý do |
  |---|---|---|
  | owl.carousel | Swiper (vue version) hoặc embla-carousel | Slider native Vue, tree-shake được |
  | magnific-popup | `vue-final-modal` / `<dialog>` native | Lightbox hiện đại |
  | waypoints + animations.ts | IntersectionObserver (Vue directive) | API trình duyệt sẵn có |
  | scrollIt | CSS `scroll-behavior` + router scrollBehavior | Đã có sẵn trong router của bạn |
  | Bootstrap JS | CSS riêng (bạn đã viết style.css) | Chỉ cần JS dropdown/modal tự viết |
  | jquery + migrate | ❌ Xóa hẳn | Không cần trong Vue |
- **Tác động:** Giảm ~350KB JS → Performance 5 → 8. Cần re-test từng component dùng plugin.

#### 2.2. URL slug SEO-friendly cho trang chi tiết
- **Hiện tại:** `/san-pham/detail/12` — Google không hiểu nội dung từ URL.
- **Fix:** Route thành `/san-pham/:slug` (vd: `/san-pham/ke-tivi-go-oc-cho-an`); slug lưu trong DB/API hoặc map từ tên sản phẩm (bỏ dấu, thay space bằng `-`).
- **Lưu ý:** Cần thêm redirect 301 từ URL cũ nếu đã index.

#### 2.3. Đăng ký hoặc xóa `ThuocLoBanView`
- Route `/thuoc-lo-ban` nếu muốn giữ tính năng (đối thủ có — là công cụ thu traffic phong thủy); hoặc xóa file nếu không dùng.

### 🟡 NHÓM 3 — Ưu tiên P2 (tuần 3-4)

#### 3.1. Tối ưu hình ảnh
- Convert ảnh sang **WebP/AVIF**; `<img loading="lazy" decoding="async">` cho ảnh dưới màn hình đầu; `fetchpriority="high"` cho ảnh hero; đặt `width/height` để tránh CLS.

#### 3.2. Security headers trên Netlify
Thêm vào `netlify.toml`:
```toml
[[headers]]
  for = "/*"
  [headers.values]
    X-Frame-Options = "DENY"
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"
    Strict-Transport-Security = "max-age=31536000; includeSubDomains"
    Content-Security-Policy = "default-src 'self'; ..."
```

#### 3.3. Schema mở rộng
- Thêm `Product` schema (kèm `offers`) cho trang chi tiết sản phẩm; `Article` schema cho tin tức; `FAQPage` nếu có mục hỏi đáp → tăng cơ hội rich snippets trên Google.

#### 3.4. Visual polish audit
- Kiểm tra breakpoints 320/375/768/1024/1440; tap-target ≥ 44px; contrast ratio ≥ 4.5:1 (WCAG AA); dark/light section đã có nhịp tốt — cần xác nhận bằng screenshot thực tế.

---

## C. BẢNG DỰ KIẾN ĐIỂM SAU POLISH

| Tiêu chí | Hiện tại | Sau P0 | Sau P1+P2 | Target $10K |
|---|---|---|---|---|
| Thiết kế & UX | 8.5 | 8.5 | 9.0 | ≥ 8.5 ✅ |
| Hiệu năng | 5.0 | 5.5 | 8.5 | ≥ 8.0 ✅ |
| SEO kỹ thuật | 4.0 | 8.0 | 8.5 | ≥ 8.0 ✅ |
| Conversion | 8.0 | 8.5 | 9.0 | ≥ 8.0 ✅ |
| Mobile | 7.5 | 7.5 | 8.5 | ≥ 8.0 ✅ |
| Bảo mật | 7.0 | 7.0 | 9.0 | ≥ 8.5 ✅ |
| Code quality | 9.0 | 9.0 | 9.5 | ≥ 8.5 ✅ |
| Analytics | 2.0 | 9.0 | 9.0 | ≥ 8.0 ✅ |
| Nội dung | 6.0 | 6.5 | 8.0 | ≥ 7.5 ✅ |
| Shareability | 3.0 | 8.0 | 8.5 | ≥ 8.0 ✅ |
| **TỔNG (có trọng số)** | **6.2** | **7.6** | **8.8** | **≥ 8.5 = $10K** |

**Giá trị thị trường ước tính: hiện tại ~$3,500 → sau P0 ~$6,500 → sau P1+P2 ~$10,000.**

---

## D. PHÂN TÍCH SÂU 3 TRỤ CỘT: SEO • TRACKING • CONVERSION FUNNEL

### 🔍 D.1. SEO KỸ THUẬT — Chi tiết vì sao bạn 4/10, đối thủ 8/10

#### D.1.1. Bản chất vấn đề: "HTML thật" vs "HTML vỏ rỗng"

Khi tôi `curl` (tức là giả lập một crawler KHÔNG chạy JavaScript) 2 website, đây là thứ nhận về:

**Website của bạn (2,201 bytes):**
```html
<title>D&L Furniture</title>        ← title mặc định, không chứa từ khóa
<div id="app"></div>                 ← RỖNG TRƠN TRỌN
<script src="src/main.ts"></script>  ← nội dung nằm trong JS này
```
→ Crawler thấy một trang gần như trống. Tất cả nội dung, mô tả sản phẩm, schema... chỉ xuất hiện SAU KHI trình duyệt tải JS, chạy Vue, Vue mount các component.

**noithatlacgia.vn (111,876 bytes):** Toàn bộ nội dung có sẵn trong HTML — WordPress là PHP render server-side, mỗi request trả về HTML hoàn chỉnh.

#### D.1.2. Ai bị ảnh hưởng và ảnh hưởng thế nào? (bảng đối chiếu từng crawler)

| Crawler | Chạy JS? | Hậu quả cho website của bạn | Tác động kinh doanh |
|---|---|---|---|
| **Googlebot** | ✅ Có (2 lớp render, chậm 1-2 tuần) | Vẫn index được NHƯNG: tốn "crawl budget", xếp hạng chậm hơn, có rủi ro render fail | Thứ hạng tăng chậm hơn đối thủ |
| **Bing/Yandex/Cốc Cốc** | ⚠️ Một phần, không đáng tin | Index không ổn định | Mất traffic từ Bing (~10-15% thị phần VN) |
| **Facebook (share link)** | ❌ KHÔNG | Không thấy og:title/og:image (vì nằm trong JS) → preview share TRẮNG | Khách share sản phẩm lên nhóm FB → không ai bấm |
| **Zalo (share link)** | ❌ KHÔNG | Tương tự — preview trống | Mất CTR từ kênh bán hàng số 1 VN |
| **TikTok bio/broadcast** | ❌ KHÔNG | Không preview | Kênh quảng cáo chính của ngành nội thất |
| **AI crawlers (ChatGPT, Perplexity, Google AI)** | ⚠️ Không ổn định | Website không xuất hiện trong câu trả lời AI | Xu hướng tìm kiếm mới đang bỏ lỡ |

#### D.1.3. Vấn đề thứ 2: SEO chỉ làm "nửa vời" trong code của bạn

Tôi đã quét toàn bộ `src/views/` — kết quả:

| View | Có inject meta riêng? |
|---|---|
| `HomeView.vue` | ✅ Có (title, description, OG, Twitter, JSON-LD LocalBusiness) |
| `NewsDetailView.vue` | ✅ Có (og:type article, JSON-LD) |
| `AboutView.vue` | ❌ KHÔNG — title vẫn là "D&L Furniture" mặc định |
| `ProductView.vue` | ❌ KHÔNG |
| `ProductDetailView.vue` | ❌ KHÔNG — trang sản phẩm, trang quan trọng nhất cho SEO thương mại, lại không có meta riêng! |
| `ProjectView.vue` | ❌ KHÔNG |
| `GalleryView.vue` | ❌ KHÔNG |
| `ContactUsView.vue` | ❌ KHÔNG |
| `NewsView.vue` | ❌ KHÔNG |

→ 7/9 trang không có title/description riêng → Google chỉ thấy một trang "D&L Furniture" lặp lại → không thể xếp hạng cho từ khóa "bàn ghế gỗ óc chó", "giường ngủ gỗ óc chó"...

#### D.1.4. Vấn đề thứ 3: các mảnh ghép SEO còn thiếu hoàn toàn

| Mảnh ghép | Trạng thái | Ý nghĩa |
|---|---|---|
| `sitemap.xml` | ❌ Không có trong `public/` | Không có sitemap → Google không biết bạn có những trang nào, index chậm & thiếu |
| `robots.txt` | ❌ Không có | Không chỉ dẫn bot, không khai báo sitemap |
| URL slug | ❌ `/san-pham/detail/12` | URL không chứa từ khóa → mất điểm relevancy; URL đẹp `/san-pham/giuong-go-oc-cho-cao-cap` tự thân đã là từ khóa |
| Breadcrumb schema | ❌ Chưa có | Thiếu hiển thị breadcrumb đẹp trong kết quả tìm kiếm |
| Internal linking | ⚠️ Yếu | Cần kiểm tra: sản phẩm phải link chéo tới dự án liên quan, tin tức liên quan |

#### D.1.5. Vì sao đối thủ được 8/10 (không phải 10)?
- ✅ Server-render + Yoast: title/meta/canonical/OG/JSON-LD (WebPage, Breadcrumb, WebSite+SearchAction) tự động cho MỌI trang
- ✅ Nội dung blog thật, URL slug tiếng Việt chuẩn
- ❌ Nhưng: title trùng lặp, HTML lỗi, link rỗng, feed nhiễm bài spam → không được 10

**Kết luận SEO:** Đối thủ thắng nhờ **cấu trúc** (WordPress server-render), không phải vì làm SEO giỏi hơn. Website của bạn có nền code tốt hơn — chỉ cần **prerender + bổ sung 7 trang thiếu meta + sitemap/slug** là đảo ngược thế trận.

---

### 📊 D.2. TRACKING & ĐO LƯỜNG — Chi tiết vì sao bạn 2/10, đối thủ 9/10

#### D.2.1. Bằng chứng rà soát code

Tôi đã tìm kiếm toàn bộ `src/` (mọi file `.ts` và `.vue`) với các mẫu: `gtag`, `dataLayer`, `fbq`, `ttq`, `analytics`, `trackEvent` —
**Kết quả: 0 kết quả.** Website của bạn hiện không track MỘT điều gì.

#### D.2.2. Đối thủ có gì mà bạn thiếu? (giải thích từng công cụ)

| Công cụ đối thủ có | Là gì? | Cho phép làm gì? |
|---|---|---|
| **GA4** (`G-865WENZP2Q`) | Google Analytics 4 — đo traffic | Biết: bao nhiêu người vào, từ đâu (FB/TikTok/Google), xem trang gì, ở lại bao lâu, dùng máy gì |
| **GTM** (`GTM-NB69T8FX`) | Google Tag Manager — quản lý tập trung mọi script tracking | Thêm/sửa/thêm event KHÔNG cần sửa code, không cần deploy lại |
| **Meta Pixel** (`2951798121596047`) | Đo hành vi người dùng Facebook | (1) Retarget: quảng cáo lại đúng người đã xem trang/đã bấm hotline; (2) Lookalike: tìm người giống khách đã mua; (3) Đo ROAS từng chiến dịch |
| **Meta Conversions API** (open-bridge) | Gửi dữ liệu chuyển đổi từ SERVER (không qua trình duyệt) | Vượt qua chặn cookie/iOS — đo chính xác ai điền form |
| **TikTok Pixel** (`CGEI3CJC77U6LAATLOS0`) | Tương tự Meta nhưng cho TikTok | Retarget + tối ưu chiến dịch trên TikTok — kênh mạnh nhất cho nội thất hiện nay |

#### D.2.3. Không có tracking = mất gì cụ thể? (kịch bản thực tế)

Hãy tưởng tượng bạn chi **50 triệu/tháng** chạy quảng cáo:

| Tình huống | Với tracking (đối thủ) | Không tracking (bạn) |
|---|---|---|
| 1000 người xem trang, 30 người điền form | Biết tỷ lệ 3%, biết nguồn nào ra lead, dồn ngân sách về nguồn tốt | Không biết gì — ngân sách phân tán mù quáng |
| 970 người xem KHÔNG điền form | Retarget họ bằng quảng cáo "Ưu đãi thiết kế miễn phí" → kéo lại 10-15% | Mất hoàn toàn 970 lead tiềm năng |
| Ai bấm nút "Gọi ngay" sticky? | Đếm được `click_phone` theo trang, theo thời gian | Không biết |
| Đo giá trị một lead | Có thể tính: 50tr quảng cáo / 30 lead = 1.67tr/lead → so với giá trị hợp đồng 200tr+ là LỜI | Không tính được → không dám tăng ngân sách |

#### D.2.4. Điểm cộng duy nhất của bạn (vì sao không phải 0)
Form booking của bạn đã **chuẩn bị sẵn hạ tầng để track**: có API thật (`submitConsultation` trong `api/consultationClient`), có trạng thái `success/error`, có honeypot chống spam (`website` field) — tức là chỉ cần gắn 1 dòng `dataLayer.push({event:'generate_lead'})` vào hàm submit là có conversion tracking hoàn chỉnh. Hạ tầng tốt, chỉ thiếu "đồng hồ đo".

#### D.2.5. Kế hoạch gắn tracking cụ thể (khi bạn duyệt)

```
Bước 1: index.html — thêm GTM container (head + body noscript)
Bước 2: src/utils/analytics.ts — viết helper:
  trackEvent('generate_lead')    // khi form submit thành công
  trackEvent('click_phone')      // khi bấm StickyContact hotline
  trackEvent('click_zalo')       // khi bấm Zalo
  trackEvent('view_item', id)    // khi xem chi tiết sản phẩm
Bước 3: Gắn GA4 config qua GTM + Meta Pixel + TikTok Pixel
Bước 4: Trong GTM tạo conversion "Submit Consultation Form"
Bước 5: Test bằng GA4 DebugView + Meta Pixel Helper
```
Công sức: ~0.5-1 ngày. Không phá vỡ kiến trúc hiện tại (helper tách riêng, chỉ chạy production).

---

### 🎯 D.3. CONVERSION FUNNEL — Chi tiết vì sao bạn 8/10, đối thủ 6/10

#### D.3.1. So sánh "hành trình của khách" trên 2 website

**Trang chủ của bạn (đọc từ `HomeView.vue`):**
```
①  Slider            → BẮT MẮT: hình ảnh đẹp, ấn tượng đầu
②  About             → TẠO NHẬN THỨC: D&L là ai, làm gì
③  Collection        → MỜI KHÁM PHÁ: bộ sưu tập sản phẩm chủ lực
④  Featured Projects → CHỨNG MINH: dự án thật đã thi công
⑤  Statement         → KHẲNG ĐỊNH GIÁ TRỊ: divider chữ — tạm nghỉ thị giác,
                       cắm cột thông điệp thương hiệu
⑥  Craft             → GIẢI THÍCH CHẤT LƯỢNG: quy trình chế tác gỗ óc chó
⑦  Facilities        → TẠO NIỀM TIN: xưởng/showroom thật (đối thủ ưa điểm này)
⑧  Testimonials      → BẰNG CHỨNG XÃ HỘI: khách nói gì về D&L
⑨  Services          → RÕ RÀNG PHẠM VI: thiết kế/thi công gồm những gì
⑩  Pricing           → XÓA LO NGẠI CHI PHÍ: bảng giá minh bạch
⑪  News              → DUY TRÌ SỰ SỐNG: blog cập nhật (tín hiệu chuyên gia)
⑫  BookingForm CTA   → CHỐT: "Điền form nhận tư vấn" — đúng lúc khách đã đủ
                       niềm tin, chưa nguội
```
Đây chính là mô hình **AIDA + Trust-building** (Attention → Interest → Desire → Action + Trust) mà agency $10K thiết kế. Comment trong code chứng minh đây là chủ đích, không phải ngẫu nhiên.

**Trang chủ đối thủ:** Slider → 2 khối giới thiệu thiết kế/thi công → lưới 6 sản phẩm (giá TRỐNG "đ") → video giới thiệu → 4 tin tức. **Không có testimonials, không có pricing, không có form booking ngay trang chủ** (form ở trang Liên hệ riêng — mất 1 cú click).

#### D.3.2. Bảng chấm từng "chốt chặn" chuyển đổi

| Chốt chặn | Bạn | Đối thủ | Nhận xét |
|---|---|---|---|
| Nút liên hệ nổi (sticky) | ✅ **Xuất sắc**: `StickyContact.vue` có 3 kênh — Gọi ngay (pulse vàng gold thu hút), Zalo, Messenger; ẩn thông minh khi gần footer tránh đè nội dung; accessibility đầy đủ (aria-label, focus-visible) | ⚠️ Có nhưng thô sơ | Đây là "cửa ra vào" luôn mở — khách bất kỳ lúc nào muốn liên hệ cũng thấy |
| Form tư vấn | ✅ **Chuẩn production**: 7 trường hợp lý (họ tên, SĐT, dịch vụ, loại công trình, diện tích, ngân sách, vị trí), validation chặt (regex SĐT VN 84/0 đầu), honeypot chống spam bot, trạng thái loading/success/error, gửi API thật | ⚠️ Contact Form 7 cơ bản | Form của bạn lọc được chất lượng lead ngay từ đầu (hỏi diện tích + ngân sách) |
| CTA cuối trang chủ | ✅ BookingForm ngay trang chủ | ❌ Phải qua trang Liên hệ | Mỗi cú click bớt đi = chuyển đổi tăng |
| Bảng giá minh bạch | ✅ Có `PricingComponent` | ❌ Giá sản phẩm còn TRỐNG "đ" | Giá trống = tín hiệu "kém uy tín" |

#### D.3.3. Vì sao bạn vẫn bị trừ 2 điểm ở mục này?

**Mục 1 — Funnel có "màn hình" nhưng chưa có "máy đếm" (liên kết trực tiếp với Tracking 2/10):**
Bạn không biết: bao nhiêu % người xem cuộn đến testimonial? bao nhiêu % bấm "Gọi ngay"? bao nhiêu % mở form rồi bỏ dở ở trường nào? Không có số liệu → không thể tối ưu (A/B test, đổi vị trí CTA, rút ngắn form...). Một funnel $10K phải được **đo liên tục**.

**Mục 2 — Các nâng cấp funnel còn thiếu:**
| Nâng cấp | Ý nghĩa |
|---|---|
| Exit-intent popup | Khi khách sắp đóng tab → hiện "Nhận bảng giá chi tiết miễn phí" |
| CTA giữa chừng (mid-scroll CTA) | Banner mini sau mục Craft/Pricing — chốt người nóng tay trước khi tới cuối trang |
| Live chat thật (Tawk.to/Tidio) | Nút sticky chỉ mở app Zalo/Messenger — chat inline giữ khách ở lại site |
| Social proof động | "12 gia đình đã tư vấn trong tuần này" — tăng áp lực tâm lý lành mạnh |
| Form rút gọn cho mobile | 7 trường hơi dài trên điện thoại — bản 3 trường (tên, SĐT, dịch vụ) tăng tỷ lệ hoàn thành ~20-30% |

#### D.3.4. Vì sao đối thủ được 6/10 (không thấp hơn)?
Họ vẫn có: slider ấn tượng, video giới thiệu doanh nghiệp (YouTube embed — tạo niềm tin hình ảnh), bài viết + dự án thật, GTranslate (chặn rào ngôn ngữ cho khách nước ngoài). Chỉ thiếu thiết kế funnel có chủ đích + form tốt → 6/10.

---

## ✅ CHECKLIST XÁC NHẬN (vui lòng tick trước khi tôi triển khai)

- [ ] **P0-1:** Prerender SSG — chọn Phương án A (vite-plugin, giữ Vue hiện tại) hay B (chuyển Nuxt 3)?
- [ ] **P0-2:** Thêm robots.txt + sitemap.xml — domain production là gì? (cần để ghi vào sitemap)
- [ ] **P0-3:** Chuyển favicon sang public/ — **xác nhận làm**
- [ ] **P0-4:** GA4 + GTM + Meta Pixel — bạn có sẵn các ID (GA4 measurement ID, Pixel ID) chưa?
- [ ] **P1-1:** Loại bỏ jQuery/Bootstrap legacy — **xác nhận làm** (cần re-test slider/popup/animation)
- [ ] **P1-2:** URL slug SEO — sản phẩm/tin tức lấy slug từ đâu (API hay sinh từ tên)?
- [ ] **P1-3:** ThuocLoBanView — giữ (đăng ký route) hay xóa?
- [ ] **P2-1..4:** Ảnh WebP, security headers, schema mở rộng, visual audit — **xác nhận làm**