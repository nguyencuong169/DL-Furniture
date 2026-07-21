<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import type { ArchiveDto } from '../api/newsSidebarClient'

const props = withDefaults(
  defineProps<{
    archives: ArchiveDto[]
    activeYear?: number | null
    activeMonth?: number | null
  }>(),
  {
    activeYear: null,
    activeMonth: null
  }
)

const emit = defineEmits<{
  select: [year: number, month: number]
  clear: []
}>()

const viewingYear = ref<number | null>(null)

const years = computed(() => {
  const totals = new Map<number, number>()
  props.archives.forEach((archive) => {
    totals.set(archive.year, (totals.get(archive.year) ?? 0) + archive.count)
  })

  return Array.from(totals, ([year, count]) => ({ year, count })).sort(
    (first, second) => second.year - first.year
  )
})

const months = computed(() => {
  const counts = new Map<number, number>()
  props.archives.forEach((archive) => {
    if (archive.year === viewingYear.value) counts.set(archive.month, archive.count)
  })

  return Array.from({ length: 12 }, (_, index) => {
    const month = index + 1
    const date = new Date(2020, index, 1)

    return {
      month,
      count: counts.get(month) ?? 0,
      shortLabel: new Intl.DateTimeFormat('vi-VN', { month: 'short' }).format(date),
      fullLabel: new Intl.DateTimeFormat('vi-VN', { month: 'long' }).format(date)
    }
  })
})

const currentYearIndex = computed(() => {
  return years.value.findIndex((item) => item.year === viewingYear.value)
})

const viewingYearTotal = computed(() => {
  return years.value.find((item) => item.year === viewingYear.value)?.count ?? 0
})

const canViewNewerYear = computed(() => currentYearIndex.value > 0)
const canViewOlderYear = computed(() => {
  return currentYearIndex.value >= 0 && currentYearIndex.value < years.value.length - 1
})

const viewNewerYear = () => {
  if (canViewNewerYear.value) viewingYear.value = years.value[currentYearIndex.value - 1].year
}

const viewOlderYear = () => {
  if (canViewOlderYear.value) viewingYear.value = years.value[currentYearIndex.value + 1].year
}

const selectMonth = (month: number) => {
  if (viewingYear.value) emit('select', viewingYear.value, month)
}

watch(
  [() => props.archives, () => props.activeYear],
  () => {
    const availableYears = years.value.map((item) => item.year)

    if (props.activeYear && availableYears.includes(props.activeYear)) {
      viewingYear.value = props.activeYear
      return
    }

    if (!viewingYear.value || !availableYears.includes(viewingYear.value)) {
      viewingYear.value = availableYears[0] ?? null
    }
  },
  { immediate: true, deep: true }
)
</script>

<template>
  <div class="widget news-archives-widget">
    <div class="widget-title news-archives-title">
      <h6>Archives</h6>
      <a
        href="#"
        class="news-archives-latest"
        :class="{ active: !activeYear || !activeMonth }"
        @click.prevent="emit('clear')"
      >
        Mới nhất
      </a>
    </div>

    <template v-if="years.length && viewingYear">
      <div class="news-archives-year-control">
        <button
          type="button"
          :disabled="!canViewOlderYear"
          aria-label="Xem năm cũ hơn"
          @click="viewOlderYear"
        >
          <i class="ti-angle-left" aria-hidden="true"></i>
        </button>

        <label>
          <span class="visually-hidden">Chọn năm lưu trữ</span>
          <select v-model.number="viewingYear" aria-label="Chọn năm lưu trữ">
            <option v-for="item in years" :key="item.year" :value="item.year">
              {{ item.year }} · {{ item.count }} bài
            </option>
          </select>
        </label>

        <button
          type="button"
          :disabled="!canViewNewerYear"
          aria-label="Xem năm mới hơn"
          @click="viewNewerYear"
        >
          <i class="ti-angle-right" aria-hidden="true"></i>
        </button>
      </div>

      <p class="news-archives-year-summary">
        <strong>{{ viewingYear }}</strong>
        <span>{{ viewingYearTotal }} bài viết</span>
      </p>

      <div class="news-archives-calendar-grid">
        <button
          v-for="item in months"
          :key="item.month"
          type="button"
          class="news-archives-calendar-cell"
          :class="{
            'is-empty': item.count <= 0,
            'is-active': activeYear === viewingYear && activeMonth === item.month
          }"
          :disabled="item.count <= 0"
          :aria-pressed="activeYear === viewingYear && activeMonth === item.month"
          :title="`${item.fullLabel} ${viewingYear}: ${item.count} bài viết`"
          @click="selectMonth(item.month)"
        >
          <span class="news-archives-calendar-month">{{ item.shortLabel }}</span>
          <span class="news-archives-calendar-count">{{ item.count }}</span>
        </button>
      </div>
    </template>

    <p v-else class="news-archives-empty">Chưa có dữ liệu lưu trữ.</p>
  </div>
</template>
