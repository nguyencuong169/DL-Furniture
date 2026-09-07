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
    icon: Building2,
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
    icon: HeartHandshake,
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
  <div class="stats-wrapper">
    <div ref="barRef" class="stats-container">
      <div v-for="(stat, index) in stats" :key="stat.id" class="stat-item">
        <div class="stat-icon-wrapper">
          <component :is="stat.icon" class="stat-icon" />
        </div>
        <div class="stat-content">
          <span class="stat-value"> {{ displayCount(index) }}{{ stat.suffix }} </span>
          <span class="stat-label">{{ stat.label }}</span>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.stats-wrapper {
  width: 100%;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.stats-container {
  display: grid;
  grid-template-columns: repeat(auto-fill, 240px);
  justify-content: center;
  align-items: center;
  gap: clamp(1rem, 3vw, 3rem);
  padding: 2.5rem 0;
  max-width: 1440px;
  margin: 0 auto;
  width: 100%;
}

.stat-item {
  display: flex;
  flex-direction: row;
  align-items: center;
  text-align: left;
  gap: 0.75rem;
  padding: 0.5rem 1rem;
  transition: all 0.3s ease;
  border-radius: 12px;
  width: 100%;
  justify-content: center;
}

.stat-item:nth-child(even) {
  transform: translateY(20px);
}

.stat-item:hover {
  background: #fbfaf8;
  transform: translateY(0) scale(1.02);
}

.stat-icon-wrapper {
  width: 48px;
  height: 48px;
  background: #f8f5f0;
  border-radius: 10px;
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  transition: all 0.3s ease;
  border: 1px solid #ececec;
}
.stat-item:hover .stat-icon-wrapper {
  background: #aa8453;
  transform: rotate(-5deg) scale(1.05);
}
.stat-icon {
  width: 20px;
  height: 20px;
  color: #aa8453;
  transition: all 0.3s ease;
}
.stat-item:hover .stat-icon {
  color: #fff;
}
.stat-content {
  display: flex;
  flex-direction: column;
  gap: 0px;
  min-width: 0;
}
.stat-value {
  font-family: 'Gilda Display', serif;
  font-size: 1.6rem;
  font-weight: 400;
  color: #222;
  line-height: 1;
  white-space: nowrap;
}
.stat-label {
  font-family: 'Barlow', sans-serif;
  font-size: 0.7rem;
  font-weight: 500;
  color: #888;
  text-transform: uppercase;
  letter-spacing: 1px;
  line-height: 1.2;
  white-space: nowrap;
}

@media (max-width: 991px) {
  .stats-container {
    flex-wrap: wrap;
    justify-content: center;
    gap: 1.5rem;
    padding: 2rem 1rem;
  }
  .stat-item {
    flex: 1 1 calc(50% - 1.5rem);
    min-width: 200px;
  }
}

@media (max-width: 575px) {
  .stats-container {
    padding: 1.5rem 1rem;
  }
  .stat-item {
    flex: 1 1 100%;
    justify-content: center;
    margin-bottom: 0.5rem;
  }
  .stat-label,
  .stat-value {
    white-space: normal;
    text-align: center;
  }
  .stat-value {
    font-size: 1.4rem;
  }
}
</style>
