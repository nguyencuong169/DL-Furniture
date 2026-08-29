<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { fetchProductCategories, type ProductCategoryResponse } from '../api/productCategoryClient'

const categories = ref<ProductCategoryResponse[]>([])
const activeIndex = ref(0)
const isLoading = ref(true)

const activeCategory = computed(() => categories.value[activeIndex.value] ?? null)
const categoryCount = computed(() => categories.value.length)
const hasOverflowingRail = computed(() => categoryCount.value > 5)

onMounted(async () => {
  try {
    const response = await fetchProductCategories()
    categories.value = [...response].sort((a, b) => a.displayOrder - b.displayOrder)
  } finally {
    isLoading.value = false
  }
})

const categoryUrl = (category: ProductCategoryResponse) => `/san-pham/${category.slug}`
const categoryNumber = (index: number) => String(index + 1).padStart(2, '0')

const setActiveCategory = (index: number) => {
  activeIndex.value = index
}
</script>

<template>
  <section class="home-collection" aria-labelledby="home-collection-title">
    <div class="container home-collection-heading-wrap">
      <div class="home-collection-heading">
        <div class="home-collection-title-wrap">
          <p class="section-subtitle"><span>D&amp;L Furniture</span></p>
          <h2 id="home-collection-title" class="section-title">Khám phá theo không gian</h2>
        </div>
      </div>
    </div>

    <div v-if="activeCategory" class="collection-stage">
      <div class="collection-stage-media">
        <img
          v-for="(category, index) in categories"
          :key="category.id"
          class="collection-stage-image"
          :class="{ 'is-active': index === activeIndex }"
          :src="category.imageUrl"
          :alt="index === activeIndex ? category.imageAlt : ''"
          :aria-hidden="index !== activeIndex"
          width="1920"
          height="1080"
          loading="lazy"
          decoding="async"
        />
        <span class="collection-stage-overlay" aria-hidden="true"></span>
      </div>

      <div class="container collection-stage-inner" aria-live="polite" aria-atomic="true">
        <div class="collection-stage-count" aria-hidden="true">
          <span>{{ categoryNumber(activeIndex) }}</span>
          <span class="collection-stage-count-line"></span>
          <span>{{ categoryNumber(categoryCount - 1) }}</span>
        </div>

        <RouterLink
          :key="activeCategory.id"
          class="collection-stage-content"
          :to="categoryUrl(activeCategory)"
          :aria-label="`Khám phá danh mục ${activeCategory.name}`"
        >
          <span class="collection-stage-kicker">Không gian sống</span>
          <span class="collection-stage-title">{{ activeCategory.name }}</span>
          <span v-if="activeCategory.description" class="collection-stage-description">
            {{ activeCategory.description }}
          </span>
          <span class="collection-stage-cta">
            Khám phá không gian <i class="ti-arrow-right" aria-hidden="true"></i>
          </span>
        </RouterLink>
      </div>

      <div
        class="collection-rail"
        :class="{ 'collection-rail--overflow': hasOverflowingRail }"
        role="group"
        aria-label="Chọn không gian"
      >
        <button
          v-for="(category, index) in categories"
          :key="category.id"
          class="collection-rail-item"
          :class="{ 'is-active': index === activeIndex }"
          type="button"
          :aria-pressed="index === activeIndex"
          :aria-label="`Hiển thị ${category.name}`"
          @mouseenter="setActiveCategory(index)"
          @focus="setActiveCategory(index)"
          @click="setActiveCategory(index)"
        >
          <span class="collection-rail-number">{{ categoryNumber(index) }}</span>
          <span class="collection-rail-name">{{ category.name }}</span>
          <i class="ti-arrow-right" aria-hidden="true"></i>
        </button>
      </div>
    </div>

    <div v-else class="collection-stage collection-stage--loading" :aria-busy="isLoading">
      <span class="sr-only">Đang tải danh mục sản phẩm</span>
    </div>
  </section>
</template>

<style scoped>
.home-collection {
  padding: 104px 0 24px;
  background: #f1ede6;
  overflow: hidden;
}

.home-collection-heading-wrap {
  position: relative;
  z-index: 2;
}

.home-collection-heading {
  margin-bottom: 22px;
}

.collection-stage {
  position: relative;
  width: min(1560px, calc(100% - 40px));
  height: clamp(650px, 74vh, 760px);
  margin: 0 auto;
  isolation: isolate;
  overflow: hidden;
  background: #191713;
}

