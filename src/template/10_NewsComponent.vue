<script setup lang="ts">
import { nextTick, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import dayjs from 'dayjs'
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

const state = reactive({
  items: [] as News[]
})

const carouselElement = ref<HTMLElement | null>(null)
let isComponentActive = true

const getJQuery = () => (window as typeof window & { jQuery?: OwlJQuery }).jQuery

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

  // The legacy scripts load after the Vue entry module. Wait briefly for Owl
  // instead of letting the homepage fall back to six full-width stacked cards.
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
    loop: true,
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
}

onMounted(async () => {
  try {
    const res = await newsApi.newsGetAll()

    if (!isComponentActive) return

    state.items = (res.data ?? []).slice(0, 6) as News[]
    await initializeCarousel()
  } catch (error) {
    console.error('Failed to load homepage news', error)
  }
})

onBeforeUnmount(() => {
  isComponentActive = false
  destroyCarousel()
})
</script>

<template>
  <section class="news home-news section-padding bg-blck">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle"><span>D&L Furniture News</span></div>
          <div class="section-title"><span>Tin tức nội thất</span></div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12">
          <div v-if="state.items.length" ref="carouselElement" class="owl-carousel owl-theme">
            <div class="item" v-for="item in state.items" :key="item.id">
              <div class="position-re o-hidden">
                <img
                  :src="resolveNewsImage(item.newsImage, item.id)"
                  :alt="item.titles || 'Tin tức'"
                  @error="handleNewsImageError($event, item.id)"
                />
                <div class="date">
                  <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                    <span>{{ dayjs(item.updatedDate).format('MMM') }}</span>
                    <i>{{ dayjs(item.updatedDate).format('DD') }}</i>
                  </RouterLink>
                </div>
              </div>
              <div class="con">
                <span class="category">
                  <RouterLink :to="{ name: 'news' }">TIN TỨC</RouterLink>
                </span>
                <h5>
                  <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                    {{ item.titles }}
                  </RouterLink>
                </h5>
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
  height: 135px;
}

.home-news .item .con h5 {
  height: 60px;
  overflow: hidden;
}

.home-news .item .con h5 a {
  display: -webkit-box;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}
</style>
