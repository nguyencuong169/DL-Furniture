# 🖼️ Hướng Dẫn Thay Thế Ảnh - Walnut Wood Furniture

## 📋 Tóm Tắt
Dự án cần thay thế **35 ảnh** không phù hợp (spa, nhà hàng, v.v.) bằng ảnh nội thất gỗ óc chó chất lượng 4K.

**Trạng thái:** ✅ Tất cả ảnh đã được backup, sẵn sàng thay thế

---

## 🎯 Các Phương Pháp Thay Thế

### **Phương Pháp 1: Chạy Script PowerShell (Tự động)**
Tôi đã tạo một script tự động tải ảnh từ Unsplash:

```powershell
cd C:\MyProjects\DL-Furniture
.\scripts\download-walnut-images.ps1
```

**Lợi ích:**
- ✅ Tự động tải 35 ảnh từ Unsplash (miễn phí, chất lượng cao)
- ✅ Giữ nguyên tên file và cấu trúc thư mục
- ✅ Sẽ thực hiện retry tự động nếu tải thất bại

---

### **Phương Pháp 2: Tải Thủ Công (Nếu Script Thất Bại)**

**Các nguồn ảnh miễn phí:**

1. **Unsplash** (Chất lượng cao, miễn phí)
   - https://unsplash.com/s/photos/walnut-wood-furniture
   - https://unsplash.com/s/photos/luxury-wood-interior
   - https://unsplash.com/s/photos/wooden-furniture-4k

2. **Pexels** (Miễn phí, không cần credit)
   - https://www.pexels.com/search/wooden%20furniture%204k/
   - https://www.pexels.com/search/walnut%20interior/

3. **Pixabay** (Miễn phí, kho lớn)
   - https://pixabay.com/search/walnut%20wood%20furniture/
   - https://pixabay.com/search/luxury%20home%20interior/

**Hướng dẫn tải thủ công:**
1. Mở link ảnh từ một trong các nguồn trên
2. Lưu ảnh với tên file tương ứng (1.jpg, 2.jpg, v.v.)
3. Đặt vào thư mục tương ứng (xem bảng dưới đây)

---

## 📂 Cấu Trúc Thư Mục Ảnh

```
src/assets/img/
├── spa/              (3 ảnh cần thay - modern furniture)
│   ├── 1.jpg        ← Nội thất hiện đại
│   ├── 2.jpg        ← Phòng khách sang trọng
│   └── 3.jpg        ← Thiết kế đương đại
│
├── restaurant/       (3 ảnh cần thay - furniture showcase)
│   ├── 1.jpg        ← Nội thất hiện đại
│   ├── 2.jpg        ← Nội thất gỗ
│   └── 3.jpg        ← Thiết kế sang trọng
│
├── pricing/         (4 ảnh cần thay - furniture & details)
│   ├── 1.jpg        ← Gỗ tự nhiên
│   ├── 2.jpg        ← Chi tiết sản phẩm
│   ├── 3.jpg        ← Kỹ nghệ
│   └── 4.jpg        ← Giới thiệu sản phẩm
│
├── team/            (6 ảnh cần thay - materials & craftsmanship)
│   ├── 1.jpg        ← Vân gỗ
│   ├── 2.jpg        ← Chi tiết chất liệu
│   ├── 3.jpg        ← Chi tiết nội thất
│   ├── 4.jpg        ← Kỹ nghệ
│   ├── 5.jpg        ← Gỗ tự nhiên
│   └── 6.jpg        ← Chi tiết xưởng
│
├── news/            (6 ảnh cần thay - interior inspiration)
│   ├── 1.jpg        ← Nội thất hiện đại
│   ├── 2.jpg        ← Thiết kế nội thất
│   ├── 3.jpg        ← Hiện đại
│   ├── 4.jpg        ← Phòng khách
│   ├── 5.jpg        ← Nội thất nhà
│   └── 6.jpg        ← Cảm hứng thiết kế
│
├── slider/          (13 ảnh hero - luxury showcase)
│   ├── 1.jpg ← 13.jpg (Ảnh slide trình bày)
│   └── ...
│
└── *.backup/        (Backup thư mục - giữ ảnh gốc)
```

