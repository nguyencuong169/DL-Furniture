<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { Medal, Phone, Ruler, Star, Users, type LucideIcon } from 'lucide-vue-next'
import { FALLBACK_STATS, fetchStats, type StatId } from '../api/statsClient'

interface StatItem {
  id: StatId
  icon: LucideIcon
  value: number
  suffix: string
  label: string
}

const getFallbackValue = (id: StatId, defaultValue: number) => {
  return FALLBACK_STATS.find((item) => item.id === id)?.value ?? defaultValue
}

const stats = ref<StatItem[]>([
  {
    id: 'experience',
    icon: Medal,
    value: getFallbackValue('experience', 15),
    suffix: '+',
    label: 'Năm kinh nghiệm'
  },
  {
    id: 'projects',
    icon: Users,
    value: getFallbackValue('projects', 320),
    suffix: '+',
    label: 'Dự án thực hiện'
  },
  {
    id: 'area',
    icon: Ruler,
    value: getFallbackValue('area', 12000),
    suffix: '+',
    label: 'M² hoàn thiện'
  },
  {
    id: 'satisfaction',
    icon: Star,
    value: getFallbackValue('satisfaction', 98),
    suffix: '%',
    label: 'Khách hàng hài lòng'
  }
])

const displayValues = ref<number[]>(stats.value.map(() => 0))
const started = ref(false)
let observer: IntersectionObserver | null = null
let rafId = 0
const barRef = ref<HTMLElement | null>(null)

const runCounters = () => {
  cancelAnimationFrame(rafId)
  const duration = 2000
  const stagger = 150
  const startValues = [...displayValues.value]
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

onMounted(() => {
  void applyRealStats()

  const root = barRef.value
  if (!root || typeof IntersectionObserver === 'undefined') {
    started.value = true
    runCounters()
    return
  }

  const trigger = () => {
    if (started.value) return
    started.value = true
    observer?.disconnect()
    runCounters()
  }

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          trigger()
        }
      })
    },
    { threshold: 0.2, rootMargin: '0px 0px -10% 0px' }
  )
  observer.observe(root)
})

