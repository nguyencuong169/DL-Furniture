<script setup lang="ts">
import { onBeforeUnmount, onMounted, reactive } from 'vue'
import { destroyOwlCarousel, initOwlCarousel } from '../utils/carousel'
import slider1 from '../assets/img/slider/slider_4.jpg'
import slider2 from '../assets/img/slider/slider_1.png'
import slider3 from '../assets/img/slider/artisan-walnut-chair.webp'

const SLIDER_SELECTOR = '.slider-fade .owl-carousel'

const state = reactive({
  overlayDark: 2
})

// Đồng bộ cấu hình homepage slider trong custom.js để re-init an toàn khi
// quay về trang chủ (custom.js chỉ init một lần lúc document.ready).
const owlOptions = {
  items: 1,
  loop: true,
  dots: true,
  margin: 0,
  autoplay: true,
  autoplayTimeout: 5000,
  animateOut: 'fadeOut',
  nav: true,
  navText: [
    '<i class="ti-angle-left" aria-hidden="true"></i>',
    '<i class="ti-angle-right" aria-hidden="true"></i>'
  ],
  responsiveClass: true,
  responsive: {
    0: { dots: false },
    600: { dots: false },
    1000: { dots: true }
  }
}

// Owl carousel loop-mode sao chép các slide (clone) — ẩn chúng khỏi cây
// accessibility để screen reader không đọc trùng nội dung.
const hideCarouselClones = (attempts = 10) => {
  const clones = document.querySelectorAll(`${SLIDER_SELECTOR} .owl-item.cloned`)
  if (!clones.length && attempts > 0) {
    window.setTimeout(() => hideCarouselClones(attempts - 1), 100)
    return
  }
  clones.forEach((clone) => clone.setAttribute('aria-hidden', 'true'))
}

onMounted(() => {
  initOwlCarousel(SLIDER_SELECTOR, owlOptions)
  hideCarouselClones()
})

onBeforeUnmount(() => {
  destroyOwlCarousel(SLIDER_SELECTOR)
})
</script>

<template>
  <header class="header slider-fade" aria-labelledby="home-hero-title">
    <div class="owl-carousel owl-theme">
      <!-- The opacity on the image is made with "data-overlay-dark="number". You can change it using the numbers 0-9. -->
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        :style="{ backgroundImage: `url(${slider2})` }"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-12">
                <span class="hero-line" aria-hidden="true"></span>
                <h4>Trải nghiệm sống đích thực</h4>
                <h1 id="home-hero-title">
                  Không gian <br />
                  tiện nghi đẳng cấp
                </h1>
                <div class="butn-light mt-30 mb-30">
                  <RouterLink
                    :to="{ name: 'home', hash: '#featured-projects' }"
                    data-scroll-nav="1"
                  >
                    <span>Xem dự án thực tế</span>
                  </RouterLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        :style="{ backgroundImage: `url(${slider1})` }"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-12">
                <span class="hero-line" aria-hidden="true"></span>
                <h4>Thiết kế &amp; thi công đồng bộ</h4>
                <h1>
                  Từ ý tưởng đến <br />
                  không gian hoàn thiện
                </h1>
                <div class="butn-light mt-30 mb-30">
                  <RouterLink
                    data-scroll-nav="1"
                    :to="{ name: 'home', hash: '#consultation' }"
                  >
                    <span>Đặt lịch tư vấn</span>
                  </RouterLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        :style="{ backgroundImage: `url(${slider3})` }"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-12">
                <span class="hero-line" aria-hidden="true"></span>
                <h4>Sự lựa chọn tốt nhất</h4>
                <h1>
                  Vật liệu tuyển chọn<br />hoàn thiện <em class="hero-accent">tinh tế</em>
                </h1>
                <div class="butn-light mt-30 mb-30">
                  <RouterLink data-scroll-nav="1" to="/thu-vien">
                    <span>Khám phá thư viện</span>
                  </RouterLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- slider reservation -->
    <div class="reservation">
      <a href="tel:+84961109897" aria-label="Gọi D&L Furniture để tư vấn thiết kế">
        <div class="icon d-flex justify-content-center align-items-center">
          <i class="flaticon-call"></i>
        </div>
        <div class="call"><span>(+84) 961-109-897</span> <br />Tư vấn thiết kế</div>
      </a>
    </div>
  </header>
</template>

<style scoped>
/* ── Caption animation (homepage slider) ───────────────────────────────────
   Hiệu ứng vào/ra cho nội dung caption mỗi slide: khi một slide trở thành
   `.active`, caption fade in + container trượt lên nhẹ; khi slide bị ẩn đi
   (không còn active hoặc đang fadeOut) caption ẩn hẳn. Class `.active` do
   Owl Carousel gán theo đúng slide đang hiển thị, nên hiệu ứng này chạy cho
   CẢ slide đầu tiên lúc load trang lẫn mỗi lần chuyển slide — không cần JS. */
.header :deep(.owl-item .caption) {
  visibility: hidden;
  opacity: 0;
  pointer-events: none;
  transition:
    opacity 180ms ease-out,
    visibility 0s linear 180ms;
}

.header :deep(.owl-item .caption > .container) {
  transform: translateY(10px);
  transition: transform 280ms cubic-bezier(0.22, 1, 0.36, 1);
  will-change: transform;
}

.header :deep(.owl-item.active:not(.owl-animated-out) .caption) {
  visibility: visible;
  opacity: 1;
  pointer-events: auto;
  transition:
    opacity 180ms ease-out,
    visibility 0s linear;
}

.header :deep(.owl-item.active:not(.owl-animated-out) .caption > .container) {
  transform: translateY(0);
}

.header :deep(.owl-item.owl-animated-out .caption) {
  visibility: hidden !important;
  opacity: 0 !important;
  pointer-events: none !important;
  transition: none !important;
}

@media (prefers-reduced-motion: reduce) {
  .header :deep(.owl-item .caption),
  .header :deep(.owl-item .caption > .container) {
    transition: none;
  }

  .header :deep(.owl-item .caption > .container) {
    transform: none;
  }
}

/* Gạch vàng mảnh thay thế star-rating template residue — giữ nhịp thị giác
   trong caption nhưng trung tính hơn, hợp tông luxury. */
.header .caption .hero-line {
  display: block;
  width: 64px;
  height: 2px;
  margin: 0 auto 24px;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
}

/* Accent từ khoá trong hero headline: nghiêng nhẹ + tông đồng, tạo điểm nhấn. */
.header .caption h1 .hero-accent {
  font-style: italic;
  font-weight: 400;
  color: #c39a62;
}

@supports ((-webkit-background-clip: text) or (background-clip: text)) {
  .header .caption h1 .hero-accent {
    color: transparent;
    background: linear-gradient(115deg, #b8894b 0%, #d9b87d 55%, #c39a62 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
  }
}
</style>
