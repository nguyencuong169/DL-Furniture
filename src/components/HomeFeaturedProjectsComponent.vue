<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { featuredProjects } from '../config/featuredProjects'

// ==========================================================================
// HomeFeaturedProjectsComponent — bản redesign theo mẫu "FORMA / Selected Work":
//   • Bỏ slider + autoplay + Ken Burns + magnetic assist → grid card TĨNH
//     kiểu editorial trên nền tối điện ảnh (kế thừa nhận dạng tối #121212).
//   • Card: ảnh ngang 4/3 → số thứ tự 01 (gold) → tên serif IN HOA (tối đa
//     2 dòng) → meta "năm / địa điểm" → link "Xem dự án →".
//   • Header giữ pattern chung: eyebrow + title trái | "Xem tất cả" phải.
//   • Mobile/tablet: giữ nguyên form cuộn ngang chuẩn đã duyệt.
//
// PHÂN TÁCH với "Khám phá theo không gian" (HomeCollectionComponent — nền kem,
// ảnh DỌC 4:5, gạch gold + tagline lợi ích): section này nền TỐI, ảnh NGANG,
// có số thứ tự + meta dự án, tiêu đề IN HOA → cùng hệ card nhưng khác tông
// và giải phẫu, tạo nhịp Sáng(Collection) → Tối(Projects) rõ ràng.
// ==========================================================================
const MOBILE_BREAKPOINT = 991

const isMobile = ref(false)

const checkScreenSize = () => {
  isMobile.value = window.innerWidth <= MOBILE_BREAKPOINT
}

onMounted(() => {
  checkScreenSize()
  window.addEventListener('resize', checkScreenSize)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkScreenSize)
})

// Số thứ tự 01-based theo thứ tự GỐC trong featuredProjects
const projectNumber = (id: number) => {
  const index = featuredProjects.findIndex((project) => project.id === id)
  return String(index + 1).padStart(2, '0')
}
</script>

<template>
  <section id="featured-projects" class="fp-section" aria-label="Dự án đã hoàn thiện">

    <div class="fp-content">

      <!-- ==========================================================================
         GIAO DIỆN MOBILE / TABLET — giữ nguyên form cuộn ngang chuẩn đã duyệt
         ========================================================================== -->
      <div class="mobile-scroll-wrapper" v-if="isMobile">
        <div class="featured-projects-header" style="padding: 0 10px;">
          <div class="section-subtitle"><span>Dự án tiêu biểu</span></div>
          <h2 class="section-title"><span>Dự án đã hoàn thiện</span></h2>
        </div>
        <div class="mobile-scroll-container">
          <div class="mobile-project-card-wrapper" v-for="project in featuredProjects" :key="project.id">
            <div class="mobile-project-card">
              <div class="mobile-card-image">
                <img :src="project.image" :alt="project.alt" loading="lazy" />
                <div class="mobile-image-badge"><span>{{ project.location }}</span></div>
              </div>
              <div class="mobile-card-caption">
                  <span class="m-client">{{ project.client }}</span>
                  <h3 class="m-title"><RouterLink :to="{ name: 'project' }">{{ project.title }}</RouterLink></h3>
                  <p class="m-type">{{ project.result }}</p>
                <div class="mobile-card-actions">
                  <RouterLink :to="{ name: 'project', hash: `#project-${project.id}` }" class="m-link">Chi tiết <i class="ti-arrow-right"></i></RouterLink>
                  <RouterLink :to="{ name: 'home', hash: '#consultation' }" class="m-btn">Tư vấn</RouterLink>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- ==========================================================================
         GIAO DIỆN DESKTOP — grid editorial kiểu FORMA "Selected Work"
         ========================================================================== -->
      <template v-else>
        <div class="fp-inner">

          <!-- Header section: eyebrow + title trái | link "Xem tất cả dự án" phải -->
          <div class="row align-items-end featured-projects-header">
            <div class="col-md-8 col-8">
              <div class="section-subtitle"><span>Dự án tiêu biểu</span></div>
              <h2 class="section-title"><span>Dự án đã hoàn thiện</span></h2>
            </div>
            <div class="col-md-4 col-4 text-end">
              <RouterLink class="fp-all" :to="{ name: 'project' }">
                <span class="desktop-txt">Xem tất cả dự án</span> <i class="ti-arrow-right" aria-hidden="true"></i>
              </RouterLink>
            </div>
          </div>

          <!-- Grid card dự án: ảnh ngang + số thứ tự + tên in hoa + meta + link -->
          <div class="fp-grid">
            <RouterLink
              v-for="project in featuredProjects"
              :key="project.id"
              class="fp-card"
              :to="{ name: 'project', hash: `#project-${project.id}` }"
              :aria-label="`Xem dự án ${project.title}`"
            >
              <span class="fp-card-media">
                <img
                  :src="project.image"
                  :alt="project.alt"
                  width="800"
                  height="600"
                  loading="lazy"
                  decoding="async"
                />
              </span>
              <span class="fp-card-num" aria-hidden="true">{{ projectNumber(project.id) }}</span>
              <span class="fp-card-title">{{ project.title }}</span>
              <span class="fp-card-result">{{ project.result }}</span>
              <span class="fp-card-meta">{{ project.year }} / {{ project.location }}</span>
              <span class="fp-card-link">
                Xem dự án
                <i class="ti-arrow-right" aria-hidden="true"></i>
              </span>
            </RouterLink>
          </div>

        </div>
      </template>

    </div>
  </section>
