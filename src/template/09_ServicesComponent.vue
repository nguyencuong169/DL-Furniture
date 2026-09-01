<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref } from 'vue'
import {
  BadgeCheck,
  Cog,
  DraftingCompass,
  MessageCircle,
  Ruler,
  Wrench,
  type LucideIcon
} from 'lucide-vue-next'

interface ProcessStep {
  number: string
  icon: LucideIcon
  title: string
  description: string
}

const processSteps: ProcessStep[] = [
  {
    number: '01',
    icon: MessageCircle,
    title: 'Lắng nghe & định hướng',
    description:
      'Làm rõ nhu cầu, phong cách, công năng ưu tiên và khung đầu tư phù hợp với gia đình.'
  },
  {
    number: '02',
    icon: Ruler,
    title: 'Khảo sát hiện trạng',
    description:
      'Đo đạc, ghi nhận kiến trúc, hạ tầng kỹ thuật và những điều kiện ảnh hưởng đến phương án.'
  },
  {
    number: '03',
    icon: DraftingCompass,
    title: 'Phát triển thiết kế',
    description:
      'Thống nhất mặt bằng, ngôn ngữ vật liệu, tỷ lệ và các chi tiết cần kiểm soát khi sản xuất.'
  },
  {
    number: '04',
    icon: Cog,
    title: 'Sản xuất & kiểm soát',
    description: 'Kiểm tra kích thước, mối ghép, bề mặt hoàn thiện và sự đồng đều giữa các module.'
  },
  {
    number: '05',
    icon: Wrench,
    title: 'Lắp đặt & hiệu chỉnh',
    description:
      'Tổ chức lắp đặt tại công trình, phối hợp các hạng mục và hiệu chỉnh theo sử dụng thực tế.'
  },
  {
    number: '06',
    icon: BadgeCheck,
    title: 'Nghiệm thu & đồng hành',
    description: 'Bàn giao hướng dẫn sử dụng, phạm vi bảo hành và đầu mối tiếp nhận khi cần hỗ trợ.'
  }
]

const lastStepIndex = processSteps.length - 1

/**
 * Tiến trình cuộn (0 → 1): bắt đầu khi mép trên timeline vượt ~82% chiều cao
 * viewport và kết thúc khi đáy timeline lên trên ~40% viewport.
 * Đường nối + vòng tròn lấp đầy theo đúng % cuộn thực tế (kiểu Apple),
 * làm mượt bằng transition 450ms thay vì nhảy trạng thái.
 */
const timelineEl = ref<HTMLElement | null>(null)
const pinEl = ref<HTMLElement | null>(null)
const progress = ref(0)
const hoverIndex = ref<number | null>(null)
let frame = 0

/**
 * Desktop (≥1200px): section được GHIM ở giữa viewport (sticky) trong một
 * vùng cuộn dài thêm ~1500px — người dùng cuộn tại chỗ để 6 bước lấp đầy
 * dần; hết 6 bước sticky tự nhả và trang cuộn tiếp như bình thường.
 * Mobile/tablet: không ghim, tiến trình theo vị trí timeline trong viewport.
 */
function updateProgress(): void {
  const pin = pinEl.value
  const timeline = timelineEl.value
  if (!pin || !timeline) return
  const viewportHeight = window.innerHeight || 1

  if (window.innerWidth >= 1200) {
    const rect = pin.getBoundingClientRect()
    const scrollable = rect.height - viewportHeight
    progress.value = scrollable > 0 ? Math.min(1, Math.max(0, -rect.top / scrollable)) : 1
    return
  }

  const rect = timeline.getBoundingClientRect()
  const start = viewportHeight * 0.82
  const end = viewportHeight * 0.4
  const total = rect.height + start - end
  progress.value = Math.min(1, Math.max(0, (start - rect.top) / total))
}

function requestUpdate(): void {
  if (frame) return
  frame = window.requestAnimationFrame(() => {
    frame = 0
    updateProgress()
  })
}

/* Bước đang hiển thị mô tả: ưu tiên hover/tap, mặc định theo tiến trình cuộn */
const activeIndex = computed(() => {
  if (hoverIndex.value !== null) return hoverIndex.value
  return Math.min(lastStepIndex, Math.floor(progress.value * lastStepIndex + 1e-4))
})

