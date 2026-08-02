<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, ref, watch } from 'vue'

type NewsFilterOption = {
  value: string
  label: string
  meta?: string
  disabled?: boolean
}

const props = defineProps<{
  id: string
  modelValue: string
  options: NewsFilterOption[]
  label: string
  disabled?: boolean
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
}>()

const root = ref<HTMLElement | null>(null)
const trigger = ref<HTMLButtonElement | null>(null)
const optionButtons = ref<HTMLButtonElement[]>([])
const isOpen = ref(false)
const highlightedIndex = ref(0)

const selectedOption = computed(() => {
  return props.options.find((option) => option.value === props.modelValue) ?? props.options[0]
})

const enabledOptionIndexes = computed(() => {
  return props.options.flatMap((option, index) => (option.disabled ? [] : [index]))
})

const focusOption = async (index: number) => {
  highlightedIndex.value = index
  await nextTick()
  optionButtons.value[index]?.focus()
}

const openMenu = () => {
  if (props.disabled) return

  const selectedIndex = props.options.findIndex((option) => option.value === props.modelValue)
  isOpen.value = true
  void focusOption(selectedIndex >= 0 ? selectedIndex : enabledOptionIndexes.value[0] ?? 0)
}

const closeMenu = (restoreFocus = false) => {
  isOpen.value = false
  if (restoreFocus) void nextTick(() => trigger.value?.focus())
}

const toggleMenu = () => {
  if (isOpen.value) closeMenu()
  else openMenu()
}

const moveHighlight = (direction: -1 | 1) => {
  const indexes = enabledOptionIndexes.value
  if (!indexes.length) return

  const currentPosition = indexes.indexOf(highlightedIndex.value)
  const nextPosition =
    currentPosition < 0 ? 0 : (currentPosition + direction + indexes.length) % indexes.length
  void focusOption(indexes[nextPosition])
}

const selectOption = (option: NewsFilterOption) => {
  if (option.disabled) return
  emit('update:modelValue', option.value)
  closeMenu(true)
}

const handleTriggerKeydown = (event: KeyboardEvent) => {
  if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
    event.preventDefault()
    if (!isOpen.value) openMenu()
    else moveHighlight(event.key === 'ArrowDown' ? 1 : -1)
  } else if (event.key === 'Escape') {
    event.preventDefault()
    closeMenu()
  }
}

const handleOptionKeydown = (event: KeyboardEvent, option: NewsFilterOption) => {
  if (event.key === 'ArrowDown' || event.key === 'ArrowUp') {
    event.preventDefault()
    moveHighlight(event.key === 'ArrowDown' ? 1 : -1)
  } else if (event.key === 'Home' || event.key === 'End') {
    event.preventDefault()
    const indexes = enabledOptionIndexes.value
    const index = event.key === 'Home' ? indexes[0] : indexes[indexes.length - 1]
    if (index !== undefined) void focusOption(index)
  } else if (event.key === 'Enter' || event.key === ' ') {
    event.preventDefault()
    selectOption(option)
  } else if (event.key === 'Escape') {
    event.preventDefault()
    closeMenu(true)
  } else if (event.key === 'Tab') {
    closeMenu()
  }
}

const handleOutsidePointerDown = (event: PointerEvent) => {
  if (!root.value?.contains(event.target as Node)) closeMenu()
}

watch(
  () => props.options,
  () => {
    optionButtons.value = []
  }
)

onMounted(() => document.addEventListener('pointerdown', handleOutsidePointerDown))
onBeforeUnmount(() => document.removeEventListener('pointerdown', handleOutsidePointerDown))
</script>

