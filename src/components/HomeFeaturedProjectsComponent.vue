<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { featuredProjects } from '../config/featuredProjects'

// ==========================================================================
// HomeFeaturedProjectsComponent — bản redesign theo mẫu "BARAMI" (v3):
//   • Header section style chung: eyebrow + title trái | link "Xem tất cả" phải
//   • Panel chính căn GIỮA dọc: client / location / badge năm → headline serif
//     (1 dòng) → CTA pill trắng
//   • Khối phải: dải 01──04 + nút prev/next ở TRÊN, 3 peek cards dọc ở DƯỚI
//     (2 rõ + card 3 cắt nửa sát mép phải báo còn tiếp)
//   • Bottom bar KHÔNG kẻ ngăn cách: specs dự án (diện tích · hạng mục · gỗ)
//
// GIỮ NGUYÊN hệ thống vận hành: autoplay 5 guards, keyboard ←/→, magnetic
// assist, Ken Burns, preload ảnh, aria-live. Đổi duy nhất presentation layer.
// ==========================================================================
const MOBILE_BREAKPOINT = 991
const NAV_UNLOCK_DELAY = 450      // khóa điều hướng trong lúc crossfade
const AUTOPLAY_INTERVAL = 5000    // khoảng cách tự chuyển (ms)

// ==========================================================================
// STATE
// ==========================================================================
const projects = ref([...featuredProjects])
const isTransitioning = ref(false)
const isMobile = ref(false)
const isHoveringStage = ref(false)
const sectionVisible = ref(true)

// Ảnh nền = dự án đang active (đầu mảng sau mỗi lần xoay)
const activeBgImage = computed(() => projects.value[0]?.image || '')

// Số thứ tự 01-based theo thứ tự GỐC trong featuredProjects (không phụ thuộc
// thứ tự xoay) — hiển thị trong pagination & thumbnail
const projectNumber = (id: number) => {
  const index = featuredProjects.findIndex((project) => project.id === id)
  return String(index + 1).padStart(2, '0')
}

const totalProjectsLabel = String(featuredProjects.length).padStart(2, '0')

// Pagination hiện tại ("01") + % progress fill trên đường kẻ
const currentNumber = computed(() => projectNumber(projects.value[0]?.id ?? 0))
const progressWidth = computed(() => {
  const total = featuredProjects.length || 1
  const index = featuredProjects.findIndex((p) => p.id === projects.value[0]?.id)
  return `${Math.min(100, ((index + 1) / total) * 100)}%`
})

// Ba peek card kế tiếp — 2 card hiện rõ + card thứ 3 bị cắt nửa sát mép phải (bleed)
const nextProjects = computed(() => projects.value.slice(1, 4))

// ==========================================================================
// NAVIGATION — xoay vòng mảng; caption + nền crossfade theo key đổi
// ==========================================================================
const rotate = (steps: number) => {
  const total = projects.value.length
  if (total <= 1) return
  const n = ((steps % total) + total) % total
  if (n === 0) return
  projects.value = projects.value.slice(n).concat(projects.value.slice(0, n))
}

const handleNextCard = () => {
  if (isMobile.value || isTransitioning.value || projects.value.length <= 1) return
  isTransitioning.value = true
  rotate(1)
  setTimeout(() => { isTransitioning.value = false }, NAV_UNLOCK_DELAY)
}

const handlePrevCard = () => {
  if (isMobile.value || isTransitioning.value || projects.value.length <= 1) return
  isTransitioning.value = true
  rotate(-1)
  setTimeout(() => { isTransitioning.value = false }, NAV_UNLOCK_DELAY)
}

/** Click peek card kế tiếp (theo id — an toàn với mảng đã xoay) */
const selectById = (id: number) => {
  const index = projects.value.findIndex((p) => p.id === id)
  if (index <= 0) return
  if (isTransitioning.value) return
  isTransitioning.value = true
  rotate(index)
  setTimeout(() => { isTransitioning.value = false }, NAV_UNLOCK_DELAY)
}

