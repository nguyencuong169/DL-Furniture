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

  window.requestAnimationFrame(() => {
    document.querySelector('.pricing .owl-prev')?.setAttribute('aria-label', 'Xem dịch vụ trước')
    document
      .querySelector('.pricing .owl-next')
      ?.setAttribute('aria-label', 'Xem dịch vụ tiếp theo')
    document.querySelectorAll('.pricing .owl-dot').forEach((dot, index) => {
      dot.setAttribute('aria-label', `Đi đến nhóm dịch vụ ${index + 1}`)
    })
  })
})
</script>

<template>
  <section class="pricing section-padding bg-blck">
    <div class="container">
      <div class="row">
        <div class="col-md-4">
          <div class="section-subtitle"><span>Dịch vụ của chúng tôi</span></div>
          <div class="section-title">
            <span>Thiết kế &amp;</span><span> thi công trọn gói</span>
          </div>
          <p class="color-2">
            <strong>D&amp;L Furniture</strong> đồng hành từ khảo sát, phát triển phương án đến sản
            xuất và lắp đặt hoàn thiện. Một đầu mối xuyên suốt giúp ý tưởng thiết kế được bảo toàn
            khi đi vào thực tế.
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
          <div
            class="owl-carousel owl-theme"
            role="region"
            aria-label="Các nhóm dịch vụ của D&L Furniture"
          >
            <div class="pricing-card" v-for="service in services" :key="service.id">
              <img
                :src="service.image"
                :alt="service.name"
                width="900"
                height="700"
                loading="lazy"
                decoding="async"
              />
              <div class="desc">
                <h3 class="name">{{ service.name }}</h3>
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
