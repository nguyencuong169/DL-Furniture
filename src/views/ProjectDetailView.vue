<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { useRoute } from 'vue-router'
import { fetchProjectById, type ProjectResponse } from '../api/projectClient'
import { setPageSeo } from '../utils/seo'
import fallbackHeroImage from '../assets/img/slider/3.jpg'

const route = useRoute()
const project = ref<ProjectResponse | null>(null)
const loading = ref(true)

onMounted(async () => {
  const id = Number(route.params.id)
  if (Number.isFinite(id) && id > 0) {
    project.value = await fetchProjectById(id)
  }
  setPageSeo({
    title: project.value
      ? `${project.value.title} | Dự Án Nội Thất Gỗ Óc Chó – D&L Furniture`
      : 'Dự án không tồn tại | D&L Furniture',
    description:
      project.value?.subtitle ||
      'Chi tiết dự án thi công nội thất gỗ óc chó do D&L Furniture thực hiện: quy mô, chất liệu, hình ảnh thực tế.',
    path: route.path
  })
  loading.value = false
})

const coverImage = computed(() => project.value?.coverImage || fallbackHeroImage)

const galleryImages = computed(() => {
  if (!project.value) return []
  const cover = project.value.coverImage
  const images = project.value.images.map((image) => image.imageUrl)
  const all = cover ? [cover, ...images] : images
  return [...new Set(all)]
})

const hasMeta = computed(
  () => Boolean(project.value?.clientName || project.value?.location || project.value?.subtitle)
)
</script>

<template>
  <main>
    <!-- Banner -->
    <div
      class="banner-header section-padding valign bg-img"
      data-overlay-dark="5"
      :style="{ backgroundImage: `url(${coverImage})` }"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <RouterLink :to="{ name: 'project' }" class="back-link">
              <i class="ti-arrow-left" aria-hidden="true"></i> Danh sách dự án
            </RouterLink>
            <span class="hero-line" aria-hidden="true"></span>
            <h1 v-if="project">{{ project.title }}</h1>
            <h1 v-else>Dự án không tồn tại</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- Content -->
    <section class="project-detail section-padding">
      <div class="container">
        <div class="row justify-content-center">
          <div class="col-lg-10 col-md-12">
            <!-- Loading -->
            <div v-if="loading" class="project-detail-loading">Đang tải dự án…</div>

            <!-- Not found -->
            <div v-else-if="!project" class="project-detail-missing">
              <p>Không tìm thấy dự án. Vui lòng quay lại danh sách dự án.</p>
              <div class="butn-dark mt-15">
                <RouterLink :to="{ name: 'project' }"><span>Xem danh sách dự án</span></RouterLink>
              </div>
            </div>

            <template v-else>
              <!-- Meta -->
              <div v-if="hasMeta" class="project-detail-meta">
                <div v-if="project.clientName" class="meta-item">
                  <span class="meta-label">Gia chủ</span>
                  <span class="meta-value">{{ project.clientName }}</span>
                </div>
                <div v-if="project.location" class="meta-item">
                  <span class="meta-label">Địa điểm</span>
                  <span class="meta-value">{{ project.location }}</span>
                </div>
                <div v-if="project.subtitle" class="meta-item">
                  <span class="meta-label">Hạng mục</span>
                  <span class="meta-value">{{ project.subtitle }}</span>
                </div>
              </div>

              <!-- Description -->
              <div v-if="project.description" class="project-detail-desc">
                <p>{{ project.description }}</p>
              </div>

              <!-- Gallery -->
              <div v-if="galleryImages.length" class="project-detail-gallery">
                <img
                  v-for="(image, index) in galleryImages"
                  :key="`${image}-${index}`"
                  :src="image"
                  :alt="project.title"
                  loading="lazy"
                />
              </div>

              <!-- CTA -->
              <div class="project-detail-cta">
                <p>
                  Dự án tương tự với không gian của bạn? Đội ngũ D&L Furniture sẽ tư vấn thiết
                  kế và báo giá theo hiện trạng công trình.
                </p>
                <div class="butn-dark">
                  <RouterLink :to="{ name: 'home', hash: '#consultation' }">
                    <span>Đặt lịch tư vấn</span>
                  </RouterLink>
                </div>
              </div>
            </template>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
.project-detail .container {
  max-width: 980px;
}

.banner-header .back-link {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  font-family: 'Barlow', sans-serif;
  font-size: 13px;
  letter-spacing: 1px;
  color: rgba(255, 255, 255, 0.85);
  text-transform: uppercase;
  margin-bottom: 18px;
  transition: color 0.3s ease;
}

.banner-header .back-link:hover {
  color: #d7b98a;
}

.banner-header h1 {
  max-width: 760px;
}

/* ---- Meta ---- */
.project-detail-meta {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
  gap: 1px;
  background: #e8e0d4;
  border: 1px solid #e8e0d4;
  margin-bottom: 34px;
}

.meta-item {
  background: #fff;
  padding: 18px 22px;
}

.meta-label {
  display: block;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 3px;
  text-transform: uppercase;
  color: #aa8453;
  margin-bottom: 6px;
}

.meta-value {
  display: block;
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  color: #1e1a16;
}

/* ---- Description ---- */
.project-detail-desc {
  margin-bottom: 34px;
}

.project-detail-desc p {
  font-size: 16px;
  line-height: 1.9;
  color: #555;
  margin: 0;
}

/* ---- Gallery ---- */
.project-detail-gallery {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 14px;
  margin-bottom: 40px;
}

.project-detail-gallery img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  aspect-ratio: 4 / 3;
  display: block;
}

.project-detail-gallery img:first-child:last-child {
  grid-column: 1 / -1;
  aspect-ratio: 16 / 9;
}

/* ---- CTA ---- */
.project-detail-cta {
  padding: 26px 30px;
  background: #f8f5f0;
  border-left: 3px solid #aa8453;
}

.project-detail-cta p {
  margin: 0 0 16px;
  color: #555;
}

.project-detail-loading,
.project-detail-missing {
  text-align: center;
  padding: 60px 0;
}

.project-detail-loading {
  color: #8a8177;
  font-family: 'Gilda Display', serif;
  font-size: 22px;
}

.project-detail-missing p {
  color: #666;
  margin-bottom: 14px;
}

@media (max-width: 767px) {
  .project-detail-gallery {
    grid-template-columns: 1fr;
  }
}
</style>