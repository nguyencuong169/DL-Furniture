<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { Building2, HeartHandshake, Medal, Ruler, type LucideIcon } from 'lucide-vue-next'
import { FALLBACK_STATS, fetchStats, type StatId } from '../api/statsClient'

interface StatItem {
  id: StatId
  icon: LucideIcon
  value: number
  suffix: string
  label: string
}

/**
 * Giá trị mặc định (dummy) khớp cam kết đã công bố trên homepage.
 * Khi DB trả về giá trị thực và real >= dummy thì thay bằng số thật
 * (xem statsClient.ts + mergeStats bên dưới) — số hiển thị không bao giờ giảm.
 */
const stats = ref<StatItem[]>([
  {
    id: 'experience',
    icon: Medal,
    value: FALLBACK_STATS.find((item) => item.id === 'experience')?.value ?? 15,
    suffix: '+',
    label: 'Năm kinh nghiệm'
  },
  {
    id: 'projects',
    icon: Building2,
    value: FALLBACK_STATS.find((item) => item.id === 'projects')?.value ?? 320,
    suffix: '+',
    label: 'Dự án thực hiện'
  },
  {
    id: 'area',
    icon: Ruler,
    value: FALLBACK_STATS.find((item) => item.id === 'area')?.value ?? 12000,
    suffix: '+',
    label: 'M² nội thất hoàn thiện'
  },
  {
    id: 'satisfaction',
    icon: HeartHandshake,
    value: FALLBACK_STATS.find((item) => item.id === 'satisfaction')?.value ?? 98,
    suffix: '%',
    label: 'Khách hàng hài lòng'
  }
])

const displayValues = ref<number[]>(stats.value.map(() => 0))
const started = ref(false)
let observer: IntersectionObserver | null = null
let rafId = 0
const barRef = ref<HTMLElement | null>(null)

/* Count-up ease-out cubic; chạy từ giá trị đang hiển thị → cho phép retarget mượt khi DB trả số thật.
   Mỗi số có delay so le (stagger) + duration dài để hiệu ứng đếm rõ ràng, không tuôn đồng loạt */
const runCounters = () => {
  cancelAnimationFrame(rafId)
  const duration = 2200
  const stagger = 240
  const startValues = displayValues.value.slice()
  const startTime = performance.now()
  const total = duration + (stats.value.length - 1) * stagger

  const tick = (now: number) => {
    const elapsed = now - startTime
    stats.value.forEach((item, index) => {
      const progress = Math.min(Math.max((elapsed - index * stagger) / duration, 0), 1)
      const eased = 1 - Math.pow(1 - progress, 3)
      displayValues.value[index] = Math.round(
        startValues[index] + (item.value - startValues[index]) * eased
      )
    })
    if (elapsed < total) rafId = requestAnimationFrame(tick)
  }

  rafId = requestAnimationFrame(tick)
}

const displayCount = (index: number) => displayValues.value[index]?.toLocaleString('vi-VN') ?? '0'

/* Chỉ nhận giá trị thật khi real >= dummy (không bao giờ hiển thị thấp hơn cam kết) */
const applyRealStats = async () => {
  const real = await fetchStats()
  let changed = false
  const merged = stats.value.map((item) => {
    const found = real.find((candidate) => candidate.id === item.id)
    if (found && found.value >= item.value && found.value !== item.value) {
      changed = true
      return { ...item, value: found.value }
    }
    return item
  })

  if (!changed) return
  stats.value = merged
  if (started.value) runCounters()
}

/* Delay ngắn sau khi bar vào khung nhìn để người dùng kịp thấy hiệu ứng đếm từ 0 */
let startDelay = 0
let scrollFallback: (() => void) | null = null

