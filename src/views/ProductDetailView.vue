<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import {
  fetchProductBySlug,
  fetchRelatedProducts,
  formatPrice,
  getProductSpecs,
  PRODUCT_FEATURES,
  type ProductResponse
} from '../api/productClient'
import PricingComponent from '../template/05_PricingComponent.vue'
import { destroyOwlCarousel, initOwlCarousel } from '../utils/carousel'
import fallbackHeroImage from '../assets/img/slider/3.jpg'
import { setPageSeo, setJsonLd } from '../utils/seo'

const route = useRoute()
const router = useRouter()

const product = ref<ProductResponse | null>(null)
const relatedProducts = ref<ProductResponse[]>([])
const loading = ref(true)
const activeImageIndex = ref(0)
const lightboxOpen = ref(false)

// P1-2: route param là slug SEO (hoặc id dạng số từ URL cũ /san-pham/detail/12)
const slugOrId = computed(() => String(route.params.slug ?? ''))

const applySeo = (p: ProductResponse | null) => {
  setPageSeo({
    title: p
      ? `${p.name} | Nội Thất Gỗ Óc Chó Cao Cấp – D&L Furniture`
      : 'Sản phẩm không tồn tại | D&L Furniture',
    description:
      p?.summary ||
      `Chi tiết sản phẩm nội thất gỗ óc chó tại D&L Furniture: kích thước, chất liệu, báo giá. Hotline 0961 109 897.`,
    path: router.currentRoute.value.path,
    image: p?.mainImage || p?.images[0]?.imageUrl || undefined
  })

  // JSON-LD Product schema — rich snippet cho Google
  if (p) {
    setJsonLd('product-jsonld', {
      '@context': 'https://schema.org',
      '@type': 'Product',
      name: p.name,
      description: p.summary || p.description || '',
      sku: p.sku || undefined,
      category: p.categoryName || undefined,
      image: galleryImages.value.map((img) => new URL(img, window.location.origin).href),
      brand: { '@type': 'Brand', name: 'D&L Furniture' },
      offers: {
        '@type': 'Offer',
        priceCurrency: p.currency || 'VND',
        price: p.price ?? 0,
        availability: 'https://schema.org/InStock',
        url: new URL(router.currentRoute.value.path, window.location.origin).href
      }
    })
  } else {
    setJsonLd('product-jsonld', null)
  }
}

const loadProduct = async (slug: string) => {
  loading.value = true
  try {
    product.value = await fetchProductBySlug(slug)
    activeImageIndex.value = 0

    // URL cũ dạng số → replace lên URL slug chuẩn (canonical, có từ khóa)
    if (product.value && /^\d+$/.test(slug)) {
      void router.replace({
        name: 'product-detail',
        params: { slug: product.value.slug },
        hash: route.hash
      })
    }

    applySeo(product.value)

    // Sản phẩm liên quan cùng danh mục
    if (product.value) {
      relatedProducts.value = await fetchRelatedProducts(product.value, 4)
    }

    // Khởi tạo slider sau khi DOM render xong
    await nextTick()
    await initHeroSlider()
  } catch {
    product.value = null
    applySeo(null)
  } finally {
    loading.value = false
  }
}

onMounted(() => loadProduct(slugOrId.value))

// Fix #2: re-fetch khi route param thay đổi (chuyển từ sản phẩm A → B)
watch(slugOrId, (newSlug, oldSlug) => {
  if (newSlug && newSlug !== oldSlug) loadProduct(newSlug)
})

const galleryImages = computed(() => {
  if (!product.value) return []
  const primary = product.value.mainImage || product.value.images[0]?.imageUrl
  const images = product.value.images.map((image) => image.imageUrl)
  if (primary && !images.includes(primary)) images.unshift(primary)
  return images.filter(Boolean)
})

const hasGallery = computed(() => galleryImages.value.length > 1)

const specs = computed(() => (product.value ? getProductSpecs(product.value.slug) : []))

const activeImage = computed(
  () => galleryImages.value[activeImageIndex.value] || fallbackHeroImage
)

// Hero slider — engine Swiper adapter (custom.js đã gỡ). Swipe qua các ảnh khi có nhiều ảnh.
const HERO_SELECTOR = '.header.slider .owl-carousel'

