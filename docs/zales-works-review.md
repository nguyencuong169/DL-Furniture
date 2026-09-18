# Đánh giá mẫu "OUR WORKs" (Zales) — gì nên học cho D&L Furniture

> Nguồn: ảnh tham khảo do chủ dự án cung cấp (11/09/2026).
> Bối cảnh: vừa xong đợt polish Oak & Origin + redesign Collection (grid kem) / Projects (sân khấu tối).

## Điểm mạnh nổi bật của mẫu

1. **Khung panel tối LỒNG trong nền có texture** — section tối không full-bleed mà là
   một panel bo góc, chừa viền nền ấm quanh 4 mép. Tạo chiều sâu "ảnh trong khung",
   tách bạch khỏi phần phía trên mà không cần divider.
2. **Typography cỡ đại làm graphic** — "OUR WORKs" chiếm gần toàn bề ngang, chữ đậm
   sans, mix hoa/thường. Title không phải để đọc — nó là hình khối trang trí.
3. **Carousel quạt (fan) các card dọc lệch chiều cao** — card giữa (active) cao hơn,
   nổi bật, có badge danh mục ("Rings"); 2 bên thấp dần, đều hướng tâm. Baseline
   so le tạo nhịp thay vì hàng ngang phẳng.
4. **Điều hướng tối giản căn giữa đáy** — 2 nút tròn arrow, không progress bar,
   không số trang.
5. **Palette đơn sắc ấm** (nâu đất → kem → gold) — rất khớp với #1f1d1a / #aa8453 /
   #d7b98a / kem #f8f5f0 mà D&L đang dùng.

## Nên áp dụng cho D&L (theo thứ tự ưu tiên)

### P1 — Panel tối lồng khung cho "Dự án đã hoàn thiện" ⭐ đáng làm nhất
Thay vì full-bleed `width: 100vw`, bọc `.fp-section` trong nền kem của trang,
panel tối `border-radius: 24px`, `margin: 0 24px` (hoặc max-width 1560px như
collection-stage cũ). Lợi ích:
- Kết thúc cảnh "rạp chiếu phim tràn viền" — section tối thành một "bức tranh lớn",
  sang và giữ nhịp kem→tối→kem rõ hơn.
- Giải quyết luôn full-bleed hack `calc(-50vw + 50%)` đang dùng.
- Chi phí thấp: chỉ đổi wrapper + thêm viền nền, giữ nguyên toàn bộ cơ chế bên trong.

### P2 — Fan card lệch chiều cao cho peek cards / collection
Dàn 3 thumb của Projects (hoặc card của Collection) so le: card giữa cao hơn ~40-60px,
2 bên hạ thấp, mọi card nghiêng nhẹ về tâm. Active card có badge danh mục.
Lưu ý: chỉ áp 1 chỗ — chọn Projects (thumbs) vì đã có sẵn 3 card dọc 260×390.

### P3 — Header intro "trên khung"
Mẫu có một hàng intro ngoài panel: title lớn trái + mô tả italic phải, rồi mới
vào panel. D&L có thể đưa "Dự án đã hoàn thiện / Xem tất cả dự án" RA NGOÀI panel
(nền kem, chữ tối), còn bên trong panel chỉ còn sân khấu — panel sẽ sạch và "giá" hơn.

### P4 — Typography đại làm điểm nhấn
Một headline超大 (vd "D&L" hoặc "CÔNG TRÌNH") mờ/nét mảnh chạy sau caption trong
panel, như watermark editorial. Chọn font có sẵn: Barlow Condensed 700 hoặc
Gilda Display. Chỉ dùng 1 lần trên trang, tránh LoF.

## KHÔNG nên học

- **Font sans hình học đầy màn hình** ("OUR WORKs") theo nguyên bản: D&L định vị
  cao cấp gỗ thủ công — serif Gilda mới là chất brand. Học *tỷ lệ* (làm lớn) chứ
  không học *font*.
- **Mix case tùy hứng** ("WORKs") — vui nhưng trái chuẩn cao cấp VN.
- **Bỏ progress/số trang** của Projects hiện tại: mẫu tối giản hơn nhưng D&L có
  autoplay + 5 guards; progress fill là tín hiệu hữu ích, giữ lại.
- **Texture nền marble**: thêm weight ảnh; nếu làm chỉ dùng 1 texture nhẹ <100KB
  hoặc CSS gradient noise.

## Kết luận

Mẫu này bổ sung đúng cái Oak & Origin không có: **chiều sâu khung hình và phàm
độ typography**. Đề xuất lộ trình: P1 (panel lồng khung Projects) → P3 (header ra
ngoài panel) → P2 (fan thumbs) → P4 (tùy chọn). Ước lượng P1+P3 ~ nửa buổi,
không đụng logic JS (autoplay guards, keyboard, magnetic assist giữ nguyên).