// ==========================================================================
// RESPONSIVE & AUTOPLAY GUARDS — chỉ tự chuyển khi TẤT CẢ điều kiện đúng:
//   1. Desktop (!isMobile)          2. Section trong viewport (≥35%)
//   3. Tab hiển thị (!document.hidden)
//   4. User không hover vùng stage  5. Không bật prefers-reduced-motion
// ==========================================================================
const checkScreenSize = () => {
  isMobile.value = window.innerWidth <= MOBILE_BREAKPOINT
  syncAutoplay()
}

let autoplayTimer: ReturnType<typeof setInterval> | null = null

const canAutoplay = () =>
  !isMobile.value &&
  sectionVisible.value &&
  !document.hidden &&
  !isHoveringStage.value &&
  !window.matchMedia('(prefers-reduced-motion: reduce)').matches

/** Đồng bộ timer autoplay theo trạng thái hiện tại (idempotent) */
const syncAutoplay = () => {
  if (canAutoplay()) {
    if (!autoplayTimer) autoplayTimer = setInterval(handleNextCard, AUTOPLAY_INTERVAL)
  } else {
    stopAutoplay()
  }
}

const stopAutoplay = () => {
  if (autoplayTimer) {
    clearInterval(autoplayTimer)
    autoplayTimer = null
  }
}

const onStageEnter = () => { isHoveringStage.value = true; syncAutoplay() }
const onStageLeave = () => { isHoveringStage.value = false; syncAutoplay() }

