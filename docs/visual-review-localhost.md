# Review tổng thể http://localhost:5173/ (kiểm tra trực quan bằng trình duyệt)

> Ngày review: 07/09/2026 · Viewport desktop 1280×800 · Vue 3 + Vite dev server

## 1. Trang chủ (`/`) — ✅ Xuất sắc

| Section | Nhận xét |
|---|---|
| Header | Sticky, logo 2 dòng thanh lịch, active state rõ (TRANG CHỦ màu gold), CTA "ĐẶT LỊCH TƯ VẤN" nổi bật góc phải |
| Hero slider | Ảnh chất lượng cao (gỗ óc chó, ánh sáng tự nhiên), typography serif cỡ lớn "VẺ ĐẸP TRƯỜNG TỒN TỪ GỖ ÓC CHÓ THẬT" — đúng vị thế thương hiệu; CTA giữa màn hình; điều hướng 1/2/3 + mũi tên trái/phải |
| Về chúng tôi | Bố cục 3 cột (văn bản — ảnh moodboard — stats); số liệu thuyết phục (11+ năm, 207+ dự án, 6.266+ m², 98% hài lòng); badge "15+ NĂM KINH NGHIỆM" trên ảnh |
| Hotline | (+84) 961-109-897 hiển thị rõ ngay section đầu |
| Bộ sưu tập | "Khám phá theo không gian" — tab 01 Phòng Khách / 02 Phòng Ngủ / 03 Phòng Bếp dạng panel tương tác, ảnh full-width đẹp |
| Sticky contact | 3 nút nổi (Zalo, Messenger, Gọi ngay) góc phải — luôn sẵn |
| Nhịp sáng/tối | Section sáng/tối so le đúng thiết kế comment trong `HomeView.vue` — mạch thuyết phục AIDA được giữ nguyên khi render |

**Điểm nhìn thấy:** 9/10 — thiết kế đạt chuẩn agency cao cấp.

## 2. Trang sản phẩm (`/san-pham`) — ⚠️ Vấn đề phát hiện

**Hiện tượng:** Hero xám trống (không có ảnh background) → sau hero là **footer ngay lập tức**, không có lưới sản phẩm.

**Nguyên nhân khả dĩ:** Backend API (`DLFurniture.Api`) không chạy trong phiên review → fetch danh sách sản phẩm thất bại → grid rỗng. Lưu ý: bản prerender `dist/san-pham/index.html` (16.8KB) **có** nội dung fallback — nghĩa là production vẫn hiển thị, nhưng dev experience và error state cần cải thiện.

**Khuyến nghị P1:**
1. Thêm **fallback data cho trang sản phẩm** như các trang khác (home/dự án có fallback rồi).
2. Thêm **empty-state / error-state UI**: "Đang cập nhật sản phẩm" + CTA liên hệ, thay vì trang trắng im lặng.
3. Hero của trang sản phẩm thiếu ảnh background (xám trống) — cần đặt ảnh mặc định.

## 3. Trang dự án (`/du-an`) — ✅ Tốt

- Hero chuẩn: "Các dự án đã thực hiện" + nhãn D&L FURNITURE.
- Dự án render đẹp layout so le: **Saroma Villa** (220m², Gỗ óc chó FAS, 2025), **Vinhomes Grand Park** — metadata rõ (diện tích, phòng, vật liệu), CTA "CHI TIẾT" + "ĐẶT LỊCH TƯ VẤN" trên từng card.
- Ảnh dự án thật, chất lượng cao.

**Điểm nhìn thấy:** 8.5/10.

## 4. Quan sát xuyên suốt

- ✅ Không thấy lỗi layout, chữ chồng, overflow ngang ở desktop.
- ✅ Typography nhất quán (serif display + sans body), màu gold/đen/gỗ đồng bộ.
- ✅ Navigation dropdown SẢN PHẨM có chỉ báo mũi tên.
- ✅ Footer đầy đủ: giờ hoạt động, danh mục, liên hệ, email.
- ⚠️ Trang `/san-pham` phụ thuộc API — cần empty/error state (xem mục 2).
- ⚠️ Không kiểm tra được mobile viewport trong phiên này (tool giới hạn) — dựa vào review code trước đó: mobile 7.5/10, cần audit breakpoint 375px thực tế.

## 5. Kết luận

Trực quan trên desktop, website đạt chất lượng **cao cấp hơn hẳn đối thủ noithatlacgia.vn** về thiết kế & trải nghiệm. Việc duy nhất cần sửa ngay từ buổi review này: **trang sản phẩm khi API lỗi phải hiển thị fallback/empty-state**, không được để trang trắng.