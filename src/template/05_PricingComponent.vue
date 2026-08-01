<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { fetchServices, type ServiceResponse } from '../api/serviceClient'
import { initOwlCarousel } from '../utils/carousel'

const services = ref<ServiceResponse[]>([])

onMounted(async () => {
  services.value = await fetchServices()
  await nextTick()
  initOwlCarousel('.pricing .owl-carousel', {
    loop: true,
    margin: 30,
    mouseDrag: true,
    autoplay: true,
    autoplayHoverPause: true,
    dots: true,
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
  })
})
</script>

<template>
  <section class="pricing section-padding bg-blck">
    <div class="container">
      <div class="row">
        <div class="col-md-4">
          <div class="section-subtitle"><span>Dịch vụ của chúng tôi</span></div>
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
            <div class="pricing-card" v-for="service in services" :key="service.id">
              <img :src="service.image" :alt="service.name" />
              <div class="desc">
                <div class="name">{{ service.name }}</div>
                <span>{{ service.description }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
