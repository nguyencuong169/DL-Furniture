<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, reactive } from 'vue'
import { initOwlCarousel } from '../utils/carousel'
import slider1 from '../assets/img/slider/slider_1.jpg'
import slider2 from '../assets/img/slider/slider_2.jpg'
import slider3 from '../assets/img/slider/slider_3.jpg'

const state = reactive({
  overlayDark: 3
})
const semanticTimers: number[] = []

const syncCarouselSemantics = () => {
  document.querySelectorAll('.slider-fade .owl-item').forEach((item) => {
    const isClone = item.classList.contains('cloned')
    item.setAttribute('aria-hidden', isClone ? 'true' : 'false')

    item.querySelectorAll('h1').forEach((heading) => {
      if (!isClone) return
      heading.setAttribute('role', 'presentation')
      heading.setAttribute('aria-hidden', 'true')
    })

    item.querySelectorAll('a').forEach((link) => {
      if (link instanceof HTMLElement) link.tabIndex = isClone ? -1 : 0
    })
  })
}

onMounted(async () => {
  await nextTick()
  initOwlCarousel('.slider-fade .owl-carousel', {
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
  })
  ;[0, 250, 750].forEach((delay) => {
    semanticTimers.push(window.setTimeout(syncCarouselSemantics, delay))
  })
})

onBeforeUnmount(() => {
  semanticTimers.forEach((timer) => window.clearTimeout(timer))
})
</script>

<template>
  <header class="header slider-fade" aria-labelledby="home-hero-title">
    <div class="owl-carousel owl-theme">
      <!-- The opacity on the image is made with "data-overlay-dark="number". You can change it using the numbers 0-9. -->
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        :data-background="slider2"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-10 offset-md-1">
                <h4>Nội thất dành riêng cho cách bạn sống</h4>
                <h1 id="home-hero-title" class="hero-title">
                  Biến không gian thành <br />
                  trải nghiệm sống
                </h1>
                <p class="hero-summary">
                  Thiết kế, sản xuất và hoàn thiện nội thất trong một hành trình đồng bộ dành cho
                  từng gia chủ.
                </p>
                <div class="hero-actions">
                  <RouterLink
                    class="hero-cta hero-cta--primary"
                    :to="{ name: 'home', hash: '#consultation' }"
                  >
                    Đặt lịch tư vấn
                  </RouterLink>
                  <RouterLink
                    class="hero-cta hero-cta--secondary"
                    :to="{ name: 'home', hash: '#featured-projects' }"
                  >
                    Xem dự án thực tế
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
        :data-background="slider1"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-10 offset-md-1">
                <h4>Thiết kế &amp; thi công đồng bộ</h4>
                <h2 class="hero-title hero-title--compact">
                  Từ ý tưởng đến <br />không gian hoàn thiện
                </h2>
                <p class="hero-summary">
                  Một đầu mối xuyên suốt từ khảo sát hiện trạng, phát triển thiết kế đến lắp đặt và
                  bàn giao.
                </p>
                <div class="hero-actions">
                  <RouterLink
                    class="hero-cta hero-cta--primary"
                    :to="{ name: 'home', hash: '#consultation' }"
                  >
                    Đặt lịch tư vấn
                  </RouterLink>
                  <RouterLink
                    class="hero-cta hero-cta--secondary"
                    :to="{ name: 'home', hash: '#featured-projects' }"
                  >
                    Xem dự án thực tế
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
        :data-background="slider3"
      >
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-10 offset-md-1">
                <h4>Kỹ nghệ D&amp;L Furniture</h4>
                <h2 class="hero-title">Vật liệu tuyển chọn,<br />hoàn thiện tinh tế</h2>
                <p class="hero-summary">
                  Từ hướng vân, mối ghép đến bề mặt chạm, mỗi chi tiết đều được kiểm soát theo điều
                  kiện sử dụng thực tế.
                </p>
                <div class="hero-actions">
                  <RouterLink
                    class="hero-cta hero-cta--primary"
                    :to="{ name: 'home', hash: '#consultation' }"
                  >
                    Đặt lịch tư vấn
                  </RouterLink>
                  <RouterLink class="hero-cta hero-cta--secondary" to="/thu-vien">
                    Khám phá thư viện
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
    <ul class="hero-assurances" aria-label="Cam kết xuyên suốt của D&L Furniture">
      <li><span>01</span> Khảo sát theo hiện trạng</li>
      <li><span>02</span> Sản xuất &amp; thi công đồng bộ</li>
      <li><span>03</span> Bàn giao &amp; bảo hành minh bạch</li>
    </ul>
  </header>
</template>

<style scoped>
.header {
  position: relative;
}