---

## ✅ Yêu Cầu Ảnh

| Yêu Cầu | Chi Tiết |
|---------|----------|
| **Định dạng** | JPG (tối ưu) hoặc PNG |
| **Độ phân giải** | 1920×1080 hoặc cao hơn (4K) |
| **Chủ đề** | Nội thất gỗ óc chó, sang trọng, hiện đại |
| **Kích thước file** | < 500KB/ảnh (để tối ưu tốc độ) |
| **Chất lượng** | Sắc nét, chuyên nghiệp, luxury |

---

## 🔄 Quy Trình Thay Thế

### Bước 1: Tải Ảnh
```powershell
# Option A: Script tự động
.\scripts\download-walnut-images.ps1

# Option B: Tải thủ công từ liên kết trên
```

### Bước 2: Đặt Ảnh Đúng Vị Trí
- Ảnh từ script sẽ tự động đặt vào thư mục đúng
- Nếu tải thủ công, đặt vào `src/assets/img/{category}/1.jpg` v.v.

### Bước 3: Xác Minh (Tùy chọn)
```bash
# Kiểm tra tất cả ảnh đã được thay thế
npm run build

# Hoặc mở trang web để xem kết quả:
npm run dev
# Truy cập: http://localhost:3000
```

---

## 🛡️ Backup & Khôi Phục

**Ảnh gốc đã được backup:**
```
src/assets/img/
├── spa.backup/
├── restaurant.backup/
├── pricing.backup/
├── team.backup/
├── news.backup/
└── slider.backup/
```

**Để khôi phục ảnh gốc:**
```powershell
# Khôi phục toàn bộ
Copy-Item -Path "src/assets/img/*.backup/*" -Destination "src/assets/img/" -Force -Recurse

# Hoặc khôi phục một danh mục
Copy-Item -Path "src/assets/img/spa.backup/*" -Destination "src/assets/img/spa/" -Force
```

---

## 📝 Lưu Ý Kỹ Thuật

### Ảnh được sử dụng trong code:
1. **src/utils/news.ts** - Ảnh fallback cho tin tức (restaurant/2.png)
   - ⚠️ Sẽ tự động cập nhật nếu ảnh được thay thế

2. **src/api/serviceClient.ts** - Import ảnh giá (pricing/1.jpg ~ 4.jpg)
   - ✅ Không cần thay đổi code nếu giữ tên file

3. **src/api/teamClient.ts** - Avatar team
   - ✅ Không cần thay đổi code nếu giữ tên file

### Cấu trúc cho phép thay thế mà không cần thay code:
- ✅ Giữ lại **tên file** (1.jpg, 2.jpg, v.v.)
- ✅ Định dạng file có thể thay (JPG ↔ PNG)
- ✅ Nội dung ảnh tùy ý (miễn là phù hợp chủ đề)

---

## 🚀 Tiếp Theo

### Sau khi thay thế ảnh:
1. ✅ Chạy script hoặc tải thủ công
2. ✅ Xác minh ảnh trên website
3. ✅ Commit thay đổi:
   ```bash
   git add src/assets/img/
   git commit -m "Replace spa/restaurant images with walnut furniture 4K images"
   ```

---

## 📞 Hỗ Trợ

**Nếu gặp vấn đề:**
- Script không tải được? → Dùng link tải thủ công ở trên
- Ảnh không hiển thị? → Kiểm tra tên file có đúng không (1.jpg, 2.jpg, v.v.)
- Chất lượng ảnh không tốt? → Tìm ảnh khác từ Unsplash/Pexels

---

**Ngày cập nhật:** 2024
**Trạng thái:** Sẵn sàng thay thế
