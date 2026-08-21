<script setup lang="ts">
const projects = [
  {
    id: 1,
    title: 'Saroma Villa',
    location: 'Thủ Thiêm',
    type: 'Nội thất biệt thự',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian phòng khách gỗ óc chó mở ra khu vườn tại Saroma Villa'
  },
  {
    id: 2,
    title: 'Vinhomes Grand Park',
    location: 'Quận 9',
    type: 'Thiết kế & thi công',
    image: '/media/gallery/villa-bedroom-lounge.webp',
    alt: 'Không gian phòng ngủ biệt thự Vinhomes Grand Park'
  },
  {
    id: 3,
    title: 'Biệt thự KĐT Vĩnh Yên',
    location: 'Vĩnh Yên',
    type: 'Nội thất biệt thự',
    image: '/media/gallery/arched-dining.jpg',
    alt: 'Không gian phòng ăn biệt thự tại khu đô thị Vĩnh Yên'
  }
]
</script>

<template>
  <section id="featured-projects" class="featured-projects" aria-labelledby="featured-title">
    <div class="container">
      <header class="featured-heading">
        <div>
          <p class="section-subtitle">Không gian đã hoàn thiện</p>
          <h2 id="featured-title" class="section-title">Dự án tiêu biểu</h2>
          <p class="featured-lead">
            Khám phá cách vật liệu, tỷ lệ và công năng được giải quyết trong từng không gian thực tế.
          </p>
        </div>
        <RouterLink class="featured-all" to="/du-an">
          Xem tất cả dự án <i class="ti-arrow-right" aria-hidden="true"></i>
        </RouterLink>
      </header>

      <div class="featured-grid">
        <RouterLink
          v-for="(project, index) in projects"
          :key="project.id"
          class="featured-card"
          :class="{ 'featured-card--primary': index === 0 }"
          :to="`/du-an#project-${project.id}`"
          :aria-label="`Xem dự án ${project.title} tại ${project.location}`"
        >
          <img
            :src="project.image"
            :alt="project.alt"
            width="1200"
            height="800"
            loading="lazy"
            fetchpriority="low"
            decoding="async"
          />
          <span class="featured-card-overlay" aria-hidden="true"></span>
          <span class="featured-card-index" aria-hidden="true">
            {{ String(index + 1).padStart(2, '0') }}
          </span>
          <span class="featured-card-content">
            <span class="featured-card-meta">{{ project.type }} · {{ project.location }}</span>
            <span class="featured-card-title">{{ project.title }}</span>
            <span class="featured-card-link">
              Khám phá dự án <i class="ti-arrow-right" aria-hidden="true"></i>
            </span>
          </span>
        </RouterLink>
      </div>

      <aside class="featured-consultation" aria-label="Bắt đầu dự án cùng D&L Furniture">
        <div>
          <span class="featured-consultation-kicker">Bạn đang chuẩn bị một không gian mới?</span>
          <h3>Trao đổi cùng kiến trúc sư ngay từ bước đầu.</h3>
        </div>
        <RouterLink class="featured-consultation-link" :to="{ name: 'home', hash: '#consultation' }">
          Đặt lịch tư vấn <i class="ti-arrow-right" aria-hidden="true"></i>
        </RouterLink>
      </aside>
    </div>
  </section>
</template>

<style scoped>
.featured-projects {
  padding: 78px 0 82px;
  scroll-margin-top: 96px;
  background: #fff;
}

.featured-projects > .container {
  width: min(1360px, calc(100% - 60px));
  max-width: none !important;
  padding: 0;
}

.featured-heading {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 30px;
  margin-bottom: 36px;
}

.featured-heading .section-subtitle {
  margin-bottom: 7px;
}

.featured-heading .section-title {
  margin: 0;
}

.featured-lead {
  max-width: 650px;
  margin: 15px 0 0;
  color: #6e6962;
  font-size: 15px;
  line-height: 1.75;
}

.featured-all,
.featured-consultation-link {
  display: inline-flex;
  align-items: center;
  gap: 11px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(170, 132, 83, 0.42);
  color: #89673d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  transition:
    gap 0.3s ease,
    border-color 0.3s ease,
    color 0.3s ease;
}

.featured-all:hover,
.featured-all:focus-visible {
  gap: 16px;
  border-color: #89673d;
  color: #5d4428;
}

.featured-grid {
  display: grid;
  height: 600px;
  grid-template-columns: minmax(0, 1.55fr) minmax(310px, 0.85fr);
  grid-template-rows: repeat(2, minmax(0, 1fr));
  gap: 16px;
}

.featured-card {
  position: relative;
  display: block;
  min-height: 0;
  overflow: hidden;
  background: #221f1a;
  color: #fff;
}

