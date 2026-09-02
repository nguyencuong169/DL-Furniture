<script setup lang="ts">
import { computed, watch } from 'vue'

import router from '../router'
import { setPageSeo } from '../utils/seo'

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

// Tiêu đề trang đổi theo danh mục đang xem (phòng khách / phòng ngủ / phòng bếp)
watch(
  cateTitle,
  (title) =>
    setPageSeo({
      title,
      description:
        'Sản phẩm nội thất gỗ óc chó và gỗ tự nhiên: sofa, bàn trà, giường ngủ, tủ quần áo, bàn ăn, tủ bếp — thiết kế và thi công theo yêu cầu tại D&L Furniture.',
      path: router.currentRoute.value.path
    }),
  { immediate: true }
)
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