function isFilled(index: number): boolean {
  return progress.value >= index / lastStepIndex - 1e-4
}

/* Độ lấp đầy của đoạn nối dọc giữa bước index và bước kế tiếp (mobile/tablet) */
function segmentFill(index: number): number {
  return Math.min(1, Math.max(0, progress.value * lastStepIndex - index))
}

onMounted(() => {
  updateProgress()
  window.addEventListener('scroll', requestUpdate, { passive: true })
  window.addEventListener('resize', requestUpdate)
})

onBeforeUnmount(() => {
  window.removeEventListener('scroll', requestUpdate)
  window.removeEventListener('resize', requestUpdate)
  if (frame) window.cancelAnimationFrame(frame)
})
</script>

<template>
  <section
    id="home-process"
    class="home-process section-padding bg-cream"
    aria-labelledby="process-title"
  >
    <div ref="pinEl" class="home-process-pin">
      <div class="home-process-sticky">
        <div class="container home-process-container">
          <header class="home-process-heading">
            <div class="home-process-title-wrap">
              <p class="section-subtitle"><span>Quy trình kiểm soát</span></p>
              <h2 id="process-title" class="section-title">Từ ý tưởng đến bàn giao</h2>
            </div>
            <p class="home-process-intro">
              Mỗi giai đoạn có một mục tiêu, một đầu ra và một điểm kiểm soát rõ ràng. Nhờ đó, ý
              tưởng thiết kế được bảo toàn khi chuyển sang sản xuất, lắp đặt và bàn giao.
            </p>
          </header>

          <ol
            ref="timelineEl"
            class="home-process-timeline"
            :style="{ '--process-progress': String(progress) }"
          >
            <!-- Nền đường nối luôn hiển thị mờ: người dùng biết trước có 6 bước -->
            <span class="home-process-line" aria-hidden="true"></span>
            <!-- Lớp lấp đầy theo tiến trình cuộn -->
            <span class="home-process-line-fill" aria-hidden="true"></span>

            <li
              v-for="(step, index) in processSteps"
              :key="step.number"
              class="home-process-step"
              :class="{ 'is-filled': isFilled(index), 'is-active': activeIndex === index }"
              :style="{ '--seg-fill': String(segmentFill(index)) }"
              tabindex="0"
              @mouseenter="hoverIndex = index"
              @mouseleave="hoverIndex = null"
              @focusin="hoverIndex = index"
              @focusout="hoverIndex = null"
            >
              <span class="home-process-step-icon" aria-hidden="true">
                <component :is="step.icon" :size="26" :stroke-width="1.5" />
              </span>
              <div class="home-process-step-body">
                <span class="home-process-step-num" aria-hidden="true">Bước {{ step.number }}</span>
                <h3>{{ step.title }}</h3>
                <p>{{ step.description }}</p>
              </div>
            </li>
          </ol>

          <!-- Mô tả chi tiết hiển thị cố định dưới timeline, theo bước đang active
           (hover/tap một mốc để xem mô tả của mốc đó) -->
          <Transition name="process-fade" mode="out-in">
            <div :key="activeIndex" class="home-process-summary" aria-live="polite">
              <p class="home-process-summary-tag">
                Bước {{ processSteps[activeIndex].number }} — {{ processSteps[activeIndex].title }}
              </p>
              <p class="home-process-summary-text">{{ processSteps[activeIndex].description }}</p>
            </div>
          </Transition>

          <footer class="home-process-footer">
            <p>Bạn đã có mặt bằng hoặc ý tưởng ban đầu?</p>
            <div>
              <RouterLink class="home-process-link" :to="{ name: 'home', hash: '#consultation' }">
                Đặt lịch tư vấn <i class="ti-arrow-right" aria-hidden="true"></i>
              </RouterLink>
              <RouterLink class="home-process-link home-process-link--muted" to="/du-an">
                Xem dự án đã hoàn thiện
              </RouterLink>
            </div>
          </footer>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-process {
  padding: 108px 0 110px;
  scroll-margin-top: 100px;
  /* background: #f1ede6; */
}

