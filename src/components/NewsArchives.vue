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

const timelineMonths = computed(() => {
  return months.value
    .filter((item) => item.count > 0)
    .sort((first, second) => second.month - first.month)
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
    currentIndex < 0 ? 0 : (currentIndex + direction + years.value.length) % years.value.length

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

      <div
        v-if="timelineMonths.length"
        id="news-archives-month-list"
        class="news-archives-timeline"
      >
        <button
          v-for="item in timelineMonths"
          :key="item.month"
          type="button"
          class="news-archives-timeline-item"
          :class="{
            'is-active': activeYear === viewingYear && activeMonth === item.month
          }"
          :aria-pressed="activeYear === viewingYear && activeMonth === item.month"
          :aria-label="`${item.fullLabel} ${viewingYear}, ${item.count} bài viết`"
          :title="`${item.fullLabel} ${viewingYear}: ${item.count} bài viết`"
          @click="selectMonth(item.month)"
        >
          <span class="news-archives-timeline-month">
            <span class="news-archives-timeline-month-full">{{ item.shortLabel }}</span>
            <span class="news-archives-timeline-month-compact" aria-hidden="true">
              T{{ item.month }}
            </span>
          </span>
          <span class="news-archives-timeline-meta">
            <span class="news-archives-timeline-count">
              <strong>{{ item.count }}</strong>
              <small>bài</small>
            </span>
            <i class="ti-arrow-right" aria-hidden="true"></i>
          </span>
        </button>
      </div>

      <p v-else class="news-archives-empty">Chưa có bài viết trong năm này.</p>
    </template>

    <p v-else class="news-archives-empty">Chưa có dữ liệu lưu trữ.</p>
  </div>
</template>

<style scoped>
.news-archives-title {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 16px;
  margin-bottom: 20px;
  padding-bottom: 12px;
}

.news-archives-title h6 {
  padding: 0;
  margin: 0;
  font-size: 24px;
  line-height: 1.3;
}

.news-archives-title-copy {
  min-width: 0;
}

.news-archives-title-copy p {
  margin: 7px 0 0;
  color: #8a8177;
  font-size: 12px;
  line-height: 1.45;
}

.news-archives-latest {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex: 0 0 auto;
  gap: 7px;
  min-height: 32px;
  padding: 5px 0;
  border: 0;
  background: transparent;
  color: #806c55;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  line-height: 1;
  letter-spacing: 1px;
  text-transform: uppercase;
  white-space: nowrap;
  cursor: pointer;
  transition: color 0.2s ease;
}

.news-archives-latest i {
  margin: 0;
  font-size: 10px;
}

.news-archives-latest:hover,
.news-archives-latest.active {
  color: #aa8453;
}

.news-archives-year-control {
  display: grid;
  grid-template-columns: 44px minmax(0, 1fr) 44px;
  align-items: stretch;
  gap: 0;
  margin-bottom: 16px;
  border: 1px solid #eee3d0;
  background: #fff;
  transition:
    border-color 0.2s ease,
    box-shadow 0.2s ease;
}

.news-archives-year-control:focus-within {
  border-color: #aa8453;
  box-shadow: 0 0 0 2px rgba(170, 132, 83, 0.12);
}

.news-archives-select {
  position: relative;
  z-index: 4;
  min-width: 0;
  border-right: 1px solid #eee3d0;
  border-left: 1px solid #eee3d0;
}

.news-archives-year-nav,
.news-archives-select-trigger {
  width: 100%;
  height: 44px;
  border: 0;
  border-radius: 0;
  background: #fff;
  color: #222;
}

.news-archives-select-trigger {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  padding: 0 38px 0 16px;
  font-family: 'Oswald', sans-serif;
  font-size: 13px;
  letter-spacing: 0.5px;
  text-align: left;
  cursor: pointer;
  transition:
    background-color 0.2s ease,
    color 0.2s ease;
}

.news-archives-select-trigger i {
  position: absolute;
  right: 15px;
  margin: 0;
  color: #aa8453;
  font-size: 10px;
  transition: transform 0.2s ease;
}

.news-archives-select.is-open .news-archives-select-trigger {
  background: #fcfaf7;
  color: #aa8453;
}

.news-archives-select.is-open .news-archives-select-trigger i {
  transform: rotate(180deg);
}

.news-archives-select-trigger:focus-visible {
  outline: 0;
}

.news-archives-select-options {
  position: absolute;
  z-index: 12;
  top: calc(100% + 6px);
  right: -1px;
  left: -1px;
  display: grid;
  overflow: hidden;
  border: 1px solid #aa8453;
  background: #fff;
  box-shadow: 0 12px 28px rgba(53, 42, 29, 0.14);
}

.news-archives-select-option {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  width: 100%;
  min-height: 42px;
  padding: 9px 15px;
  border: 0;
  border-bottom: 1px solid #eee3d0;
  border-radius: 0;
  background: #fff;
  color: #222;
  font-family: 'Oswald', sans-serif;
  font-size: 13px;
  letter-spacing: 0.5px;
  line-height: 1.3;
  text-align: left;
  cursor: pointer;
  transition:
    background-color 0.18s ease,
    color 0.18s ease;
}

.news-archives-select-option:last-child {
  border-bottom: 0;
}

.news-archives-select-option:hover,
.news-archives-select-option:focus,
.news-archives-select-option:focus-visible {
  outline: 0;
  background: #f8f5f0;
  color: #aa8453;
}

.news-archives-select-option.is-selected,
.news-archives-select-option.is-selected:hover,
.news-archives-select-option.is-selected:focus,
.news-archives-select-option.is-selected:focus-visible {
  background: #aa8453;
  color: #fff;
}

.news-archives-select-option i {
  margin: 0;
  font-size: 10px;
}

.news-archives-options-enter-active,
.news-archives-options-leave-active {
  transition:
    opacity 0.16s ease,
    transform 0.16s ease;
  transform-origin: top;
}

.news-archives-options-enter-from,
.news-archives-options-leave-to {
  opacity: 0;
  transform: translateY(-5px);
}

.news-archives-year-nav {
  padding: 0;
  color: #aa8453;
  cursor: pointer;
  transition:
    background-color 0.2s ease,
    color 0.2s ease;
}

.news-archives-year-nav:hover:not(:disabled) {
  background: #aa8453;
  color: #fff;
}

.news-archives-year-nav:disabled {
  background: #f5f1eb;
  color: #c9c1b7;
  cursor: not-allowed;
}

.news-archives-timeline {
  display: block;
  border-top: 1px solid #e8dece;
}

.news-archives-timeline-item {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 18px;
  width: 100%;
  min-height: 52px;
  padding-right: 5px;
  padding-left: 5px;
  border: 0;
  border-bottom: 1px solid #e8dece;
  border-radius: 0;
  background: transparent;
  font-family: inherit;
  text-align: left;
  overflow: hidden;
  cursor: pointer;
  transition:
    background-color 0.2s ease,
    padding-left 0.2s ease;
}

.news-archives-timeline-item::before {
  position: absolute;
  top: 12px;
  bottom: 12px;
  left: 0;
  width: 2px;
  content: '';
  background: #aa8453;
  opacity: 0;
  transform: scaleY(0.35);
  transition:
    opacity 0.2s ease,
    transform 0.2s ease;
}

.news-archives-timeline-month {
  color: #292724;
  font-family: 'Gilda Display', serif;
  font-size: 16px;
  line-height: 1.25;
  white-space: nowrap;
  transition: color 0.2s ease;
}

.news-archives-timeline-month-compact {
  display: none;
}

.news-archives-timeline-meta,
.news-archives-timeline-count {
  display: inline-flex;
  align-items: baseline;
  white-space: nowrap;
}

.news-archives-timeline-meta {
  flex: 0 0 auto;
  gap: 11px;
}

.news-archives-timeline-count {
  gap: 4px;
  color: #81776c;
  font-family: 'Barlow Condensed', sans-serif;
  line-height: 1;
  transition: color 0.2s ease;
}

.news-archives-timeline-count strong {
  font-size: 13px;
  font-weight: 400;
}

.news-archives-timeline-count small {
  font-size: 10px;
  letter-spacing: 0.7px;
  text-transform: uppercase;
}

.news-archives-timeline-meta i {
  margin: 0;
  color: #aa8453;
  font-size: 9px;
  opacity: 0;
  transform: translateX(-4px);
  transition:
    opacity 0.2s ease,
    transform 0.2s ease;
}

.news-archives-timeline-item:hover {
  padding-left: 12px;
  background: rgba(170, 132, 83, 0.07);
}

.news-archives-timeline-item.is-active {
  padding-left: 12px;
  background: rgba(170, 132, 83, 0.07);
}

.news-archives-timeline-item:hover::before {
  opacity: 1;
  transform: scaleY(1);
}

.news-archives-timeline-item:hover .news-archives-timeline-month,
.news-archives-timeline-item.is-active .news-archives-timeline-month {
  color: #aa8453;
}

.news-archives-timeline-item.is-active .news-archives-timeline-count {
  color: #806c55;
}

.news-archives-timeline-item:hover .news-archives-timeline-meta i,
.news-archives-timeline-item.is-active .news-archives-timeline-meta i {
  opacity: 1;
  transform: translateX(0);
}

.news-archives-latest:focus-visible,
.news-archives-year-nav:focus-visible,
.news-archives-timeline-item:focus-visible {
  position: relative;
  z-index: 2;
  outline: 2px solid #aa8453;
  outline-offset: 2px;
}

.news-archives-empty {
  margin: 0;
  color: #666;
  font-size: 14px;
}

@media (max-width: 575px) {
  .news-archives-timeline-item {
    min-height: 48px;
  }

  .news-archives-timeline-month {
    font-size: 15px;
  }

  .news-archives-timeline-meta {
    gap: 8px;
  }
}
</style>
