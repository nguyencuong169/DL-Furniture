<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'

interface StatItem {
  value: number
  suffix: string
  label: string
  note: string
}

// Số liệu bám theo những cam kết đã công bố trên homepage (Facilities, Process):
// >15 năm kinh nghiệm nghệ nhân, 100% gỗ óc chó FAS, 6 bước quy trình, 5 năm bảo hành.
const stats: StatItem[] = [
  {
    value: 15,
    suffix: '+',
    label: 'Năm kinh nghiệm chế tác',
    note: 'Nghệ nhân mộc lành nghề xử lý từng chi tiết'
  },
  {
    value: 100,
    suffix: '%',
    label: 'Gỗ óc chó FAS Bắc Mỹ',
    note: 'Nhập khẩu loại 1, chọn phôi theo sắc vân'
  },
  {
    value: 6,
    suffix: '',
    label: 'Bước quy trình kiểm soát',
    note: 'Từ thiết kế đến sản xuất, lắp đặt và bàn giao'
  },
  {
    value: 5,
    suffix: '',
    label: 'Năm bảo hành chuẩn mực',
    note: 'Kèm dịch vụ bảo trì định kỳ trọn đời'
  }
]

const displayValues = ref<number[]>(stats.map(() => 0))
const started = ref(false)
let observer: IntersectionObserver | null = null
let rafId = 0

const prefersReducedMotion = () =>
  typeof window !== 'undefined' && window.matchMedia('(prefers-reduced-motion: reduce)').matches

const runCounters = () => {
  const duration = 1400
  const startTime = performance.now()

  const tick = (now: number) => {
    const progress = Math.min((now - startTime) / duration, 1)
    const eased = 1 - Math.pow(1 - progress, 3)
    stats.forEach((item, index) => {
      displayValues.value[index] = Math.round(eased * item.value)
    })
    if (progress < 1) rafId = requestAnimationFrame(tick)
  }

  rafId = requestAnimationFrame(tick)
}

onMounted(() => {
  if (prefersReducedMotion()) {
    displayValues.value = stats.map((item) => item.value)
    started.value = true
    return
  }

  const root = document.querySelector<HTMLElement>('.dl-stats')
  if (!root || typeof IntersectionObserver === 'undefined') {
    displayValues.value = stats.map((item) => item.value)
    started.value = true
    return
  }

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !started.value) {
          started.value = true
          runCounters()
          observer?.disconnect()
        }
      })
    },
    { threshold: 0.25 }
  )
  observer.observe(root)
})

onBeforeUnmount(() => {
  observer?.disconnect()
  cancelAnimationFrame(rafId)
})
</script>

<template>
  <section class="dl-stats" aria-label="Số liệu uy tín của D&L Furniture">
    <div class="container dl-stats-container">
      <ul class="dl-stats-grid">
        <li v-for="(stat, index) in stats" :key="stat.label" class="dl-stat">
          <span class="dl-stat-value" aria-hidden="true">
            <span class="dl-stat-number">{{ displayValues[index] }}</span>{{ stat.suffix }}
          </span>
          <span class="sr-only"
            >{{ stat.value }}{{ stat.suffix }} {{ stat.label.toLowerCase() }}</span
          >
          <h3 class="dl-stat-label">{{ stat.label }}</h3>
          <p class="dl-stat-note">{{ stat.note }}</p>
        </li>
      </ul>
    </div>
  </section>
</template>

<style scoped>
.dl-stats {
  padding: 72px 0 78px;
  background: #f1ede6;
  border-bottom: 1px solid #d1c8bb;
}

/* Đồng bộ khung 1140px chuẩn Cappa, khớp nội dung với section .container khác */
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

.dl-stats-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(0, 1fr));
  margin: 0;
  padding: 0;
  list-style: none;
}

.dl-stat {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  padding: 6px 34px 2px;
}

.dl-stat:first-child {
  padding-left: 0;
}

.dl-stat:last-child {
  padding-right: 0;
}

.dl-stat + .dl-stat {
  border-left: 1px solid #d1c8bb;
}

.dl-stat-value {
  color: #a17a47;
  font-family: 'Gilda Display', serif;
  font-size: clamp(46px, 4.6vw, 64px);
  font-weight: 400;
  line-height: 1;
}

.dl-stat-label {
  margin: 16px 0 8px;
  color: #221f1a;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 0.14em;
  line-height: 1.3;
  text-transform: uppercase;
}

.dl-stat-note {
  max-width: 250px;
  margin: 0;
  color: #6e6962;
  font-size: 13px;
  line-height: 1.6;
}

@media (max-width: 991.98px) {
  .dl-stats {
    padding: 58px 0 62px;
  }

  .dl-stats-grid {
    grid-template-columns: repeat(2, minmax(0, 1fr));
  }

  .dl-stat {
    padding: 0 22px;
  }

  .dl-stat:last-child {
    padding-right: 22px;
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

  .dl-stat:nth-child(n + 3) {
    padding-top: 38px;
    border-top: 1px solid #d1c8bb;
  }
}

@media (max-width: 575.98px) {
  .dl-stats {
    padding: 52px 0 56px;
  }

  .dl-stat-label {
    letter-spacing: 0.1em;
  }
}
</style>