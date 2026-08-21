<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
import { getNewsPaged } from '../api/newsPagedClient'
import type { News } from '../generated/api-client/models'
import { handleNewsImageError, resolveNewsImage } from '../utils/news'

interface OwlCarouselElement {
  data(key: string): unknown
  trigger(eventName: string): OwlCarouselElement
  owlCarousel(options: Record<string, unknown>): OwlCarouselElement
}

interface OwlJQuery {
  (element: HTMLElement): OwlCarouselElement
  fn?: {
    owlCarousel?: unknown
  }
}

const props = withDefaults(
  defineProps<{
    title?: string
    subtitle?: string
    items?: News[]
    limit?: number
    loop?: boolean
    variant?: 'carousel' | 'grid'
  }>(),
  {
    title: 'Tin tức nội thất',
    subtitle: 'D&L Furniture News',
    items: undefined,
    limit: 3,
    loop: true,
    variant: 'carousel'
  }
)

const state = reactive({
  items: [] as News[]
})

const carouselElement = ref<HTMLElement | null>(null)
const canScrollPrevious = ref(false)
const canScrollNext = ref(false)
let isComponentActive = true
const isGrid = computed(() => props.variant === 'grid')
const itemLimit = computed(() => Math.max(1, Math.min(12, Math.floor(props.limit))))

const getPublishedDate = (newsItem: News) => newsItem.createdDate ?? newsItem.updatedDate

const normalizeTitleTokens = (title?: string) =>
  new Set(
    (title ?? '')
      .normalize('NFD')
      .replace(/[\u0300-\u036f]/g, '')
      .toLowerCase()
      .replace(/đ/g, 'd')
      .match(/[a-z0-9]+/g)
      ?.filter((token) => token.length > 2) ?? []
  )

const getTitleSimilarity = (first?: string, second?: string) => {
  const firstTokens = normalizeTitleTokens(first)
  const secondTokens = normalizeTitleTokens(second)
  if (!firstTokens.size || !secondTokens.size) return 0

  const intersection = [...firstTokens].filter((token) => secondTokens.has(token)).length
  const union = new Set([...firstTokens, ...secondTokens]).size
  return union ? intersection / union : 0
}