/* Mở rộng nhẹ chiều rộng timeline (chuẩn xxl của Bootstrap) để 6 bước thở dễ hơn */
.home-process-container {
  max-width: 1320px;
}

.home-process-heading {
  padding-bottom: 41px;
  border-bottom: 1px solid #d1c8bb;
  text-align: center;
}

.home-process-title-wrap .section-title {
  margin-bottom: 0;
}

.home-process-intro {
  max-width: 730px;
  margin: 24px auto 0;
  color: #59534c;
  font-size: 16px;
  line-height: 1.85;
}

.home-process-timeline {
  --process-progress: 0;
  position: relative;
  display: grid;
  grid-template-columns: repeat(6, minmax(0, 1fr));
  gap: 34px 22px;
  padding: 0;
  margin: 64px 0 0;
  list-style: none;
}

/* Nền đường nối mờ luôn hiển thị + lớp lấp đầy theo tiến trình cuộn */
.home-process-line,
.home-process-line-fill {
  position: absolute;
  top: 37px;
  left: 8.3333%;
  width: 83.3333%;
  height: 2px;
  border-radius: 2px;
}

.home-process-line {
  background: #d1c8bb;
  opacity: 0.55;
}

.home-process-line-fill {
  background: #aa8453;
  transform: scaleX(var(--process-progress));
  transform-origin: left center;
  transition: transform 0.45s cubic-bezier(0.25, 0.1, 0.25, 1);
}

.home-process-step {
  position: relative;
  text-align: center;
  outline: none;
}

.home-process-step-icon {
  position: relative;
  z-index: 1;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 76px;
  height: 76px;
  border: 1px solid #d9d0c2;
  border-radius: 50%;
  color: #aa8453;
  background: #f8f5f0;
  transition:
    background-color 0.4s ease,
    border-color 0.4s ease,
    color 0.4s ease,
    box-shadow 0.4s ease,
    transform 0.4s ease;
}

/* Mốc đã đạt: vòng tròn đặc — mốc chưa tới: viền rỗng */
.home-process-step.is-filled .home-process-step-icon {
  border-color: #aa8453;
  color: #fff;
  background: #aa8453;
}

/* Mốc đang active (cuộn tới hoặc hover): quầng vàng nhạt */
.home-process-step.is-active .home-process-step-icon,
.home-process-step:focus-visible .home-process-step-icon {
  box-shadow: 0 0 0 6px rgba(170, 132, 83, 0.16);
}

.home-process-step:hover .home-process-step-icon {
  transform: translateY(-4px);
}

.home-process-step-body {
  margin-top: 22px;
}

.home-process-step-num {
  display: block;
  margin-bottom: 10px;
  color: rgba(158, 119, 70, 0.78);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.home-process-step h3 {
  margin: 0 0 11px;
  color: #28241f;
  font-family: 'Gilda Display', serif;
  font-size: 22px;
  font-weight: 400;
  line-height: 1.3;
  transition: color 0.4s ease;
}

.home-process-step.is-active h3 {
  color: #8a6a3f;
}

.home-process-step p {
  margin: 0;
  color: #5f5951;
  font-size: 15px;
  line-height: 1.72;
}

/* Desktop: mô tả chi tiết gom về panel cố định dưới timeline */
.home-process-step p {
  display: none;
}

.home-process-summary {
  max-width: 720px;
  min-height: 84px;
  margin: 44px auto 0;
  text-align: center;
}

.home-process-summary-tag {
  margin: 0 0 8px;
  color: #9e7746;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.home-process-summary-text {
  margin: 0;
  color: #59534c;
  font-size: 16px;
  line-height: 1.75;
}

.process-fade-enter-active,
.process-fade-leave-active {
  transition:
    opacity 0.3s ease,
    transform 0.3s ease;
}

.process-fade-enter-from,
.process-fade-leave-to {
  opacity: 0;
  transform: translateY(8px);
}

.home-process-footer {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: 22px;
  padding-top: 34px;
  margin-top: 56px;
  border-top: 1px solid #d1c8bb;
  text-align: center;
}

.home-process-footer > p {
  margin: 0;
  color: #2c2924;
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  line-height: 1.25;
}

.home-process-footer > div {
  display: flex;
  align-items: center;
  gap: 24px;
}

.home-process-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(137, 103, 61, 0.48);
  color: #89673d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  transition:
    gap 0.3s ease,
    border-color 0.3s ease,
    color 0.3s ease;
}

