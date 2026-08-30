<script setup lang="ts">
const projects = [
  {
    id: 1,
    type: 'Biệt thự',
    location: 'Thủ Thiêm',
    title: 'Saroma Villa',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian phòng khách gỗ óc chó mở ra khu vườn tại Saroma Villa'
  },
  {
    id: 2,
    type: 'Căn hộ',
    location: 'Vinhomes Grand Park',
    title: 'Vinhomes Grand Park',
    image: '/media/gallery/villa-bedroom-lounge.webp',
    alt: 'Không gian phòng ngủ biệt thự Vinhomes Grand Park'
  },
  {
    id: 3,
    type: 'Nhà hàng',
    location: 'Vĩnh Yên',
    title: 'Biệt thự KĐT Vĩnh Yên',
    image: '/media/gallery/arched-dining.jpg',
    alt: 'Không gian phòng ăn biệt thự tại khu đô thị Vĩnh Yên'
  },
  {
    id: 4,
    type: 'Biệt thự',
    location: 'Thảo Điền',
    title: 'Thao Dien Luxury',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian biệt thự cao cấp Thảo Điền'
  },
  {
    id: 5,
    type: 'Căn hộ',
    location: 'Quận 7',
    title: 'Phú Mỹ Hưng Suite',
    image: '/media/gallery/villa-bedroom-lounge.webp',
    alt: 'Căn hộ hạng sang Phú Mỹ Hưng'
  }
]
</script>

<template>
  <section id="featured-projects" class="featured-projects" aria-labelledby="featured-title">
    <div class="container">
      <header class="featured-heading">
        <div class="featured-heading-copy">
          <p class="section-subtitle"><span>Không gian đã hoàn thiện</span></p>
          <div class="featured-heading-main">
            <h2 id="featured-title" class="section-title">Dự án tiêu biểu</h2>
            <RouterLink to="/du-an" class="all-projects-link">
              Xem tất cả dự án <span class="arrow">→</span>
            </RouterLink>
          </div>
        </div>
      </header>
    </div>

    <!-- Grid wrapper full width (outside .container) -->
    <div class="featured-grid-wrapper">
      <div class="featured-grid" :style="{ '--cols': Math.min(projects.length, 5) }">
        <RouterLink
          v-for="(project, index) in projects"
          :key="project.id"
          class="featured-card"
          :to="`/du-an#project-${project.id}`"
          :aria-label="`Xem dự án ${project.title} — ${project.type} tại ${project.location}`"
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
            <p class="featured-caption-meta">{{ project.type }} — {{ project.location }}</p>
            <h3 class="featured-caption-title">{{ project.title }}</h3>
            <span class="butn-dark2"><span>Khám phá dự án</span></span>
          </div>
        </RouterLink>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* ---------- Section base ---------- */
.featured-projects {
  padding: clamp(84px, 10vw, 132px) 0;
  scroll-margin-top: 96px;
  background: #fff;
}

/* Keep container behavior for header content */
.container {
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
  box-sizing: border-box;
}

/* Heading */
.featured-heading {
  margin-bottom: clamp(16px, 4vw, 36px);
}

.featured-heading-main {
  display: flex;
  justify-content: space-between;
  align-items: baseline;
  gap: 20px;
}

.section-title {
  margin: 0;
}

.all-projects-link {
  color: #aa8453;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
  font-weight: 500;
  text-decoration: none;
  transition: color 0.3s ease;
  white-space: nowrap;
}

.all-projects-link:hover {
  color: #221f1a;
}

.all-projects-link .arrow {
  display: inline-block;
  transition: transform 0.3s ease;
  margin-left: 4px;
}

.all-projects-link:hover .arrow {
  transform: translateX(4px);
}

/* ---------- Full-bleed grid wrapper (spans full viewport) ---------- */
.featured-grid-wrapper {
  width: 100%;
  /* ensure wrapper spans viewport and doesn't inherit container padding */
  margin: 0;
  padding: 0;
  box-sizing: border-box;
  overflow: visible;
}

/* Grid itself: equal columns up to 5 */
.featured-grid {
  display: grid;
  grid-template-columns: repeat(var(--cols, 3), 1fr);
  gap: clamp(12px, 1.5vw, 24px);
  align-items: start;
  width: 100%;
  box-sizing: border-box;
  /* remove any outer gutters so grid touches viewport edges */
  padding: 0;
  margin: 0;
}

/* Card styling */
.featured-card {
  display: block;
  width: 100%;
  transition: transform 0.4s ease;
  box-sizing: border-box;
  padding: 0 12px; /* internal gutter between card content and grid cell edge */
}

/* Remove left/right whitespace at extreme edges by zeroing padding on first/last */
.featured-card:first-child {
  padding-left: 0;
}
.featured-card:last-child {
  padding-right: 0;
}

/* Optional stagger for visual rhythm on wide screens */
@media (min-width: 992px) {
  .featured-card:nth-child(even) {
    margin-top: clamp(40px, 5vw, 80px);
  }
}

.featured-card:hover {
  transform: translateY(-10px);
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
  display: none;
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
  margin: 0 0 16px;
  color: #221f1a;
  font-family: 'Gilda Display', serif;
  font-size: clamp(26px, 2.2vw, 34px);
  font-weight: 400;
  line-height: 1.15;
  letter-spacing: -0.01em;
  min-height: 3em;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.featured-card:hover .butn-dark2:after,
.featured-card:focus-visible .butn-dark2:after {
  width: 100%;
  left: 0;
}

/* ---------- Responsive: switch to horizontal scroll on smaller screens ---------- */

/* Medium and below: use horizontal scroll (no wrapping) */
@media (max-width: 991.98px) {
  .featured-grid {
    display: flex;
    flex-wrap: nowrap;
    justify-content: flex-start;
    gap: 20px;
    padding: 0 16px; /* small side padding for comfortable touch area */
    overflow-x: auto;
    -webkit-overflow-scrolling: touch;
    scroll-snap-type: x mandatory;
  }

  .featured-card {
    flex: 0 0 auto;
    width: min(320px, 85%);
    scroll-snap-align: start;
    margin-top: 0; /* remove stagger on small screens */
    padding: 0; /* card padding handled by grid gap */
  }

  /* ensure first/last card don't have extra side padding */
  .featured-grid .featured-card:first-child {
    margin-left: 0;
  }
  .featured-grid .featured-card:last-child {
    margin-right: 0;
  }
}

/* Small screens: single column width but still scrollable if many cards */
@media (max-width: 767.98px) {
  .featured-projects {
    padding: 48px 0;
  }

  .featured-heading {
    margin-bottom: 30px;
    text-align: center;
  }
  .featured-heading-main {
    flex-direction: column;
    align-items: center;
    gap: 12px;
  }

  .featured-grid {
    gap: 16px;
    padding: 0 12px;
  }

  .featured-card {
    width: 100%;
    max-width: 420px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .featured-media img {
    transition: none;
  }
}

/* 1. Thêm padding 2 mép trái/phải cho wrapper */
.featured-grid-wrapper {
  width: 100%;
  margin: 0;
  padding: 0 clamp(16px, 4vw, 40px); /* Tự động co giãn từ 16px đến 40px */
  box-sizing: border-box;
  overflow: visible;
}

/* 2. Đổi padding của card đầu/cuối về 12px giống các card khác */
.featured-card:first-child {
  padding-left: 12px;
}
.featured-card:last-child {
  padding-right: 12px;
}
</style>