.collection-stage-media,
.collection-stage-image,
.collection-stage-overlay {
  position: absolute;
  inset: 0;
}

.collection-stage-image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
  opacity: 0;
  filter: saturate(0.86) contrast(1.02);
  transform: scale(1.025);
  transition:
    opacity 0.7s ease,
    filter 0.5s ease,
    transform 0.5s ease;
}

.collection-stage-image.is-active {
  opacity: 1;
  transform: scale(1);
}

.collection-stage:hover .collection-stage-image.is-active,
.collection-stage:focus-within .collection-stage-image.is-active {
  filter: brightness(75%);
  transform: scale(1.09);
  transition:
    opacity 0.7s ease,
    filter 1s ease,
    transform 1s ease;
}

.collection-stage-overlay {
  z-index: 1;
  background: linear-gradient(
      90deg,
      rgba(13, 12, 10, 0.74) 0%,
      rgba(13, 12, 10, 0.42) 37%,
      transparent 70%
    ),
    linear-gradient(0deg, rgba(13, 12, 10, 0.74) 0%, transparent 48%),
    linear-gradient(180deg, rgba(13, 12, 10, 0.18) 0%, transparent 30%);
}

.collection-stage-inner {
  position: relative;
  z-index: 2;
  height: 100%;
  pointer-events: none;
}

.collection-stage-count {
  position: absolute;
  top: 42px;
  right: 12px;
  display: flex;
  align-items: center;
  gap: 11px;
  color: rgba(255, 255, 255, 0.78);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.15em;
}

.collection-stage-count-line {
  display: block;
  width: 42px;
  height: 1px;
  background: rgba(255, 255, 255, 0.42);
}

.collection-stage-content {
  position: absolute;
  bottom: 148px;
  left: 12px;
  display: block;
  max-width: 570px;
  color: #fff;
  pointer-events: auto;
  animation: collection-content-in 0.65s cubic-bezier(0.22, 1, 0.36, 1) both;
}

.collection-stage-kicker {
  display: block;
  margin-bottom: 13px;
  color: #d3ad7b;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.24em;
  text-transform: uppercase;
}

.collection-stage-title {
  display: block;
  font-family: 'Gilda Display', serif;
  font-size: clamp(54px, 5.4vw, 78px);
  line-height: 1;
  letter-spacing: -0.025em;
}

.collection-stage-description {
  display: block;
  max-width: 500px;
  margin-top: 20px;
  color: rgba(255, 255, 255, 0.8);
  font-size: 15px;
  line-height: 1.75;
}

.collection-stage-cta {
  display: inline-flex;
  align-items: center;
  gap: 13px;
  margin-top: 28px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.45);
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.18em;
  text-transform: uppercase;
  transition:
    border-color 0.3s ease,
    gap 0.3s ease;
}

.collection-stage-content:hover .collection-stage-cta,
.collection-stage-content:focus-visible .collection-stage-cta {
  gap: 18px;
  border-color: #fff;
}

.collection-stage-content:focus-visible {
  outline: 1px solid rgba(255, 255, 255, 0.88);
  outline-offset: 10px;
}

.collection-rail {
  position: absolute;
  z-index: 3;
  right: 0;
  bottom: 0;
  left: 0;
  display: flex;
  height: 104px;
  overflow-x: auto;
  border-top: 1px solid rgba(255, 255, 255, 0.18);
  background: rgba(17, 16, 14, 0.76);
  backdrop-filter: blur(14px);
  scrollbar-width: none;
}

.collection-rail::-webkit-scrollbar {
  display: none;
}

.collection-rail-item {
  position: relative;
  display: grid;
  flex: 1 1 0;
  min-width: 0;
  grid-template-columns: auto 1fr auto;
  align-items: center;
  gap: 18px;
  padding: 0 clamp(24px, 3vw, 52px);
  border: 0;
  border-right: 1px solid rgba(255, 255, 255, 0.12);
  background: transparent;
  color: rgba(255, 255, 255, 0.58);
  text-align: left;
  cursor: pointer;
  transition:
    background 0.35s ease,
    color 0.35s ease;
}

.collection-rail--overflow .collection-rail-item {
  flex: 0 0 clamp(210px, 20vw, 300px);
}

