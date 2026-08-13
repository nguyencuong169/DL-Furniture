<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { fetchProductCategories, type ProductCategoryResponse } from '../api/productCategoryClient'

const categories = ref<ProductCategoryResponse[]>([])

onMounted(async () => {
  categories.value = await fetchProductCategories()
})

const categoryUrl = (category: ProductCategoryResponse) => `/san-pham/${category.slug}`

const categoryNumber = (index: number) => String(index + 1).padStart(2, '0')
</script>

<template>
  <section class="home-collection section-padding" aria-labelledby="home-collection-title">
    <div class="container">
      <div class="home-collection-heading">
        <div>
          <p class="section-subtitle">D&amp;L Furniture</p>
          <h2 id="home-collection-title" class="section-title">Khám phá theo không gian</h2>
        </div>
        <RouterLink class="home-collection-all" to="/san-pham">
          Xem tất cả sản phẩm <i class="ti-arrow-right" aria-hidden="true"></i>
        </RouterLink>
      </div>

      <div class="home-collection-panels" aria-label="Danh mục sản phẩm">
        <article
          v-for="(category, index) in categories"
          :key="category.id"
          class="collection-panel"
        >
          <RouterLink
            :to="categoryUrl(category)"
            class="collection-panel-link"
            :aria-label="`Khám phá danh mục ${category.name}`"
          >
            <img
              class="collection-panel-image"
              :src="category.imageUrl"
              :alt="category.imageAlt"
              width="900"
              height="1200"
              loading="lazy"
              decoding="async"
            />
            <span class="collection-panel-overlay" aria-hidden="true"></span>

            <span class="collection-panel-index">{{ categoryNumber(index) }}</span>

            <span class="collection-panel-action" aria-hidden="true">
              <i class="ti-zoom-in"></i>
            </span>

            <span class="collection-panel-content">
              <span class="collection-panel-kicker">Không gian sống</span>
              <span class="collection-panel-title">{{ category.name }}</span>
              <span v-if="category.description" class="collection-panel-description">
                {{ category.description }}
              </span>
              <span class="collection-panel-cta">
                Khám phá <i class="ti-arrow-right" aria-hidden="true"></i>
              </span>
            </span>
          </RouterLink>
        </article>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-collection {
  background: #f8f5f0;
  overflow: hidden;
}

.home-collection-heading {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 30px;
  margin-bottom: 42px;
}

.home-collection-heading .section-subtitle {
  margin-bottom: 6px;
}

.home-collection-heading .section-title {
  margin: 0;
}

.home-collection-all {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  color: #8e6c41;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.14em;
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(170, 132, 83, 0.45);
  text-transform: uppercase;
}

.home-collection-panels {
  display: flex;
  height: 640px;
  overflow: hidden;
  background: #171613;
}

.collection-panel {
  flex: 1 1 0;
  min-width: 0;
  overflow: hidden;
  transition: flex 0.65s cubic-bezier(0.22, 1, 0.36, 1);
}

.collection-panel-link {
  position: relative;
  display: block;
  width: 100%;
  height: 100%;
  overflow: hidden;
  color: #fff;
}

.collection-panel-image {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: saturate(0.82) brightness(0.78);
  transition:
    filter 0.65s ease,
    transform 0.9s cubic-bezier(0.22, 1, 0.36, 1);
}

.collection-panel-overlay {
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, rgba(13, 12, 10, 0.38) 0%, transparent 36%),
    linear-gradient(0deg, rgba(13, 12, 10, 0.92) 0%, rgba(13, 12, 10, 0.08) 58%);
  transition: background 0.5s ease;
}

.collection-panel-index {
  position: absolute;
  top: 30px;
  left: 30px;
  color: rgba(255, 255, 255, 0.9);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 15px;
  letter-spacing: 0.12em;
}

