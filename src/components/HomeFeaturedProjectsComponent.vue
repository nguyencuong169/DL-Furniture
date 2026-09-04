<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { featuredProjects } from '../config/featuredProjects'

// ==========================================================================
// CONSTANTS — Tập trung tất cả magic numbers để dễ bảo trì
// ==========================================================================
const MOBILE_BREAKPOINT = 991

const CARD_VERTICAL_GAP = 86
// 36px (thay vì 50px): card active tràn sát mép phải (bleed) nên các card sau dịch
// phải từng bậc sẽ tràn qua mép màn hình một phần — 36px giữ lượng bị cắt tối thiểu
const CARD_HORIZONTAL_GAP = 36
const CARD_SCALE_STEP = 0.04
const CARD_OPACITY_STEP = 0.12
const CARD_OPACITY_FLOOR = 0.9

const SWAP_DROP_DELAY = 350       // Thời gian chờ card rơi trước khi tráo mảng
const SWAP_UNLOCK_DELAY = 100     // Thời gian chờ sau khi tráo xong để mở khóa
const PREV_UNLOCK_DELAY = 500     // Thời gôi chờ sau khi prev card
const SELECT_UNLOCK_DELAY = 400   // Thời gian chờ sau khi select card
const AUTOPLAY_INTERVAL = 5000    // Khoảng cách giữa các lần tự chuyển (ms)

// ==========================================================================
// STATE
// ==========================================================================
const projects = ref([...featuredProjects])
const swappingId = ref<number | null>(null)
const isTransitioning = ref(false)
const isMobile = ref(false)

// Lấy hình ảnh của dự án đang active ở đầu mảng làm nền cho section
const activeBgImage = computed(() => {
  return projects.value[0]?.image || ''
})

// Số thứ tự của một dự án (01-based, theo thứ tự gốc trong featuredProjects —
// không phụ thuộc thứ tự deck sau khi tráo) hiển thị trong header của card
const projectNumber = (id: number) => {
  const index = featuredProjects.findIndex((project) => project.id === id)
  return String(index + 1).padStart(2, '0')
}

const totalProjectsLabel = String(featuredProjects.length).padStart(2, '0')

/**
 * Tính style cho từng card trong bộ bài.
 * Card ở vị trí 0 là card trên cùng (active).
 * Các card phía sau dịch chuyển dần theo hướng lệch lên trên và thu nhỏ dần.
 */
const getCardStyle = (index: number, id: number) => {
  if (isMobile.value) return {}

  const total = projects.value.length

  if (swappingId.value === id) {
    return {
      transform: 'translate3d(0, 120px, 0) scale(0.92)',
      opacity: 0,
      pointerEvents: 'none' as const,
      zIndex: 0,
      transition: `transform ${SWAP_DROP_DELAY}ms cubic-bezier(0.25, 1, 0.5, 1), opacity ${SWAP_DROP_DELAY}ms ease`
    }
  }

  // Công thức tịnh tiến xéo song song cố định tăm tắp bám biên
  const tx = index * CARD_HORIZONTAL_GAP
  const ty = index * -CARD_VERTICAL_GAP
  const scale = 1 - (index * CARD_SCALE_STEP)

  // Transform truyền qua CSS variable thay vì inline transform — để :hover/:focus
  // trong CSS có thể nâng card (inline transform sẽ ghi đè mọi hover rule)
  return {
    '--tx': `${tx}px`,
    '--ty': `${ty}px`,
    '--card-scale': scale,
    
    // Nâng mức sàn opacity lên 0.9 để chữ trên card phía sau luôn dễ đọc, nét rõ
    opacity: index === 0 ? 1 : Math.max(1 - (index * CARD_OPACITY_STEP), CARD_OPACITY_FLOOR), 
    
    zIndex: total - index,
    transition: `transform 0.65s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.45s ease`
  }
}

// ==========================================================================
// CARD ACTIONS
// ==========================================================================

/** Chuyển sang card tiếp theo (card đầu rơi xuống, chuyển ra sau) */
const handleNextCard = () => {
  if (isMobile.value || isTransitioning.value || projects.value.length <= 1) return
  isTransitioning.value = true

  const topCard = projects.value[0]
  swappingId.value = topCard.id

  // Chờ card chớm rơi rồi tráo mảng để các card sau tiến lên ngay lập tức
  setTimeout(() => {
    const shifted = projects.value.shift()
    if (shifted) projects.value.push(shifted)
    swappingId.value = null

    setTimeout(() => {
      isTransitioning.value = false
    }, SWAP_UNLOCK_DELAY)
  }, SWAP_DROP_DELAY)
}

/** Lùi về card trước */
const handlePrevCard = () => {
  if (isMobile.value || isTransitioning.value || projects.value.length <= 1) return
  isTransitioning.value = true

  const popped = projects.value.pop()
  if (popped) projects.value.unshift(popped)

  setTimeout(() => {
    isTransitioning.value = false
  }, PREV_UNLOCK_DELAY)
}

/** Click chọn card theo index */
const selectCard = (index: number) => {
  if (isMobile.value || isTransitioning.value) return
  if (index === 0) {
    handleNextCard()
  } else {
    isTransitioning.value = true
    for (let i = 0; i < index; i++) {
      const shifted = projects.value.shift()
      if (shifted) projects.value.push(shifted)
    }
    setTimeout(() => { isTransitioning.value = false }, SELECT_UNLOCK_DELAY)
  }
}

