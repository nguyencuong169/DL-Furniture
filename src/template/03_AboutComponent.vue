<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'
import { Medal, Ruler, Star, Users, type LucideIcon } from 'lucide-vue-next'
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
          <p class="section-subtitle"><span>D&L Furniture</span></p>
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
            <div class="icon"><span class="flaticon-call"></span></div>
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
              src="@/assets/img/intros/intro4.jpg"
              alt="Không gian nội thất do D&L Furniture thiết kế và thi công"
            />
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

  .about-image img {
    min-height: 260px;
    max-height: 380px;
  }

  .stats-container {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1.75rem;
  }

  .stat-icon {
    width: 30px;
    height: 30px;
  }

  .stat-icon-wrapper {
    width: 44px;
    height: 44px;
  }

  .stat-value {
    font-size: 38px;
  }
}

@media (max-width: 575px) {
  .stats-container {
    grid-template-columns: 1fr;
    gap: 1.25rem;
    padding-top: 1.25rem;
  }
  .stat-label,
  .stat-value {
    white-space: normal;
  }
  .stat-value {
    font-size: 32px;
  }
}
</style>
