<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
import { newsApi } from '../api/newsClient'
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
    loop?: boolean
  }>(),
  {
    title: 'Tin tức nội thất',
    subtitle: 'D&L Furniture News',
    items: undefined,
    loop: true
  }
)

const state = reactive({
  items: [] as News[]
})

const carouselElement = ref<HTMLElement | null>(null)
let isComponentActive = true

const getPublishedDate = (newsItem: News) => newsItem.createdDate ?? newsItem.updatedDate

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

const loadItems = async () => {
  if (props.items) {
    state.items = props.items.slice(0, 6)
    await initializeCarousel()
    return
  }

  try {
    const res = await newsApi.newsGetAll()
    if (!isComponentActive) return
    state.items = (res.data ?? []).slice(0, 6) as News[]
    await initializeCarousel()
  } catch {
    state.items = []
  }
}

watch(
  () => props.items,
  () => {
    if (props.items) {
      destroyCarousel()
      void loadItems()
    }
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
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle">
            <span>{{ subtitle ? subtitle : 'D&L Furniture News' }}</span>
          </div>
          <h2 class="section-title">
            <span>{{ title }}</span>
          </h2>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12">
          <div
            v-if="state.items.length"
            ref="carouselElement"
            class="owl-carousel owl-theme"
            role="region"
            aria-roledescription="carousel"
            :aria-label="title"
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
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
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
  height: 165px;
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
</style>
