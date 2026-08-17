<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { fetchServices, type ServiceResponse } from '../api/serviceClient'

const services = ref<ServiceResponse[]>([])
const featuredServices = computed(() => services.value.slice(0, 2))

onMounted(async () => {
  services.value = await fetchServices()
})
</script>

<template>
  <section class="pricing home-services bg-blck" aria-labelledby="home-services-title">
    <div class="container home-services-container">
      <div class="home-services-layout">
        <div class="home-services-copy">
          <div class="section-subtitle"><span>Dịch vụ của chúng tôi</span></div>
          <h2 id="home-services-title" class="section-title">
            <span>Thiết kế &amp;</span><span> thi công trọn gói</span>
          </h2>
          <p class="color-2">
            <strong>D&amp;L Furniture</strong> đồng hành từ khảo sát, phát triển phương án đến sản
            xuất và lắp đặt hoàn thiện. Một đầu mối xuyên suốt giúp ý tưởng thiết kế được bảo toàn
            khi đi vào thực tế.
          </p>
          <div class="reservations mb-30">
            <div class="icon"><span class="flaticon-call"></span></div>
            <div class="text">
              <p class="color-2">Tư vấn trực tiếp</p>
              <a href="tel:+84961109897">(+84) 961-109-897</a>
            </div>
          </div>
          <a class="pricing-process-link" href="#home-process">
            Xem quy trình <i class="ti-arrow-right" aria-hidden="true"></i>
          </a>
        </div>
        <div class="home-services-grid" aria-label="Dịch vụ nổi bật của D&L Furniture">
          <article
            v-for="(service, index) in featuredServices"
            :key="service.id"
            class="home-service-card"
          >
            <div class="home-service-media">
              <img
                :src="service.image"
                :alt="service.name"
                width="900"
                height="700"
                loading="lazy"
                decoding="async"
              />
            </div>
            <div class="home-service-content">
              <span class="home-service-number" aria-hidden="true">
                {{ String(index + 1).padStart(2, '0') }}
              </span>
              <h3>{{ service.name }}</h3>
              <p>{{ service.description }}</p>
              <RouterLink :to="{ name: 'home', hash: '#consultation' }">
                Đặt lịch tư vấn <i class="ti-arrow-right" aria-hidden="true"></i>
              </RouterLink>
            </div>
          </article>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-services {
  padding: 82px 0;
}

.home-services-container {
  width: min(1280px, calc(100% - 60px));
  max-width: none;
  padding: 0;
}

.home-services-layout {
  display: grid;
  grid-template-columns: minmax(270px, 0.72fr) minmax(0, 1.48fr);
  align-items: center;
  gap: clamp(54px, 6vw, 92px);
}

.home-services-copy > p {
  max-width: 430px;
  font-size: 16px;
  line-height: 1.8;
}

.home-services-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 22px;
}

.home-service-card {
  min-width: 0;
  background: #f7f3ed;
  transition: transform 0.35s ease;
}

.home-service-card:hover {
  transform: translateY(-5px);
}

.home-service-media {
  height: 290px;
  overflow: hidden;
  background: #302c27;
}

.home-service-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.7s cubic-bezier(0.22, 1, 0.36, 1);
}

.home-service-card:hover img {
  transform: scale(1.04);
}

.home-service-content {
  position: relative;
  min-height: 245px;
  padding: 31px 34px 32px;
}

.home-service-number {
  position: absolute;
  top: 34px;
  right: 32px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.15em;
}

.home-service-content h3 {
  max-width: calc(100% - 38px);
  margin: 0 0 14px;
  color: #24211d;
  font-family: 'Gilda Display', serif;
  font-size: 30px;
  font-weight: 400;
  line-height: 1.2;
}

.home-service-content p {
  margin: 0;
  color: #68625b;
  font-size: 15px;
  line-height: 1.72;
}

.home-service-content a {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  margin-top: 22px;
  color: #89673d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}

.pricing-process-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.32);
  color: rgba(255, 255, 255, 0.86);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.15em;
  text-transform: uppercase;
  transition:
    border-color 0.3s ease,
    color 0.3s ease,
    gap 0.3s ease;
}

.pricing-process-link:hover,
.pricing-process-link:focus-visible {
  gap: 15px;
  border-color: #d3ad7b;
  color: #d3ad7b;
}

.pricing-process-link:focus-visible {
  outline: 2px solid #d3ad7b;
  outline-offset: 5px;
}

@media (max-width: 991.98px) {
  .home-services-layout {
    grid-template-columns: 1fr;
  }

  .home-services-copy {
    max-width: 680px;
  }
}

@media (max-width: 767.98px) {
  .home-services {
    padding: 68px 0;
  }

  .home-services-container {
    width: calc(100% - 30px);
  }

  .home-services-grid {
    grid-template-columns: 1fr;
  }

  .home-service-media {
    height: 250px;
  }

  .home-service-content {
    min-height: 0;
    padding: 27px 25px 29px;
  }

  .home-service-content h3 {
    font-size: 27px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .home-service-card,
  .home-service-media img {
    transition: none;
  }
}
</style>
