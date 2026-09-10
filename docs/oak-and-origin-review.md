# 🪵 Đánh giá thiết kế "Oak & Origin" — Bài học cho D&L Furniture

> Ngày: 10/09/2026
> Đối tượng so sánh: Mẫu thiết kế landing page "Oak & Origin — Handmade Furniture" (ảnh tham khảo)
> Với: Website D&L Furniture hiện tại (Vue 3, `src/views/HomeView.vue` + `src/template/*`)

---

## 1. Nhận định tổng quan

**Oak & Origin là một landing page "brand-first" rất đẹp** — phong cách editorial, tông tối ấm (nâu gỗ, kem, caramel), typography serif khổ lớn, ít CTA nhưng rất tập trung.

**So với D&L hiện tại:** website của bạn đã mạnh hơn về **chiến lược chuyển đổi** (funnel AIDA 12 section, form booking, sticky contact, bảng giá, testimonials — xem `docs/website-review-10k-detailed.md`). Oak & Origin mạnh hơn về **cảm xúc thương hiệu và sự "thuần khiết" thị giác**. Nói cách khác: **họ thắng về "feel", bạn thắng về "funnel"** — và điều cần làm là mượn cái "feel" của họ mà không phá funnel của bạn.

---

## 2. Những điểm ĐÁNG HỌC (theo thứ tự ưu tiên)

### 🥇 P1-1. Hero copy kiểu "tuyên ngôn" ngắn, đập thẳng
Oak & Origin: `HANDMADE. HONEST. TIMELESS.` (eyebrow) → **"MADE BY HAND. MADE TO LAST."** (3 dòng, serif khổ cực lớn) → 1 câu mô tả ngắn → 1 CTA duy nhất.

D&L hiện tại: "VẺ ĐẸP TRƯỜNG TỒN TỪ GỖ ÓC CHÓ THẬT" — hay nhưng thiên về **chất liệu**, chưa phải **tuyên ngôn giá trị**.

**Học hỏi:** Thử A/B headline hero theo công thức:
- Eyebrow: `THIẾT KẾ. CHẾ TÁC. HOÀN THIỆN.` (3 từ, uppercase, letter-spacing)
- Headline: **"LÀM TỪ GỖ. LÀM CHO BẠN. LÀM ĐỂ TRƯỜNG TỒN."** hoặc **"TỪ GỖ ÓC CHÓ THẬT. BỞI TAY THỢ THẬT."**
- Giữ 1 CTA chính (màu gold) + 1 CTA phụ dạng link text — tránh 2 nút cùng trọng lượng.

**File liên quan:** `src/template/02_SliderComponent.vue`

### 🥈 P1-2. Dải CTA tối "YOUR PIECE. YOUR STORY." ngay trước footer
Oak & Origin chốt trang bằng một dải tối full-width: ảnh xưởng gỗ mờ làm nền, headline cảm xúc ("Your piece. Your story."), 1 nút CTA, và **hàng 3 icon cam kết** (Sustainable Wood / Handmade with Care / Built to Last).

D&L có `11_BookingFormComponent` ở cuối rồi — nhưng có thể **bọc form trong một dải tối tương tự**:
- Nền: ảnh xưởng/thợ mộc thật (bạn có sẵn ảnh trong `public/media/`), overlay tối 75%.
- Headline cảm xúc: **"NỘI THẤT CỦA NHÀ BẠN. CÂU CHUYỆN CỦA BẠN."**
- Hàng 3 icon cam kết bằng Lucide (đã dùng trong dự án): 🌳 *Gỗ tự nhiên 100%* · 🤝 *Thi công trọn gói* · 🛡️ *Bảo hành dài hạn* — đặt NGAY trên form để xóa lo ngại đúng lúc quyết định.

**Tác động:** tăng conversion ở chốt chặn cuối — điểm yếu còn lại của funnel (theo D.3 trong review 10k).

### 🥉 P2-3. Chữ viết tay (script) làm điểm nhấn "chất thủ công"
Dòng *"Built for generations."* viết tay nghiêng dưới khối văn bản About tạo cảm giác **con người, gia truyền** — rất hợp ngành nội thất gỗ.

**Học hỏi:** Thêm 1 font script (Google Fonts: *Caveat* hoặc *Dancing Script*, chỉ ~20KB, `display=swap`) dùng đúng 1–2 chỗ:
- Dưới section About (`src/template/03_AboutComponent.vue`): *"Được làm bằng cả trái tim."*
- Trong dải CTA tối: *"Từ đời này sang đời khác."*

⚠️ Quy tắc: script chỉ dùng cho 1 câu ngắn/section — lạm dụng sẽ thành rẻ tiền.

### P2-4. Thẻ danh mục "ảnh + nhãn + 1 câu hứa"
3 thẻ Custom Tables / Handcrafted Storage / Chairs & Seating: ảnh dọc, caption dưới ảnh gồm **tên danh mục (uppercase) + 1 câu lợi ích ngắn + gạch chân accent**.

