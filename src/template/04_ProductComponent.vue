<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { Ruler, ShieldCheck, Trees, type LucideIcon } from 'lucide-vue-next'
import { fetchProducts, formatPrice, type ProductResponse } from '../api/productClient'

/* Điểm chung của mọi sản phẩm D&L (cam kết thương hiệu) — thay cho 4 icon
   "tiện nghi khách sạn" (giường/bồn tắm/bữa sáng/khăn) thừa hưởng từ theme gốc. */
const PRODUCT_ATTRIBUTES: { icon: LucideIcon; label: string }[] = [
  { icon: Trees, label: 'Gỗ óc chó tự nhiên' },
  { icon: Ruler, label: 'Đo đạc theo hiện trạng' },
  { icon: ShieldCheck, label: 'Bảo hành & bảo trì' }
]

const route = useRoute()
const products = ref<ProductResponse[]>([])

const activeCategory = computed(() => {
  const segments = route.path.replace(/^\/+|\/+$/g, '').split('/')
  const knownCategories = ['phong-ngu', 'phong-khach', 'phong-bep']

  return segments[0] === 'san-pham' && knownCategories.includes(segments[1])
    ? segments[1]
    : undefined
})

const displayedProducts = computed(() => products.value.slice(0, 5))

const loadProducts = async () => {
  products.value = await fetchProducts(
    activeCategory.value ? { category: activeCategory.value } : {}
  )
}

watch(activeCategory, loadProducts, { immediate: true })

const productImage = (product: ProductResponse) =>
  product.mainImage || product.images[0]?.imageUrl || ''

const productDetailUrl = (product: ProductResponse) => `/san-pham/detail/${product.id}`
</script>

<template>
  <section class="rooms1 section-padding bg-cream" data-scroll-index="1">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle">D&L Furniture</div>
          <div class="section-title">Các mẫu nội thất mới nhất</div>
        </div>
      </div>
      <div class="row">
        <div
          v-for="(product, index) in displayedProducts"
          :key="product.id"
          :class="index < 3 ? 'col-md-4' : 'col-md-6'"
        >
          <div class="item">
            <div class="position-re o-hidden">
              <img :src="productImage(product)" :alt="product.name" />
            </div>
            <span class="category">
              <a :href="productDetailUrl(product)">{{ product.categoryName || 'Nội thất' }}</a>
            </span>
            <div class="con">
              <h6>
                <a :href="productDetailUrl(product)">{{ formatPrice(product) }}</a>
              </h6>
              <h5>
                <a :href="productDetailUrl(product)">{{ product.name }}</a>
              </h5>
              <div class="line"></div>
              <ul class="product-attributes">
                <li v-for="attribute in PRODUCT_ATTRIBUTES" :key="attribute.label">
                  <component :is="attribute.icon" :size="15" :stroke-width="1.5" aria-hidden="true" />
                  <span>{{ attribute.label }}</span>
                </li>
              </ul>
              <div class="row facilities">
                <div class="col col-md-12 text-end">
                  <div class="permalink">
                    <a :href="productDetailUrl(product)">
                      Chi tiết <i class="ti-arrow-right"></i>
                    </a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Thuộc tính sản phẩm: icon Lucide đồng bộ với bộ icon toàn site (Quy trình, Vì sao chọn chúng tôi) */
.product-attributes {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 18px;
  margin: 14px 0 2px;
  padding: 0;
  list-style: none;
}

.product-attributes li {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: #6e6962;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14.5px;
  letter-spacing: 0.03em;
}

.product-attributes li :deep(svg) {
  flex-shrink: 0;
  color: #aa8453;
}
</style>