const initHeroSlider = async () => {
  await nextTick()
  initOwlCarousel(HERO_SELECTOR, {
    items: 1,
    loop: hasGallery.value,
    dots: false,
    nav: hasGallery.value,
    mouseDrag: hasGallery.value,
    autoplay: false
  })
}

const selectImage = (index: number) => {
  activeImageIndex.value = index
}

const openLightbox = () => {
  lightboxOpen.value = true
  document.body.style.overflow = 'hidden'
}

const closeLightbox = () => {
  lightboxOpen.value = false
  document.body.style.overflow = ''
}

const lightboxPrev = () => {
  if (!galleryImages.value.length) return
  activeImageIndex.value =
    (activeImageIndex.value - 1 + galleryImages.value.length) % galleryImages.value.length
}

const lightboxNext = () => {
  if (!galleryImages.value.length) return
  activeImageIndex.value = (activeImageIndex.value + 1) % galleryImages.value.length
}

const handleKeydown = (e: KeyboardEvent) => {
  if (!lightboxOpen.value) return
  if (e.key === 'Escape') closeLightbox()
  if (e.key === 'ArrowLeft') lightboxPrev()
  if (e.key === 'ArrowRight') lightboxNext()
}

onMounted(() => document.addEventListener('keydown', handleKeydown))
onBeforeUnmount(() => {
  document.removeEventListener('keydown', handleKeydown)
  document.body.style.overflow = ''
  destroyOwlCarousel(HERO_SELECTOR)
  setJsonLd('product-jsonld', null)
})

const productImage = (p: ProductResponse) => p.mainImage || p.images[0]?.imageUrl || ''
const productDetailUrl = (p: ProductResponse) => `/san-pham/${p.slug}`
</script>