</template>

<style scoped>
/* ==========================================================================
   1. SECTION FULL-BLEED — nền tối điện ảnh (kế thừa nhận dạng cũ)
   ========================================================================== */
.fp-section {
  position: relative;
  overflow: hidden;
  background-color: #121212;
  display: flex;
  flex-direction: column;
  width: 100vw !important;
  margin-left: calc(-50vw + 50%) !important;
  margin-right: calc(-50vw + 50%) !important;
}

.fp-content {
  position: relative; z-index: 3;
  width: 100%;
  display: flex; flex-direction: column;
  padding-top: 110px; padding-bottom: 104px;
  flex: 1;
}

/* Container nội dung: rộng bằng các section khác (đồng bộ header cũ) */
.fp-inner {
  width: 100%;
  max-width: 960px;
  margin-left: auto !important;
  margin-right: auto !important;
  padding-left: 12px;
  padding-right: 12px;
}
@media (min-width: 1200px) { .fp-inner { max-width: 1140px; } }
@media (min-width: 1400px) { .fp-inner { max-width: 1320px; } }

/* ==========================================================================
   2. HEADER SECTION — eyebrow + title trái | link "Xem tất cả" phải
   ========================================================================== */
.featured-projects-header {
  width: 100%;
  margin-bottom: 44px !important;
  padding-left: 12px;
  padding-right: 12px;
}
.featured-projects-header .section-title span { color: #ffffff; }
.featured-projects-header .section-subtitle span { color: #aa8453; }
.fp-all {
  display: inline-flex; align-items: center; gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.2);
  color: #dddddd;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px; font-weight: 500;
  letter-spacing: 0.15em; text-transform: uppercase;
  transition: color 0.3s ease, border-color 0.3s ease;
}
.fp-all i { font-size: 13px; transition: transform 0.3s ease; }
.fp-all:hover { color: #aa8453; border-color: #aa8453; }
.fp-all:hover i { transform: translateX(4px); }
.fp-all:focus-visible { outline: 2px solid #aa8453; outline-offset: 4px; }

/* ==========================================================================
   3. GRID CARD — kiểu FORMA "Selected Work"
   992–1199px: 2 cột (2×2) · ≥1200px: 4 cột một hàng
   ========================================================================== */
.fp-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 52px 30px;
}
@media (min-width: 1200px) {
  .fp-grid {
    grid-template-columns: repeat(4, minmax(0, 1fr));
    gap: 30px;
  }
}

.fp-card {
  display: flex; flex-direction: column;
  align-items: flex-start;
  text-decoration: none;
  min-width: 0;
}

/* Ảnh ngang 4/3 — viền mờ phân tách ranh giới trên nền tối (ngôn ngữ cũ) */
.fp-card-media {
  display: block;
  width: 100%;
  aspect-ratio: 4 / 3;
  overflow: hidden;
  background: #0d0d0d;
  border: 1px solid rgba(255, 255, 255, 0.14);
  box-shadow: 0 14px 34px rgba(0, 0, 0, 0.45);
}
.fp-card-media img {
  display: block;
  width: 100%; height: 100%;
  object-fit: cover;
  filter: brightness(0.88);
  transform: scale(1.001);
  transition:
    transform 0.7s cubic-bezier(0.22, 1, 0.36, 1),
    filter 0.4s ease;
}
.fp-card:hover .fp-card-media img,
.fp-card:focus-visible .fp-card-media img {
  transform: scale(1.06);
  filter: brightness(1);
}

/* Số thứ tự 01 — gold, tracking rộng (đúng "01 / 02 / 03" của FORMA) */
.fp-card-num {
  margin-top: 20px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px; font-weight: 600;
  letter-spacing: 0.28em;
}

/* Tên dự án — serif IN HOA, tối đa 2 dòng (headline editorial của FORMA) */
.fp-card-title {
  margin-top: 10px;
  color: #ffffff;
  font-family: 'Gilda Display', serif;
  font-weight: 400;
  font-size: clamp(17px, 1.35vw, 20px);
  line-height: 1.35;
  letter-spacing: 0.04em;
  text-transform: uppercase;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  transition: color 0.3s ease;
}
.fp-card:hover .fp-card-title,
.fp-card:focus-visible .fp-card-title { color: #d7b98a; }

/* Dòng kết quả: 1 câu ngắn nêu giá trị/kết quả dự án (số liệu cụ thể) */
.fp-card-result {
  margin-top: 8px;
  color: rgba(255, 255, 255, 0.7);
  font-family: 'Barlow', sans-serif;
  font-size: 13px;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

/* Meta: năm / địa điểm — chữ nhỏ tracking rộng, mờ */
.fp-card-meta {
  margin-top: 9px;
  color: rgba(255, 255, 255, 0.55);
  font-family: 'Barlow', sans-serif;
  font-size: 12px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  line-height: 1.5;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  max-width: 100%;
}

/* Link "Xem dự án →" — kẻ mờ phía trên như hàng "VIEW PROJECT" của FORMA */
.fp-card-link {
  display: inline-flex; align-items: center; gap: 12px;
  margin-top: 16px;
  padding-top: 13px;
  border-top: 1px solid rgba(255, 255, 255, 0.18);
  align-self: stretch;
  justify-content: space-between;
  color: #dddddd;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px; font-weight: 500;
  letter-spacing: 0.2em; text-transform: uppercase;
  transition: color 0.3s ease, border-color 0.3s ease;
}
.fp-card-link i { font-size: 12px; transition: transform 0.3s ease; }
.fp-card:hover .fp-card-link,
.fp-card:focus-visible .fp-card-link { color: #aa8453; border-color: #aa8453; }
.fp-card:hover .fp-card-link i,
.fp-card:focus-visible .fp-card-link i { transform: translateX(4px); }
.fp-card:focus-visible { outline: 2px solid #aa8453; outline-offset: 6px; }

/* ==========================================================================
   4. MOBILE / TABLET — cuộn ngang tự nhiên (giữ nguyên form chuẩn đã duyệt)
   ========================================================================== */
@media (max-width: 991px) {
  .fp-section { min-height: auto; padding: 50px 0 !important; width: 100% !important; margin-left: 0 !important; margin-right: 0 !important; background-color: #151515; }
  .fp-content { padding: 0 !important; }
  .mobile-scroll-wrapper { width: 100%; padding: 5px 0 15px 0; }
  .featured-projects-header { margin-bottom: 24px; }
  .featured-projects-header .section-title span { color: #ffffff; }
  .featured-projects-header .section-subtitle span { color: #aa8453; }
  .mobile-scroll-container { display: flex !important; flex-wrap: nowrap !important; overflow-x: auto !important; padding-left: 20px; padding-right: 20px; gap: 20px; scroll-snap-type: x mandatory !important; -webkit-overflow-scrolling: touch; }
  .mobile-scroll-container::-webkit-scrollbar { display: none; }
  .mobile-project-card-wrapper { display: flex; flex: 0 0 82%; width: 82%; scroll-snap-align: center !important; }
  .mobile-project-card { display: flex; flex-direction: column; width: 100%; background: #1e1b18; border-radius: 14px; overflow: hidden; border: 1px solid rgba(255, 255, 255, 0.06); box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3); }
  .mobile-card-image { position: relative; width: 100%; aspect-ratio: 8 / 5; overflow: hidden; }
  .mobile-card-image img { width: 100%; height: 100%; object-fit: cover; }
  .mobile-image-badge { position: absolute; top: 12px; left: 12px; background: rgba(18, 16, 14, 0.85); padding: 3px 10px; border-radius: 20px; border: 1px solid rgba(170, 132, 83, 0.3); }
  .mobile-image-badge span { color: #aa8453; font-size: 10px; font-family: 'Barlow Condensed', sans-serif; text-transform: uppercase; letter-spacing: 0.05em; }
  .mobile-card-caption { display: flex; flex-direction: column; flex: 1; padding: 18px 16px; }
  .m-client { color: #aa8453; font-size: 11px; text-transform: uppercase; letter-spacing: 2px; font-weight: 600; display: block; margin-bottom: 2px; }
  .m-title { min-height: 52px; }
  .m-title a { color: #ffffff; font-size: 20px; font-family: 'Gilda Display', serif; font-weight: 400; line-height: 1.3; display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
  .m-type { color: #b5b5b5; font-size: 13px; margin-bottom: 15px; }
  .mobile-card-actions { display: flex; align-items: center; justify-content: space-between; margin-top: auto; border-top: 1px solid rgba(255, 255, 255, 0.06); padding-top: 14px; }
  .m-link { color: #ffffff; font-size: 13px; font-family: 'Barlow Condensed', sans-serif; text-transform: uppercase; }
  .m-link i { color: #aa8453; margin-left: 3px; }
  .m-btn { background: #aa8453; color: #ffffff; padding: 5px 14px; font-size: 12px; border-radius: 4px; font-family: 'Barlow Condensed', sans-serif; text-transform: uppercase; }
}

/* ==========================================================================
   5. REDUCED MOTION
   ========================================================================== */
@media (prefers-reduced-motion: reduce) {
  .fp-card-media img,
  .fp-card-title,
  .fp-card-link,
  .fp-card-link i,
  .fp-all,
  .fp-all i {
    transition: none;
  }
}
</style>