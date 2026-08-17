<script setup lang="ts">
import testimonialBg from '../assets/img/slider/2.jpg'
import { ref, onMounted, nextTick } from 'vue'
import { fetchTestimonials, type TestimonialResponse } from '../api/testimonialClient'
import { initOwlCarousel } from '../utils/carousel'

const testimonials = ref<TestimonialResponse[]>([])

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
                      <span>{{ item.location }}</span>
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

<style scoped></style>