D&L đã có "Khám phá theo không gian" (tab Phòng Khách/Ngủ/Bếp) — cấu trúc tương đương, nhưng có thể mượn chi tiết: **thêm 1 câu hứa lợi ích dưới mỗi nhãn** ("Phòng khách — Nơi cả gia đình quây quần", "Phòng ngủ — Giấc ngủ trên gỗ thật"...). Nhỏ, rẻ, tăng cảm giác được "chăm chút".

### P2-5. Badge tròn dạng "con dấu khắc" — bạn đã có, hãy nâng cấp
Oak & Origin có badge tròn "HANDCRAFTED WOODWORK · EST. 2018" (text chạy vòng tròn). D&L đã có seal "15+ NĂM" trong About (`about-badge`) — tương đương về ý tưởng.

**Học hỏi (nâng cấp nhỏ):** đưa text chạy theo đường tròn (SVG `<textPath>`, quay chậm bằng CSS `animation: rotate 20s linear infinite`) thay cho text nằm ngang — đúng chất "con dấu khắc gỗ" mà comment trong code của bạn đang nhắm tới. Có thể đặt thêm 1 badge ở góc hero.

### P3-6. Làm ấm nền sáng: từ trắng sang kem
Oak & Origin dùng nền kem ấm (~`#f0e9dd`) thay vì trắng tinh, tạo cảm giác giấy thủ công, hợp gỗ. D&L đang dùng nền trắng + gold `#aa8453`.

**Học hỏi:** thử đổi nền các section sáng sang `#faf6ef` / `#f7f3ec` (bạn đã dùng `#f7f3ec` làm viền diamond trong About — nhất quán luôn). Chỉnh 1 biến CSS là toàn site đổi theo.

### P3-7. Chi tiết micro CTA: mũi tên ↗ trong nút
Nút "VIEW THE COLLECTION ↗" — mũi tên chéo nhỏ tạo cảm giác "bước vào". Thêm `<ArrowUpRight :size="16"/>` (lucide-vue-next, đã có trong dự án) vào các nút CTA chính. 5 phút thực hiện.

---

## 3. Những điểm KHÔNG NÊN học từ Oak & Origin

| Điểm của họ | Vì sao không copy |
|---|---|
| Footer cực tối giản | Footer D&L đầy đủ (giờ hoạt động, danh mục, liên hệ) tốt hơn cho SEO + khách VN quen tìm thông tin ở footer |
| Single-page, ít nội dung | Thiếu testimonials, pricing, blog → yếu cho SEO & thuyết phục. Funnel 12 section của D&L là lợi thế, giữ nguyên |
| Không có sticky contact | `StickyContact.vue` của bạn (Zalo/Messenger/Gọi ngay) là vũ khí chuyển đổi cho thị trường VN — họ không có |
| Ảnh moodboard tối toàn trang | Đẹp nhưng nếu lạm dụng làm giảm độ tương phản nội dung; D&L đang có nhịp sáng/tối đúng — chỉ cần "hâm nóng" tông màu |

---

## 4. Kế hoạch đề xuất (nếu bạn duyệt triển khai)

| # | Việc | File | Công sức | Ưu tiên |
|---|---|---|---|---|
| 1 | A/B headline hero theo công thức tuyên ngôn | `02_SliderComponent.vue` | 1h | P1 |
| 2 | Bọc BookingForm trong dải tối + hàng 3 icon cam kết | `11_BookingFormComponent.vue` | 2–3h | P1 |
| 3 | Thêm font script + 1–2 điểm nhấn viết tay | `index.html`, `03_AboutComponent.vue` | 1h | P2 |
| 4 | Thêm câu hứa lợi ích dưới nhãn tab bộ sưu tập | Collection component | 1h | P2 |
| 5 | Badge text-vòng-tròn quay (SVG textPath) | `03_AboutComponent.vue` | 1–2h | P2 |
| 6 | Đổi nền section sáng sang kem `#faf6ef` | biến CSS global | 1h + kiểm tra contrast | P3 |
| 7 | Thêm mũi tên ↗ vào nút CTA | các nút chính | 30p | P3 |

**Lưu ý:** các việc trên là **polish thị giác** — không thay thế các P0/P1 về SEO/tracking đã nêu trong `docs/website-review-10k-detailed.md` (prerender, GA4/Pixel, sitemap). Ưu tiên vẫn nên là nhóm P0 kỹ thuật trước, polish thiết kế song song sau.

---

## 5. Kết luận

**Có, học được nhiều — nhưng học về "cảm xúc", không phải về "cấu trúc".**
Ba thứ đáng lấy nhất từ Oak & Origin: (1) hero copy tuyên ngôn ngắn và mạnh, (2) dải CTA tối có icon cam kết trước form booking, (3) điểm nhấn viết tay tạo chất thủ công. Cả ba đều rẻ tiền, ít rủi ro, và không phá vỡ funnel AIDA cũng như kiến trúc Vue hiện tại.