const getImageKey = (item: News) =>
  resolveNewsImage(item.newsImage, item.id).trim().toLowerCase().split(/[?#]/, 1)[0]

const selectDiverseItems = (items: News[], limit = 3) => {
  const candidates = items.filter((item) => !item.hidden && !item.delFlag)
  const selected: News[] = []

  for (const item of candidates) {
    const imageKey = getImageKey(item)
    const isTooSimilar = selected.some((selectedItem) => {
      const hasDuplicateImage = imageKey && getImageKey(selectedItem) === imageKey
      const hasSimilarTitle = getTitleSimilarity(selectedItem.titles, item.titles) >= 0.55
      return hasDuplicateImage || hasSimilarTitle
    })

    if (!isTooSimilar) selected.push(item)
    if (selected.length === limit) return selected
  }

  for (const item of candidates) {
    if (!selected.some((selectedItem) => selectedItem.id === item.id)) selected.push(item)
    if (selected.length === limit) break
  }

  return selected
}

const getJQuery = () => (window as typeof window & { jQuery?: OwlJQuery }).jQuery

const updateCarouselAccessibility = () => {
  const element = carouselElement.value
  if (!element) return

  element.querySelector<HTMLButtonElement>('.owl-prev')?.setAttribute('aria-label', 'Xem tin trước')
  element
    .querySelector<HTMLButtonElement>('.owl-next')
    ?.setAttribute('aria-label', 'Xem tin tiếp theo')

  element.querySelectorAll<HTMLButtonElement>('.owl-dot').forEach((dot, index) => {
    dot.setAttribute('aria-label', `Đi đến tin số ${index + 1}`)
  })

  element.querySelectorAll<HTMLElement>('.owl-item.cloned').forEach((clone) => {
    clone.setAttribute('aria-hidden', 'true')
    clone
      .querySelectorAll<HTMLElement>('a, button, input, select, textarea, [tabindex]')
      .forEach((control) => {
        control.setAttribute('tabindex', '-1')
      })
  })
}

const destroyCarousel = () => {
  const jquery = getJQuery()
  const element = carouselElement.value

  if (!jquery || !element) return

  const carousel = jquery(element)
  if (carousel.data('owl.carousel')) {
    carousel.trigger('destroy.owl.carousel')
  }
}

const initializeCarousel = async () => {
  if (isGrid.value) return
  await nextTick()

  let jquery = getJQuery()
  for (let attempt = 0; attempt < 10 && !jquery?.fn?.owlCarousel; attempt += 1) {
    await new Promise<void>((resolve) => window.requestAnimationFrame(() => resolve()))
    jquery = getJQuery()
  }

  if (!isComponentActive || !carouselElement.value || !jquery?.fn?.owlCarousel) return

  const carousel = jquery(carouselElement.value) as OwlCarouselElement

  if (carousel.data('owl.carousel')) {
    carousel.trigger('destroy.owl.carousel')
  }

  carousel.owlCarousel({
    loop: props.loop,
    margin: 30,
    mouseDrag: true,
    autoplay: false,
    dots: false,
    nav: true,
    navText: [
      "<span class='lnr ti-angle-left'></span>",
      "<span class='lnr ti-angle-right'></span>"
    ],
    responsiveClass: true,
    responsive: {
      0: {
        items: 1,
        dots: true,
        nav: false
      },
      600: {
        items: 2,
        dots: true,
        nav: false
      },
      1000: {
        items: 3
      }
    }
  })

  window.requestAnimationFrame(updateCarouselAccessibility)
}

const syncNewsRail = () => {
  const element = carouselElement.value
  if (!element || !isGrid.value) return

  const maxScrollLeft = element.scrollWidth - element.clientWidth
  canScrollPrevious.value = element.scrollLeft > 4
  canScrollNext.value = maxScrollLeft - element.scrollLeft > 4
}

const scrollNews = (direction: -1 | 1) => {
  const element = carouselElement.value
  if (!element) return

  element.scrollBy({
    left: direction * Math.max(280, element.clientWidth * 0.85),
    behavior: 'smooth'
  })
}

const loadItems = async () => {
  if (props.items) {
    state.items = selectDiverseItems(props.items, itemLimit.value)
    await initializeCarousel()
    await nextTick()
    syncNewsRail()
    return
  }

  try {
    const res = await getNewsPaged(1, itemLimit.value)
    if (!isComponentActive) return
    state.items = selectDiverseItems(res.items, itemLimit.value)
    await initializeCarousel()
    await nextTick()
    syncNewsRail()
  } catch {
    state.items = []
  }
}

watch(
  () => [props.items, props.limit],
  () => {
    destroyCarousel()
    void loadItems()
  },
  { deep: true }
)

onMounted(async () => {
  await loadItems()
})

onBeforeUnmount(() => {
  isComponentActive = false
  destroyCarousel()
})
</script>

<template>
  <section v-if="state.items.length" class="news home-news section-padding bg-blck">
    <div class="container">
      <div class="row align-items-end home-news-heading">
        <div class="col-md-8">
          <div class="section-subtitle">
            <span>{{ subtitle ? subtitle : 'D&L Furniture News' }}</span>
          </div>
          <h2 class="section-title">
            <span>{{ title }}</span>
          </h2>
        </div>
        <div class="col-md-4 text-md-end">
          <RouterLink class="home-news-all" :to="{ name: 'news' }">
            Xem tất cả bài viết <i class="ti-arrow-right" aria-hidden="true"></i>
          </RouterLink>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12">
          <div v-if="state.items.length" :class="isGrid ? 'home-news-grid-wrap' : ''">
            <button
              v-if="isGrid"
              class="home-news-arrow home-news-arrow--previous"
              type="button"
              aria-label="Xem tin trước"
              :disabled="!canScrollPrevious"
              @click="scrollNews(-1)"
            >
              <i class="ti-angle-left" aria-hidden="true"></i>
            </button>
            <div
              ref="carouselElement"
              :class="isGrid ? 'home-news-grid' : 'owl-carousel owl-theme'"
              role="region"
              :aria-roledescription="isGrid ? undefined : 'carousel'"
              :aria-label="isGrid ? `${title}, có thể cuộn ngang` : title"
              @scroll.passive="syncNewsRail"
            >
              <div class="item" v-for="item in state.items" :key="item.id">
                <div class="position-re o-hidden">
                  <img
                    :src="resolveNewsImage(item.newsImage, item.id)"
                    :alt="item.titles || 'Tin tức'"
                    width="900"
                    height="1200"
                    loading="lazy"
                    decoding="async"
                    @error="handleNewsImageError($event, item.id)"
                  />
                  <div class="date">
                    <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                      <span>{{ dayjs(getPublishedDate(item)).locale('vi').format('MMM') }}</span>
                      <i>{{ dayjs(getPublishedDate(item)).format('DD') }}</i>
                    </RouterLink>
                  </div>
                </div>
                <div class="con">
                  <span class="category">
                    <RouterLink :to="{ name: 'news' }">TIN TỨC</RouterLink>
                  </span>
                  <h3 class="news-card-title">
                    <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                      {{ item.titles }}
                    </RouterLink>
                  </h3>
                </div>
              </div>
            </div>
            <button
              v-if="isGrid"
              class="home-news-arrow home-news-arrow--next"
              type="button"
              aria-label="Xem tin tiếp theo"
              :disabled="!canScrollNext"
              @click="scrollNews(1)"
            >
              <i class="ti-angle-right" aria-hidden="true"></i>
            </button>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-news {
  padding: 90px 0 94px;
}

.home-news > .container {
  width: min(1280px, calc(100% - 60px));
  max-width: none;
  padding: 0;
}

.home-news-heading {
  margin-bottom: 38px;
}

.home-news-heading .section-title {
  margin-bottom: 0;
}

.home-news-all {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(255, 255, 255, 0.32);
  color: rgba(255, 255, 255, 0.82);
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.15em;
  text-transform: uppercase;
}

.home-news-all:hover,
.home-news-all:focus-visible {
  border-color: #d3ad7b;
  color: #d3ad7b;
}

.home-news-grid {
  position: relative;
  display: flex;
  overflow-x: auto;
  overscroll-behavior-inline: contain;
  gap: 24px;
  padding-bottom: 0;
  scroll-snap-type: x proximity;
  scrollbar-width: none;
  -ms-overflow-style: none;
}

.home-news-grid::-webkit-scrollbar {
  display: none;
}

.home-news-grid-wrap {
  position: relative;
}

.home-news-arrow {
  position: absolute;
  z-index: 2;
  top: 45%;
  display: inline-flex;
  width: 42px;
  height: 42px;
  align-items: center;
  justify-content: center;
  border: 1px solid rgba(255, 255, 255, 0.72);
  border-radius: 50%;
  background: rgba(25, 23, 20, 0.3);
  color: #fff;
  cursor: pointer;
  opacity: 0;
  pointer-events: none;
  transform: translateY(-50%);
  transition:
    border-color 0.25s ease,
    background 0.25s ease,
    color 0.25s ease,
    opacity 0.25s ease;
}

.home-news-grid-wrap:hover .home-news-arrow:not(:disabled),
.home-news-arrow:focus-visible:not(:disabled) {
  opacity: 1;
  pointer-events: auto;
}

.home-news-arrow--previous {
  left: 12px;
}

.home-news-arrow--next {
  right: 12px;
}

.home-news-arrow:hover:not(:disabled),
.home-news-arrow:focus-visible:not(:disabled) {
  border-color: #aa8453;
  background: rgba(25, 23, 20, 0.72);
  color: #d3ad7b;
}

.home-news-arrow:disabled {
  cursor: default;
  opacity: 0;
  pointer-events: none;
}

.home-news-grid .item {
  flex: 0 0 calc((100% - 48px) / 3);
  min-width: 0;
  margin: 0;
  scroll-snap-align: start;
}

.home-news-grid .item .position-re {
  aspect-ratio: 4 / 5;
}

.home-news-grid .item .con {
  height: 132px;
  padding: 20px 24px 22px;
}

.home-news-grid .item .con .news-card-title {
  height: 70px;
  font-size: 25px;
}

.home-news-grid .item .con .news-card-title a {
  -webkit-line-clamp: 2;
}

.home-news-all:focus-visible {
  outline: 2px solid #d3ad7b;
  outline-offset: 5px;
}

@media (max-width: 767.98px) {
  .home-news-grid {
    gap: 16px;
    margin-right: -15px;
    padding-right: 15px;
  }

  .home-news-grid .item {
    flex-basis: min(82vw, 340px);
  }
}

.home-news .item .position-re {
  width: 100%;
  aspect-ratio: 3 / 4;
}

.home-news .item .position-re img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  object-position: center;
}

.home-news .item .con {
  box-sizing: border-box;
  height: 132px;
}

.home-news .item .con .news-card-title {
  height: 90px;
  margin: 0;
  overflow: hidden;
  color: #222;
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  font-weight: 400;
  line-height: 1.25;
}

.home-news .item .con .news-card-title a {
  display: -webkit-box;
  overflow: hidden;
  color: inherit;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
}

.home-news .item .con .news-card-title a:hover {
  color: #aa8453;
}

@media (max-width: 767.98px) {
  .home-news {
    padding: 76px 0 80px;
  }

  .home-news > .container {
    width: calc(100% - 30px);
  }

  .home-news-all {
    margin-top: 17px;
  }

  .home-news-grid {
    gap: 14px;
    scroll-snap-type: x mandatory;
  }

  .home-news-grid .item {
    scroll-snap-align: start;
  }

  .home-news-grid .item .con .news-card-title {
    height: 70px;
    font-size: 23px;
  }

  .home-news-grid .item .con .news-card-title a {
    -webkit-line-clamp: 2;
  }
  .home-news-arrow {
    top: 34%;
    width: 38px;
    height: 38px;
    opacity: 1;
    pointer-events: auto;
  }

  .home-news-arrow--previous {
    left: 8px;
  }

  .home-news-arrow--next {
    right: 8px;
  }
}

.home-news-grid .item .con .news-card-title {
  height: 58px;
  max-height: 58px;
}

.home-news-grid .item .con .news-card-title a {
  display: -webkit-box;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}
</style>