.collection-rail-item::before {
  position: absolute;
  top: -1px;
  right: 50%;
  left: 50%;
  height: 2px;
  background: #c29a68;
  content: '';
  transition:
    right 0.45s cubic-bezier(0.22, 1, 0.36, 1),
    left 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.collection-rail-item:hover,
.collection-rail-item:focus-visible,
.collection-rail-item.is-active {
  background: rgba(255, 255, 255, 0.055);
  color: #fff;
}

.collection-rail-item.is-active::before {
  right: 0;
  left: 0;
}

.collection-rail-item:focus-visible {
  z-index: 1;
  outline: 1px solid rgba(255, 255, 255, 0.8);
  outline-offset: -5px;
}

.collection-rail-number {
  color: #c29a68;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.15em;
}

.collection-rail-name {
  overflow: hidden;
  font-family: 'Gilda Display', serif;
  font-size: clamp(18px, 1.45vw, 22px);
  line-height: 1.15;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.collection-rail-item i {
  font-size: 11px;
  opacity: 0;
  transform: translateX(-7px);
  transition:
    opacity 0.3s ease,
    transform 0.3s ease;
}

.collection-rail-item.is-active i {
  opacity: 0.72;
  transform: translateX(0);
}

.collection-stage--loading {
  background: linear-gradient(
      100deg,
      transparent 30%,
      rgba(255, 255, 255, 0.055) 50%,
      transparent 70%
    ),
    #1b1916;
  background-size: 220% 100%;
  animation: collection-loading 1.5s ease-in-out infinite;
}

@keyframes collection-content-in {
  from {
    opacity: 0;
    transform: translateY(18px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes collection-loading {
  to {
    background-position: -220% 0;
  }
}

@media (max-width: 1199px) {
  .collection-stage {
    width: calc(100% - 30px);
    height: 650px;
  }

  .collection-stage-content {
    right: 12px;
    bottom: 142px;
  }

  .collection-rail-item {
    gap: 13px;
    padding: 0 24px;
  }
}

@media (max-width: 991px) {
  .home-collection {
    padding-top: 86px;
  }

  .collection-stage {
    height: 630px;
  }

  .collection-stage-overlay {
    background: linear-gradient(
        90deg,
        rgba(13, 12, 10, 0.68) 0%,
        rgba(13, 12, 10, 0.25) 60%,
        transparent 100%
      ),
      linear-gradient(0deg, rgba(13, 12, 10, 0.82) 0%, transparent 62%);
  }

  .collection-stage-content {
    left: 30px;
    max-width: 520px;
  }

  .collection-stage-count {
    right: 30px;
  }

  .collection-rail-item,
  .collection-rail--overflow .collection-rail-item {
    flex: 0 0 44%;
  }
}

@media (max-width: 767px) {
  .home-collection {
    padding: 74px 0 0;
  }

  .home-collection-heading {
    margin-bottom: 32px;
  }

  .collection-stage {
    width: 100%;
    height: 600px;
  }

  .collection-stage-image {
    object-position: center;
  }

  .collection-stage-overlay {
    background: linear-gradient(
        0deg,
        rgba(13, 12, 10, 0.9) 0%,
        rgba(13, 12, 10, 0.36) 58%,
        rgba(13, 12, 10, 0.08) 100%
      ),
      linear-gradient(90deg, rgba(13, 12, 10, 0.28) 0%, transparent 75%);
  }

  .collection-stage-count {
    top: 24px;
    right: 15px;
  }

  .collection-stage-content {
    right: 20px;
    bottom: 120px;
    left: 20px;
    max-width: none;
  }

  .collection-stage-kicker {
    margin-bottom: 10px;
    font-size: 11px;
  }

  .collection-stage-title {
    font-size: clamp(44px, 14vw, 58px);
  }

  .collection-stage-description {
    display: -webkit-box;
    max-width: 340px;
    margin-top: 14px;
    overflow: hidden;
    font-size: 14px;
    line-height: 1.6;
    -webkit-box-orient: vertical;
    -webkit-line-clamp: 2;
  }

  .collection-stage-cta {
    margin-top: 20px;
  }

  .collection-rail {
    height: 92px;
    scroll-snap-type: x proximity;
  }

  .collection-rail-item,
  .collection-rail--overflow .collection-rail-item {
    flex-basis: 76%;
    gap: 13px;
    padding: 0 20px;
    scroll-snap-align: start;
  }

  .collection-rail-name {
    font-size: 20px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .collection-stage-image,
  .collection-stage-content,
  .collection-stage-cta,
  .collection-rail-item,
  .collection-rail-item::before,
  .collection-rail-item i {
    animation: none;
    transition: none;
  }

  .collection-stage--loading {
    animation: none;
  }
}
</style>