.featured-card--primary {
  grid-row: 1 / 3;
}

.featured-card img,
.featured-card-overlay {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
}

.featured-card img {
  z-index: 0;
  object-fit: cover;
  filter: saturate(0.82) contrast(1.02);
  transform: scale(1.01);
  transition:
    filter 0.5s ease,
    transform 0.5s ease;
}

.featured-card-overlay {
  z-index: 1;
  background: linear-gradient(0deg, rgba(15, 13, 11, 0.8) 0%, rgba(15, 13, 11, 0.1) 64%);
  transition: background 0.5s ease;
}

.featured-card-index {
  position: absolute;
  top: 24px;
  left: 26px;
  color: rgba(255, 255, 255, 0.78);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.16em;
  z-index: 2;
}

.featured-card-content {
  position: absolute;
  right: 28px;
  bottom: 27px;
  left: 28px;
  display: block;
  z-index: 2;
}

.featured-card--primary .featured-card-content {
  right: 44px;
  bottom: 42px;
  left: 44px;
}

.featured-card-meta {
  display: block;
  margin-bottom: 9px;
  color: #d4b184;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.17em;
  text-transform: uppercase;
}

.featured-card-title {
  display: block;
  max-width: 650px;
  color: #fff;
  font-family: 'Gilda Display', serif;
  font-size: 31px;
  line-height: 1.12;
}

.featured-card--primary .featured-card-title {
  font-size: clamp(42px, 4vw, 58px);
}

.featured-card-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  max-height: 0;
  margin-top: 0;
  overflow: hidden;
  color: rgba(255, 255, 255, 0.88);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.16em;
  opacity: 0;
  text-transform: uppercase;
  transform: translateY(7px);
  transition:
    max-height 0.35s ease,
    margin-top 0.35s ease,
    opacity 0.35s ease,
    transform 0.35s ease;
}

.featured-card:hover img,
.featured-card:focus-visible img {
  filter: brightness(75%);
  transform: scale(1.09);
  transition:
    filter 1s ease,
    transform 1s ease;
}

.featured-card:hover .featured-card-link,
.featured-card:focus-visible .featured-card-link {
  max-height: 30px;
  margin-top: 18px;
  opacity: 1;
  transform: translateY(0);
}

.featured-card:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 4px;
}

.featured-consultation {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 40px;
  padding: 38px 42px;
  margin-top: 16px;
  background: #24221f;
}

.featured-consultation-kicker {
  display: block;
  margin-bottom: 7px;
  color: #cda675;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.featured-consultation h3 {
  margin: 0;
  color: #fff;
  font-family: 'Gilda Display', serif;
  font-size: 28px;
  font-weight: 400;
  line-height: 1.3;
}

.featured-consultation-link {
  flex: 0 0 auto;
  border-color: rgba(255, 255, 255, 0.35);
  color: #fff;
}

.featured-consultation-link:hover,
.featured-consultation-link:focus-visible {
  gap: 16px;
  border-color: #fff;
  color: #fff;
}

@media (max-width: 991.98px) {
  .featured-projects {
    padding: 82px 0;
  }

  .featured-grid {
    height: auto;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    grid-template-rows: 510px 330px;
  }

  .featured-card--primary {
    grid-row: auto;
    grid-column: 1 / -1;
  }

  .featured-card--primary .featured-card-content {
    right: 32px;
    bottom: 32px;
    left: 32px;
  }
}

@media (max-width: 767.98px) {
  .featured-projects {
    padding: 68px 0;
  }

  .featured-projects > .container {
    width: calc(100% - 30px);
  }

  .featured-heading {
    display: block;
    margin-bottom: 30px;
  }

  .featured-heading .section-title {
    font-size: 40px;
  }

  .featured-all {
    margin-top: 18px;
  }

  .featured-grid {
    display: grid;
    grid-template-columns: 1fr;
    grid-template-rows: 460px repeat(2, 320px);
    gap: 10px;
  }

  .featured-card--primary {
    grid-column: auto;
  }

  .featured-card-content,
  .featured-card--primary .featured-card-content {
    right: 24px;
    bottom: 24px;
    left: 24px;
  }

  .featured-card--primary .featured-card-title,
  .featured-card-title {
    font-size: 34px;
  }

  .featured-card-link {
    max-height: 30px;
    margin-top: 15px;
    opacity: 1;
    transform: none;
  }

  .featured-consultation {
    display: block;
    padding: 31px 25px 33px;
    margin-top: 10px;
  }

  .featured-consultation h3 {
    font-size: 26px;
  }

  .featured-consultation-link {
    margin-top: 23px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .featured-card img,
  .featured-card-link,
  .featured-all,
  .featured-consultation-link {
    transition: none;
  }
}
</style>
