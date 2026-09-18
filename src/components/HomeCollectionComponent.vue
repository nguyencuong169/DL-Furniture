<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { ArrowUpRight } from 'lucide-vue-next'
import { fetchProductCategories, type ProductCategoryResponse } from '../api/productCategoryClient'

// ==========================================================================
// HomeCollectionComponent — "Khám phá theo không gian" (bản redesign):
//   Trước đây: sân khấu tối full-màn hình + rail chuyển danh mục → NHỊP TRANG
//   bị "2 rạp phim tối liền nhau" khi đứng ngay trước HomeFeaturedProjects.
//   Bây giờ: grid card NỀN KEM kiểu "Crafted with Passion" (Oak & Origin):
//     • Header: subtitle + title + câu viết tay trái | link "Xem tất cả" phải
//     • Card: ảnh dọc 4:5 + gạch gold + tên serif + tagline lợi ích
//   Nhịp mới: Tối(Slider) → Sáng(About, trắng) → Be(Collection) → Tối(Projects).
//   Giữ nguyên logic fetch categories + CATEGORY_TAGLINES từ bản cũ.
// ==========================================================================
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

/* Câu hứa lợi ích ngắn dưới tên danh mục (giữ từ bản rail P2-4).
   Fallback: cắt câu đầu của description từ API nếu slug chưa có trong map. */
const CATEGORY_TAGLINES: Record<string, string> = {
  'phong-khach': 'Nơi khách bước vào đầu tiên — cũng là nơi kể gu sống của bạn',
  'phong-ngu': 'Thiết kế cho giấc ngủ ngon — không chỉ đẹp mắt',
  'phong-bep': 'Trái tim của mọi ngôi nhà — nơi cả nhà sum họp mỗi ngày'
}

const categoryTagline = (category: ProductCategoryResponse) =>
  CATEGORY_TAGLINES[category.slug] ?? category.description?.split(/[.!]/)[0] ?? ''

/* Skeleton 3 ô trong lúc tải danh mục */
const skeletonPlaceholders = computed(() => Array.from({ length: 3 }, (_, i) => i))
</script>

<template>
  <section class="home-collection" aria-labelledby="home-collection-title">
    <div class="container">
      <!-- Header: title trái | link "Xem tất cả" phải (đồng bộ pattern fp-header) -->
      <div class="collection-header">
        <div class="collection-title-wrap">
          <p class="section-subtitle"><span>Bộ sưu tập</span></p>
          <h2 id="home-collection-title" class="section-title">Khám phá theo không gian</h2>
          <p class="collection-script">Mỗi không gian, một câu chuyện.</p>
        </div>
        <RouterLink class="collection-all" to="/san-pham">
          Xem tất cả sản phẩm <i class="ti-arrow-right" aria-hidden="true"></i>
        </RouterLink>
      </div>

      <!-- Grid card danh mục -->
      <div v-if="categories.length" class="collection-grid">
        <RouterLink
          v-for="category in categories"
          :key="category.id"
          class="collection-card"
          :to="categoryUrl(category)"
          :aria-label="`Khám phá danh mục ${category.name}`"
        >
          <span class="collection-card-media">
            <img
              :src="category.imageUrl"
              :alt="category.imageAlt"
              width="800"
              height="1000"
              loading="lazy"
              decoding="async"
            />
            <span class="collection-card-badge" aria-hidden="true">
              <ArrowUpRight :size="16" :stroke-width="1.75" />
            </span>
          </span>
          <span class="collection-card-name">{{ category.name }}</span>
          <span class="collection-card-rule" aria-hidden="true"></span>
          <span v-if="categoryTagline(category)" class="collection-card-tag">
            {{ categoryTagline(category) }}
          </span>
        </RouterLink>
      </div>

      <!-- Skeleton khi đang tải -->
      <div v-else class="collection-grid" :aria-busy="isLoading">
        <span class="sr-only">Đang tải danh mục sản phẩm</span>
        <div v-for="n in skeletonPlaceholders" :key="n" class="collection-card--skeleton"></div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-collection {
  padding: 96px 0 110px;
  /* Nền be (bg-cream #f8f5f0) theo nhịp Cappa:
     Tối(Slider) → Sáng(About, trắng) → Be(Collection) → Tối(Projects) */
  background: #f8f5f0;
}

/* ── HEADER ─────────────────────────────────────────────────────────── */
.collection-header {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 24px;
  margin-bottom: 42px;
}

