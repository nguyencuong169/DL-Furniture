<script setup lang="ts">
import { reactive, computed } from 'vue'

import Product from '../template/04_ProductComponent.vue'
import router from '../router'

const state = reactive({})

const cateTitle = computed(() => {
  if (router.currentRoute.value.path.startsWith('/product/phong-khach/')) {
    return 'Phòng Khách'
  } else if (router.currentRoute.value.path.startsWith('/product/phong-ngu/')) {
    return 'Phòng Ngủ'
  } else if (router.currentRoute.value.path.startsWith('/product/phong-bep/')) {
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
            <span>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
            </span>
            <h5>{{ cateTitle }}</h5>
            <h1>Rooms & Suites</h1>
          </div>
        </div>
      </div>
    </div>
    <Product />
  </main>
</template>
