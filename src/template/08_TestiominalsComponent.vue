<script setup lang="ts">
import testimonialBg from '../assets/img/slider/2.jpg'
import { ref, onMounted } from 'vue'
import { fetchTestimonials, type TestimonialResponse } from '../api/testimonialClient'

const testimonials = ref<TestimonialResponse[]>([])

onMounted(async () => {
  testimonials.value = await fetchTestimonials()
})
</script>

<template>
  <section class="testimonials">
    <div
      class="background bg-img bg-fixed section-padding pb-0"
      :style="{ backgroundImage: `url(${testimonialBg})` }"
      data-overlay-dark="3"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-8 offset-md-2">
            <div class="testimonials-box">
              <div class="head-box">
                <h6>Khách hàng đánh giá</h6>
                <h4>Khách hàng nói gì về chúng tôi?</h4>
                <div class="line"></div>
              </div>
              <div class="owl-carousel owl-theme">
                <div class="item" v-for="item in testimonials" :key="item.id">
                  <span class="quote"><img src="../assets/img/quot.png" alt="Trích dẫn" /></span>
                  <p v-html="item.content"></p>
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
