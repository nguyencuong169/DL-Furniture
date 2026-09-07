<script setup lang="ts">
import { computed, watchEffect } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowRight, Check } from 'lucide-vue-next'
import {
  getServiceLanding,
  relatedProjectsFor,
  serviceLandings,
  servicePath,
  type ServiceLanding
} from '../config/services'
import { setPageSeo } from '../utils/seo'

const route = useRoute()
const router = useRouter()

/**
 * Trang landing dịch vụ theo loại hình (B2 — SEO).
 * Nội dung nằm hoàn toàn trong `src/config/services.ts`; view chỉ dựng
 * bố cục chung: banner → intro + điểm nhấn → phạm vi hạng mục (nền tối)
 * → dự án liên quan → FAQ → CTA tư vấn + liên kết chéo sang dịch vụ khác.
 * Slug lạ → chuyển về trang 404.
 */
const service = computed<ServiceLanding | undefined>(() =>
  getServiceLanding(String(route.params.slug ?? ''))
)

const relatedProjects = computed(() => (service.value ? relatedProjectsFor(service.value) : []))

const otherServices = computed(() =>
  serviceLandings.filter((item) => item.slug !== service.value?.slug)
)

watchEffect(() => {
  const current = service.value
  if (!current) {
    void router.replace({ name: 'NotFound' })
    return
  }
  setPageSeo({
    title: current.metaTitle,
    description: current.metaDescription,
    path: servicePath(current)
  })
})
</script>

<template>
  <main v-if="service">
    <!-- Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      :style="{ backgroundImage: `url(${service.heroImage})` }"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <h5>D&L Furniture — {{ service.heroTagline }}</h5>
            <h1>{{ service.name }}</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- Intro + điểm nhấn -->
    <section class="svc-intro section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="svc-eyebrow">Dịch vụ của chúng tôi</span>
            <h2 class="svc-heading">{{ service.name }}</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-8">
            <p v-for="paragraph in service.intro" :key="paragraph.slice(0, 24)" class="svc-lead">
              {{ paragraph }}
            </p>
          </div>
        </div>
        <div class="row svc-highlights">
          <div
            v-for="(highlight, index) in service.highlights"
            :key="highlight.title"
            class="col-md-4"
          >
            <article class="svc-highlight-card">
              <span class="svc-highlight-number">0{{ index + 1 }}</span>
              <h3>{{ highlight.title }}</h3>
              <p>{{ highlight.text }}</p>
            </article>
          </div>
        </div>
      </div>
    </section>

    <!-- Phạm vi hạng mục (nền tối) -->
    <section class="svc-scope">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="svc-eyebrow svc-eyebrow--light">Phạm vi thi công</span>
            <h2 class="svc-heading svc-heading--light">Hạng mục D&L nhận trọn gói</h2>
          </div>
        </div>
        <ul class="svc-scope-grid">
          <li v-for="item in service.scope" :key="item">
            <Check aria-hidden="true" />
            <span>{{ item }}</span>
          </li>
        </ul>
      </div>
    </section>

    <!-- Dự án liên quan -->
    <section v-if="relatedProjects.length" class="svc-projects section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="svc-eyebrow">Dự án đã thực hiện</span>
            <h2 class="svc-heading">Công trình cùng loại hình</h2>
          </div>
        </div>
        <div class="row svc-projects-grid">
          <div v-for="project in relatedProjects" :key="project.id" class="col-md-6">
            <article class="svc-project-card">
              <RouterLink :to="{ name: 'project' }" class="svc-project-image">
                <img :src="project.image" :alt="project.alt" loading="lazy" />
              </RouterLink>
              <div class="svc-project-body">
                <span class="svc-project-meta">
                  {{ project.client }} · {{ project.location }} · {{ project.year }}
                </span>
                <h3>
                  <RouterLink :to="{ name: 'project' }">{{ project.title }}</RouterLink>
                </h3>
                <div class="svc-project-specs">
                  <span v-for="spec in project.specs" :key="spec.label">
                    <component :is="spec.icon" aria-hidden="true" /> {{ spec.label }}
                  </span>
                </div>
              </div>
            </article>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12 text-center">
            <RouterLink to="/du-an" class="svc-more-link">
              Xem tất cả dự án <ArrowRight aria-hidden="true" />
            </RouterLink>
          </div>
        </div>
      </div>
    </section>

    <!-- FAQ -->
    <section class="svc-faq section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="svc-eyebrow">Giải đáp</span>
            <h2 class="svc-heading">Câu hỏi thường gặp</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-10 offset-md-1">
            <details
              v-for="(item, index) in service.faq"
              :key="item.question"
              class="svc-faq-item"
              :open="index === 0"
            >
              <summary>{{ item.question }}</summary>
              <p>{{ item.answer }}</p>
            </details>
          </div>
        </div>
      </div>
    </section>

    <!-- CTA -->
    <section class="svc-cta">
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-center">
            <h2>Bạn đang có mặt bằng phù hợp với hạng mục này?</h2>
            <p>
              Nhận khảo sát, tư vấn phương án và báo giá khối lượng minh bạch từ đội ngũ D&L
              Furniture.
            </p>
            <RouterLink :to="{ name: 'home', hash: '#consultation' }" class="svc-cta-button">
              Đặt lịch tư vấn <ArrowRight aria-hidden="true" />
            </RouterLink>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12 text-center svc-cta-others">
            <span>Dịch vụ khác:</span>
            <RouterLink v-for="item in otherServices" :key="item.slug" :to="servicePath(item)">
              {{ item.name }}
            </RouterLink>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