.home-process-link--muted {
  border-color: transparent;
  color: #4f4a43;
}

.home-process-link:hover,
.home-process-link:focus-visible {
  gap: 15px;
  border-color: #8e6738;
  color: #8e6738;
}

.home-process-link:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 5px;
}

/* Desktop (≥1200px): GHIM section giữa viewport trong vùng cuộn dài thêm
   ~1500px — cuộn tại chỗ để 6 bước lấp đầy dần; hết tiến trình sticky tự
   nhả và trang cuộn tiếp bình thường. Navbar là absolute nên top:0 là sạch. */
@media (min-width: 1200px) {
  .home-process.section-padding {
    padding: 0;
  }

  .home-process-pin {
    --pin-scroll: 1500px;
    height: calc(100vh + var(--pin-scroll));
  }

  .home-process-sticky {
    position: sticky;
    top: 0;
    display: flex;
    align-items: center;
    min-height: 100vh;
    padding: 48px 0;
  }
}

/* Dưới 1200px: timeline dọc — nền nối mờ từng đoạn + đoạn gold lấp đầy theo cuộn */
@media (max-width: 1199.98px) {
  .home-process-timeline {
    grid-template-columns: 1fr;
    gap: 30px;
    margin-top: 48px;
  }

  .home-process-line,
  .home-process-line-fill {
    display: none;
  }

  .home-process-step {
    display: grid;
    grid-template-columns: 76px minmax(0, 1fr);
    gap: 22px;
    text-align: left;
  }

  /* Nền mờ: người dùng biết trước hành trình 6 bước */
  .home-process-step:not(:last-child)::after {
    position: absolute;
    top: 88px;
    bottom: -34px;
    left: 37px;
    width: 2px;
    background: #d1c8bb;
    opacity: 0.55;
    content: '';
  }

  /* Đoạn gold lấp đầy dần theo tiến trình cuộn */
  .home-process-step:not(:last-child)::before {
    position: absolute;
    z-index: 1;
    top: 88px;
    bottom: -34px;
    left: 37px;
    width: 2px;
    background: #aa8453;
    transform: scaleY(var(--seg-fill, 0));
    transform-origin: top center;
    transition: transform 0.45s cubic-bezier(0.25, 0.1, 0.25, 1);
    content: '';
  }

  .home-process-step-body {
    margin-top: 4px;
  }

  /* Mobile/tablet: mô tả hiển thị ngay dưới từng mốc, ẩn panel gom */
  .home-process-step p {
    display: block;
  }

  .home-process-summary {
    display: none;
  }
}

@media (max-width: 767.98px) {
  .home-process {
    padding: 76px 0;
  }

  .home-process-heading {
    padding-bottom: 31px;
  }

  .home-process-timeline {
    gap: 26px;
    margin-top: 40px;
  }

  .home-process-step {
    grid-template-columns: 60px minmax(0, 1fr);
    gap: 16px;
  }

  .home-process-step:not(:last-child)::after,
  .home-process-step:not(:last-child)::before {
    top: 72px;
    bottom: -30px;
    left: 29px;
  }

  .home-process-step-icon {
    width: 60px;
    height: 60px;
  }

  .home-process-step-icon svg {
    width: 22px;
    height: 22px;
  }

  .home-process-step h3 {
    font-size: 20px;
  }

  .home-process-footer,
  .home-process-footer > div {
    align-items: flex-start;
    flex-direction: column;
  }

  .home-process-footer > div {
    gap: 18px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .home-process-line-fill,
  .home-process-step:not(:last-child)::before,
  .home-process-step-icon,
  .home-process-step h3,
  .home-process-link,
  .process-fade-enter-active,
  .process-fade-leave-active {
    transition: none;
  }
}
</style>
