<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { fetchProductBySlug, formatPrice, type ProductResponse } from '../api/productClient'
import PricingComponent from '../template/05_PricingComponent.vue'
import { destroyOwlCarousel, initOwlCarousel } from '../utils/carousel'
import fallbackHeroImage from '../assets/img/slider/3.jpg'
import { setPageSeo } from '../utils/seo'

const route = useRoute()
const router = useRouter()

const product = ref<ProductResponse | null>(null)
const loading = ref(true)

// P1-2: route param là slug SEO (hoặc id dạng số từ URL cũ /san-pham/detail/12)
const slugOrId = computed(() => String(route.params.slug ?? ''))

onMounted(async () => {
  product.value = await fetchProductBySlug(slugOrId.value)
  // URL cũ dạng số → replace lên URL slug chuẩn (canonical, có từ khóa)
  if (product.value && /^\d+$/.test(slugOrId.value)) {
    void router.replace({
      name: 'product-detail',
      params: { slug: product.value.slug },
      hash: route.hash
    })
  }
  setPageSeo({
    title: product.value
      ? `${product.value.name} | Nội Thất Gỗ Óc Chó Cao Cấp – D&L Furniture`
      : 'Sản phẩm không tồn tại | D&L Furniture',
    description:
      product.value?.summary ||
      `Chi tiết sản phẩm nội thất gỗ óc chó tại D&L Furniture: kích thước, chất liệu, báo giá. Hotline 0961 109 897.`,
    path: router.currentRoute.value.path
  })
  loading.value = false
})

const mainImage = computed(() => {
  if (!product.value) return ''
  return product.value.mainImage || product.value.images[0]?.imageUrl || ''
})

// Hero slider 1 slide — init qua Swiper adapter (custom.js đã gỡ).
// Không dots/nav: chỉ cần engine hiển thị slide đúng cấu trúc theme CSS.
const HERO_SELECTOR = '.header.slider .owl-carousel'

const initHeroSlider = async () => {
  await nextTick()
  initOwlCarousel(HERO_SELECTOR, {
    items: 1,
    loop: false,
    dots: false,
    nav: false,
    mouseDrag: false
  })
}

watch(loading, async (isLoading) => {
  if (!isLoading) await initHeroSlider()
})

onBeforeUnmount(() => {
  destroyOwlCarousel(HERO_SELECTOR)
})

const galleryImages = computed(() => {
  if (!product.value) return []
  const primary = product.value.mainImage || product.value.images[0]?.imageUrl
  const images = product.value.images.map((image) => image.imageUrl)
  if (primary && !images.includes(primary)) images.unshift(primary)
  return images
})
</script>

<template>
  <main>
    <!-- Room Page Slider -->
    <header class="header slider">
      <div class="owl-carousel owl-theme">
        <div class="owl-stage">
          <div
            class="text-center item bg-img"
            data-overlay-dark="3"
            :style="{
              backgroundImage: `url(${mainImage || fallbackHeroImage})`
            }"
          ></div>
        </div>
      </div>
      <!-- arrow down -->
      <div class="arrow bounce text-center">
        <a href="#" data-scroll-nav="1" class=""><i class="ti-arrow-down"></i></a>
      </div>
    </header>

    <!-- Room Content -->
    <section class="rooms-page section-padding" data-scroll-index="1">
      <div class="container">
        <div class="row">
          <div class="col-md-12" v-if="loading">
            <div class="product-detail-loading">Đang tải sản phẩm…</div>
          </div>

          <template v-else-if="product">
            <div class="col-md-12">
              <span class="hero-line" aria-hidden="true"></span>
              <div class="section-subtitle">
                D&L Furniture — {{ product.categoryName || 'Sản phẩm' }}
              </div>
              <div class="section-title">{{ product.name }}</div>
            </div>

            <!-- Gallery -->
            <div class="col-md-5" v-if="galleryImages.length">
              <div class="product-gallery">
                <img
                  v-for="(image, index) in galleryImages"
                  :key="index"
                  :src="image"
                  :alt="product.name"
                  loading="lazy"
                />
              </div>
            </div>

            <div :class="galleryImages.length ? 'col-md-7' : 'col-md-12'">
              <p class="mb-30" v-if="product.summary">{{ product.summary }}</p>
              <p class="mb-30" v-if="product.description">{{ product.description }}</p>
              <p class="mb-30" v-else>
                Chế tác từ gỗ óc chó tự nhiên, sản phẩm được tuyển chọn và hoàn thiện thủ công để
                giữ trọn vẹn vân gỗ cùng độ bền theo năm tháng.
              </p>

              <div class="product-detail-price">
                <span class="label">Giá niêm yết</span>
                <span class="value">{{ formatPrice(product) }}</span>
              </div>

              <div class="row mt-30">
                <div class="col-md-6" v-if="product.sku">
                  <h6>Mã sản phẩm</h6>
                  <ul class="list-unstyled page-list mb-30">
                    <li>
                      <div class="page-list-icon"><span class="ti-check"></span></div>
                      <div class="page-list-text">
                        <p>{{ product.sku }}</p>
                      </div>
                    </li>
                  </ul>
                </div>
                <div class="col-md-6" v-if="product.categoryName">
                  <h6>Chất liệu</h6>
                  <ul class="list-unstyled page-list mb-30">
                    <li>
                      <div class="page-list-icon"><span class="ti-check"></span></div>
                      <div class="page-list-text">
                        <p>Gỗ óc chó tự nhiên</p>
                      </div>
                    </li>
                  </ul>
                </div>
                <div class="col-md-12">
                  <h6>Tư vấn &amp; báo giá</h6>
                  <p>
                    Liên hệ đội ngũ D&amp;L Furniture để nhận tư vấn thiết kế miễn phí và báo giá
                    theo hiện trạng công trình của bạn.
                  </p>
                  <div class="butn-dark mt-15 mb-30">
                    <a href="/lien-he"><span>Liên hệ tư vấn</span></a>
                  </div>
                </div>
              </div>
            </div>
          </template>

          <div class="col-md-12" v-else>
            <div class="product-detail-missing">
              <p>Không tìm thấy sản phẩm. Vui lòng quay lại danh sách sản phẩm.</p>
              <div class="butn-dark mt-15 mb-30">
                <a href="/san-pham"><span>Xem sản phẩm</span></a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Pricing -->
    <PricingComponent></PricingComponent>
  </main>
</template>

<style scoped>
.product-gallery {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 12px;
  margin-bottom: 30px;
}

.product-gallery img {
  width: 100%;
  display: block;
  object-fit: cover;
  aspect-ratio: 4 / 3;
}

.product-detail-price {
  display: flex;
  align-items: baseline;
  gap: 14px;
  padding: 18px 22px;
  background: #f8f5f0;
  border-left: 3px solid #aa8453;
  margin-bottom: 22px;
}

.product-detail-price .label {
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: #8a8177;
}

.product-detail-price .value {
  font-family: 'Gilda Display', serif;
  font-size: 30px;
  color: #aa8453;
  line-height: 1;
}

.product-detail-loading,
.product-detail-missing {
  text-align: center;
  padding: 60px 0;
}

.product-detail-loading {
  color: #8a8177;
  font-family: 'Gilda Display', serif;
  font-size: 22px;
}

.product-detail-missing p {
  color: #8a8177;
}
</style>