onBeforeUnmount(() => {
  observer?.disconnect()
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <section class="about section-padding">
    <div class="container">
      <div class="row about-layout align-items-center">
        <!-- Left: content -->
        <div class="col-lg-4 col-md-12 mb-30 animate-box" data-animate-effect="fadeInUp">
          <span class="hero-line" aria-hidden="true"></span>
          <p class="section-subtitle"><span>Về chúng tôi</span></p>
          <div class="section-title">Không gian được thiết kế từ cách bạn sống</div>
          <p>
            Mỗi dự án bắt đầu bằng việc lắng nghe nhu cầu, khảo sát hiện trạng và nhận diện những
            thói quen tạo nên nhịp sống riêng của gia chủ. Từ đó,
            <strong>D&L Furniture</strong> phát triển giải pháp cân bằng giữa thẩm mỹ, công năng và
            cảm giác sử dụng lâu dài.
          </p>
          <p>
            Vật liệu, tỷ lệ và từng điểm tiếp xúc được đặt trong cùng một hệ ngôn ngữ để nội thất
            trở thành một phần tự nhiên của kiến trúc — chỉn chu nhưng không phô trương.
          </p>
          <!-- call -->
          <div class="reservations">
            <div class="icon"><span><Phone :size="34" :stroke-width="1.25" /></span></div>
            <div class="text">
              <p>Tư vấn thiết kế</p>
              <a href="tel:+84961109897">(+84) 961-109-897</a>
            </div>
          </div>
        </div>

        <!-- Center: large image -->
        <div class="col-lg-5 col-md-7 mb-30 animate-box" data-animate-effect="fadeInUp">
          <div class="about-image">
            <img
              src="@/assets/img/intros/intro6.jpg"
              alt="Không gian nội thất do D&L Furniture thiết kế và thi công"
            />
            <!-- Seal "15+ năm": điểm nhấn editorial đè mép ảnh. Số liệu bind từ
                 stat 'experience' (stats[0]) — cùng nguồn với cột phải, không hardcode -->
            <div class="about-badge">
              <span class="about-badge-value">{{ stats[0]?.value }}{{ stats[0]?.suffix }}</span>
              <span class="about-badge-label">{{ stats[0]?.label }}</span>
            </div>
          </div>
        </div>

        <!-- Right: stats column -->
        <div class="col-lg-3 col-md-5 mb-30 animate-box" data-animate-effect="fadeInUp">
          <div ref="barRef" class="stats-container">
            <div v-for="(stat, index) in stats" :key="stat.id" class="stat-item">
              <div class="stat-icon-wrapper">
                <component :is="stat.icon" class="stat-icon" :stroke-width="1.5" />
              </div>
              <div class="stat-content">
                <span class="stat-value"> {{ displayCount(index) }}{{ stat.suffix }} </span>
                <span class="stat-label">{{ stat.label }}</span>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.about .hero-line {
  display: block;
  width: 64px;
  height: 2px;
  margin-bottom: 22px;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
}

.about-layout {
  --bs-gutter-x: 2.5rem;
}

.about-image {
  position: relative; /* neo cho seal "15+ năm" */
  height: 100%;
  display: flex;
  align-items: center;
}

.about-image img {
  width: 100%;
  height: 100%;
  min-height: 320px;
  max-height: 480px;
  object-fit: cover;
  border-radius: 4px;
}

/* ── SEAL "15+ NĂM" ──────────────────────────────────────────────────────
   Con dấu tròn nền tối + vành khắc nét đứt gold, treo nửa ngoài mép trái ảnh
   (phá khung kiểu editorial). Dùng lại hệ màu #1f1d1a / #aa8453 / #d7b98a. */
.about-badge {
  position: absolute;
  left: -30px;
  bottom: 30px;
  z-index: 2;
  width: 128px;
  height: 128px;
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 3px;
  border-radius: 50%;
  /* Nền hơi trong + halo ring 6px bao ngoài: badge tách khỏi ảnh DỮ màu nào
     (sáng hay tối) — fix trường hợp đặt trên vùng ảnh tối bị "tan" vào nền */
  background: rgba(32, 29, 25, 0.9);
  border: 1px solid rgba(212, 178, 128, 0.75);
  box-shadow:
    0 0 0 6px rgba(32, 29, 25, 0.22),
    0 20px 44px rgba(34, 29, 22, 0.35);
  text-align: center;
  transition: transform 0.35s ease;
}

/* Vành khắc thứ hai nét đứt — chất "con dấu khắc gỗ" */
.about-badge::before {
  position: absolute;
  inset: 7px;
  border: 1px dashed rgba(212, 178, 128, 0.65);
  border-radius: 50%;
  content: '';
}

.about-badge:hover {
  transform: rotate(-4deg);
}

.about-badge-value {
  font-family: 'Gilda Display', serif;
  font-size: 34px;
  font-weight: 400;
  line-height: 1;
  color: #d7b98a;
}

.about-badge-label {
  max-width: 88px;
  font-family: 'Barlow', sans-serif;
  font-size: 9.5px;
  font-weight: 500;
  letter-spacing: 0.14em;
  line-height: 1.35;
  color: rgba(255, 255, 255, 0.82);
  text-transform: uppercase;
}

@media (max-width: 991px) {
  /* Mobile: badge thu nhỏ + lùi vào TRONG ảnh (đừng tràn ra ngoài màn hình) */
  .about-badge {
    left: 14px;
    bottom: 14px;
    width: 104px;
    height: 104px;
  }

  .about-badge-value {
    font-size: 27px;
  }

  .about-badge-label {
    font-size: 8.5px;
  }
}

.stats-container {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.stat-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  text-align: left;
  gap: 1rem;
  transition: all 0.3s ease;
}

.stat-icon-wrapper {
  width: 52px;
  height: 52px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}
.stat-item:hover .stat-icon-wrapper {
  transform: scale(1.08);
}
.stat-icon {
  width: 36px;
  height: 36px;
  color: #aa8453;
  transition: all 0.3s ease;
}
.stat-item:hover .stat-icon {
  color: #8a6a3f;
}
.stat-content {
  display: flex;
  flex-direction: column;
  gap: 4px;
  min-width: 0;
}
.stat-value {
  font-family: 'Gilda Display', serif;
  font-size: 46px; /* bằng .section-title của header giới thiệu */
  font-weight: 400;
  color: #222;
  line-height: 1;
  white-space: nowrap;
}
.stat-label {
  font-family: 'Barlow', sans-serif;
  font-size: 0.8rem;
  font-weight: 500;
  color: #888;
  text-transform: uppercase;
  letter-spacing: 1.2px;
  line-height: 1.3;
  white-space: nowrap;
}

@media (max-width: 991px) {
  .about-layout {
    --bs-gutter-x: 1.5rem;
  }

  /* GỌN CHIỀU DỌC: trước đây padding đáy section (~100px) + mb-30 của cột
     cộng dồn tạo khoảng trống trắng dài dưới stats — gom về mức vừa phải */
  .about.section-padding {
    padding-bottom: 48px;
  }

  .about-layout > [class*='col-'] {
    margin-bottom: 14px;
  }

  .about-image img {
    min-height: 240px;
    max-height: 340px;
  }

  .stats-container {
    display: grid;
    /* 1 stat mỗi hàng — cột hẹp không đủ chỗ cho "12.000+" nếu lên 2 cột */
    grid-template-columns: 1fr;
    gap: 1rem;
    padding-top: 0.25rem;
  }

  .stat-item {
    gap: 0.75rem;
  }

  .stat-icon {
    width: 28px;
    height: 28px;
  }

  .stat-icon-wrapper {
    width: 42px;
    height: 42px;
  }

  .stat-value {
    font-size: clamp(24px, 3.4vw, 32px);
  }
}

@media (max-width: 575px) {
  .stat-label,
  .stat-value {
    white-space: normal;
  }
  .stat-value {
    font-size: 30px;
  }
}
</style>
