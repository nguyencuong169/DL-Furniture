<script setup lang="ts">
import testimonialBg from '../assets/img/slider/slider_2.jpg'
import { ref, onMounted, nextTick } from 'vue'
import { fetchTestimonials, type TestimonialResponse } from '../api/testimonialClient'
import { initOwlCarousel } from '../utils/carousel'

const testimonials = ref<TestimonialResponse[]>([])

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
})
</script>

<template>
  <section
    v-if="testimonials.length"
    class="testimonials home-testimonials"
    aria-labelledby="testimonials-title"
  >
    <div
      class="background bg-img bg-fixed section-padding pb-0"
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
.home-testimonials .testimonials-box {
  padding: 40px 44px 42px;
  border: 1px solid rgba(255, 255, 255, 0.11);
  background: rgba(24, 21, 18, 0.7);
  box-shadow: 0 22px 60px rgba(0, 0, 0, 0.18);
  backdrop-filter: blur(5px);
}

.home-testimonials .head-box h6,
.home-testimonials .head-box h2,
.home-testimonials .item p,
.home-testimonials .item .info h6 {
  color: #fff;
}

.home-testimonials .item p {
  max-width: 900px;
  color: rgba(255, 255, 255, 0.9);
  font-size: 16px;
  line-height: 1.78;
  text-shadow: 0 1px 12px rgba(0, 0, 0, 0.28);
}

.home-testimonials .item .info {
  display: flex;
  align-items: center;
  margin-top: 25px;
}

.home-testimonials .item .info .author-img {
  width: 74px;
  height: 74px;
  flex: 0 0 74px;
  float: none;
  border: 2px solid rgba(213, 174, 124, 0.78);
}

.home-testimonials .item .info .author-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.home-testimonials .item .info .cont {
  min-width: 0;
  margin-left: 15px;
}

.home-testimonials .item .info h6 {
  margin-bottom: 8px;
  line-height: 1.25;
}

.home-testimonials .item .info .testimonial-project,
.home-testimonials .item .info .testimonial-location {
  display: block;
  line-height: 1.45;
}

.home-testimonials .item .info .testimonial-project {
  color: #e3c49d;
  font-size: 13px;
  font-weight: 500;
}

.home-testimonials .item .info .testimonial-location {
  margin-top: 2px;
  color: rgba(255, 255, 255, 0.78);
  font-size: 12px;
}

.home-testimonials .testimonial-location i {
  margin-right: 5px;
  color: #d5ae7c;
  font-size: 11px;
}

@media (max-width: 767.98px) {
  .home-testimonials .testimonials-box {
    padding: 31px 24px 34px;
  }

  .home-testimonials .item p {
    font-size: 15px;
    line-height: 1.72;
  }

  .home-testimonials .item .info .author-img {
    width: 66px;
    height: 66px;
    flex-basis: 66px;
  }
}
</style>