<template>
  <main>
    <!-- Room Page Slider -->
    <header class="header slider">
      <div class="owl-carousel owl-theme">
        <div class="owl-stage">
          <div
            v-for="(image, index) in galleryImages"
            :key="`${image}-${index}`"
            class="text-center item bg-img"
            data-overlay-dark="3"
            :style="{ backgroundImage: `url(${image})` }"
            role="img"
            :aria-label="product?.images[index]?.caption || product?.name || 'Ảnh sản phẩm'"
          ></div>
          <div
            v-if="!galleryImages.length"
            class="text-center item bg-img"
            data-overlay-dark="3"
            :style="{ backgroundImage: `url(${fallbackHeroImage})` }"
            role="img"
            aria-label="Ảnh đại diện sản phẩm"
          ></div>
        </div>
      </div>
      <!-- arrow down -->
      <div class="arrow bounce text-center">
        <a href="#product-content" data-scroll-nav="1"><i class="ti-arrow-down"></i></a>
      </div>
    </header>

    <!-- Room Content -->
    <section id="product-content" class="rooms-page section-padding" data-scroll-index="1">
      <div class="container">
        <div v-if="loading" class="row">
          <div class="col-md-12">
            <div class="product-detail-loading">Đang tải sản phẩm…</div>
          </div>
        </div>

        <template v-else-if="product">
          <div class="row">
            <div class="col-md-12">
              <nav class="product-breadcrumb" aria-label="Breadcrumb">
                <!-- Trỏ tới route con mặc định 'product-list' (không phải cha 'product')
                     để trang danh mục thực sự render, tránh router-view rỗng. -->
                <RouterLink :to="{ name: 'product-list' }">Sản phẩm</RouterLink>
                <span class="sep">/</span>
                <RouterLink
                  v-if="product.categorySlug"
                  :to="`/san-pham/${product.categorySlug}`"
                >
                  {{ product.categoryName || 'Nội thất gỗ óc chó' }}
                </RouterLink>
                <span v-else>{{ product.categoryName || 'Nội thất gỗ óc chó' }}</span>
                <span class="sep">/</span>
                <span class="current">{{ product.name }}</span>
              </nav>
              <span class="hero-line" aria-hidden="true"></span>
              <div class="section-subtitle">
                D&L Furniture — {{ product.categoryName || 'Nội thất gỗ óc chó' }}
              </div>
              <div class="section-title">{{ product.name }}</div>
            </div>
          </div>

          <div class="row mt-30 product-detail-grid">
            <!-- Gallery + thumbnails -->
            <div class="col-md-5">
              <div class="product-gallery">
                <div
                  class="product-gallery-main"
                  :style="{ backgroundImage: `url(${activeImage})` }"
                  role="img"
                  :aria-label="product.name"
                  @click="openLightbox"
                >
                  <div v-if="hasGallery" class="zoom-hint" aria-hidden="true">
                    <i class="ti-zoom-in"></i>
                  </div>
                </div>
                <div v-if="hasGallery" class="product-gallery-thumbs">
                  <button
                    v-for="(image, index) in galleryImages"
                    :key="`thumb-${image}-${index}`"
                    type="button"
                    class="product-thumb"
                    :class="{ active: index === activeImageIndex }"
                    :aria-label="`Xem ảnh ${index + 1}`"
                    :aria-pressed="index === activeImageIndex"
                    @click="selectImage(index)"
                  >
                    <img :src="image" :alt="`Thumbnail ${index + 1}`" loading="lazy" decoding="async" />
                  </button>
                </div>
              </div>
            </div>

            <!-- Mô tả + thông số -->
            <div class="col-md-7">
              <div class="room-price">
                <span class="room-price-label">Giá niêm yết</span>
                <span class="room-price-value">{{ formatPrice(product) }}</span>
              </div>

              <p class="mt-30 mb-30 product-summary" v-if="product.summary">{{ product.summary }}</p>
              <p class="mb-30 product-description" v-if="product.description">{{ product.description }}</p>
              <p class="mb-30 product-description" v-else>
                Chế tác từ gỗ óc chó tự nhiên, sản phẩm được tuyển chọn và hoàn thiện thủ công để
                giữ trọn vẹn vân gỗ cùng độ bền theo năm tháng.
              </p>

              <!-- Thông số kỹ thuật -->
              <div v-if="specs.length" class="product-specs">
                <h6>Thông số kỹ thuật</h6>
                <dl class="specs-list">
                  <div v-for="spec in specs" :key="spec.label" class="spec-row">
                    <dt>{{ spec.label }}</dt>
                    <dd>{{ spec.value }}</dd>
                  </div>
                </dl>
              </div>

              <div class="row mt-30">
                <div class="col-md-6" v-if="product.sku">
                  <h6>Mã sản phẩm</h6>
                  <ul class="list-unstyled page-list mb-30">
                    <li>
                      <div class="page-list-icon"><span class="ti-check"></span></div>
                      <div class="page-list-text"><p>{{ product.sku }}</p></div>
                    </li>
                  </ul>
                </div>
                <div class="col-md-6" v-if="product.categoryName">
                  <h6>Danh mục</h6>
                  <ul class="list-unstyled page-list mb-30">
                    <li>
                      <div class="page-list-icon"><span class="ti-angle-right"></span></div>
                      <div class="page-list-text"><p>{{ product.categoryName }}</p></div>
                    </li>
                  </ul>
                </div>
              </div>

              <div class="butn-dark mt-15 mb-30">
                <RouterLink :to="{ name: 'contacts' }"><span>Liên hệ tư vấn</span></RouterLink>
              </div>
            </div>
          </div>

          <!-- Cam kết bền vững -->
          <div class="row mt-30">
            <div class="col-md-12">
              <div class="room-facilities">
                <div class="wrap">
                  <div class="row">
                    <div class="col-md-3 col-sm-6" v-for="feature in PRODUCT_FEATURES" :key="feature">
                      <ul>
                        <li><i class="ti-check"></i>{{ feature }}</li>
                      </ul>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>

          <!-- Sản phẩm liên quan -->
          <div v-if="relatedProducts.length" class="row mt-60 related-products">
            <div class="col-md-12">
              <div class="section-subtitle">Cùng danh mục</div>
              <div class="section-title related-title">Sản phẩm liên quan</div>
            </div>
            <div
              v-for="rp in relatedProducts"
              :key="rp.id"
              class="col-md-3 col-sm-6"
            >
              <RouterLink class="related-card" :to="productDetailUrl(rp)">
                <div class="related-media">
                  <img :src="productImage(rp)" :alt="rp.name" loading="lazy" decoding="async" />
                </div>
                <div class="related-info">
                  <div class="related-name">{{ rp.name }}</div>
                  <div class="related-price">{{ formatPrice(rp) }}</div>
                </div>
              </RouterLink>
            </div>
          </div>
        </template>

        <div v-else class="row">
          <div class="col-md-12">
            <div class="product-detail-missing">
              <p>Không tìm thấy sản phẩm. Vui lòng quay lại danh sách sản phẩm.</p>
              <div class="butn-dark mt-15 mb-30">
                <RouterLink :to="{ name: 'product-list' }"><span>Xem danh sách sản phẩm</span></RouterLink>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Pricing -->
    <PricingComponent></PricingComponent>

    <!-- Lightbox -->
    <div v-if="lightboxOpen" class="product-lightbox" @click.self="closeLightbox">
      <button class="lightbox-close" type="button" aria-label="Đóng" @click="closeLightbox">
        <i class="ti-close"></i>
      </button>
      <button class="lightbox-prev" type="button" aria-label="Ảnh trước" @click="lightboxPrev">
        <i class="ti-angle-left"></i>
      </button>
      <img
        :src="activeImage"
        :alt="product?.name || 'Ảnh sản phẩm'"
        class="lightbox-img"
      />
      <button class="lightbox-next" type="button" aria-label="Ảnh tiếp theo" @click="lightboxNext">
        <i class="ti-angle-right"></i>
      </button>
      <div class="lightbox-counter">{{ activeImageIndex + 1 }} / {{ galleryImages.length }}</div>
    </div>
  </main>
