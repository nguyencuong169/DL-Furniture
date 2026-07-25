<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'
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
const isYearMenuOpen = ref(false)
const highlightedYear = ref<number | null>(null)
const yearSelectRoot = ref<HTMLElement | null>(null)
const yearSelectTrigger = ref<HTMLButtonElement | null>(null)

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
      shortLabel: `Tháng ${month}`,
      fullLabel: new Intl.DateTimeFormat('vi-VN', { month: 'long' }).format(date)
    }
  })
})

const currentYearIndex = computed(() => {
  return years.value.findIndex((item) => item.year === viewingYear.value)
})

const canViewNewerYear = computed(() => currentYearIndex.value > 0)
const canViewOlderYear = computed(() => {
  return currentYearIndex.value >= 0 && currentYearIndex.value < years.value.length - 1
})

const focusHighlightedYear = async () => {
  await nextTick()
  yearSelectRoot.value
    ?.querySelector<HTMLButtonElement>(`[data-year-option="${highlightedYear.value}"]`)
    ?.focus()
}

const openYearMenu = async () => {
  highlightedYear.value = viewingYear.value
  isYearMenuOpen.value = true
  await focusHighlightedYear()
}

const closeYearMenu = (returnFocus = false) => {
  isYearMenuOpen.value = false
  if (returnFocus) void nextTick(() => yearSelectTrigger.value?.focus())
}

const toggleYearMenu = () => {
  if (isYearMenuOpen.value) {
    closeYearMenu()
    return
  }

  void openYearMenu()
}

const focusRelativeYear = (direction: 1 | -1) => {
  if (!years.value.length) return

  const currentIndex = years.value.findIndex((item) => item.year === highlightedYear.value)
  const nextIndex =
    currentIndex < 0
      ? 0
      : (currentIndex + direction + years.value.length) % years.value.length

  highlightedYear.value = years.value[nextIndex].year
  void focusHighlightedYear()
}

const focusBoundaryYear = (position: 'first' | 'last') => {
  if (!years.value.length) return
  highlightedYear.value =
    position === 'first' ? years.value[0].year : years.value[years.value.length - 1].year
  void focusHighlightedYear()
}

const handleYearOptionKeydown = (event: KeyboardEvent, year: number) => {
  if (event.key === 'ArrowDown') {
    event.preventDefault()
    focusRelativeYear(1)
  } else if (event.key === 'ArrowUp') {
    event.preventDefault()
    focusRelativeYear(-1)
  } else if (event.key === 'Home') {
    event.preventDefault()
    focusBoundaryYear('first')
  } else if (event.key === 'End') {
    event.preventDefault()
    focusBoundaryYear('last')
  } else if (event.key === 'Escape') {
    event.preventDefault()
    closeYearMenu(true)
  } else if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault()
    selectYear(year)
  } else if (event.key === 'Tab') {
    closeYearMenu()
  }
}

const selectYear = (year: number) => {
  viewingYear.value = year
  closeYearMenu(true)
}

const viewNewerYear = () => {
  closeYearMenu()
  if (canViewNewerYear.value) viewingYear.value = years.value[currentYearIndex.value - 1].year
}

const viewOlderYear = () => {
  closeYearMenu()
  if (canViewOlderYear.value) viewingYear.value = years.value[currentYearIndex.value + 1].year
}

const selectMonth = (month: number) => {
  if (viewingYear.value) emit('select', viewingYear.value, month)
}

const handleOutsidePointerDown = (event: PointerEvent) => {
  if (!yearSelectRoot.value?.contains(event.target as Node)) closeYearMenu()
}

onMounted(() => document.addEventListener('pointerdown', handleOutsidePointerDown))
onBeforeUnmount(() => document.removeEventListener('pointerdown', handleOutsidePointerDown))

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
      <div class="news-archives-title-copy">
        <h6>Lưu trữ</h6>
        <p>Khám phá bài viết theo thời gian</p>
      </div>
      <button
        type="button"
        class="news-archives-latest"
        :class="{ active: !activeYear || !activeMonth }"
        @click="emit('clear')"
      >
        <i class="ti-reload" aria-hidden="true"></i>
        <span>Mới nhất</span>
      </button>
    </div>

    <template v-if="years.length && viewingYear">
      <div class="news-archives-year-control" role="group" aria-label="Điều hướng năm lưu trữ">
        <button
          type="button"
          class="news-archives-year-nav"
          :disabled="!canViewOlderYear"
          aria-label="Xem năm cũ hơn"
          @click="viewOlderYear"
        >
          <i class="ti-angle-left" aria-hidden="true"></i>
        </button>

        <div
          ref="yearSelectRoot"
          class="news-archives-select"
          :class="{ 'is-open': isYearMenuOpen }"
        >
          <button
            ref="yearSelectTrigger"
            type="button"
            class="news-archives-select-trigger"
            role="combobox"
            aria-label="Chọn năm lưu trữ"
            aria-haspopup="listbox"
            aria-controls="news-archives-year-options"
            :aria-expanded="isYearMenuOpen"
            @click="toggleYearMenu"
            @keydown.down.prevent="openYearMenu"
            @keydown.up.prevent="openYearMenu"
            @keydown.esc.prevent="closeYearMenu()"
          >
            <span>Năm {{ viewingYear }}</span>
            <i class="ti-angle-down" aria-hidden="true"></i>
          </button>

          <Transition name="news-archives-options">
            <div
              v-if="isYearMenuOpen"
              id="news-archives-year-options"
              class="news-archives-select-options"
              role="listbox"
              aria-label="Các năm lưu trữ"
            >
              <button
                v-for="item in years"
                :key="item.year"
                type="button"
                class="news-archives-select-option"
                :class="{ 'is-selected': item.year === viewingYear }"
                role="option"
                :aria-selected="item.year === viewingYear"
                :data-year-option="item.year"
                @focus="highlightedYear = item.year"
                @click="selectYear(item.year)"
                @keydown="handleYearOptionKeydown($event, item.year)"
              >
                <span>Năm {{ item.year }}</span>
                <i v-if="item.year === viewingYear" class="ti-check" aria-hidden="true"></i>
              </button>
            </div>
          </Transition>
        </div>

        <button
          type="button"
          class="news-archives-year-nav"
          :disabled="!canViewNewerYear"
          aria-label="Xem năm mới hơn"
          @click="viewNewerYear"
        >
          <i class="ti-angle-right" aria-hidden="true"></i>
        </button>
      </div>

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
          :aria-label="`${item.fullLabel} ${viewingYear}, ${item.count} bài viết`"
          :title="`${item.fullLabel} ${viewingYear}: ${item.count} bài viết`"
          @click="selectMonth(item.month)"
        >
          <span class="news-archives-calendar-month">
            <span class="news-archives-calendar-month-full">{{ item.shortLabel }}</span>
            <span class="news-archives-calendar-month-compact" aria-hidden="true">
              T{{ item.month }}
            </span>
          </span>
          <span class="news-archives-calendar-count">
            <strong>{{ item.count }}</strong>
            <small>bài</small>
          </span>
        </button>
      </div>
    </template>

    <p v-else class="news-archives-empty">Chưa có dữ liệu lưu trữ.</p>
  </div>
</template>
