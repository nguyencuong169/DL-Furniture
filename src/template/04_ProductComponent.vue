<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute } from 'vue-router'
import { fetchProducts, formatPrice, type ProductResponse } from '../api/productClient'

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
              <a :href="productDetailUrl(product)">{{ product.categoryName || 'Book' }}</a>
            </span>
            <div class="con">
              <h6>
                <a :href="productDetailUrl(product)">{{ formatPrice(product) }}</a>
              </h6>
              <h5>
                <a :href="productDetailUrl(product)">{{ product.name }}</a>
              </h5>
              <div class="line"></div>
              <div class="row facilities">
                <div class="col col-md-7">
                  <ul>
                    <li><i class="flaticon-bed"></i></li>
                    <li><i class="flaticon-bath"></i></li>
                    <li><i class="flaticon-breakfast"></i></li>
                    <li><i class="flaticon-towel"></i></li>
                  </ul>
                </div>
                <div class="col col-md-5 text-end">
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
