<script setup lang="ts">
import { computed } from 'vue'

import router from '../router'

const cateTitle = computed(() => {
  if (router.currentRoute.value.path.startsWith('/san-pham/phong-khach/')) {
    return 'Phòng Khách'
  } else if (router.currentRoute.value.path.startsWith('/san-pham/phong-ngu/')) {
    return 'Phòng Ngủ'
  } else if (router.currentRoute.value.path.startsWith('/san-pham/phong-bep/')) {
    return 'Phòng Bếp'
  } else {
    return 'Sản phẩm'
  }
})
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/1-FQ5yJaaV.jpg"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <span class="hero-line" aria-hidden="true"></span>
            <h5>{{ cateTitle }}</h5>
            <h1>{{ cateTitle }}</h1>
          </div>
        </div>
      </div>
    </div>
    <!-- <Product /> -->
    <router-view></router-view>
  </main>
</template>
