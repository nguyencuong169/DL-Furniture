<script setup lang="ts">
import { ref, computed } from 'vue'
import BookingFormComponent from '../template/11_BookingFormComponent.vue'
import bannerImage from '/media/gallery/artisan-walnut-chair.webp'
import { setPageSeo } from '../utils/seo'
import { Mail, MapPin, Phone } from 'lucide-vue-next'

setPageSeo({
  title: 'Liên hệ',
  description:
    'Liên hệ D&L Furniture để được tư vấn, khảo sát và báo giá nội thất miễn phí trong 24 giờ làm việc. Hotline (+84) 961-109-897.',
  path: '/lien-he'
})

interface FaqItem {
  q: string
  a: string
}

const faqs: FaqItem[] = [
  {
    q: 'Tư vấn và báo giá có mất phí không?',
    a: 'Hoàn toàn miễn phí. Đội ngũ D&L Furniture sẽ lắng nghe nhu cầu, khảo sát hiện trạng (nếu cần) và gửi bản vẽ + báo giá chi tiết trong 3–5 ngày làm việc, kèm phương án tối ưu chi phí cho từng không gian.'
  },
  {
    q: 'Quy trình làm việc của D&L Furniture diễn ra như thế nào?',
    a: 'Quy trình gồm 4 bước: (1) tư vấn và khảo sát hiện trạng, (2) thiết kế 2D/3D và chốt phương án, (3) thi công sản xuất tại xưởng và lắp đặt tại công trình, (4) nghiệm thu, bàn giao và bảo hành. Toàn bộ quy trình đều có cán bộ phụ trách theo dõi và cập nhật tiến độ cho gia chủ.'
  },
  {
    q: 'Nội thất được sản xuất từ chất liệu gì?',
    a: 'Chúng tôi chuyên gỗ tự nhiên và gỗ công nghiệp cao cấp (MDF chống ẩm, veneer, melamine) với phụ kiện nhập khẩu chính hãng. Tùy ngân sách và nhu cầu, chúng tôi sẽ tư vấn loại vật liệu phù hợp nhất, đảm bảo độ bền và thẩm mỹ lâu dài.'
  },
  {
    q: 'Thời gian thi công trung bình là bao lâu?',
    a: 'Với tủ bếp và nội thất phòng ngủ thông dụng, thời gian từ 2–4 tuần tùy độ phức tạp. Các hạng mục lớn như phòng khách tổng thể có thể kéo dài 6–8 tuần. Tiến độ cụ thể sẽ được cam kết rõ trong hợp đồng.'
  },
  {
    q: 'Chính sách bảo hành như thế nào?',
    a: 'Sản phẩm được bảo hành lên đến 24 tháng về kết cấu và phụ kiện, cùng chế độ bảo trì trọn đời với chi phí ưu đãi cho khách hàng cũ. Mọi sự cố phát sinh đều được tiếp nhận và xử lý trong vòng 48 giờ.'
  },
  {
    q: 'Có nhận thiết kế và thi công theo yêu cầu riêng không?',
    a: 'Có. Mỗi công trình đều được thiết kế riêng theo hiện trạng không gian và phong cách của gia chủ — không lặp mẫu đại trà. Bạn chỉ cần để lại thông tin qua form tư vấn bên trên, đội ngũ sẽ liên hệ trong vòng 24 giờ làm việc.'
  },
  {
    q: 'Có giao hàng và lắp đặt tận nơi không?',
    a: 'Có. Chúng tôi giao hàng và lắp đặt hoàn thiện tại công trình trên toàn quốc. Khách hàng nội thành Hà Nội được miễn phí vận chuyển và lắp đặt cho đơn hàng trên một mức giá nhất định.'
  },
  {
    q: 'Phương thức thanh toán như thế nào?',
    a: 'Quý khách thanh toán theo tiến độ: đặt cọc khi ký hợp đồng, thanh toán theo từng giai đoạn thi công và hoàn tất phần còn lại khi nghiệm thu bàn giao. D&L luôn minh bạch trong từng khoản mục của báo giá.'
  }
]

const openIndex = ref(-1)

const toggleWith = (index: number) => {
  openIndex.value = openIndex.value === index ? -1 : index
}

/* ---------- MAP FIX ----------
   Bug cũ: query chỉ "Thạch Xá, Thạch Thất, Hà Nội" (cấp xã) khiến Google tự chọn
   một POI nổi bật gần đó (ví dụ cây xăng) thay vì đúng địa chỉ công ty.
   Fix: dùng địa chỉ đầy đủ "Đường Cầu Liêu, Thạch Xá, Thạch Thất, Hà Nội".
   Đáng tin cậy hơn nữa: điền toạ độ thật (lat,lng) rồi bật USE_COORDS = true —
   lấy bằng cách chuột phải đúng vị trí xưởng trên Google Maps > copy tọa độ. */
const COMPANY_LAT = '21.0333' // TODO: thay bằng lat thật của xưởng
const COMPANY_LNG = '105.5333' // TODO: thay bằng lng thật của xưởng
const USE_COORDS = false // đổi thành true sau khi điền đúng tọa độ ở trên

const FULL_ADDRESS = 'Đường Cầu Liêu, Thạch Xá, Thạch Thất, Hà Nội'

