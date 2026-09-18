<script setup lang="ts">
import { computed, watch } from 'vue'

import router from '../router'
import { setPageSeo } from '../utils/seo'
import { resolveProductBreadcrumb } from '../utils/productCategories'

const breadcrumb = computed(() =>
  resolveProductBreadcrumb(router.currentRoute.value.path)
)

// Eyebrow (dòng nhỏ phía trên): cấp cha nếu có, ngược lại là tên thương hiệu.
const eyebrow = computed(() => breadcrumb.value?.parent || 'D&L Furniture')

// Title (dòng lớn): cấp hiện tại — "Sofa", "Phòng Khách", hoặc "Sản phẩm".
const pageTitle = computed(() => breadcrumb.value?.current || 'Sản phẩm')

// Tiêu đề trang đổi theo danh mục đang xem (phòng khách / phòng ngủ / phòng bếp / danh mục con)
watch(
  pageTitle,
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
      :style="{ backgroundImage: 'url(/media/gallery/walnut-villa-living.webp)' }"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <span class="hero-line" aria-hidden="true"></span>
            <h5>{{ eyebrow }}</h5>
            <h1>{{ pageTitle }}</h1>
          </div>
        </div>
      </div>
    </div>
    <!-- <Product /> -->
    <router-view></router-view>
  </main>
</template>