/* ==========================================================================
   SERVICE DETAIL VIEW — landing dịch vụ theo loại hình (B2)
   Dùng đúng token của hệ: gold #aa8453, Gilda Display (heading),
   Barlow Condensed (eyebrow). Nhịp: banner tối → intro sáng → scope tối
   → dự án sáng → FAQ sáng → CTA tối.
   ========================================================================== */

.svc-eyebrow {
  display: inline-block;
  margin-bottom: 10px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 3px;
  text-transform: uppercase;
}

.svc-eyebrow--light {
  color: #c9a876;
}

.svc-heading {
  margin: 0 0 26px;
  color: #1e1a16;
  font-family: 'Gilda Display', serif;
  font-size: 34px;
  line-height: 1.2;
}

.svc-heading--light {
  color: #f5efe6;
}

/* ---- Intro ---- */
.svc-intro .svc-lead {
  margin-bottom: 16px;
  color: #5a5348;
  font-size: 16px;
  line-height: 1.75;
}

.svc-highlights {
  margin-top: 26px;
}

.svc-highlight-card {
  height: 100%;
  padding: 28px 26px;
  background: #faf7f2;
  border: 1px solid rgba(170, 132, 83, 0.25);
  border-top: 2px solid #aa8453;
}

.svc-highlight-number {
  display: block;
  margin-bottom: 12px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 26px;
  font-weight: 600;
  letter-spacing: 2px;
}

.svc-highlight-card h3 {
  margin-bottom: 10px;
  color: #1e1a16;
  font-family: 'Gilda Display', serif;
  font-size: 20px;
}

.svc-highlight-card p {
  margin: 0;
  color: #6b6357;
  font-size: 14px;
  line-height: 1.65;
}

/* ---- Scope (nền tối) ---- */
.svc-scope {
  padding: 90px 0;
  background: #211c17;
}

.svc-scope-grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 18px 32px;
  margin: 0;
  padding: 0;
  list-style: none;
}

.svc-scope-grid li {
  display: flex;
  align-items: flex-start;
  gap: 12px;
  padding: 16px 18px;
  background: rgba(245, 239, 230, 0.04);
  border: 1px solid rgba(245, 239, 230, 0.12);
  color: #ece5d8;
  font-size: 15px;
  line-height: 1.5;
}

.svc-scope-grid li svg {
  width: 18px;
  height: 18px;
  margin-top: 2px;
  color: #aa8453;
  flex-shrink: 0;
}

/* ---- Dự án liên quan ---- */
.svc-projects-grid {
  margin-top: 14px;
  margin-bottom: 30px;
}

.svc-project-card {
  height: 100%;
  background: #fff;
  border: 1px solid rgba(170, 132, 83, 0.25);
  box-shadow: 0 18px 44px rgba(17, 15, 13, 0.08);
  transition: box-shadow 0.3s ease;
}

.svc-project-card:hover {
  box-shadow: 0 26px 60px rgba(17, 15, 13, 0.14);
}

.svc-project-image {
  display: block;
  aspect-ratio: 3 / 2;
  overflow: hidden;
}

.svc-project-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.5s ease;
}

.svc-project-card:hover .svc-project-image img {
  transform: scale(1.04);
}