.collection-panel-action {
  position: absolute;
  top: 48%;
  left: 50%;
  display: grid;
  width: 62px;
  height: 62px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.72);
  border-radius: 50%;
  color: #fff;
  font-size: 20px;
  opacity: 0;
  transform: translate(-50%, -38%) scale(0.84);
  transition:
    opacity 0.35s ease,
    transform 0.45s ease;
}

.collection-panel-content {
  position: absolute;
  right: 30px;
  bottom: 32px;
  left: 30px;
  color: #fff;
}

.collection-panel-kicker {
  display: block;
  margin-bottom: 10px;
  color: #d5b182;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.2em;
  text-transform: uppercase;
}

.collection-panel-title {
  display: block;
  font-family: 'Gilda Display', serif;
  font-size: clamp(30px, 2.55vw, 42px);
  line-height: 1.08;
}

.collection-panel-description {
  display: block;
  max-width: 390px;
  max-height: 0;
  margin-top: 0;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.78);
  font-size: 14px;
  line-height: 1.65;
  opacity: 0;
  transform: translateY(12px);
  transition:
    max-height 0.5s ease,
    margin-top 0.5s ease,
    opacity 0.35s ease 0.08s,
    transform 0.45s ease 0.08s;
}

.collection-panel-cta {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-top: 20px;
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.16em;
  opacity: 0.78;
  text-transform: uppercase;
  transform: translateX(-8px);
  transition:
    opacity 0.35s ease,
    transform 0.35s ease;
}

.collection-panel:hover,
.collection-panel:focus-within {
  flex-grow: 1.35;
}

.collection-panel:hover .collection-panel-image,
.collection-panel:focus-within .collection-panel-image {
  filter: saturate(1) brightness(0.9);
  transform: scale(1.045);
}

.collection-panel:hover .collection-panel-action,
.collection-panel:focus-within .collection-panel-action {
  opacity: 1;
  transform: translate(-50%, -50%) scale(1);
}

.collection-panel:hover .collection-panel-description,
.collection-panel:focus-within .collection-panel-description {
  max-height: 100px;
  margin-top: 14px;
  opacity: 1;
  transform: translateY(0);
}

.collection-panel:hover .collection-panel-cta,
.collection-panel:focus-within .collection-panel-cta {
  opacity: 1;
  transform: translateX(0);
}

@media (max-width: 1199px) {
  .home-collection-panels {
    height: 560px;
  }

  .collection-panel-content {
    right: 24px;
    bottom: 26px;
    left: 24px;
  }

  .collection-panel-description {
    display: none;
  }
}

@media (max-width: 991px) {
  .home-collection-panels {
    display: grid;
    height: 560px;
    grid-auto-columns: 72%;
    grid-auto-flow: column;
    gap: 12px;
    margin-right: -30px;
    padding-right: 30px;
    overflow-x: auto;
    background: transparent;
    scroll-snap-type: x mandatory;
    scrollbar-width: none;
  }

  .home-collection-panels::-webkit-scrollbar {
    display: none;
  }

  .collection-panel {
    scroll-snap-align: start;
  }

  .collection-panel-action {
    opacity: 1;
    transform: translate(-50%, -50%) scale(0.92);
  }
}

@media (max-width: 767px) {
  .home-collection {
    padding: 78px 0;
    overflow: hidden;
  }

  .home-collection-heading {
    display: block;
    margin-bottom: 30px;
  }

  .home-collection-heading .section-title {
    font-size: 40px;
    line-height: 1.14;
  }

  .home-collection-all {
    margin-top: 20px;
  }

  .home-collection-panels {
    height: 510px;
    grid-auto-columns: 86%;
    gap: 14px;
    margin-right: -15px;
    padding-right: 15px;
  }

  .collection-panel-index {
    top: 24px;
    left: 22px;
  }

  .collection-panel-content {
    right: 22px;
    bottom: 24px;
    left: 22px;
  }

  .collection-panel-title {
    font-size: 34px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .collection-panel,
  .collection-panel-action,
  .collection-panel-cta,
  .collection-panel-description,
  .collection-panel-image {
    transition: none;
  }
}
</style>