onMounted(() => {
  void applyRealStats()

  const root = barRef.value
  if (!root || typeof IntersectionObserver === 'undefined') {
    /* Không hỗ trợ IO: vẫn chạy count-up sau mount thay vì hiện số tức thì */
    started.value = true
    startDelay = window.setTimeout(runCounters, 400)
    return
  }

  /* Kích hoạt bằng IntersectionObserver với ngưỡng cao:
     - threshold 0.6 → card phải lộ ≥ 60% diện tích
     - rootMargin -20% dưới → đồng thời card phải được cuộn lên trên
       mép 80% chiều cao khung nhìn (không tính phần "hé lộ" ở đáy màn hình).
     LƯU Ý QUAN TRỌNG: IO luôn bắn 1 lần ngay khi observe() với trạng thái hiện
     tại — lúc trang vừa tải bar đang "hé lộ" ở đáy viewport nên isIntersecting
     có thể là true dù khách chưa cuộn. Do đó chỉ trigger khi scrollY > ngưỡng
     (đã có hành vi cuộn thật); nếu chưa, gắn scroll fallback tự kiểm tra vị trí
     bar để bắt trường hợp ratio đã ≥ threshold từ đầu (không bao giờ "crossing"). */
  const trigger = () => {
    if (started.value) return
    started.value = true
    observer?.disconnect()
    if (scrollFallback) {
      window.removeEventListener('scroll', scrollFallback)
      scrollFallback = null
    }
    startDelay = window.setTimeout(runCounters, 350)
  }

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting || started.value) return
        trigger()
        return
        /* Trang chưa được cuộn: bỏ qua lần bắn đầu (layout lúc tải có thể chưa
           ổn định). Khi khách cuộn thật, fallback sẽ kiểm tra bar đã vào vùng
           đọc (trên mép 80% khung nhìn) chưa rồi mới kích hoạt. */
        if (!scrollFallback) {
          scrollFallback = () => {
            const rect = root.getBoundingClientRect()
            const readLine = window.innerHeight * 0.8
            if (rect.top < readLine && rect.bottom > window.innerHeight * 0.15) trigger()
          }
          window.addEventListener('scroll', scrollFallback, { passive: true })
        }
      })
    },
    { threshold: 0.8, rootMargin: '0px 0px -20% 0px' }
  )
  observer.observe(root)
})

onBeforeUnmount(() => {
  observer?.disconnect()
  if (scrollFallback) window.removeEventListener('scroll', scrollFallback)
  window.clearTimeout(startDelay)
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <section class="dl-stats" aria-label="Số liệu uy tín của D&L Furniture">
    <div class="container dl-stats-container">
      <div ref="barRef" class="dl-stats-bar" :class="{ 'is-visible': started }">
        <ul class="dl-stats-grid">
          <li v-for="(stat, index) in stats" :key="stat.id" class="dl-stat">
            <span class="dl-stat-icon" aria-hidden="true">
              <component :is="stat.icon" :size="24" :stroke-width="1.5" />
            </span>
            <div class="dl-stat-body" :class="{ 'is-started': started }">
              <h3 class="dl-stat-label">{{ stat.label }}</h3>
              <span v-if="started" class="dl-stat-value" aria-hidden="true">
                <span class="dl-stat-number">{{ displayCount(index) }}</span
                ><span class="dl-stat-suffix">{{ stat.suffix }}</span>
              </span>
              <span class="visually-hidden"
                >{{ stat.value.toLocaleString('vi-VN') }}{{ stat.suffix }} {{ stat.label }}</span>
            </div>
          </li>
        </ul>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Section nền trong suốt: phần trên bar là ảnh hero (tối), phần dưới bar là
   nền trắng của section About liền kề → bar tối nổi đè ~90px lên mép dưới hero
   tạo chiều sâu (depth) mà không sinh vệt màu đứt đoạn giữa hai section */
.dl-stats {
  background: transparent;
  padding: 0 0 64px;
}

.dl-stats-container {
  width: 100%;
  max-width: 1140px;
  margin-right: auto;
  margin-left: auto;
  padding-right: 15px;
  padding-left: 15px;
}

@media (min-width: 576px) {
  .dl-stats-container {
    max-width: 540px;
  }
}

@media (min-width: 768px) {
  .dl-stats-container {
    max-width: 720px;
  }
}

@media (min-width: 992px) {
  .dl-stats-container {
    max-width: 960px;
  }
}

@media (min-width: 1200px) {
  .dl-stats-container {
    max-width: 1140px;
  }
}

.dl-stats-bar {
  position: relative;
  z-index: 2;
  margin-top: -110px;
  padding: 44px 46px;
  border: 1px solid rgba(213, 174, 124, 0.16);
  border-radius: 26px;
  background: #1f1d1a;
  box-shadow: 0 34px 64px rgba(15, 13, 11, 0.38);
  opacity: 0;
  transform: translateY(30px);
  transition: all 0.8s cubic-bezier(0.4, 0, 0.2, 1);
  pointer-events: none;
}

.dl-stats-bar.is-visible {
  opacity: 1;
  transform: translateY(0);
  pointer-events: auto;
}

.dl-stats-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  margin: 0;
  padding: 0;
  list-style: none;
}

.dl-stat {
  display: flex;
  align-items: center;
  gap: 16px;
  padding: 2px 26px;
}

.dl-stat:first-child {
  padding-left: 0;
}

.dl-stat:last-child {
  padding-right: 0;
}

.dl-stat + .dl-stat {
  border-left: 1px solid rgba(241, 237, 230, 0.12);
}

.dl-stat-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 56px;
  height: 56px;
  border: 1px solid rgba(170, 132, 83, 0.55);
  border-radius: 50%;
  color: #d5ae7c;
}