.svc-project-body {
  padding: 20px 22px 22px;
}

.svc-project-meta {
  display: block;
  margin-bottom: 6px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.svc-project-body h3 {
  margin: 0 0 12px;
  font-family: 'Gilda Display', serif;
  font-size: 19px;
  line-height: 1.35;
}

.svc-project-body h3 a {
  color: #1e1a16;
}

.svc-project-body h3 a:hover {
  color: #aa8453;
}

.svc-project-specs {
  display: flex;
  flex-wrap: wrap;
  gap: 8px 18px;
}

.svc-project-specs span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: #6b6357;
  font-size: 12.5px;
}

.svc-project-specs svg {
  width: 14px;
  height: 14px;
  color: #aa8453;
}

.svc-more-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
  transition: gap 0.25s ease;
}

.svc-more-link:hover,
.svc-more-link:focus-visible {
  gap: 15px;
  color: #8e6738;
}

/* ---- FAQ ---- */
.svc-faq-item {
  margin-bottom: 14px;
  background: #faf7f2;
  border: 1px solid rgba(170, 132, 83, 0.25);
}

.svc-faq-item summary {
  position: relative;
  padding: 18px 52px 18px 22px;
  color: #1e1a16;
  cursor: pointer;
  font-family: 'Gilda Display', serif;
  font-size: 17px;
  list-style: none;
}

.svc-faq-item summary::-webkit-details-marker {
  display: none;
}

/* Dấu + xoay 45° thành × khi mở */
.svc-faq-item summary::after {
  content: '+';
  position: absolute;
  right: 22px;
  top: 50%;
  transform: translateY(-50%);
  color: #aa8453;
  font-family: 'Barlow', sans-serif;
  font-size: 22px;
  transition: transform 0.25s ease;
}

.svc-faq-item[open] summary::after {
  transform: translateY(-50%) rotate(45deg);
}

.svc-faq-item summary:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 2px;
}

.svc-faq-item p {
  margin: 0;
  padding: 0 22px 20px;
  color: #5a5348;
  font-size: 14.5px;
  line-height: 1.7;
}

/* ---- CTA ---- */
.svc-cta {
  padding: 90px 0;
  background: #211c17;
}

.svc-cta h2 {
  margin-bottom: 14px;
  color: #f5efe6;
  font-family: 'Gilda Display', serif;
  font-size: 30px;
}

.svc-cta p {
  margin-bottom: 28px;
  color: #b9b0a2;
  font-size: 15.5px;
}

.svc-cta-button {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding: 14px 34px;
  background: #aa8453;
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 2.5px;
  text-transform: uppercase;
  transition: gap 0.25s ease, background 0.25s ease;
}

.svc-cta-button:hover,
.svc-cta-button:focus-visible {
  gap: 15px;
  background: #8e6738;
  color: #fff;
}

.svc-cta-others {
  margin-top: 34px;
  color: #8a8177;
  font-size: 13.5px;
}

.svc-cta-others span {
  margin-right: 8px;
  letter-spacing: 1px;
  text-transform: uppercase;
  font-family: 'Barlow Condensed', sans-serif;
}

.svc-cta-others a {
  margin: 0 10px;
  color: #c9a876;
  border-bottom: 1px solid transparent;
  transition: color 0.25s ease, border-color 0.25s ease;
}

.svc-cta-others a:hover,
.svc-cta-others a:focus-visible {
  color: #f5efe6;
  border-color: #f5efe6;
}

/* ---- Responsive ---- */
@media (max-width: 991.98px) {
  .svc-heading {
    font-size: 28px;
  }

  .svc-scope-grid {
    grid-template-columns: repeat(2, 1fr);
  }

  .svc-cta h2 {
    font-size: 26px;
  }
}

@media (max-width: 575.98px) {
  .svc-scope {
    padding: 70px 0;
  }

  .svc-cta {
    padding: 70px 0;
  }

  .svc-scope-grid {
    grid-template-columns: 1fr;
  }

  .svc-faq-item summary {
    padding: 15px 46px 15px 16px;
    font-size: 15.5px;
  }

  .svc-faq-item p {
    padding: 0 16px 16px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .svc-project-image img,
  .svc-project-card,
  .svc-more-link,
  .svc-cta-button,
  .svc-faq-item summary::after,
  .svc-cta-others a {
    transition: none;
  }
}
</style>