.header .caption .hero-title {
  position: relative;
  max-width: 940px;
  margin: 0 auto;
  color: #fff;
  font-family: 'Gilda Display', serif;
  font-size: clamp(46px, 4.15vw, 60px);
  font-weight: 400;
  letter-spacing: clamp(5px, 0.58vw, 8px);
  text-transform: uppercase;
}

.header .caption .hero-title--compact {
  max-width: 1100px;
  font-size: clamp(44px, 3.8vw, 57px);
  letter-spacing: clamp(4px, 0.5vw, 7px);
}

.header .caption h4 {
  margin-bottom: 18px;
  text-shadow: 0 2px 18px rgba(0, 0, 0, 0.28);
}

.hero-summary {
  /* max-width: 620px; */
  margin: 20px auto 0;
  color: rgba(255, 255, 255, 0.9);
  font-size: 16px;
  line-height: 1.75;
  text-shadow: 0 2px 20px rgba(0, 0, 0, 0.42);
}

.hero-actions {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 12px;
  margin-top: 27px;
}

.hero-cta {
  display: inline-flex;
  min-width: 178px;
  min-height: 48px;
  align-items: center;
  justify-content: center;
  padding: 0 25px;
  border: 1px solid rgba(255, 255, 255, 0.7);
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.17em;
  text-transform: uppercase;
  transition:
    border-color 0.3s ease,
    background 0.3s ease,
    color 0.3s ease,
    transform 0.3s ease;
}

.hero-cta--primary {
  border-color: #aa8453;
  background: #aa8453;
}

.hero-cta--secondary {
  background: rgba(15, 13, 11, 0.2);
  backdrop-filter: blur(6px);
}

.hero-cta:hover,
.hero-cta:focus-visible {
  border-color: #fff;
  background: #fff;
  color: #222;
  transform: translateY(-2px);
}

.hero-cta:focus-visible,
.reservation a:focus-visible {
  outline: 2px solid #fff;
  outline-offset: 4px;
}

.hero-assurances {
  position: absolute;
  z-index: 6;
  right: 50%;
  bottom: 0;
  display: grid;
  width: min(860px, calc(100% - 280px));
  grid-template-columns: repeat(3, minmax(0, 1fr));
  padding: 0;
  margin: 0;
  background: rgba(18, 16, 13, 0.78);
  backdrop-filter: blur(14px);
  list-style: none;
  transform: translateX(50%);
}

.hero-assurances li {
  display: flex;
  min-height: 76px;
  align-items: center;
  gap: 12px;
  justify-content: center;
  padding: 0 18px;
  border-right: 1px solid rgba(255, 255, 255, 0.14);
  color: rgba(255, 255, 255, 0.82);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.1em;
  text-transform: uppercase;
}

.hero-assurances li:last-child {
  border-right: 0;
}

.hero-assurances span {
  color: #d2aa76;
  font-size: 11px;
  letter-spacing: 0.14em;
}

@media (max-width: 991.98px) {
  .header .caption .hero-title {
    font-size: 46px;
    letter-spacing: 7px;
  }

  .header .caption .hero-title--compact {
    max-width: 900px;
    font-size: 43px;
    letter-spacing: 5px;
  }

  .hero-assurances {
    width: calc(100% - 60px);
  }

  .hero-assurances li {
    padding: 0 12px;
    font-size: 11px;
  }
}

@media (max-width: 575.98px) {
  .header .caption {
    padding-bottom: 34px;
  }

  .header .caption .hero-title {
    font-size: clamp(31px, 9vw, 40px);
    letter-spacing: 3px;
    line-height: 1.25;
  }

  .header .caption .hero-title--compact {
    font-size: clamp(29px, 8.4vw, 37px);
    letter-spacing: 2.5px;
  }

  .header .caption h4 {
    max-width: 300px;
    margin-right: auto;
    margin-left: auto;
    font-size: 12px;
    letter-spacing: 3px;
    line-height: 1.6;
  }

  .hero-summary {
    display: none;
  }

  .hero-actions {
    align-items: stretch;
    flex-direction: column;
    width: min(280px, 100%);
    margin: 26px auto 0;
  }

  .hero-cta {
    width: 100%;
    min-height: 46px;
  }

  .hero-assurances {
    width: 100%;
    grid-template-columns: repeat(3, minmax(0, 1fr));
  }

  .hero-assurances li {
    min-height: 63px;
    gap: 5px;
    flex-direction: column;
    padding: 8px 6px;
    font-size: 9px;
    letter-spacing: 0.05em;
    line-height: 1.35;
    text-align: center;
  }
}

@media (prefers-reduced-motion: reduce) {
  .hero-cta {
    transition: none;
  }
}
</style>