<template>
  <div ref="root" class="news-filter-select" :class="{ 'is-open': isOpen }">
    <button
      :id="id"
      ref="trigger"
      type="button"
      class="news-filter-select__trigger"
      role="combobox"
      aria-haspopup="listbox"
      :aria-label="label"
      :aria-controls="`${id}-options`"
      :aria-expanded="isOpen"
      :disabled="disabled"
      @click="toggleMenu"
      @keydown="handleTriggerKeydown"
    >
      <span>{{ selectedOption?.label }}</span>
      <i class="ti-angle-down" aria-hidden="true"></i>
    </button>

    <Transition name="news-filter-options">
      <div
        v-if="isOpen"
        :id="`${id}-options`"
        class="news-filter-select__options"
        role="listbox"
        :aria-label="label"
      >
        <button
          v-for="(option, index) in options"
          :key="option.value || 'all'"
          :ref="(element) => element && (optionButtons[index] = element as HTMLButtonElement)"
          type="button"
          class="news-filter-select__option"
          :class="{ 'is-selected': option.value === modelValue }"
          :disabled="option.disabled"
          role="option"
          :aria-selected="option.value === modelValue"
          @focus="highlightedIndex = index"
          @click="selectOption(option)"
          @keydown="handleOptionKeydown($event, option)"
        >
          <span>{{ option.label }}</span>
          <small v-if="option.meta">{{ option.meta }}</small>
          <i
            v-if="option.value === modelValue"
            class="ti-check"
            aria-hidden="true"
          ></i>
        </button>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
.news-filter-select {
  position: relative;
  z-index: 8;
  width: 100%;
}

.news-filter-select.is-open {
  z-index: 30;
}

.news-filter-select__trigger {
  display: flex;
  width: 100%;
  height: 62px;
  padding: 0 20px;
  align-items: center;
  justify-content: space-between;
  gap: 16px;
  border: 0;
  border-radius: 0;
  background: #fff;
  color: #222;
  font-family: 'Barlow', sans-serif;
  font-size: 15px;
  line-height: 1.3;
  text-align: left;
  cursor: pointer;
}

.news-filter-select__trigger span {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.news-filter-select__trigger i {
  flex: 0 0 auto;
  margin: 0;
  color: #aa8453;
  font-size: 10px;
  transition: transform 0.2s ease;
}

.news-filter-select.is-open .news-filter-select__trigger i {
  transform: rotate(180deg);
}

.news-filter-select__trigger:focus-visible {
  outline: 0;
  box-shadow: inset 0 0 0 2px #aa8453;
}

.news-filter-select__trigger:disabled {
  color: #999188;
  cursor: wait;
  opacity: 0.72;
}

.news-filter-select__options {
  position: absolute;
  z-index: 30;
  top: calc(100% + 6px);
  right: 0;
  left: 0;
  overflow-y: auto;
  max-height: 312px;
  padding: 6px;
  border: 1px solid rgba(170, 132, 83, 0.55);
  background: #fff;
  box-shadow: 0 18px 42px rgba(28, 23, 18, 0.18);
  scrollbar-color: #aa8453 #f3eee7;
  scrollbar-width: thin;
}

.news-filter-select__option {
  position: relative;
  display: grid;
  width: 100%;
  min-height: 46px;
  padding: 10px 36px 10px 13px;
  grid-template-columns: minmax(0, 1fr) auto;
  align-items: center;
  gap: 12px;
  border: 0;
  border-bottom: 1px solid #f0e9df;
  border-radius: 0;
  background: #fff;
  color: #302b25;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
  line-height: 1.35;
  text-align: left;
  cursor: pointer;
  transition:
    background-color 0.16s ease,
    color 0.16s ease;
}

.news-filter-select__option:last-child {
  border-bottom: 0;
}

.news-filter-select__option small {
  color: #8a8177;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.6px;
  white-space: nowrap;
}

.news-filter-select__option > i {
  position: absolute;
  right: 13px;
  margin: 0;
  color: currentcolor;
  font-size: 10px;
}

.news-filter-select__option:hover,
.news-filter-select__option:focus,
.news-filter-select__option:focus-visible {
  outline: 0;
  background: #f8f5f0;
  color: #8b653a;
}

.news-filter-select__option.is-selected,
.news-filter-select__option.is-selected:hover,
.news-filter-select__option.is-selected:focus {
  background: #aa8453;
  color: #fff;
}

.news-filter-select__option.is-selected small {
  color: rgba(255, 255, 255, 0.76);
}

.news-filter-select__option:disabled {
  color: #b9b1a8;
  cursor: not-allowed;
}

.news-filter-options-enter-active,
.news-filter-options-leave-active {
  transition:
    opacity 0.16s ease,
    transform 0.16s ease;
  transform-origin: top;
}

.news-filter-options-enter-from,
.news-filter-options-leave-to {
  opacity: 0;
  transform: translateY(-5px);
}

@media (max-width: 767px) {
  .news-filter-select__options {
    top: calc(100% + 2px);
    max-height: 260px;
  }
}
</style>