</template>

<style scoped>
/* Chỉ bổ sung phần hiển thị giá, bảng thông số & khung reservation;
   toàn bộ layout/typography dùng class gốc của Cappa. */
.room-price {
  display: flex;
  align-items: baseline;
  gap: 14px;
  padding: 18px 22px;
  background: #f8f5f0;
  border-left: 3px solid #aa8453;
}

.room-price-label {
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: #8a8177;
}

.room-price-value {
  font-family: 'Gilda Display', serif;
  font-size: 28px;
  color: #aa8453;
  line-height: 1;
}

.product-breadcrumb {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  gap: 8px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #8a8177;
  margin-bottom: 18px;
}

.product-breadcrumb a {
  color: #aa8453;
}

.product-breadcrumb .sep {
  color: #c9c0b4;
}

.product-breadcrumb .current {
  color: #1e1a16;
}

/* Thông số kỹ thuật — bảng khoa học */
.product-specs {
  margin-bottom: 26px;
  border: 1px solid #ede7dd;
  background: #fff;
}

.product-specs h6 {
  padding: 16px 20px;
  margin: 0;
  border-bottom: 1px solid #ede7dd;
  background: #f8f5f0;
}

.specs-list {
  margin: 0;
  padding: 0;
}

.spec-row {
  display: flex;
  padding: 13px 20px;
}

.spec-row + .spec-row {
  border-top: 1px solid #f1ece4;
}

.spec-row dt {
  flex: 0 0 170px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 2px;
  text-transform: uppercase;
  color: #aa8453;
  font-weight: 600;
}

.spec-row dd {
  flex: 1;
  margin: 0;
  font-size: 15px;
  color: #333;
}

.room-reservation {
  background: #1f1d1a;
  color: #fff;
  padding: 30px;
}

.room-reservation h6 {
  color: #fff;
  margin-bottom: 10px;
}

.room-reservation p {
  color: rgba(255, 255, 255, 0.7);
  font-size: 14px;
  margin-bottom: 18px;
}

.room-reservation .reservations .text p {
  margin: 0;
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
  margin-bottom: 10px;
}

/* ── Gallery + thumbnails (luxury) ────────────────────────────────────────── */
.product-gallery {
  position: sticky;
  top: 100px;
}

.product-gallery-main {
  position: relative;
  width: 100%;
  aspect-ratio: 4 / 5;
  background-size: cover;
  background-position: center;
  cursor: zoom-in;
  overflow: hidden;
}

.product-gallery-main::after {
  content: '';
  position: absolute;
  inset: 0;
  background: linear-gradient(180deg, transparent 60%, rgba(0, 0, 0, 0.15));
  opacity: 0;
  transition: opacity 0.4s ease;
}

.product-gallery-main:hover::after {
  opacity: 1;
}

.zoom-hint {
  position: absolute;
  right: 16px;
  bottom: 16px;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 42px;
  height: 42px;
  color: #fff;
  background: rgba(31, 29, 26, 0.7);
  border: 1px solid rgba(212, 178, 128, 0.5);
  border-radius: 50%;
  font-size: 18px;
  opacity: 0;
  transform: translateY(8px);
  transition:
    opacity 0.35s ease,
    transform 0.35s ease;
}