/* Câu viết tay điểm nhấn — cùng ngôn ngữ Dancing Script với About/Booking */
.collection-script {
  margin: 12px 0 0;
  color: #aa8453;
  font-family: 'Dancing Script', cursive;
  font-size: 26px;
  font-weight: 600;
  line-height: 1.15;
  transform: rotate(-1.5deg);
  transform-origin: left center;
}

/* Link "Xem tất cả sản phẩm" — pattern .fp-all nhưng bản nền sáng */
.collection-all {
  display: inline-flex;
  flex-shrink: 0;
  align-items: center;
  gap: 10px;
  margin-bottom: 6px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(34, 30, 26, 0.25);
  color: #3a362f;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  transition:
    color 0.3s ease,
    border-color 0.3s ease;
}

.collection-all i {
  font-size: 13px;
  transition: transform 0.3s ease;
}

.collection-all:hover {
  color: #aa8453;
  border-color: #aa8453;
}

.collection-all:hover i {
  transform: translateX(4px);
}

.collection-all:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 4px;
}

/* ── GRID CARD ──────────────────────────────────────────────────────── */
.collection-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 30px;
}

.collection-card {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
}

.collection-card-media {
  position: relative;
  display: block;
  width: 100%;
  aspect-ratio: 4 / 5;
  overflow: hidden;
  background: #e9e2d6;
}

.collection-card-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transform: scale(1.001);
  transition:
    transform 0.8s cubic-bezier(0.22, 1, 0.36, 1),
    filter 0.5s ease;
}

.collection-card:hover .collection-card-media img,
.collection-card:focus-visible .collection-card-media img {
  transform: scale(1.06);
}

/* Badge mũi tên ↗ — chất Oak & Origin, chỉ hiện trên hover/focus */
.collection-card-badge {
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

.collection-card:hover .collection-card-badge,
.collection-card:focus-visible .collection-card-badge {
  opacity: 1;
  transform: translateY(0);
}

.collection-card-name {
  margin-top: 20px;
  color: #26221d;
  font-family: 'Gilda Display', serif;
  font-size: clamp(19px, 1.6vw, 23px);
  line-height: 1.25;
  transition: color 0.3s ease;
}

.collection-card:hover .collection-card-name,
.collection-card:focus-visible .collection-card-name {
  color: #aa8453;
}

/* Gạch gold ngắn dưới tên — đúng chi tiết caption của Oak & Origin */
.collection-card-rule {
  display: block;
  width: 34px;
  height: 2px;
  margin-top: 12px;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
  transform-origin: left center;
  transition: transform 0.45s cubic-bezier(0.22, 1, 0.36, 1);
}

.collection-card:hover .collection-card-rule,
.collection-card:focus-visible .collection-card-rule {
  transform: scaleX(1.8);
}

.collection-card-tag {
  margin-top: 11px;
  color: #6f6a62;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
  line-height: 1.55;
}

.collection-card:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 6px;
}

/* ── SKELETON ───────────────────────────────────────────────────────── */
.collection-card--skeleton {
  aspect-ratio: 4 / 5;
  background:
    linear-gradient(100deg, transparent 30%, rgba(255, 255, 255, 0.55) 50%, transparent 70%),
    #e9e2d6;
  background-size: 220% 100%;
  animation: collection-loading 1.5s ease-in-out infinite;
}

@keyframes collection-loading {
  to {
    background-position: -220% 0;
  }
}

/* ── RESPONSIVE ─────────────────────────────────────────────────────── */
@media (max-width: 991px) {
  .home-collection {
    padding: 80px 0 88px;
  }

  .collection-grid {
    gap: 20px;
  }

  .collection-card-tag {
    font-size: 13px;
  }
}

@media (max-width: 767px) {
  .home-collection {
    padding: 70px 0 76px;
  }

  .collection-header {
    flex-direction: column;
    align-items: flex-start;
    gap: 18px;
    margin-bottom: 30px;
  }

  .collection-all {
    margin-bottom: 0;
  }

  .collection-script {
    font-size: 22px;
  }

  .collection-grid {
    gap: 30px;
    grid-template-columns: 1fr;
  }

  /* Mobile: ảnh ngang 16/10 gọn chiều dọc hơn ảnh dọc 4:5 */
  .collection-card-media {
    aspect-ratio: 16 / 10;
  }

  .collection-card-name {
    margin-top: 15px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .collection-card-media img,
  .collection-card-badge,
  .collection-card-rule,
  .collection-card-name,
  .collection-card--skeleton {
    transition: none;
    animation: none;
  }
}
</style>