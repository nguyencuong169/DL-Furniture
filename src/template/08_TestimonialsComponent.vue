<script setup lang="ts">
import testimonialBg from '../assets/img/slider/slider_5.jpg'
import { ref, onMounted, onBeforeUnmount, nextTick } from 'vue'
import { fetchTestimonials, type TestimonialResponse } from '../api/testimonialClient'
import { initOwlCarousel } from '../utils/carousel'

const testimonials = ref<TestimonialResponse[]>([])

/* ── ENTRANCE REVEAL (chạy 1 lần) ─────────────────────────────────────────
   Section render LẶP ĐỢI sau khi fetch (v-if) → observer phải setup SAU
   nextTick. Tự chứa (không phụ thuộc animate-box của theme custom.js) và
   cùng ngôn ngữ fade-up với Craft/Featured. prefers-reduced-motion → hiện
   tĩnh ngay (WCAG 2.2.2). */
const sectionRef = ref<HTMLElement | null>(null)
const isRevealed = ref(false)
let revealObserver: IntersectionObserver | null = null

const prefersReducedMotion =
  typeof window !== 'undefined' &&
  window.matchMedia?.('(prefers-reduced-motion: reduce)').matches

const setupReveal = () => {
  const el = sectionRef.value
  if (!el) return

  if (prefersReducedMotion || typeof IntersectionObserver === 'undefined') {
    isRevealed.value = true
    return
  }

  revealObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          isRevealed.value = true
          revealObserver?.disconnect()
        }
      })
    },
    { threshold: 0.15, rootMargin: '0px 0px -5% 0px' }
  )
  revealObserver.observe(el)
}

const projectLabels: Record<number, string> = {
  1: 'Cải tạo phòng khách & phòng ngủ',
  2: 'Nội thất gỗ óc chó theo yêu cầu',
  3: 'Thiết kế & thi công nội thất trọn gói'
}

const getProjectName = (item: TestimonialResponse) =>
  item.projectName?.trim() || projectLabels[item.id] || 'Dự án nội thất theo yêu cầu'

onMounted(async () => {
  testimonials.value = (await fetchTestimonials()).sort((a, b) => a.sortOrder - b.sortOrder)
  await nextTick()
  initOwlCarousel('.home-testimonials .owl-carousel', {
    loop: true,
    margin: 30,
    mouseDrag: true,
    autoplay: true,
    autoplayHoverPause: true,
    dots: true,
    nav: false,
    navText: [
      "<span class='lnr ti-angle-left'></span>",
      "<span class='lnr ti-angle-right'></span>"
    ],
    responsiveClass: true,
    responsive: {
      0: { items: 1 },
      600: { items: 1 },
      1000: { items: 1 }
    }
  })
  setupReveal()
})

onBeforeUnmount(() => {
  revealObserver?.disconnect()
})
</script>

<template>
  <section
    v-if="testimonials.length"
    class="testimonials home-testimonials"
    aria-labelledby="testimonials-title"
  >
    <div
      ref="sectionRef"
      class="background bg-img bg-fixed section-padding pb-0"
      :class="{ 'is-revealed': isRevealed }"
      :style="{ backgroundImage: `url(${testimonialBg})` }"
      data-overlay-dark="3"
    >
      <div class="container">
        <div class="row">
          <div class="col-lg-8 offset-lg-2 col-md-10 offset-md-1">
            <div class="testimonials-box">
              <div class="head-box">
                <h6>Khách hàng đánh giá</h6>
                <h2 id="testimonials-title">Khách hàng nói gì về chúng tôi?</h2>
                <div class="line"></div>
              </div>
              <div class="owl-carousel owl-theme">
                <div class="item" v-for="item in testimonials" :key="item.id">
                  <span class="quote"><img src="../assets/img/quot.png" alt="Trích dẫn" /></span>
                  <div class="testimonial-rating" :aria-label="`${item.rating} trên 5 sao`">
                    <i
                      v-for="star in Math.max(0, Math.min(5, Math.round(item.rating)))"
                      :key="star"
                      class="star-rating"
                      aria-hidden="true"
                    ></i>
                  </div>
                  <p>{{ item.content }}</p>
                  <div class="info">
                    <div class="author-img">
                      <img :src="item.avatarImage" :alt="item.customerName" />
                    </div>
                    <div class="cont">
                      <h6>{{ item.customerName }}</h6>
                      <span class="testimonial-project">{{ getProjectName(item) }}</span>
                      <span class="testimonial-location">
                        <i class="ti-location-pin" aria-hidden="true"></i>{{ item.location }}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* ── ENTRANCE REVEAL: khối nội dung trượt lên khi vào viewport (1 lần) ── */
.testimonials-box {
  opacity: 0;
  transform: translateY(28px);
  transition:
    opacity 0.8s ease 0.05s,
    transform 0.8s cubic-bezier(0.25, 1, 0.5, 1) 0.05s;
}

.is-revealed .testimonials-box {
  opacity: 1;
  transform: none;
}

@media (prefers-reduced-motion: reduce) {
  .testimonials-box {
    opacity: 1;
    transform: none;
    transition: none;
  }
}
</style>