// ==========================================================================
// RESPONSIVE & AUTOPLAY
// ==========================================================================

/**
 * Kiểm tra kích thước màn hình — autoplay được đồng bộ tập trung qua syncAutoplay()
 */
const checkScreenSize = () => {
  isMobile.value = window.innerWidth <= MOBILE_BREAKPOINT
  syncAutoplay()
}

let autoplayTimer: ReturnType<typeof setInterval> | null = null

// ==========================================================================
// AUTOPLAY GUARDS — chỉ tự chuyển khi TẤT CẢ điều kiện đúng:
//   1. Desktop (!isMobile)
//   2. Section đang trong viewport (sectionVisible — IntersectionObserver)
//   3. Tab đang hiển thị (!document.hidden)
//   4. User không đang hover lên bộ bài (!isHoveringDeck)
//   5. Không bật prefers-reduced-motion
// → Không autoswap ngầm khi user đang xem section khác / tab ẩn / reduce motion
// ==========================================================================
const isHoveringDeck = ref(false)
const sectionVisible = ref(true)

const canAutoplay = () =>
  !isMobile.value &&
  sectionVisible.value &&
  !document.hidden &&
  !isHoveringDeck.value &&
  !window.matchMedia('(prefers-reduced-motion: reduce)').matches

/** Đồng bộ timer autoplay theo trạng thái hiện tại (idempotent — không duplicate timer) */
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

/* Hover bộ bài → tạm dừng autoplay; rời chuột → resume nếu còn đủ điều kiện */
const onDeckEnter = () => { isHoveringDeck.value = true; syncAutoplay() }
const onDeckLeave = () => { isHoveringDeck.value = false; syncAutoplay() }

// ==========================================================================
// ĐIỀU HƯỚNG PHÍM TOÀN CỤC ←/→
// Khi section đang trong viewport, bấm ←/→ ở BẤT KỲ ĐÂU (không cần focus vào
// nút nav hay card) cũng next/prev. Bỏ qua khi: mobile, section ngoài màn hình,
// hoặc user đang gõ trong input/textarea/select/contenteditable.
// ==========================================================================
const onGlobalKeydown = (e: KeyboardEvent) => {
  if (isMobile.value || !sectionVisible.value) return
  const target = e.target as HTMLElement | null
  if (target && (target.tagName === 'INPUT' || target.tagName === 'TEXTAREA' || target.tagName === 'SELECT' || target.isContentEditable)) return
  if (e.key === 'ArrowRight') { e.preventDefault(); handleNextCard() }
  else if (e.key === 'ArrowLeft') { e.preventDefault(); handlePrevCard() }
}

const sectionEl = ref<HTMLElement | null>(null)

// ==========================================================================
// FULL-VIEWPORT MAGNETIC ASSIST (lớp 2 của pattern "snap 2 lớp")
// Sau khi user NGỪNG cuộn (scrollend), nếu section còn "lem viền" trong
// phạm vi 160px so với vị trí neo thì kéo nốt về đúng điểm — bảo đảm lúc
// dừng luôn có khung hình trọn vẹn cho section. Không bao giờ kéo xa hơn
// 160px nên không cướp hành trình cuộn của user.
//
// ĐIỂM NEO = HEADER_CLEARANCE (120px): khi cuộn LÊN, .nav-scroll trở thành
// fixed cao 90px đè lên phần đầu trang — nếu neo về rect.top = 0 thì phần
// đầu section bị header che mất. Nên neo về rect.top = +120px để luôn có
// khoảng hở trên cùng cho header (điểm đầu viewport + 120px).
// ==========================================================================
const SNAP_ASSIST_RANGE = 120     // px lệch tối đa được phép "hút" về điểm neo
// LƯU Ý ĐỒNG BỘ: CSS desktop (min-height: max(720px, calc(100svh - 90px)))
// đang trừ đúng giá trị này — đổi HEADER_CLEARANCE thì phải sửa cả 2 nơi.
const HEADER_CLEARANCE = 90       // px khoảng hở trên cùng cho header fixed (~90px)
const SCROLL_SETTLE_DELAY = 150   // fallback debounce cho trình duyệt thiếu scrollend

let settleTimer: ReturnType<typeof setTimeout> | null = null

const magneticAssist = () => {
  if (isMobile.value || !sectionEl.value) return
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return

  const rect = sectionEl.value.getBoundingClientRect()
  // Lệch so với điểm neo (viewport top + 120px). Đã thẳng hàng hoặc lệch
  // quá xa → không can thiệp
  const offset = rect.top - HEADER_CLEARANCE
  if (Math.abs(offset) < 2 || Math.abs(offset) > SNAP_ASSIST_RANGE) return

  window.scrollTo({ top: window.scrollY + offset, behavior: 'smooth' })
}

const onScrollEnd = () => magneticAssist()

const onScrollSettle = () => {
  if (settleTimer) clearTimeout(settleTimer)
  settleTimer = setTimeout(magneticAssist, SCROLL_SETTLE_DELAY)
}

// 'onscrollend' chưa nằm trong DOM lib của TS — kiểm tra qua boolean để tránh
// TS narrowing window thành 'never'; cast event name khi bind listener
const supportsScrollEnd = 'onscrollend' in window

