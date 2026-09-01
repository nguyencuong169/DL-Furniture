<script setup lang="ts">
import { featuredProjects } from '../config/featuredProjects'
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/1-b3ntw45g.jpg"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <span class="hero-line" aria-hidden="true"></span>
            <h5>D&L Furniture</h5>
            <h1>Các dự án đã thực hiện</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- Projects -->
    <section class="section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div
              v-for="(project, index) in featuredProjects"
              :key="project.id"
              :id="`project-${project.id}`"
              class="rooms2 animate-box"
              :class="{ left: index % 2 === 1, 'mb-90': index < featuredProjects.length - 1 }"
              data-animate-effect="fadeInUp"
            >
              <figure>
                <img :src="project.image" :alt="project.alt" class="img-fluid" loading="lazy" />
              </figure>
              <div class="caption">
                <h3>{{ project.client }} <span>/ {{ project.location }}</span></h3>
                <h4>
                  <RouterLink :to="{ name: 'project' }">{{ project.title }}</RouterLink>
                </h4>
                <p>{{ project.type }}</p>
                <div class="row room-facilities">
                  <div v-for="spec in project.specs" :key="spec.label" class="col-md-4">
                    <ul>
                      <li>
                        <component :is="spec.icon" aria-hidden="true" /> {{ spec.label }}
                      </li>
                    </ul>
                  </div>
                </div>
                <hr class="border-2" />
                <div class="info-wrapper">
                  <div class="more">
                    <RouterLink :to="{ name: 'project' }" class="link-btn" tabindex="0">
                      Chi tiết <i class="ti-arrow-right" aria-hidden="true"></i>
                    </RouterLink>
                  </div>
                  <div class="butn-dark">
                    <RouterLink :to="{ name: 'home', hash: '#consultation' }">
                      <span>Đặt lịch tư vấn</span>
                    </RouterLink>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
/* Container về chuẩn 1140px của Cappa để tỷ lệ card (figure 66.67% + ảnh 4:3)
   cân đối đúng như theme gốc */
section .container {
  max-width: 1140px;
}

.rooms2[id] {
  scroll-margin-top: 115px;
}

.rooms2[id]:target {
  outline: 1px solid rgba(170, 132, 83, 0.55);
  outline-offset: 12px;
}

/* Ảnh tỉ lệ 8:5 (đúng ảnh gốc Cappa 1920x1200) — đồng bộ với homepage */
.rooms2 > figure img {
  display: block;
  width: 100%;
  height: auto;
  aspect-ratio: 8 / 5;
  object-fit: cover;
}

/* Box details khóa chiều cao 390px như Cappa, nội dung căn giữa theo chiều dọc */
.rooms2 .caption {
  height: 390px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 28px 4%;
}

@media (max-width: 991px) {
  .rooms2 .caption {
    height: auto;
  }
}

.rooms2 .caption p {
  margin-bottom: 10px;
}

/* Facilities chuẩn Cappa: 3 cột đều nhau */
.room-facilities {
  display: flex;
  align-items: flex-start;
  margin: 0 0 5px;
}

.room-facilities .col-md-4 {
  flex: 1 1 0;
  width: auto;
  max-width: 100%;
  min-width: 0;
}

.room-facilities ul {
  margin: 0;
}

.room-facilities ul li {
  display: flex;
  align-items: center;
  font-size: 14px;
  line-height: 1.6;
}

.room-facilities ul li svg {
  width: 16px;
  height: 16px;
  margin-right: 7px;
  color: #aa8453;
  flex-shrink: 0;
}
</style>
