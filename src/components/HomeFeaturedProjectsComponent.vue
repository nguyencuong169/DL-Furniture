<script setup lang="ts">
const projects = [
  {
    id: 1,
    room: 'Phòng Khách',
    style: 'Modern Elegance',
    title: 'Saroma Villa',
    location: 'Thủ Thiêm',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian phòng khách gỗ óc chó mở ra khu vườn tại Saroma Villa'
  },
  {
    id: 2,
    room: 'Phòng Ngủ',
    style: 'Comfort & Style',
    title: 'Vinhomes Grand Park',
    location: 'Quận 9',
    image: '/media/gallery/villa-bedroom-lounge.webp',
    alt: 'Không gian phòng ngủ biệt thự Vinhomes Grand Park'
  },
  {
    id: 3,
    room: 'Phòng Ăn',
    style: 'Minimal & Functional',
    title: 'Biệt thự KĐT Vĩnh Yên',
    location: 'Vĩnh Yên',
    image: '/media/gallery/arched-dining.jpg',
    alt: 'Không gian phòng ăn biệt thự tại khu đô thị Vĩnh Yên'
  }
]
</script>

<template>
  <section id="featured-projects" class="featured-projects" aria-labelledby="featured-title">
    <div class="container">
      <header class="featured-heading">
        <div class="featured-heading-copy">
          <p class="section-subtitle"><span>Không gian đã hoàn thiện</span></p>
          <h2 id="featured-title" class="section-title">Dự án tiêu biểu</h2>
        </div>
      </header>

      <div class="featured-grid">
        <RouterLink
          v-for="(project, index) in projects"
          :key="project.id"
          class="featured-card"
          :to="`/du-an#project-${project.id}`"
          :aria-label="`Xem dự án ${project.title} — ${project.room} tại ${project.location}`"
        >
          <figure class="featured-media">
            <img
              :src="project.image"
              :alt="project.alt"
              width="1200"
              height="900"
              loading="lazy"
              decoding="async"
            />
          </figure>
          <div class="featured-caption">
            <span class="featured-caption-index" aria-hidden="true">
              {{ String(index + 1).padStart(2, '0') }}
            </span>
            <p class="featured-caption-meta">{{ project.room }} — {{ project.style }}</p>
            <h3 class="featured-caption-title">{{ project.title }}</h3>
            <p class="featured-caption-location">{{ project.location }}</p>
            <span class="butn-dark2"><span>Khám phá dự án</span></span>
          </div>
        </RouterLink>
      </div>
    </div>
  </section>
</template>

<style scoped>
.featured-projects {
  padding: clamp(84px, 10vw, 132px) 0;
  scroll-margin-top: 96px;
  background: #fff;
}

.featured-heading {
  margin-bottom: clamp(16px, 4vw, 36px);
}

.featured-grid {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  align-items: start;
  gap: clamp(26px, 2.8vw, 46px);
}

.featured-card {
  display: block;
}

.featured-media {
  position: relative;
  margin: 0;
  overflow: hidden;
  aspect-ratio: 4 / 5;
  background: #1d1a16;
}

.featured-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  filter: saturate(0.86) contrast(1.03);
  transform: scale(1.01);
  transition:
    filter 0.6s ease,
    transform 0.6s ease;
}

.featured-card:hover .featured-media img,
.featured-card:focus-visible .featured-media img {
  filter: brightness(75%);
  transform: scale(1.09);
  transition:
    filter 1s ease,
    transform 1s ease;
}

.featured-card:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 4px;
}

.featured-caption {
  padding-top: 22px;
}

.featured-caption-index {
  display: block;
  margin-bottom: 10px;
  color: rgba(170, 132, 83, 0.55);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.2em;
}

.featured-caption-meta {
  margin: 0 0 10px;
  color: #9e7746;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.featured-caption-title {
  margin: 0 0 8px;
  color: #221f1a;
  font-family: 'Gilda Display', serif;
  font-size: clamp(26px, 2.2vw, 34px);
  font-weight: 400;
  line-height: 1.15;
  letter-spacing: -0.01em;
}

.featured-caption-location {
  margin: 0 0 16px;
  color: #6e6962;
  font-size: 13px;
  letter-spacing: 0.05em;
}

.featured-card:hover .butn-dark2:after,
.featured-card:focus-visible .butn-dark2:after {
  width: 100%;
  left: 0;
}

@media (min-width: 992px) {
  .featured-card:nth-child(2) {
    margin-top: clamp(40px, 4.5vw, 84px);
  }
}

@media (max-width: 991.98px) {
  .featured-projects {
    padding: 72px 0;
  }

  .featured-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }
}

@media (max-width: 767.98px) {
  .featured-projects {
    padding: 64px 0;
  }

  .featured-heading {
    margin-bottom: 30px;
  }

  .featured-grid {
    grid-template-columns: 1fr;
    gap: 40px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .featured-media img {
    transition: none;
  }
}
</style>