.product-gallery-main:hover .zoom-hint {
  opacity: 1;
  transform: translateY(0);
}

.product-gallery-thumbs {
  display: flex;
  gap: 10px;
  margin-top: 10px;
  overflow-x: auto;
  scrollbar-width: thin;
}

.product-thumb {
  flex: 0 0 72px;
  height: 90px;
  padding: 0;
  border: 2px solid transparent;
  background: #e9e2d6;
  cursor: pointer;
  overflow: hidden;
  transition: border-color 0.25s ease;
}

.product-thumb img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.product-thumb.active {
  border-color: #aa8453;
}

.product-thumb:hover {
  border-color: #d7b98a;
}

/* ── Sản phẩm liên quan ───────────────────────────────────────────────────── */
.related-products {
  border-top: 1px solid #ede7dd;
  padding-top: 50px;
}

.related-title {
  font-size: 32px;
  margin-bottom: 30px;
}

.related-card {
  display: block;
}

.related-media {
  aspect-ratio: 4 / 5;
  overflow: hidden;
  background: #e9e2d6;
}

.related-media img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
  transition: transform 0.8s cubic-bezier(0.22, 1, 0.36, 1);
}

.related-card:hover .related-media img {
  transform: scale(1.06);
}

.related-info {
  padding: 16px 0 0;
}

.related-name {
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  color: #26221d;
  line-height: 1.3;
  transition: color 0.3s ease;
}

.related-card:hover .related-name {
  color: #aa8453;
}

.related-price {
  margin-top: 6px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 15px;
  letter-spacing: 1px;
  color: #aa8453;
}

/* ── Lightbox ─────────────────────────────────────────────────────────────── */
.product-lightbox {
  position: fixed;
  inset: 0;
  z-index: 10000;
  display: flex;
  align-items: center;
  justify-content: center;
  background: rgba(15, 13, 10, 0.92);
  backdrop-filter: blur(4px);
}

.lightbox-img {
  max-width: 85vw;
  max-height: 85vh;
  object-fit: contain;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.5);
}

.lightbox-close,
.lightbox-prev,
.lightbox-next {
  position: absolute;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 52px;
  height: 52px;
  padding: 0;
  color: #fff;
  background: rgba(255, 255, 255, 0.08);
  border: 1px solid rgba(212, 178, 128, 0.4);
  border-radius: 50%;
  font-size: 20px;
  cursor: pointer;
  transition:
    background 0.25s ease,
    border-color 0.25s ease;
}

.lightbox-close:hover,
.lightbox-prev:hover,
.lightbox-next:hover {
  background: rgba(170, 132, 83, 0.3);
  border-color: #aa8453;
}

.lightbox-close {
  top: 24px;
  right: 24px;
}

.lightbox-prev {
  left: 24px;
  top: 50%;
  transform: translateY(-50%);
}

.lightbox-next {
  right: 24px;
  top: 50%;
  transform: translateY(-50%);
}

.lightbox-counter {
  position: absolute;
  bottom: 24px;
  left: 50%;
  transform: translateX(-50%);
  color: rgba(255, 255, 255, 0.6);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  letter-spacing: 2px;
}

/* ── Mô tả sản phẩm — typography sang trọng ────────────────────────────────── */
.product-summary {
  font-size: 17px;
  line-height: 1.8;
  color: #444;
  font-style: italic;
  border-left: 2px solid #aa8453;
  padding-left: 18px;
}

.product-description {
  font-size: 15px;
  line-height: 1.85;
  color: #555;
}

@media (max-width: 991px) {
  .room-reservation {
    margin-top: 24px;
  }
  .spec-row dt {
    flex-basis: 130px;
  }
  .product-gallery {
    position: static;
    margin-bottom: 30px;
  }
  .related-title {
    font-size: 26px;
  }
}

@media (max-width: 767px) {
  .product-gallery-main {
    aspect-ratio: 1 / 1;
  }
  .lightbox-close,
  .lightbox-prev,
  .lightbox-next {
    width: 44px;
    height: 44px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .related-media img,
  .product-gallery-main::after,
  .zoom-hint,
  .related-name {
    transition: none;
  }
}
</style>