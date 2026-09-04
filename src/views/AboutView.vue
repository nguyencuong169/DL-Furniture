<script setup lang="ts">
import aboutBanner from '../assets/img/slider/1.jpg'
import AboutComponent from '../template/03_AboutComponent.vue'
import PricingComponent from '../template/05_PricingComponent.vue'
import FacilitiesComponent from '../template/07_FacilitiesComponent.vue'
import TeamComponent from '../template/14_TeamComponent.vue'
import TestimonialsComponent from '../template/08_TestimonialsComponent.vue'
import { setPageSeo } from '../utils/seo'

setPageSeo({
  title: 'Giới thiệu',
  description:
    'D&L Furniture — xưởng nội thất thiết kế và thi công gỗ óc chó, gỗ tự nhiên cao cấp tại Hà Nội. Đội ngũ thiết kế, thi công và bảo hành trọn đời.',
  path: '/gioi-thieu'
})
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      :style="{ backgroundImage: `url(${aboutBanner})` }"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <h5>D&L Furniture</h5>
            <h1>Về chúng tôi</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- About -->
    <AboutComponent />

    <!-- Pricing -->
    <PricingComponent />

    <!-- Facilities -->
    <FacilitiesComponent />

    <!-- Team -->
    <TeamComponent />

    <!-- Testimonials -->
    <TestimonialsComponent />
  </main>
</template>

<style></style>
