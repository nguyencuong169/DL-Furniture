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

// P1-2 SEO slug: /san-pham/giuong-oc-cho-g01 thay cho /san-pham/detail/12
const productDetailUrl = (product: ProductResponse) => `/san-pham/${product.slug}`
</script>

<template>
  <!--
    Không đặt section header ở đây: banner phía trên (ProductView) đã hiển thị
    breadcrumb "Phòng Khách / Sofa" nên tiêu đề lặp lại gây trùng lặp.
    Danh sách đi thẳng vào lưới sản phẩm — đúng pattern trang Rooms của Cappa.
  -->
  <section class="rooms1 section-padding bg-cream" data-scroll-index="1">
    <div class="container">
      <div class="row">
        <div v-for="product in displayedProducts" :key="product.id" class="col-md-4 col-sm-6">
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
  </section>
</template>

<style scoped>
/* Ảnh card: giữ tỷ lệ portrait 4:5 + object-fit cover (card cao, sang trọng). */
.rooms1 .item .o-hidden {
  aspect-ratio: 4 / 5;
  overflow: hidden;
}

.rooms1 .item .o-hidden img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

/* Thông tin sản phẩm LUÔN hiển thị (không cần hover mới thấy).
   Ghi đè .rooms1 .item .con { bottom: -60px } của theme gốc. */
.rooms1 .item .con {
  bottom: 0;
  padding: 22px 20px 20px;
}

/* Divider gọn lại để không đẩy permalink xuống quá xa. */
.rooms1 .item .con .line {
  margin: 12px 0 0;
}

/* Permalink "Chi tiết": bỏ cơ chế height:0 / overflow:hidden của theme gốc. */
.rooms1 .item .con .permalink {
  display: block;
  height: auto;
  overflow: visible;
  margin-top: 12px;
}
</style>