let sectionObserver: IntersectionObserver | null = null

const onVisibilityChange = () => syncAutoplay()

onMounted(() => {
  checkScreenSize()
  window.addEventListener('resize', checkScreenSize)
  syncAutoplay()

  // Preload ảnh tất cả dự án (desktop): nền Ken Burns + card crossfade không bao
  // giờ flash ảnh chưa load khi autoplay/điều hướng chuyển dự án
  if (!isMobile.value) {
    featuredProjects.forEach((p) => { const img = new Image(); img.src = p.image })
  }

  // Chỉ tự chuyển khi section đang trong viewport (≥35% hiển thị)
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
  <section id="featured-projects" ref="sectionEl" class="room2 section-padding featured-projects-section">
    
    <!-- Lớp phủ ảnh nền toàn màn hình với hiệu ứng Ken Burns -->
    <div class="section-full-bg" v-if="!isMobile">
      <transition name="ken-burns" mode="out-in">
        <div 
          :key="activeBgImage" 
          class="bg-image-layer" 
          :style="{ backgroundImage: `url(${activeBgImage})` }"
        ></div>
      </transition>
      <div class="section-overlay"></div>
    </div>

    <!-- Content layer chứa chữ và bộ bài -->
    <div class="container-fluid content-layer">
      
      <!-- Header tiêu đề dự án chính — bố trí như header section tin tức:
           title trái, link "Xem tất cả" phải (align-items-end) -->
      <div class="row align-items-end featured-projects-header" :style="isMobile ? 'padding: 0 10px;' : ''">
        <div class="col-md-8 col-8">
          <div class="section-subtitle"><span>Dự án tiêu biểu</span></div>
          <h2 class="section-title"><span>Dự án đã hoàn thiện</span></h2>
        </div>
        <div class="col-md-4 col-4 text-end">
          <RouterLink class="featured-projects-all" :to="{ name: 'project' }">
            <span class="desktop-txt" v-if="!isMobile">Xem tất cả dự án</span> <i class="ti-arrow-right" aria-hidden="true"></i>
          </RouterLink>
        </div>
      </div>

      <!-- ==========================================================================
         TRƯỜNG HỢP 1: GIAO DIỆN DESKTOP (MÀN HÌNH LỚN > 991px)
         ========================================================================== -->
      <div class="row align-items-center position-relative fp-desktop-row" v-if="!isMobile">
        
        <!-- BÊN TRÁI: Khối chữ thông tin chi tiết dự án -->
        <div class="col-xl-5 col-lg-6 col-md-12 fp-caption-col">
          <transition name="fade-slide" mode="out-in">
            <div v-if="projects.length > 0" :key="projects[0].id" class="caption fp-caption">
              
              <!-- Tên khách hàng / Địa chỉ -->
              <h3 class="fp-client">
                {{ projects[0].client }} <span class="fp-client-location">/ {{ projects[0].location }}</span>
                <em class="fp-client-year">{{ projects[0].year }}</em>
              </h3>
              
              <!-- Tiêu đề dự án lớn -->
              <h4 class="fp-project-title">
                <RouterLink :to="{ name: 'project', hash: `#project-${projects[0].id}` }" class="fp-project-link">
                  {{ projects[0].title }}
                </RouterLink>
              </h4>
              
              <!-- Đoạn văn mô tả ngắn -->
              <p class="fp-project-type">
                {{ projects[0].type }}
              </p>
              
              <!-- Khối danh sách thông số kỹ thuật Lucide Icons -->
              <div class="row room-facilities fp-specs">
                <div v-for="spec in projects[0].specs" :key="spec.label" class="col-md-4">
                  <ul class="fp-spec-list">
                    <li class="fp-spec-item">
                      <component :is="spec.icon" aria-hidden="true" class="fp-spec-icon" /> 
                      {{ spec.label }}
                    </li>
                  </ul>
                </div>
              </div>
              
              <!-- Đường gạch ngang phân cách -->
              <hr class="border-2 fp-divider" />
              
              <div class="info-wrapper fp-actions">
                <div class="more">
                  <RouterLink :to="{ name: 'project', hash: `#project-${projects[0].id}` }" class="link-btn fp-link-btn">
                    Xem  chi tiết dự án <i class="ti-arrow-right fp-link-icon" aria-hidden="true"></i>
                  </RouterLink>
                </div>
                <div class="butn-dark">
                  <RouterLink :to="{ name: 'home', hash: '#consultation' }" class="fp-consult-btn">
                    <span>Đặt lịch tư vấn</span>
                  </RouterLink>
                </div>
              </div>
            </div>
          </transition>
        </div>

        <!-- BÊN PHẢI: Khung chứa bộ bài (ĐÃ GOM CỤM NÚT XẾP DỌC THEO SƯỜN TRÁI CARD) -->
<div class="col-xl-7 col-lg-6 col-md-12 deck-column">
  <!-- Wrapper bọc ngoài giữ Autoplay thông minh -->
  <div 
    class="deck-interactive-wrapper"
    @mouseenter="onDeckEnter" 
    @mouseleave="onDeckLeave"
  >
    <!-- Live region ẩn: screen reader được thông báo dự án đang active khi
         autoplay/bấm điều hướng (thay vai trò aria-live của counter cũ) -->
    <p class="deck-sr-status" aria-live="polite">
      Dự án {{ projectNumber(projects[0]?.id ?? 0) }}/{{ totalProjectsLabel }}:
      {{ projects[0]?.title }}
    </p>

    <!-- KHỐI ĐIỀU HƯỚNG XẾP DỌC TINH TẾ (GOM CỤM CHỐNG BỊ ẨN) -->
    <div class="deck-vertical-nav">
      <button @click="handlePrevCard" class="deck-nav-btn" aria-label="Dự án trước">
        <i class="ti-arrow-left"></i>
      </button>
      <button @click="handleNextCard" class="deck-nav-btn" aria-label="Dự án tiếp theo">
        <i class="ti-arrow-right"></i>
      </button>
    </div>

    <!-- Bộ bài xếp chồng tĩnh (Giữ nguyên phom dáng chuẩn của bạn) -->
    <div class="card-swap-deck">
      <div
        v-for="(project, index) in projects"
        :key="project.id"
        class="rooms2 card-swap-item"
        :class="{ 'is-swapping': swappingId === project.id }"
        :style="getCardStyle(index, project.id)"
        role="button"
        tabindex="0"
        :aria-label="`Xem dự án ${project.title}`"
        @click="selectCard(index)"
        @keydown.enter.prevent="selectCard(index)"
        @keydown.space.prevent="selectCard(index)"
      >
        <div class="card-top-bar">
          <span class="card-hero-line" aria-hidden="true"></span>
          <span class="tab-title">
            <strong class="fp-card-client">{{ project.client }} / {{ project.location }}</strong>
            <span class="fp-card-title-sep">—</span>
            <span class="fp-card-title">{{ project.title }}</span>
            <span class="fp-card-year">({{ project.year || '2026' }})</span>
          </span>
          <span class="card-index">
            {{ projectNumber(project.id) }}
            <em class="card-index-total">/ {{ totalProjectsLabel }}</em>
          </span>
        </div>
        <div class="card-preview-thumb">
          <img :src="project.image" :alt="project.alt" loading="lazy" />
        </div>
      </div>
    </div>
  </div>
</div>

      </div>

      <!-- GIAO DIỆN MOBILE / TABLET CUỘN NGANG TỰ NHIÊN -->
      <div class="mobile-scroll-wrapper" v-else>
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

    </div>
  </section>
</template>


<style scoped>
/* ==========================================================================
   1. CẤU HÌNH FULL BLEED VÀ OVERLAY NỀN TỐI ĐIỆN ẢNH
   ========================================================================== */
.featured-projects-section {
  position: relative;
  overflow: hidden;
  min-height: 720px;
  background-color: #121212;
  display: flex;
  align-items: flex-end; 
  padding-bottom: 0 !important;
  width: 100vw !important;  
  margin-left: calc(-50vw + 50%) !important; 
  margin-right: calc(-50vw + 50%) !important;
}

.section-full-bg { position: absolute; inset: 0; width: 100% !important; height: 100% !important; z-index: 1; }
.bg-image-layer { position: absolute; inset: 0; width: 100% !important; height: 100% !important; background-size: cover; background-position: center; background-repeat: no-repeat; }
.section-overlay {
  position: absolute; inset: 0;
  background: linear-gradient(90deg, rgba(14, 12, 10, 0.96) 0%, rgba(14, 12, 10, 0.88) 40%, rgba(14, 12, 10, 0.65) 70%, rgba(14, 12, 10, 0.35) 100%) !important;
  z-index: 2;
}

.content-layer { position: relative; z-index: 3; width: 100%; max-width: 100% !important; padding-left: 4%; padding-right: 0px; padding-bottom: 50px; }
.deck-column { display: flex; justify-content: flex-end; align-items: flex-end; position: relative; min-height: 620px; }

.deck-interactive-wrapper {
  /* Card active TRÀN SÁT MÉP PHẢI (right: 0 + content-layer padding-right: 0) và
     tràn xuống đáy (bottom: -140px) — bleed kiểu tạp chí. Đánh đổi: header các card
     phía sau (dịch phải CARD_HORIZONTAL_GAP mỗi bậc) sẽ tràn qua mép phải một phần —
     GAP giữ 36px (thay vì 50px gốc) để lượng cắt này ở mức tối thiểu.
     TỶ LỆ 5:4 (820:656) khoá bằng aspect-ratio thay vì height cố định: ở viewport
     hẹp (992-1399px, cột phải chỉ ~50% màn hình) height tự co theo width — card
     luôn giữ đúng tỷ lệ ảnh, không bị bóp thành dọc và crop ảnh méo. */
  position: absolute; right: 0; bottom: -140px !important; width: 100%; max-width: 820px; aspect-ratio: 5 / 4; margin-top: 140px;
}

.card-swap-deck {
  width: 100%; height: 100%; transform: rotate(1.25deg) scale(1.1) !important; transform-origin: bottom right;
}

/* Cặp nút điều hướng gài lọt lòng góc trái ảnh active
   Đồng bộ 1:1 với mũi tên slider hero (.slider-fade .owl-theme .owl-nav trong
   style.css): tròn 40px, nền trong suốt, viền trắng mờ 0.5, icon trắng;
   hover thu nhẹ scale(0.9) + viền chuyển vàng #aa8453. */
.deck-vertical-nav { position: absolute; left: 24px; top: 38%; display: flex; flex-direction: column; gap: 14px; z-index: 999 !important; }
.deck-nav-btn { width: 40px; height: 40px; border-radius: 100%; border: 1px solid rgba(255, 255, 255, 0.5); background: transparent; color: #ffffff; display: flex; align-items: center; justify-content: center; cursor: pointer; padding: 0; transition: all 0.2s ease-in-out; transform: scale(1); }
.deck-nav-btn i { font-size: 13px; line-height: 1; transition: transform 0.3s ease; }
.deck-nav-btn:hover { background: transparent; border: 1px solid #aa8453; color: #ffffff; transform: scale(0.9); }
.deck-nav-btn:focus-visible { outline: 2px solid #aa8453; outline-offset: 4px; }
.deck-vertical-nav .deck-nav-btn:nth-child(1):hover i { transform: translateX(-2px); }
.deck-vertical-nav .deck-nav-btn:nth-child(2):hover i { transform: translateX(2px); }

/* ==========================================================================
   2. TINH CHỈNH THU NHỎ KHUNG CHỮ BÊN TRÁI ĐẠT ĐỘ CÂN ĐỐI UX
   ========================================================================== */
.rooms2 .caption {
  /* ÉP CỨNG WIDTH: Thu hẹp tối đa từ 480px về mức 420px. Biến khối chữ thành 
     dải cột tạp chí gọn gàng, phơi bày khoảng không ảnh nền làm việc ở giữa thoáng rộng */
  max-width: 558px !important; 
}

.rooms2.card-swap-item {
  position: absolute !important; bottom: 0 !important; right: 0 !important; left: auto !important; width: 100% !important; height: 100% !important; margin: 0 !important; background: #161512; border: 1px solid rgba(255, 255, 255, 0.14); border-radius: 16px; box-shadow: -15px 15px 45px rgba(0, 0, 0, 0.45); transform-origin: bottom center !important; cursor: pointer; overflow: hidden; text-align: left; transform: translate3d(var(--tx, 0px), var(--ty, 0px), 0) scale(var(--card-scale, 1));
  transition: transform 0.65s cubic-bezier(0.25, 1, 0.5, 1), opacity 0.45s ease;
}

.rooms2.card-swap-item:nth-of-type(1) { border-color: rgba(170, 132, 83, 0.65) !important; box-shadow: -25px 25px 65px rgba(0, 0, 0, 0.65); }
/* Gợi ý có thể bấm: card phía sau hover/focus → NHẢY KHỎI XẤP, trượt sang trái 70% chiều
   rộng card (30% còn lại vẫn nằm trong xấp, bị card active che — z-index thấp hơn).
   Dịch % (thay px) để tự theo đúng kích thước card ở mọi breakpoint.
   Nhờ transform gốc chạy qua CSS variable (--tx/--ty/--card-scale do getCardStyle cung cấp)
   nên :hover được phép ghi đè. Nhấc nhẹ -48px + phóng 1.04 để card "nổi" khi bay ra. */
.rooms2.card-swap-item:not(:nth-of-type(1)):hover,
.rooms2.card-swap-item:not(:nth-of-type(1)):focus-visible {
  transform: translate3d(calc(var(--tx, 0px) - 70%), calc(var(--ty, 0px) - 48px), 0) scale(1);
  border-color: rgba(170, 132, 83, 0.85) !important;
  box-shadow: -30px 30px 70px rgba(0, 0, 0, 0.7);
}
/* Khi một card nhảy khỏi xấp: đẩy TOÀN BỘ đuôi phía sau lên cùng mức -48px
   (general sibling ~) để header các card xa hơn luôn lộ ra ngoài thẻ đang bay,
   không bị che → user nhìn tên + chọn trực tiếp từng card.
   Giữ nguyên scale bậc của chúng (chỉ nâng, không phóng) — transition 0.65s dùng lại. */
.rooms2.card-swap-item:hover ~ .rooms2.card-swap-item,
.rooms2.card-swap-item:focus-visible ~ .rooms2.card-swap-item {
  transform: translate3d(var(--tx, 0px), calc(var(--ty, 0px) - 48px), 0) scale(var(--card-scale, 1));
}
/* CHỐNG GIẬT HOVER (hover oscillation): card bay khỏi xấp → vùng dưới con trỏ trống
   → hover đứt → card kéo về → hover lại → lặp vô hạn gây nhức mắt; tệ hơn, card khác
   vừa được nâng -48px trôi vào dưới con trỏ → hover "nhảy" sang card đó (handoff).
   Fix 2 lớp:
   (1) CẦU HIT-AREA (::after): lớp vô hình phủ đúng rect card NGHỈ, counter-transform
       ngược chính xác delta hover (translate +70%/+48px, scale về --card-scale, origin
       bottom center khớp transform-origin card; tx/ty tự triệt tiêu trong phép
       T_hover ∘ A = T_rest nên cầu đúng ở mọi bậc thang) → khi card đang bay, vùng
       hover cũ vẫn thuộc subtree card → :hover không bao giờ đứt giữa chừng.
   (2) CHẶN HANDOFF (:has): trong lúc có card đang bay, mọi card sau khác bị
       pointer-events: none → hit-test bỏ qua hoàn toàn (dù z-index cao hơn) →
       không thể cướp hover. Rê chuột ra khỏi cầu → card về, mọi thứ khôi phục. */
.rooms2.card-swap-item::after {
  content: '';
  position: absolute;
  inset: 0;
  transform-origin: bottom center;
  pointer-events: auto;
}
.rooms2.card-swap-item:not(:nth-of-type(1)):hover::after,
.rooms2.card-swap-item:not(:nth-of-type(1)):focus-visible::after {
  transform: translate(70%, 48px) scale(var(--card-scale, 1));
}
.card-swap-deck:has(.card-swap-item:not(:nth-of-type(1)):hover) .card-swap-item:not(:nth-of-type(1)):not(:hover),
.card-swap-deck:has(.card-swap-item:not(:nth-of-type(1)):focus-visible) .card-swap-item:not(:nth-of-type(1)):not(:focus-visible) {
  pointer-events: none;
}

.rooms2.card-swap-item.is-swapping { animation: cardParallelFallAndLoop 1.1s cubic-bezier(0.4, 0, 0.2, 1) forwards !important; transition: none !important; }

@keyframes cardParallelFallAndLoop {
  0% { transform: translate3d(0, 0, 0) scale(1); opacity: 1; z-index: 20; }
  45% { transform: translate3d(-30px, 240px, 0) scale(0.96); opacity: 0.9; z-index: 20; }
  55% { z-index: 0; transform: translate3d(-30px, 240px, -50px) scale(0.94); opacity: 0.25; }
  100% { transform: translate3d(0, 150px, -100px) scale(0.95); opacity: 0; z-index: 0; }
}

/* KHÓA NỀN ĐẬM CHO THANH TIỀN ĐỀ CARD PHÍA SAU ĐỂ HIỂN THỊ CHỮ NÉT CĂNG */
.card-top-bar {
  display: flex;
  align-items: center;
  gap: 10px;
  padding: 14px 28px 14px 22px;
  background: #181512 !important;
  border-bottom: 1px solid rgba(255, 255, 255, 0.08);
}

/* Số thứ tự dự án trong header card ("01 / 04") — số của card active đi cùng
   viền vàng (nth-of-type(1)); tổng số mờ để không tranh chấp thị giác */
.card-index {
  margin-left: auto;
  flex-shrink: 0;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.25em;
  color: rgba(255, 255, 255, 0.88);
}
.card-index-total {
  font-style: normal;
  font-weight: 500;
  letter-spacing: 0.15em;
  color: rgba(255, 255, 255, 0.4);
}
.rooms2.card-swap-item:nth-of-type(1) .card-index { color: #aa8453; }

/* tab-title co giãn trong flex để số thứ tự luôn nằm sát mép phải */
.card-top-bar .tab-title { width: auto; min-width: 0; flex: 1 1 auto; }

/* Live region ẩn thông báo dự án active cho screen reader */
.deck-sr-status {
  position: absolute;
  width: 1px;
  height: 1px;
  margin: -1px;
  padding: 0;
  overflow: hidden;
  clip: rect(0 0 0 0);
  white-space: nowrap;
  border: 0;
}

/* Hero-line thu nhỏ trên top-bar card — đồng bộ ngôn ngữ "gạch vàng gradient"
   của hero banner (hero-line 64px → 22px) thay cho dot tròn kiểu UI/tech */
.card-hero-line { display: block; width: 22px; height: 2px; flex-shrink: 0; background: linear-gradient(90deg, #aa8453, #d7b98a); }

.tab-title {
  color: #ffffff !important;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 0.06em;
}

/* Tăng cường độ đậm cho phần thẻ strong (Tên dự án chủ nhà) */
.tab-title strong {
  font-weight: 700 !important;
}

.card-preview-thumb { width: 100%; height: calc(100% - 47px); background: #0d0d0d; }
.card-preview-thumb img { width: 100%; height: 100%; object-fit: cover; opacity: 1; }

/* Hiệu ứng trượt chữ */
.fade-slide-enter-active { transition: opacity 0.6s cubic-bezier(0.25, 1, 0.5, 1), transform 0.6s cubic-bezier(0.25, 1, 0.5, 1); }
.fade-slide-leave-active { transition: opacity 0.3s ease-in, transform 0.3s ease-in; }
.fade-slide-enter-from { opacity: 0; transform: translate3d(-24px, 0, 0); }
.fade-slide-leave-to { opacity: 0; transform: translate3d(15px, 0, 0); }

/* Hiệu ứng Ken Burns cho ảnh nền mỗi dự án: crossfade mềm + zoom nhẹ
   (scale 1.06 → 1) khi đổi dự án — tạo cảm giác ảnh "thở" chuyển động */
.ken-burns-enter-active {
  transition:
    opacity 1.1s ease,
    transform 1.1s cubic-bezier(0.25, 1, 0.5, 1);
}
.ken-burns-leave-active {
  transition: opacity 0.55s ease;
}
.ken-burns-enter-from {
  opacity: 0;
  transform: scale(1.06);
}
.ken-burns-leave-to {
  opacity: 0;
}
.ken-burns-enter-to {
  opacity: 1;
  transform: scale(1);
}

/* Tôn trọng prefers-reduced-motion: bỏ zoom/slide, chỉ giữ crossfade nhanh */
@media (prefers-reduced-motion: reduce) {
  .ken-burns-enter-active { transition: opacity 0.3s ease; }
  .ken-burns-enter-from { transform: none; }
  .fade-slide-enter-active, .fade-slide-leave-active { transition: opacity 0.2s ease; }
  .fade-slide-enter-from, .fade-slide-leave-to { transform: none; }
}

.featured-projects-header { margin-bottom: 40px; }
.featured-projects-header .section-title span { color: #ffffff; }
.featured-projects-header .section-subtitle span { color: #aa8453; }
.featured-projects-all { display: inline-flex; align-items: center; gap: 10px; padding-bottom: 7px; border-bottom: 1px solid rgba(255, 255, 255, 0.2); color: #dddddd; font-family: 'Barlow Condensed', sans-serif; font-size: 12px; font-weight: 500; letter-spacing: 0.15em; text-transform: uppercase; }
.featured-projects-all:hover { color: #aa8453; border-color: #aa8453; }

/* ==========================================================================
   2b. DESKTOP CAPTION — Thông tin dự án (trích inline styles → classes)
   ========================================================================== */
.fp-desktop-row { margin: 0 !important; }
.fp-caption-col { padding-left: 2%; }
.fp-caption { color: #ffffff !important; padding-right: 30px; background: transparent !important; width:max-content;}

.fp-client {
  color: #aa8453 !important;
  font-size: 12px !important;
  font-family: 'Barlow Condensed', sans-serif !important;
  text-transform: uppercase !important;
  letter-spacing: 3px !important;
  margin-bottom: 8px !important;
  font-weight: 600 !important;
  display: block !important;
}
/* Địa chỉ sáng hơn (không còn xám mờ) — Barlow thường, không uppercase */
.fp-client-location {
  color: #e2dcd4 !important;
  font-family: 'Barlow', sans-serif !important;
  font-weight: 400 !important;
  font-size: 12px !important;
  letter-spacing: 0.5px !important;
  text-transform: none !important;
}
/* Badge năm sản xuất — đồng bộ với .client-year ở ProjectView */
.fp-client-year {
  display: inline-block;
  font-style: normal;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 1.5px;
  color: #ffffff;
  background: #aa8453;
  padding: 2px 8px;
  border-radius: 20px;
  margin-left: 8px;
  vertical-align: 1px;
}

.fp-project-title { margin-bottom: 8px !important; display: block !important; }
.fp-project-link {
  color: #ffffff !important;
  font-size: 30px !important;
  font-family: 'Gilda Display', serif !important;
  font-weight: 400 !important;
  line-height: 1.25 !important;
  text-shadow: none !important;
  display: inline-block !important;
  padding-bottom: 10px !important;
}
.fp-project-link:hover { color: #aa8453 !important; }

.fp-project-type {
  color: #d5cfc7 !important;
  margin-top: 4px !important;
  margin-bottom: 12px !important;
  font-size: 13px !important;
  line-height: 1.5 !important;
  text-shadow: none !important;
}

.fp-specs { margin: 0 0 10px !important; display: flex !important; align-items: flex-start !important; gap: 6px !important; }
.fp-specs .col-md-4 { flex: 1 1 0; width: auto; max-width: 100%; min-width: 0; }
.fp-spec-list { margin: 0 !important; padding: 0 !important; list-style: none !important; }
.fp-spec-item { display: flex !important; align-items: flex-start !important; font-size: 13px !important; line-height: 1.5 !important; color: #e8e4df !important; font-weight: 400 !important; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.fp-spec-icon { width: 14px !important; height: 14px !important; margin-top: 2px !important; margin-right: 6px !important; color: #aa8453 !important; flex-shrink: 0 !important; }

.fp-divider { border-color: rgba(255, 255, 255, 0.22) !important; margin: 14px 0 !important; opacity: 1 !important; }

/* "Chi tiết" bên trái — "Đặt lịch tư vấn" dịch hẳn sang bên phải */
.fp-actions { display: flex !important; align-items: center !important; justify-content: space-between !important; gap: 12px !important; flex-wrap: wrap !important; }
.fp-link-btn { color: #ffffff !important; font-family: 'Barlow Condensed', sans-serif !important; text-transform: uppercase !important; letter-spacing: 0.1em !important; white-space: nowrap !important; }
.fp-link-icon { color: #aa8453 !important; margin-left: 5px !important; }
.fp-consult-btn {
  color: #ffffff !important;
  padding: 10px 16px !important;
  font-size: 13px !important;
  letter-spacing: 2px !important;
  display: inline-block !important;
}

/* Card top-bar (trích inline styles → classes) */
.tab-title { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; display: block; width: 100%; }
.fp-card-client { font-weight: 700; color: #ffffff; }
.fp-card-title-sep { color: rgba(255, 255, 255, 0.6); margin-left: 8px; }
.fp-card-title { color: rgba(255, 255, 255, 0.8); margin-left: 4px; }
.fp-card-year { color: #c89a5e; margin-left: 8px; font-weight: 600; }

/* ==========================================================================
   3. RESPONSIVE CAROUSEL CUỘN NGANG TRÊN MOBILE (GIỮ NGUYÊN FORM CHUẨN)
   ========================================================================== */
@media (max-width: 991px) {
  .featured-projects-section { min-height: auto; padding: 50px 0 !important; width: 100% !important; margin-left: 0 !important; margin-right: 0 !important; background-color: #151515; }
  .content-layer { padding-left: 0px !important; padding-right: 0px !important; padding-bottom: 0px !important; }
  .mobile-scroll-wrapper { width: 100%; padding: 5px 0 15px 0; }
  .mobile-scroll-container { display: flex !important; flex-wrap: nowrap !important; overflow-x: auto !important; padding-left: 20px; padding-right: 20px; gap: 20px; scroll-snap-type: x mandatory !important; -webkit-overflow-scrolling: touch; }
  .mobile-scroll-container::-webkit-scrollbar { display: none; }
  .mobile-project-card-wrapper { flex: 0 0 82%; width: 82%; scroll-snap-align: center !important; }
  .mobile-project-card { background: #1e1b18; border-radius: 14px; overflow: hidden; border: 1px solid rgba(255, 255, 255, 0.06); box-shadow: 0 10px 25px rgba(0, 0, 0, 0.3); }
  .mobile-card-image { position: relative; width: 100%; aspect-ratio: 8 / 5; overflow: hidden; }
  .mobile-card-image img { width: 100%; height: 100%; object-fit: cover; }
  .mobile-image-badge { position: absolute; top: 12px; left: 12px; background: rgba(18, 16, 14, 0.85); padding: 3px 10px; border-radius: 20px; border: 1px solid rgba(170, 132, 83, 0.3); }
  .mobile-image-badge span { color: #aa8453; font-size: 10px; font-family: 'Barlow Condensed', sans-serif; text-transform: uppercase; letter-spacing: 0.05em; }
  .mobile-card-caption { padding: 18px 16px; }
  .m-client { color: #aa8453; font-size: 11px; text-transform: uppercase; letter-spacing: 2px; font-weight: 600; display: block; margin-bottom: 2px; }
  .m-title a { color: #ffffff; font-size: 20px; font-family: 'Gilda Display', serif; font-weight: 400; line-height: 1.3; }
  .m-type { color: #b5b5b5; font-size: 13px; margin-bottom: 15px; }
  .mobile-card-actions { display: flex; align-items: center; justify-content: space-between; border-top: 1px solid rgba(255, 255, 255, 0.06); padding-top: 14px; }
  .m-link { color: #ffffff; font-size: 13px; font-family: 'Barlow Condensed', sans-serif; text-transform: uppercase; }
  .m-link i { color: #aa8453; margin-left: 3px; }
  .m-btn { background: #aa8453; color: #ffffff; padding: 5px 14px; font-size: 12px; border-radius: 4px; font-family: 'Barlow Condensed', sans-serif; text-transform: uppercase; }
}

/* ==========================================================================
   DESKTOP ≥992px — "HIỂN THỊ NHƯ HERO": section phủ đúng 1 viewport
   Cuộn tới → section chiếm trọn màn hình (min-height: 100svh), nội dung neo
   ĐÁY (flex-end — kế thừa thiết kế gốc của section) → xấp card tịnh tiến
   xuống bottom, giữ nguyên hiệu ứng cắt mép (-140px bị overflow:hidden clip
   tại đáy viewport). Ngắm trọn vẹn "Dự án tiêu biểu". Cuộn tiếp → section
   dâng lên cuộn bình thường, KHÔNG chốt, KHÔNG dead-scroll.
========================================================================== */
@media (min-width: 992px) {
  /* LƯU Ý: KHÔNG dùng scroll-snap-type trên html — trang có sẵn nhiều element
     khác mang scroll-snap-align (card tin tức, collection rail...) khiến chúng
     trở thành điểm snap dọc của cả trang, làm viewport dừng sai vị trí.
     Điểm dừng full-viewport được bảo đảm bởi JS magnetic assist (scrollend). */
  .featured-projects-section {
    /* Trừ đúng HEADER_CLEARANCE (90px) của magnetic assist: khi section được
       neo về rect.top = 90px (dưới header fixed), đáy section khít ĐÚNG đáy
       viewport — section chiếm trọn phần màn hình còn lại dưới header.
       max(720px, ...) giữ chiều cao tối thiểu cho nội dung trên màn thấp. */
    min-height: max(720px, calc(100vh - 90px));
    min-height: max(720px, calc(100svh - 90px));
    height: auto;
    padding: 0 0 0 !important;
    align-items: stretch;
  }

  /* Content-layer trải trọn chiều cao viewport:
     - Header (title + "Xem tất cả") đẩy lên TRÊN CÙNG, cách mép 120px
     — đồng bộ .section-padding của header các section khác.
     - Caption + bộ bài neo ĐÁY (xấp card tịnh tiến xuống bottom,
     giữ hiệu ứng cắt mép -140px). */
  .content-layer {
    padding-top: 120px;
    padding-bottom: 0;
    display: flex;
    flex-direction: column;
    justify-content: space-between;
  }

  /* Header theo đúng pattern header section tin tức (.home-news-heading):
     nằm trong container căn giữa (KHÔNG full-bleed), title trái —
     link "Xem tất cả" phải căn đáy dòng, margin-bottom 38px.
     max-width theo từng breakpoint giống .container của Bootstrap. */
  .featured-projects-header {
    width: 100%;
    max-width: 960px;
    margin-left: auto !important;
    margin-right: auto !important;
    margin-bottom: 38px !important;
    padding-left: 12px;
    padding-right: 12px;
  }

  @media (min-width: 1200px) {
    .featured-projects-header { max-width: 1140px; }
  }

  @media (min-width: 1400px) {
    .featured-projects-header { max-width: 1320px; }
  }
}

</style>