const mapSrc = computed(() =>
  USE_COORDS
    ? `https://maps.google.com/maps?q=${COMPANY_LAT},${COMPANY_LNG}&t=m&z=16&output=embed`
    : `https://maps.google.com/maps?q=${encodeURIComponent(FULL_ADDRESS)}&t=m&z=16&output=embed&iwloc=near`
)

const openInMapsUrl = computed(
  () => `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(FULL_ADDRESS)}`
)
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      :style="{ backgroundImage: `url(${bannerImage})` }"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <h5>Liên hệ D&amp;L</h5>
            <h1>Liên hệ với chúng tôi</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- Contact -->
    <section class="contact section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12 mb-60">
            <p class="section-subtitle"><span>Liên hệ D&L</span></p>
            <h2 class="section-title">Thông tin liên hệ</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-5 mb-60">
            <p>CÔNG TY CỔ PHẦN KIẾN TRÚC NỘI THẤT DŨNG & LINH.</p>
            <div class="reservations mb-30">
              <div class="icon"><span><Phone :size="34" :stroke-width="1.25" /></span></div>
              <div class="text">
                <p>Tư vấn thiết kế</p>
                <a href="tel:+84961109897">(+84) 961-109-897</a>
              </div>
            </div>
            <div class="reservations mb-30">
              <div class="icon"><span><Mail :size="34" :stroke-width="1.25" /></span></div>
              <div class="text">
                <p>Email</p>
                <a href="mailto:info@dl-furniture.com">info@dl-furniture.com</a>
              </div>
            </div>
            <div class="reservations">
              <div class="icon"><span><MapPin :size="34" :stroke-width="1.25" /></span></div>
              <div class="text">
                <p>Địa chỉ</p>
                Đường Cầu Liêu<br />Thạch Xá - Thạch Thất - Hà Nội
              </div>
            </div>
          </div>
          <div class="col-md-7 mb-30">
            <BookingFormComponent compact />
          </div>
        </div>
      </div>
    </section>

    <!-- FAQ Section -->
    <section id="faq" class="faq section-padding bg-cream">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <p class="section-subtitle"><span>Câu hỏi thường gặp</span></p>
            <h2 class="section-title">Những điều bạn cần biết</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <ul class="accordion-box clearfix">
              <li
                v-for="(faq, index) in faqs"
                :key="faq.q"
                class="accordion block"
                :class="{ 'active-block': openIndex === index }"
              >
                <div
                  class="acc-btn"
                  :class="{ active: openIndex === index }"
                  @click="toggleWith(index)"
                >
                  {{ faq.q }}
                </div>
                <div class="acc-content" :class="{ current: openIndex === index }">
                  <div class="content">
                    <div class="text">{{ faq.a }}</div>
                  </div>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>

    <!-- Map Section -->
    <section class="map-section">
      <div class="container">
        <div class="row">
          <div class="col-md-12 map-heading">
            <p class="section-subtitle"><span>Xưởng D&amp;L Furniture</span></p>
            <h2 class="section-title">Tìm đến chúng tôi</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12 map-frame animate-box" data-animate-effect="fadeInUp">
            <a class="map-open-link" :href="openInMapsUrl" target="_blank" rel="noopener">
              Mở trong Google Maps
            </a>
            <iframe
              :src="mapSrc"
              width="100%"
              height="600"
              style="border: 0"
              allowfullscreen="true"
              loading="lazy"
            ></iframe>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
.bg-fixed {
  background-attachment: unset;
}

/* Google Map - brand-toned */
.map-section {
  position: relative;
  background: #f8f5f0;
  padding: 0 0 120px;
}
.map-heading {
  padding-top: 90px;
  margin-bottom: 40px;
}

.map-frame {
  position: relative;
  z-index: 1;
  border-radius: 6px;
  overflow: hidden;
  box-shadow: 0 18px 50px rgba(34, 34, 34, 0.12);
}

.map-open-link {
  position: absolute;
  top: 16px;
  left: 16px;
  z-index: 3;
  background: #fff;
  color: #aa8453;
  font-size: 13px;
  font-weight: 600;
  padding: 8px 14px;
  border-radius: 4px;
  text-decoration: none;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
}

.map-frame iframe {
  display: block;
  width: 100%;
  height: 600px;
  border: 0;
  /* Bỏ hue-rotate (gây lệch tông xanh/lá ở bản trước), giảm sepia/saturate
     để marker và nhãn đường vẫn đọc rõ. */
  filter: grayscale(0.5) sepia(0.25) saturate(0.85) brightness(1.02) contrast(0.95);
}

/* Lớp phủ màu thương hiệu — dùng radial-gradient để KHÔNG nhuộm đều khu vực
   trung tâm bản đồ (nơi marker công ty nằm), giúp marker vẫn nổi bật. */
.map-frame::after {
  content: '';
  position: absolute;
  inset: 0;
  z-index: 2;
  pointer-events: none;
  background: radial-gradient(circle at center, transparent 0%, transparent 15%, #aa8453 70%);
  mix-blend-mode: color;
  opacity: 0.35;
}

/* Mimic Cappa jQuery slideUp/slideDown(300ms) - smooth height animation */
.faq .accordion-box .acc-content {
  display: block;
  max-height: 0;
  overflow: hidden;
  transition: max-height 0.3s ease;
}
.faq .accordion-box .acc-content.current {
  max-height: 600px;
}
</style>