// ==========================================================================
// ĐIỀU HƯỚNG PHÍM TOÀN CỤC ←/→ (bỏ qua khi đang gõ trong input…)
// ==========================================================================
const onGlobalKeydown = (e: KeyboardEvent) => {
  if (isMobile.value || !sectionVisible.value) return
  const target = e.target as HTMLElement | null
  if (target && (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA' || target.tagName === 'SELECT' || target.isContentEditable)) return
  if (e.key === 'ArrowRight') { e.preventDefault(); handleNextCard() }
  else if (e.key === 'ArrowLeft') { e.preventDefault(); handlePrevCard() }
}

// ==========================================================================
// FULL-VIEWPORT MAGNETIC ASSIST (giữ nguyên từ bản đã hoàn thành)
// Sau scrollend, nếu section lệch trong phạm vi 120px so với điểm neo
// (viewport top + HEADER_CLEARANCE) thì kéo nốt về đúng điểm.
// ĐỒNG BỘ: CSS desktop min-height: max(720px, calc(100svh - 90px)).
// ==========================================================================
const sectionEl = ref<HTMLElement | null>(null)
const SNAP_ASSIST_RANGE = 120
const HEADER_CLEARANCE = 90
const SCROLL_SETTLE_DELAY = 150

let settleTimer: ReturnType<typeof setTimeout> | null = null

const magneticAssist = () => {
  if (isMobile.value || !sectionEl.value) return
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

  const rect = sectionEl.value.getBoundingClientRect()
  const offset = rect.top - HEADER_CLEARANCE
  if (Math.abs(offset) < 2 || Math.abs(offset) > SNAP_ASSIST_RANGE) return

  window.scrollTo({ top: window.scrollY + offset, behavior: 'smooth' })
}

const onScrollEnd = () => magneticAssist()

const onScrollSettle = () => {
  if (settleTimer) clearTimeout(settleTimer)
  settleTimer = setTimeout(magneticAssist, SCROLL_SETTLE_DELAY)
}

// 'onscrollend' chưa nằm trong DOM lib của TS — kiểm tra qua boolean
const supportsScrollEnd = 'onscrollend' in window

let sectionObserver: IntersectionObserver | null = null

const onVisibilityChange = () => syncAutoplay()

onMounted(() => {
  checkScreenSize()
  window.addEventListener('resize', checkScreenSize)
  syncAutoplay()

  // Preload ảnh tất cả dự án: Ken Burns crossfade không bao giờ flash trắng
  if (!isMobile.value) {
    featuredProjects.forEach((p) => { const img = new Image(); img.src = p.image })
  }

  // Autoplay chỉ chạy khi section trong viewport (≥35% hiển thị)
  if ('IntersectionObserver' in window && sectionEl.value) {
    sectionObserver = new IntersectionObserver((entries) => {
      sectionVisible.value = entries[0]?.isIntersecting ?? true
      syncAutoplay()
    }, { threshold: 0.35 })
    sectionObserver.observe(sectionEl.value)
  }
  document.addEventListener('visibilitychange', onVisibilityChange)
  window.addEventListener('keydown', onGlobalKeydown)

  if (supportsScrollEnd) {
    window.addEventListener('scrollend' as keyof WindowEventMap, onScrollEnd as EventListener)
  } else {
    window.addEventListener('scroll', onScrollSettle, { passive: true })
  }
})

onUnmounted(() => {
  window.removeEventListener('resize', checkScreenSize)
  sectionObserver?.disconnect()
  document.removeEventListener('visibilitychange', onVisibilityChange)
  window.removeEventListener('keydown', onGlobalKeydown)
  if (supportsScrollEnd) {
    window.removeEventListener('scrollend' as keyof WindowEventMap, onScrollEnd as EventListener)
  } else {
    window.removeEventListener('scroll', onScrollSettle)
  }
  if (settleTimer) clearTimeout(settleTimer)
  stopAutoplay()
})
</script>

<template>
  <section id="featured-projects" ref="sectionEl" class="fp-section" aria-labelledby="fp-heading">

    <!-- Lớp phủ ảnh nền toàn section với hiệu ứng Ken Burns (giữ nguyên) -->
    <div class="fp-bg" v-if="!isMobile">
      <transition name="ken-burns" mode="out-in">
        <div
          :key="activeBgImage"
          class="fp-bg-image"
          :style="{ backgroundImage: `url(${activeBgImage})` }"
        ></div>
      </transition>
      <div class="fp-bg-overlay"></div>
    </div>

    <div class="fp-content">

      <!-- Live region ẩn cho screen reader -->
      <p class="fp-sr-status" aria-live="polite">
        Dự án {{ currentNumber }}/{{ totalProjectsLabel }}: {{ projects[0]?.title }}
      </p>

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
                <p class="m-type">{{ project.type }}</p>
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
         GIAO DIỆN DESKTOP — editorial luxury kiểu BARAMI (v2)
         ========================================================================== -->
      <template v-else>
        <!-- Header section — style header chung: eyebrow + title trái,
             link "Xem tất cả dự án" phải (align-items-end) -->
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

        <!-- Sân khấu chính: căn GIỮA dọc — caption trái + peek cards phải -->
        <div class="fp-stage" @mouseenter="onStageEnter" @mouseleave="onStageLeave">
          <transition name="fade-slide" mode="out-in">
            <div v-if="projects.length > 0" :key="projects[0].id" class="fp-caption">
              <!-- Tên khách hàng + badge năm — đưa LÊN TRÊN tên dự án -->
              <p class="fp-client-row">
                <span class="fp-client-name">{{ projects[0].client }}</span>
                <span class="fp-client-loc">/ {{ projects[0].location }}</span>
                <span class="fp-year-badge">{{ projects[0].year }}</span>
              </p>

              <!-- Tên dự án (headline lớn) -->
              <h3 id="fp-heading" class="fp-headline">
                <RouterLink :to="{ name: 'project', hash: `#project-${projects[0].id}` }">
                  {{ projects[0].title }}
                </RouterLink>
              </h3>

              <!-- CTA dùng class button CHUẨN của hero (.butn-dark) — không tạo style mới -->
              <div class="butn-dark">
                <RouterLink :to="{ name: 'project', hash: `#project-${projects[0].id}` }">
                  <span>Xem chi tiết dự án</span>
                </RouterLink>
              </div>
            </div>
          </transition>

          <!-- Khối phải (image 1): dải số + nút điều hướng phía TRÊN,
               3 peek cards phía DƯỚI (2 rõ + card 3 cắt nửa sát mép phải) -->
          <div class="fp-right">
          <div class="fp-stage-nav">
            <!-- 2 nút prev/next TRƯỚC, dải gạch progress SAU (bỏ đánh số 01/04) -->
            <div class="fp-nav">
              <button type="button" class="fp-nav-btn" aria-label="Dự án trước" @click="handlePrevCard">
                <i class="ti-angle-left" aria-hidden="true"></i>
              </button>
              <button type="button" class="fp-nav-btn" aria-label="Dự án tiếp theo" @click="handleNextCard">
                <i class="ti-angle-right" aria-hidden="true"></i>
              </button>
            </div>

            <div class="fp-pagination" aria-hidden="true">
              <span class="fp-page-track">
                <span class="fp-page-fill" :style="{ width: progressWidth }"></span>
              </span>
            </div>
          </div>

          <div class="fp-thumbs" role="group" aria-label="Dự án kế tiếp">
            <button
              v-for="project in nextProjects"
              :key="project.id"
              type="button"
              class="fp-thumb"
              :aria-label="`Chuyển đến dự án ${project.title}`"
              @click="selectById(project.id)"
            >
              <span class="fp-thumb-media">
                <img :src="project.image" :alt="project.alt" loading="lazy" />
                <span class="fp-thumb-num" aria-hidden="true">{{ projectNumber(project.id) }}</span>
              </span>
              <span class="fp-thumb-title">{{ project.title }}</span>
            </button>
          </div>
          </div>
        </div>

        <!-- Thanh đáy — KHÔNG kẻ ngăn cách:
             specs dự án trái (thay social) · pagination 01──04 · nav tròn phải -->
        <div class="fp-bottom">
          <transition name="fade-slide" mode="out-in">
            <div v-if="projects.length > 0" :key="projects[0].id" class="fp-specs">
              <span v-for="spec in projects[0].specs" :key="spec.label" class="fp-spec-item">
                <component :is="spec.icon" aria-hidden="true" class="fp-spec-icon" />
                {{ spec.label }}
              </span>
            </div>
          </transition>
        </div>
      </template>

    </div>
  </section>
</template>

<style scoped>
/* ==========================================================================
   1. SECTION FULL-BLEED — nền tối điện ảnh (kế thừa bản trước)
   ========================================================================== */
.fp-section {
  position: relative;
  overflow: hidden;
  min-height: 720px;
  background-color: #121212;
  display: flex;
  flex-direction: column;
  width: 100vw !important;
  margin-left: calc(-50vw + 50%) !important;
  margin-right: calc(-50vw + 50%) !important;
}

.fp-bg { position: absolute; inset: 0; width: 100% !important; height: 100% !important; z-index: 1; }
.fp-bg-image { position: absolute; inset: 0; width: 100% !important; height: 100% !important; background-size: cover; background-position: center; background-repeat: no-repeat; }
.fp-bg-overlay {
  position: absolute; inset: 0;
  /* Gradient NHẸ, chỉ phủ vùng sát mép trái chứa chữ — ảnh trung tâm sáng rõ */
  background: linear-gradient(90deg, rgba(12, 10, 8, 0.82) 0%, rgba(12, 10, 8, 0.55) 30%, rgba(12, 10, 8, 0.28) 55%, rgba(12, 10, 8, 0.08) 75%, rgba(12, 10, 8, 0) 100%) !important;
  z-index: 2;
}

.fp-content {
  position: relative; z-index: 3;
  width: 100%;
  display: flex; flex-direction: column;
  padding-left: 4%; padding-right: 3.5%;
  padding-top: 110px; padding-bottom: 92px;
  flex: 1;
}

/* ==========================================================================
   2. HEADER SECTION — style header chung: chỉ title (không eyebrow)
   ========================================================================== */
/* Header section — rộng bằng các section khác (ví dụ "Khám phá theo không gian"):
   max-width container + auto margin để căn giữa trong full-bleed section. */
.featured-projects-header {
  width: 100%;
  max-width: 960px;
  margin-left: auto !important;
  margin-right: auto !important;
  margin-bottom: 30px !important;
  padding-left: 12px;
  padding-right: 12px;
}
@media (min-width: 1200px) { .featured-projects-header { max-width: 1140px; } }
@media (min-width: 1400px) { .featured-projects-header { max-width: 1320px; } }
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
   3. STAGE — căn GIỮA dọc: caption trái + peek cards phải sát mép
   ========================================================================== */
.fp-stage {
  flex: 1;
  display: flex; align-items: center;
  gap: 40px;
  padding: 16px 0 32px;
}

.fp-caption { max-width: 640px; color: #ffffff !important; }

/* Headline: tên dự án — serif mảnh, cho phép 2 dòng nhưng KHÔNG dùng "…":
   tên dự án luôn hiển thị đầy đủ thông tin */
.fp-headline { margin: 0 0 16px !important; }
.fp-headline a {
  color: #ffffff !important;
  font-family: 'Gilda Display', serif !important;
  font-weight: 400 !important;
  font-size: clamp(30px, 2.9vw, 52px) !important;
  line-height: 1.15 !important;
  letter-spacing: 0.01em;
  font-style: italic;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  white-space: normal;
  max-width: 100%;
  transition: color 0.3s ease;
}
.fp-headline a:hover { color: #d7b98a !important; }

/* Tên khách hàng / địa điểm / badge năm thực hiện */
.fp-client-row { margin: 0 0 30px !important; display: flex; align-items: center; gap: 12px; }
.fp-client-name {
  color: #e2dcd4 !important;
  font-family: 'Barlow', sans-serif !important;
  font-size: 15px !important; font-weight: 400 !important; letter-spacing: 0.4px !important;
}
.fp-client-loc {
  color: #d5cfc7 !important;
  font-family: 'Barlow', sans-serif !important;
  font-size: 14px !important; font-weight: 400 !important; letter-spacing: 0.4px !important;
}
.fp-year-badge {
  font-style: normal;
  font-size: 11px; font-weight: 600; letter-spacing: 1.5px;
  color: #ffffff; background: #aa8453;
  padding: 2px 10px; border-radius: 20px;
}


/* ------------------------------------------------------------------
   Peek cards — HÌNH DỌC, 3 card hàng ngang: 2 card rõ + card 3 cắt nửa
   sát mép phải (bleed 50%). Card 02 to nhất, card 03 nhỏ dần.
   Nav ở TRÊN peek cards (image 1). */
.fp-right {
  margin-left: auto;
  display: flex; flex-direction: column;
  align-items: flex-end;
  gap: 22px;
  flex-shrink: 0;
  min-width: 0;
}

.fp-thumbs {
  /* Cắt đúng 50% card 3: đẩy ra ngoài = padding-right (3.5vw) + nửa card (130px) */
  margin-right: calc(-3.5vw - 130px);
  display: flex; align-items: center;
  gap: 18px;
  flex-shrink: 0;
}

/* Dải điều hướng TRÊN peek cards — ĐIỂM BẮT ĐẦU THẲNG CARD ĐẦU TIÊN:
   width đúng bằng 1 card, margin-right đẩy vô đúng vị trí card 1 */
.fp-stage-nav {
  width: 260px;
  /* mép TRÁI nav trùng mép TRÁI card 1: outer-width nav = outer-width thumbs
     (thumbs outer = 816 - 130 - 3.5vw = 686 - 3.5vw → M = 686 - 3.5vw - 260) */
  margin-right: calc(426px - 3.5vw);
  display: flex; align-items: center;
  justify-content: space-between;
  gap: 10px;
}
.fp-thumb {
  padding: 0; border: 0; background: transparent;
  cursor: pointer; text-align: left;
  flex-shrink: 0;
}
.fp-thumb-media {
  position: relative; display: block;
  width: 100%;
  overflow: hidden;
  background: #0d0d0d;
  /* Viền sáng rõ + bóng sâu: phân tách ranh giới các card trên nền tối */
  border: 1px solid rgba(255, 255, 255, 0.18);
  box-shadow: 0 18px 44px rgba(0, 0, 0, 0.55);
  border-radius: 12px; /* bo tròn nhẹ 4 góc */
}

/* 3 cards KÍCH THƯỚC BẰNG NHAU, dọc tỷ lệ w:h = 40:60 (260×390),
   card 3 bị cắt nửa bởi margin-right âm của .fp-thumbs */
.fp-thumb { flex: 0 0 260px; width: 260px; }
.fp-thumb .fp-thumb-media { height: 390px; }
.fp-thumb-media img {
  width: 100%; height: 100%; object-fit: cover;
  filter: brightness(0.82);
  transition: transform 0.6s cubic-bezier(0.25, 1, 0.5, 1), filter 0.4s ease;
}
.fp-thumb:hover .fp-thumb-media img,
.fp-thumb:focus-visible .fp-thumb-media img { transform: scale(1.06); filter: brightness(1); }
.fp-thumb-num {
  position: absolute; top: 8px; left: 12px;
  color: #ffffff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 24px; font-weight: 700; letter-spacing: 0.06em;
  text-shadow: 0 2px 12px rgba(0, 0, 0, 0.6);
}
.fp-thumb:nth-child(2) .fp-thumb-num { font-size: 18px; top: 6px; left: 9px; }
.fp-thumb:nth-child(3) .fp-thumb-num { font-size: 22px; }
.fp-thumb-title {
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
  height: 35px; /* LUÔN giữ chỗ 2 dòng → card đồng chiều cao dù tên dài/ngắn */
  margin-top: 8px;
  color: #e8e4df;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px; font-weight: 600;
  text-transform: uppercase; letter-spacing: 0.14em;
  line-height: 1.6;
  transition: color 0.3s ease;
}
.fp-thumb:hover .fp-thumb-title,
.fp-thumb:focus-visible .fp-thumb-title { color: #aa8453; }
.fp-thumb:focus-visible { outline: 2px solid #aa8453; outline-offset: 4px; }

/* ==========================================================================
   4. BOTTOM BAR — KHÔNG kẻ ngăn cách: specs dự án trái
   ========================================================================== */
.fp-bottom {
  display: flex; align-items: center; justify-content: flex-start;
  gap: 24px;
}

/* Specs dự án: địa điểm · diện tích · hạng mục · chất liệu (thay social) */
.fp-specs {
  display: flex; align-items: center; flex-wrap: wrap;
  gap: 8px 16px;
  max-width: 48%;
}
.fp-spec-loc {
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px; font-weight: 600;
  text-transform: uppercase; letter-spacing: 0.2em;
  white-space: nowrap;
}
.fp-spec-dot { color: rgba(255, 255, 255, 0.35); }
.fp-spec-item {
  display: inline-flex; align-items: center; gap: 6px;
  color: #e8e4df;
  font-size: 13px; font-weight: 400;
  white-space: nowrap;
}
.fp-spec-icon { width: 14px; height: 14px; color: #aa8453; flex-shrink: 0; }

/* Progress track đơn (bỏ số 01/04): fill vàng gradient theo dự án active */
.fp-pagination { display: flex; align-items: center; flex: 1; min-width: 0; }
.fp-page-track { position: relative; width: 100%; max-width: 150px; height: 1px; background: rgba(255, 255, 255, 0.28); }
.fp-page-fill {
  position: absolute; left: 0; top: 0; height: 100%;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
  transition: width 0.6s cubic-bezier(0.25, 1, 0.5, 1);
}

/* Nút tròn prev/next — ĐỒNG BỘ 1:1 với nút owl-nav hero/news:
   tròn 40px, viền trắng mờ, hover scale(0.9) + viền gold #aa8453 */
.fp-nav { display: flex; gap: 10px; flex-shrink: 0; }
.fp-nav-btn {
  width: 40px; height: 40px; border-radius: 100%;
  border: 1px solid rgba(255, 255, 255, 0.5);
  background: transparent; color: #ffffff;
  display: flex; align-items: center; justify-content: center;
  cursor: pointer; padding: 0;
  transition: all 0.2s ease-in-out;
}
.fp-nav-btn i { font-size: 13px; line-height: 1; color: #ffffff; transition: transform 0.3s ease, color 0.3s ease; }
.fp-nav-btn:hover { border-color: #aa8453; transform: scale(0.9); }
.fp-nav-btn:hover i { color: #aa8453; }
.fp-nav-btn:first-child:hover i { transform: translateX(-2px); }
.fp-nav-btn:last-child:hover i { transform: translateX(2px); }
.fp-nav-btn:focus-visible { outline: 2px solid #aa8453; outline-offset: 4px; }

/* Live region ẩn cho screen reader */
.fp-sr-status {
  position: absolute; width: 1px; height: 1px;
  margin: -1px; padding: 0; overflow: hidden;
  clip: rect(0 0 0 0); white-space: nowrap; border: 0;
}

/* ==========================================================================
   5. CHUYỂN CẢNH — caption trượt + Ken Burns (giữ nguyên từ bản trước)
   ========================================================================== */
.fade-slide-enter-active { transition: opacity 0.6s cubic-bezier(0.25, 1, 0.5, 1), transform 0.6s cubic-bezier(0.25, 1, 0.5, 1); }
.fade-slide-leave-active { transition: opacity 0.3s ease-in, transform 0.3s ease-in; }
.fade-slide-enter-from { opacity: 0; transform: translate3d(-24px, 0, 0); }
.fade-slide-leave-to { opacity: 0; transform: translate3d(15px, 0, 0); }

.ken-burns-enter-active {
  transition: opacity 1.1s ease, transform 1.1s cubic-bezier(0.25, 1, 0.5, 1);
}
.ken-burns-leave-active { transition: opacity 0.55s ease; }
.ken-burns-enter-from { opacity: 0; transform: scale(1.06); }
.ken-burns-leave-to { opacity: 0; }
.ken-burns-enter-to { opacity: 1; transform: scale(1); }

@media (prefers-reduced-motion: reduce) {
  .ken-burns-enter-active { transition: opacity 0.3s ease; }
  .ken-burns-enter-from { transform: none; }
  .fade-slide-enter-active, .fade-slide-leave-active { transition: opacity 0.2s ease; }
  .fade-slide-enter-from, .fade-slide-leave-to { transform: none; }
  .fp-thumb-media img, .fp-page-fill { transition: none; }
}

/* ==========================================================================
   6. DESKTOP ≥992px — "HIỂN THỊ NHƯ HERO" + RESPONSIVE CARDS THEO CHIỀU NGANG
   Nhỏ ≤1199px: card thu nhỏ theo tỷ lệ để nav + pagination LUÔN nằm trong
   viewport (tránh bị overflow:hidden cắt mất). ≥1400px: mặc định 260×390.
   ========================================================================== */
@media (min-width: 992px) {
  .fp-section {
    min-height: max(720px, calc(100vh - 90px));
    min-height: max(720px, calc(100svh - 90px));
    height: auto;
  }
}

@media (min-width: 992px) and (max-width: 1199px) {
  .fp-thumb { flex: 0 0 185px; width: 185px; }
  .fp-thumb .fp-thumb-media { height: 278px; }
  .fp-thumbs { margin-right: calc(-3.5vw - 92px); gap: 12px; }
  .fp-stage-nav { width: 185px; margin-right: calc(302px - 3.5vw); }
  .fp-stage { gap: 24px; }
  .fp-caption { max-width: 430px; }
}

@media (min-width: 1200px) and (max-width: 1399px) {
  .fp-thumb { flex: 0 0 220px; width: 220px; }
  .fp-thumb .fp-thumb-media { height: 330px; }
  .fp-thumb-title { height: 35px; }
  .fp-thumbs { margin-right: calc(-3.5vw - 110px); }
  .fp-stage-nav { width: 220px; margin-right: calc(366px - 3.5vw); }
}

/* ==========================================================================
   7. MOBILE / TABLET — cuộn ngang tự nhiên (giữ nguyên form chuẩn đã duyệt)
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
</style>