<script setup lang="ts">
import { onBeforeUnmount, onMounted, reactive } from 'vue'
import { destroyOwlCarousel, initOwlCarousel, triggerOwlAutoplay } from '../utils/carousel'
import { Phone } from 'lucide-vue-next'
import slider1 from '../assets/img/slider/image.jpg'
import slider2 from '../assets/img/slider/slider_1.jpg'
import slider3 from '../assets/img/slider/artisan-walnut-chair.webp'

const SLIDER_SELECTOR = '.slider-fade .owl-carousel'

const state = reactive({
  overlayDark: 2
})

// Người dùng bật "giảm chuyển động" trong hệ điều hành → không autoplay (WCAG 2.2.2).
const prefersReducedMotion =
  typeof window.matchMedia === 'function' &&
  window.matchMedia('(prefers-reduced-motion: reduce)').matches

// Đồng bộ cấu hình homepage slider trong custom.js để re-init an toàn khi
// quay về trang chủ (custom.js chỉ init một lần lúc document.ready).
const owlOptions = {
  items: 1,
  loop: true,
  dots: true,
  margin: 0,
  autoplay: !prefersReducedMotion,
  autoplayTimeout: 5000,
  // KHÔNG dùng autoplayHoverPause của Owl: nó pause khi chuột chạm bất kỳ đâu
  // trên hero, buộc người dùng phải kéo chuột qua hẳn vùng slider mới chạy lại.
  autoplayHoverPause: false,
  animateOut: 'fadeOut',
  nav: true,
  navText: [
    '<i class="ti-angle-left" aria-hidden="true"></i>',
    '<i class="ti-angle-right" aria-hidden="true"></i>'
  ],
  responsiveClass: true,
  responsive: {
    // Bật dot trên mobile để người dùng biết số lượng slide (trước đây bị tắt < 1000px)
    0: { dots: true, nav: false },
    600: { dots: true },
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

// ── Pause autoplay CHỈ trên CTA chính ("Đặt lịch tư vấn") ──────────────────
// autoplayHoverPause của Owl pause cả vùng hero, gây khó chịu (phải kéo chuột
// qua hẳn slider mới chạy lại). Thay bằng: hover/focus vào nút vàng → stop;
// rời nút → play lại ngay. Vẫn đảm bảo WCAG 2.2.2 vì nội dung tự động chuyển
// động dừng được khi người dùng tương tác, và tắt hẳn với prefers-reduced-motion.
const ctaBindings: Array<[HTMLElement, string, () => void]> = []

const stopHeroAutoplay = () => triggerOwlAutoplay(SLIDER_SELECTOR, 'stop')
const resumeHeroAutoplay = () => triggerOwlAutoplay(SLIDER_SELECTOR, 'play')

const bindCtaHoverPause = (attempts = 15) => {
  const carousel = document.querySelector<HTMLElement>(SLIDER_SELECTOR)
  if (!carousel?.classList.contains('owl-loaded')) {
    // Carousel chưa init xong (async data) — thử lại ngắn.
    if (attempts > 0) window.setTimeout(() => bindCtaHoverPause(attempts - 1), 100)
    return
  }
  carousel.querySelectorAll<HTMLElement>('.butn-dark').forEach((el) => {
    el.addEventListener('mouseenter', stopHeroAutoplay)
    el.addEventListener('mouseleave', resumeHeroAutoplay)
    el.addEventListener('focusin', stopHeroAutoplay)
    el.addEventListener('focusout', resumeHeroAutoplay)
    ctaBindings.push(
      [el, 'mouseenter', stopHeroAutoplay],
      [el, 'mouseleave', resumeHeroAutoplay],
      [el, 'focusin', stopHeroAutoplay],
      [el, 'focusout', resumeHeroAutoplay]
    )
  })
}

const unbindCtaHoverPause = () => {
  ctaBindings.forEach(([el, type, fn]) => el.removeEventListener(type, fn))
  ctaBindings.length = 0
}

onMounted(() => {
  initOwlCarousel(SLIDER_SELECTOR, owlOptions)
  hideCarouselClones()
  bindCtaHoverPause()
})

onBeforeUnmount(() => {
  unbindCtaHoverPause()
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
                <h4>Nội thất gỗ óc chó cao cấp</h4>
                <h1 id="home-hero-title">
                  Vẻ đẹp trường tồn <br />
                  từ <em class="hero-accent">gỗ óc chó</em> thật
                </h1>
                <div class="butn-dark mt-30 mb-30">
                  <RouterLink :to="{ name: 'home', hash: '#consultation' }">
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
        :style="{ backgroundImage: `url(${slider1})` }"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-12">
                <span class="hero-line" aria-hidden="true"></span>
                <h4>Thiết kế &amp; thi công đồng bộ</h4>
                <h1>
                  Từ bản vẽ thiết kế <br />
                  đến từng mối ghép
                </h1>
                <div class="butn-dark mt-30 mb-30">
                  <RouterLink :to="{ name: 'home', hash: '#consultation' }">
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
          <Phone :size="22" :stroke-width="1.5" class="reservation-phone" />
        </div>
        <div class="call"><span>(+84) 961-109-897</span> <br />Tư vấn thiết kế</div>
      </a>
    </div>
  </header>
</template>

<style scoped>
/* ── Caption animation (homepage slider) ───────────────────────────────────
   Mô phỏng đúng hiệu ứng slider-fade gốc của theme Cappa: các phần tử trong
   caption KHÔNG hiện cùng lúc mà xuất hiện lần lượt theo delay so le khi
   slide nhận class `.active` (do Owl Carousel gán):
     hero-line → fadeDown 0.3s → h4 fadeDown 0.5s → h1 fadeUp 0.7s
     → nút fadeUp 0.9s.
   `animation-fill-mode: both` giữ phần tử ẩn trong thời gian delay và cho
   phép chúng trở về ẩn khi slide mất `.active`, nên mỗi lần chuyển slide
   (hoặc quay lại trang chủ) chuỗi hiệu ứng chạy lại từ đầu. */
.header :deep(.owl-item .caption) {
  pointer-events: none;
}

.header :deep(.owl-item.active .caption) {
  pointer-events: auto;
}

/* Trạng thái mặc định: ẩn — tránh nhấp nháy trước khi Owl init xong. */
.header :deep(.owl-item .caption .hero-line),
.header :deep(.owl-item .caption h4),
.header :deep(.owl-item .caption h1),
.header :deep(.owl-item .caption .butn-light),
  .header :deep(.owl-item .caption .butn-dark) {
  opacity: 0;
}

/* Slide đang hiển thị: từng phần tử vào theo thứ tự so le như Cappa. */
.header :deep(.owl-item.active .caption .hero-line) {
  animation: hero-fade-down 0.8s ease 0.3s both;
}

.header :deep(.owl-item.active .caption h4) {
  animation: hero-fade-down 1s ease 0.5s both;
}

.header :deep(.owl-item.active .caption h1) {
  animation: hero-fade-up 1s ease 0.7s both;
}

.header :deep(.owl-item.active .caption .butn-light),
  .header :deep(.owl-item.active .caption .butn-dark) {
  animation: hero-fade-up 1s ease 0.9s both;
}

@keyframes hero-fade-down {
  0% {
    opacity: 0;
    transform: translateY(-40px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes hero-fade-up {
  0% {
    opacity: 0;
    transform: translateY(40px);
  }

  100% {
    opacity: 1;
    transform: translateY(0);
  }
}

@media (prefers-reduced-motion: reduce) {
  .header :deep(.owl-item .caption .hero-line),
  .header :deep(.owl-item .caption h4),
  .header :deep(.owl-item .caption h1),
  .header :deep(.owl-item .caption .butn-light),
  .header :deep(.owl-item .caption .butn-dark) {
    opacity: 1;
    transform: none;
    animation: none;
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

/* Icon goi dien trong khoi reservation: Lucide thay flaticon (thong nhat bo icon) */
.header .reservation-phone {
  color: #fff;
}
</style>
