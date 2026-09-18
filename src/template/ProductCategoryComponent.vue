<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ArrowUpRight } from 'lucide-vue-next'
import { fetchProductCategories, type ProductCategoryResponse } from '../api/productCategoryClient'

const categories = ref<ProductCategoryResponse[]>([])
const isLoading = ref(true)

onMounted(async () => {
  try {
    const response = await fetchProductCategories()
    categories.value = [...response].sort((a, b) => a.displayOrder - b.displayOrder)
  } finally {
    isLoading.value = false
  }
})

const categoryUrl = (category: ProductCategoryResponse) => `/san-pham/${category.slug}`

const CATEGORY_TAGLINES: Record<string, string> = {
  'phong-khach': 'Nơi khách bước vào đầu tiên — cũng là nơi kể gu sống của bạn',
  'phong-ngu': 'Thiết kế cho giấc ngủ ngon — không chỉ đẹp mắt',
  'phong-bep': 'Trái tim của mọi ngôi nhà — nơi cả nhà sum họp mỗi ngày'
}

const categoryTagline = (category: ProductCategoryResponse) =>
  CATEGORY_TAGLINES[category.slug] ?? category.description?.split(/[.!]/)[0] ?? ''

const skeletonPlaceholders = computed(() => Array.from({ length: 3 }, (_, i) => i))
</script>

<template>
  <section class="product-categories section-padding bg-cream" aria-labelledby="pc-title">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle">D&L Furniture</div>
          <div id="pc-title" class="section-title">Khám phá theo không gian</div>
        </div>
      </div>

      <div v-if="categories.length" class="row pc-grid">
        <div v-for="category in categories" :key="category.id" class="col-md-4 col-sm-6">
          <RouterLink
            class="pc-card"
            :to="categoryUrl(category)"
            :aria-label="`Khám phá danh mục ${category.name}`"
          >
            <span class="pc-media">
              <img
                :src="category.imageUrl"
                :alt="category.imageAlt"
                width="800"
                height="1000"
                loading="lazy"
                decoding="async"
              />
              <span class="pc-badge" aria-hidden="true">
                <ArrowUpRight :size="16" :stroke-width="1.75" />
              </span>
            </span>
            <span class="pc-name">{{ category.name }}</span>
            <span class="pc-rule" aria-hidden="true"></span>
            <span v-if="categoryTagline(category)" class="pc-tag">{{ categoryTagline(category) }}</span>
          </RouterLink>
        </div>
      </div>

      <div v-else class="row pc-grid" :aria-busy="isLoading">
        <span class="sr-only">Đang tải danh mục sản phẩm</span>
        <div v-for="n in skeletonPlaceholders" :key="n" class="col-md-4 col-sm-6">
          <div class="pc-skeleton"></div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.product-categories {
  background: #f8f5f0;
}

.pc-grid {
  margin-top: 36px;
  row-gap: 30px;
}

.pc-card {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.pc-media {
  position: relative;
  display: block;
  width: 100%;
  aspect-ratio: 4 / 5;
  overflow: hidden;
  background: #e9e2d6;
}

.pc-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transform: scale(1.001);
  transition:
    transform 0.8s cubic-bezier(0.22, 1, 0.36, 1),
    filter 0.5s ease;
}

.pc-card:hover .pc-media img,
.pc-card:focus-visible .pc-media img {
  transform: scale(1.06);
}

.pc-badge {
  position: absolute;
  right: 14px;
  bottom: 14px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 38px;
  height: 38px;
  color: #fff;
  background: rgba(31, 29, 26, 0.85);
  border: 1px solid rgba(212, 178, 128, 0.55);
  border-radius: 50%;
  opacity: 0;
  transform: translateY(8px);
  transition:
    opacity 0.35s ease,
    transform 0.35s ease;
}

.pc-card:hover .pc-badge,
.pc-card:focus-visible .pc-badge {
  opacity: 1;
  transform: translateY(0);
}

.pc-name {
  margin-top: 20px;
  color: #26221d;
  font-family: 'Gilda Display', serif;
  font-size: clamp(19px, 1.6vw, 23px);
  line-height: 1.25;
  transition: color 0.3s ease;
}

.pc-card:hover .pc-name,
.pc-card:focus-visible .pc-name {
  color: #aa8453;
}

.pc-rule {
  display: block;
  width: 34px;
  height: 2px;
  margin-top: 12px;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
  transform-origin: left center;
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.pc-card:hover .pc-rule,
.pc-card:focus-visible .pc-rule {
  transform: scaleX(1.8);
}

.pc-tag {
  margin-top: 11px;
  color: #6f6a62;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
  line-height: 1.55;
}

.pc-card:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 6px;
}

.pc-skeleton {
  aspect-ratio: 4 / 5;
  background:
    linear-gradient(100deg, transparent 30%, rgba(255, 255, 255, 0.55) 50%, transparent 70%),
    #e9e2d6;
  background-size: 220% 100%;
  animation: pc-loading 1.5s ease-in-out infinite;
}

@keyframes pc-loading {
  to {
    background-position: -220% 0;
  }
}

@media (max-width: 767px) {
  .pc-media {
    aspect-ratio: 16 / 10;
  }
  .pc-grid {
    row-gap: 30px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .pc-media img,
  .pc-badge,
  .pc-rule,
  .pc-name,
  .pc-skeleton {
    transition: none;
    animation: none;
  }
}
</style>