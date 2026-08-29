<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { fetchServices, type ServiceResponse } from '../api/serviceClient'
import { destroyOwlCarousel, initOwlCarousel } from '../utils/carousel'

const CAROUSEL_SELECTOR = '.pricing .owl-carousel'

const services = ref<ServiceResponse[]>([])

const featuredServices = computed(() =>
  [...services.value].sort((first, second) => first.sortOrder - second.sortOrder)
)

// Đồng bộ với config gốc "Pricing owlCarousel" trong custom.js
const owlOptions = {
  loop: true,
  margin: 30,
  mouseDrag: true,
  autoplay: true,
  dots: true,
  autoplayHoverPause: true,
  nav: false,
  navText: [
    "<span class='lnr ti-angle-left'></span>",
    "<span class='lnr ti-angle-right'></span>"
  ],
  responsiveClass: true,
  responsive: {
    0: { items: 1 },
    600: { items: 1 },
    1000: { items: 2 }
  }
}

onMounted(async () => {
  services.value = await fetchServices()
  await nextTick() // đợi Vue patch xong v-for thành DOM thật
  initOwlCarousel(CAROUSEL_SELECTOR, owlOptions)
})

// Re-init nếu services đổi lại sau này (refetch, filter...)
watch(services, async () => {
  await nextTick()
  initOwlCarousel(CAROUSEL_SELECTOR, owlOptions)
})

onBeforeUnmount(() => {
  destroyOwlCarousel(CAROUSEL_SELECTOR)
})
</script>

<template>
  <section class="pricing section-padding bg-blck">
    <div class="container">
      <div class="row">
        <div class="col-md-4">
          <div class="section-subtitle"><span>D&L Furniture</span></div>
          <div class="section-title"><span>Dịch vụ thi công</span></div>
          <p class="color-2">
            <strong>D&L Furniture</strong> tự hào là đơn vị hàng đầu trong lĩnh vực thiết kế thi
            công nội thất với đội nhân sự lành nghề giàu kinh nghiệm. Công ty đã được rất nhiều
            khách hàng tin tưởng lựa chọn và đã "trình làng" hàng trăm dự án, công trình khác nhau.
          </p>
          <div class="reservations mb-30">
            <div class="icon"><span class="flaticon-call"></span></div>
            <div class="text">
              <p class="color-2">Tư vấn thiết kế miễn phí</p>
              <a href="tel:+84961109897">(+84) 961-109-897</a>
            </div>
          </div>
        </div>
        <div class="col-md-8">
          <div class="owl-carousel owl-theme">
            <div class="pricing-card" v-for="item in featuredServices" :key="item.id">
              <img :src="item.image" :alt="item.name" />
              <div class="desc">
                <div class="name">{{ item.name }}</div>
                <span>{{ item.description }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>