.dl-stat-body {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  text-align: left;
  opacity: 0;
  transform: translateY(10px);
  transition: all 0.6s ease-out;
  transition-delay: 0.4s;
}

.dl-stat-body.is-started {
  opacity: 1;
  transform: translateY(0);
}

.dl-stat-value {
  display: block;
  color: #d5ae7c;
  font-family: 'Gilda Display', serif;
  font-size: clamp(32px, 2.9vw, 42px);
  font-weight: 400;
  line-height: 1;
  white-space: nowrap;
}

.dl-stat-suffix {
  margin-left: 2px;
  font-size: 0.62em;
}

.dl-stat-label {
  margin: 0 0 7px;
  color: rgba(241, 237, 230, 0.66);
  font-family: 'Barlow', sans-serif;
  font-size: 13px;
  font-weight: 400;
  line-height: 1.35;
}

@media (max-width: 991.98px) {
  .dl-stats-bar {
    margin-top: -95px;
    padding: 34px 30px;
  }

  .dl-stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    row-gap: 30px;
  }

  .dl-stat {
    padding: 0 20px;
  }

  .dl-stat:nth-child(odd) {
    padding-left: 0;
  }

  .dl-stat:nth-child(even) {
    padding-right: 0;
  }

  .dl-stat + .dl-stat {
    border-left: 0;
  }

  .dl-stat:nth-child(even) {
    border-left: 1px solid rgba(241, 237, 230, 0.12);
  }
}

@media (max-width: 575.98px) {
  .dl-stats {
    padding-bottom: 48px;
  }

  .dl-stats-bar {
    margin-top: -85px;
    padding: 26px 24px;
    border-radius: 18px;
  }

  .dl-stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
    row-gap: 24px;
  }

  .dl-stat {
    padding: 16px 0;
  }

  .dl-stat:first-child {
    padding-top: 0;
  }

  .dl-stat:last-child {
    padding-bottom: 0;
  }

  .dl-stat + .dl-stat {
    border-top: 0;
  }

  .dl-stat:nth-child(even) {
    border-left: 0;
  }

  .dl-stat-icon {
    width: 48px;
    height: 48px;
  }

  .dl-stat-icon svg {
    width: 21px;
    height: 21px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .dl-stats-bar {
    box-shadow: none;
  }
}
</style>
