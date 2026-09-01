<script setup lang="ts">
import { featuredProjects } from '../config/featuredProjects'
</script>

<template>
  <section id="featured-projects" class="room2 section-padding bg-cream">
    <div class="container">
      <div class="row align-items-end featured-projects-header">
        <div class="col-md-8">
          <div class="section-subtitle"><span>Dự án tiêu biểu</span></div>
          <h2 class="section-title"><span>Dự án đã hoàn thiện</span></h2>
        </div>
        <div class="col-md-4 text-md-end">
          <RouterLink class="featured-projects-all" :to="{ name: 'project' }">
            Xem tất cả dự án <i class="ti-arrow-right" aria-hidden="true"></i>
          </RouterLink>
        </div>
      </div>
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
</template>

<style scoped>
.rooms2[id] {
  scroll-margin-top: 115px;
}

.rooms2[id]:target {
  outline: 1px solid rgba(170, 132, 83, 0.55);
  outline-offset: 12px;
}

/* Header đồng bộ formal box Tin tức: title trái + link "Xem tất cả" phải, căn đáy */
.featured-projects-header {
  margin-bottom: 38px;
}

.featured-projects-header .section-title {
  margin-bottom: 0;
}

.featured-projects-header .section-title span {
  color: #221f1a;
}

.featured-projects-all {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(90, 70, 45, 0.35);
  color: #4f4a43;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.15em;
  text-transform: uppercase;
}

.featured-projects-all:hover,
.featured-projects-all:focus-visible {
  border-color: #8a6a3f;
  color: #8a6a3f;
}

@media (max-width: 767.98px) {
  .featured-projects-all {
    margin-top: 17px;
  }
}

/* Container về chuẩn 1140px của Cappa: figure 66.67% ≈ 760px
   → ảnh 4:3 cao ~570px, đúng tỷ lệ cân đối của theme gốc */
.room2 .container {
  max-width: 1140px;
}

.featured-projects-header .section-title {
  margin-bottom: 0;
}

/* Ảnh tỉ lệ 8:5 (đúng ảnh gốc Cappa 1920x1200) → ~465px, chứa box 390px giữa ảnh */
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
  /* Caption chuyển về dạng relative (flow dưới ảnh) — trả chiều cao tự nhiên */
  .rooms2 .caption {
    height: auto;
  }
}

.rooms2 .caption p {
  margin-bottom: 10px;
}

/* Lucide icon cho thông số dự án: 3 cột đều nhau, item trong cột có thể xuống dòng,
   mỗi cột hẹp như ảnh demo (không co giãn 1 hàng gây lệch caption) */
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
