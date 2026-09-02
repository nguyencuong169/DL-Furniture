<script setup lang="ts">
import { featuredProjects } from '../config/featuredProjects'
import { setPageSeo } from '../utils/seo'

setPageSeo({
  title: 'Dự án',
  description:
    'Các dự án nội thất D&L Furniture đã thực hiện: biệt thự, penthouse, căn hộ cao cấp — thi công gỗ óc chó và gỗ tự nhiên trọn gói.',
  path: '/du-an'
})
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
                <h3>
                  {{ project.client }} <span>/ {{ project.location }}</span>
                  <em class="client-year">{{ project.year }}</em>
                </h3>
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
/* ==========================================================================
   PROJECT VIEW — KHUNG DETAILS GỌN GÀNG, CÂN ĐỐI
   ==========================================================================
   Bố cục giữ nguyên rooms2 (figure 66.7% + caption chồng 50%), nhưng dồn
   nội dung lại gọn-gàng kiểu cột tạp chí như caption homepage:
   - Bỏ khóa chiều cao 390px cứng → để caption tự đo theo nội dung
   - Typography thu nhỏ & nhịp đều (client 12px / title 28px / body 13px)
   - Specs 3 cột đều, icon nhỏ đồng bộ
   - Viền + bóng đổ mảnh tạo cảm giác khung rõ ràng
========================================================================== */

/* Container về chuẩn 1140px của Cappa để tỷ lệ card cân đối */
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

/* ---- Khung details gọn gàng ---- */
.rooms2 .caption {
  /* Bỏ height:390px cứng → nội dung quyết định chiều cao */
  height: auto;
  min-height: 320px;
  display: flex;
  flex-direction: column;
  justify-content: center;
  padding: 30px 30px 30px 4.5%;
  background: #fff !important;
  border: 1px solid rgba(170, 132, 83, 0.25);
  box-shadow: 0 24px 60px rgba(17, 15, 13, 0.12);
}

/* Caption bên phải (dự án index lẻ): căn viền đối xứng */
.rooms2.left .caption {
  padding: 30px 4.5% 30px 30px;
  border: 1px solid rgba(170, 132, 83, 0.25);
  box-shadow: 0 24px 60px rgba(17, 15, 13, 0.12);
}

/* ---- Client / Location ---- */
.rooms2 .caption h3,
.rooms2 .caption h3 a {
  font-size: 12px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 600;
  letter-spacing: 3px;
  text-transform: uppercase;
  margin-bottom: 8px;
}
.rooms2 .caption h3 span {
  font-size: 12px;
  color: #8a8177;
  font-family: 'Barlow', sans-serif;
  font-weight: 400;
  letter-spacing: 0.5px;
  text-transform: none;
}
.rooms2 .caption h3 .client-year {
  display: inline-block;
  font-style: normal;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 1.5px;
  color: #fff;
  background: #aa8453;
  padding: 2px 8px;
  border-radius: 20px;
  margin-left: 8px;
  vertical-align: 1px;
}

/* ---- Tiêu đề dự án ---- */
.rooms2 .caption h4,
.rooms2 .caption h4 a {
  font-size: 28px;
  line-height: 1.25;
  color: #1e1a16;
  margin-bottom: 6px;
  font-family: 'Gilda Display', serif;
  font-weight: 400;
}
.rooms2 .caption h4 a:hover {
  color: #aa8453;
}

/* ---- Mô tả loại dự án ---- */
.rooms2 .caption p {
  margin-bottom: 16px;
  font-size: 13px;
  color: #666;
}

/* ---- Specs: 3 cột đều, icon nhỏ gọn ---- */
.room-facilities {
  display: flex;
  align-items: flex-start;
  margin: 0 0 8px;
  gap: 6px;
}

.room-facilities .col-md-4 {
  flex: 1 1 0;
  width: auto;
  max-width: 100%;
  min-width: 0;
}

.room-facilities ul {
  margin: 0;
  padding: 0;
  list-style: none;
}

.room-facilities ul li {
  display: flex;
  align-items: flex-start;
  font-size: 13px;
  line-height: 1.5;
  color: #444;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.room-facilities ul li svg {
  width: 14px;
  height: 14px;
  margin-top: 2px;
  margin-right: 6px;
  color: #aa8453;
  flex-shrink: 0;
}

/* ---- Divider + Actions ---- */
.rooms2 .caption hr.border-2 {
  margin: 18px 0;
}

.rooms2 .caption .info-wrapper {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  flex-wrap: wrap;
}

.rooms2 .caption .info-wrapper .more {
  font-size: 13px;
}

.rooms2 .caption .info-wrapper .butn-dark a {
  padding: 10px 16px;
  font-size: 13px;
  letter-spacing: 2px;
  display: inline-block;
}

@media (max-width: 991px) {
  .rooms2 .caption {
    height: auto;
    min-height: 0;
    padding: 30px 24px;
    border: none;
    border-bottom: 1px solid rgba(170, 132, 83, 0.25);
    box-shadow: none;
  }
  .rooms2.left .caption {
    padding: 30px 24px;
    border: none;
    border-bottom: 1px solid rgba(170, 132, 83, 0.25);
    box-shadow: none;
  }
  .room-facilities ul li {
    white-space: normal;
    overflow: visible;
  }
}
</style>
