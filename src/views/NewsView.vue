<script setup lang="ts">
import { computed, nextTick, onMounted, reactive, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
import newsBanner from '../assets/img/slider/7.jpg'
import type { NewsItem } from '../types/news'
import type { NewsPageFilters } from '../api/newsPagedClient'
import { getNewsPaged, getNewsPagedByArchiveMonth } from '../api/newsPagedClient'
import {
  getNewsArchives,
  getNewsCategories,
  getNewsRelated,
  getNewsTags
} from '../api/newsSidebarClient'
import type { CategoryDto } from '../api/newsSidebarClient'
import { getNewsDate, handleNewsImageError, resolveNewsImage } from '../utils/news'
import NewsArchives from '../components/NewsArchives.vue'
import NewsRelatedList from '../components/NewsRelatedList.vue'
import BookingFormComponent from '../template/11_BookingFormComponent.vue'
import ClientsComponent from '../template/12_ClientsComponent.vue'

const NEWS_VIEW_MODE_STORAGE_KEY = 'news-view-mode'
const POPULAR_VIEW_THRESHOLD = 300

type NewsViewMode = 'grid' | 'list'

const route = useRoute()
const router = useRouter()

const state = reactive({
  items: [] as NewsItem[],
  page: 1,
  pageSize: 6,
  totalPages: 0,
  totalCount: 0
})

const sidebar = reactive({
  categories: [] as CategoryDto[],
  archives: [] as Array<{ year: number; month: number; monthLabel: string; count: number }>,
  tags: [] as Array<{ name: string; count: number }>,
  related: [] as NewsItem[]
})

const uiState = reactive({
  showAllTags: false,
  categoryId: null as number | null,
  tag: '',
  search: ''
})

const archiveFilter = reactive({
  enabled: false,
  year: null as number | null,
  month: null as number | null
})

const searchInput = ref('')
const loading = ref(true)
const loadingRelated = ref(false)
const loadingCategories = ref(true)
const categoryLoadError = ref(false)
const sidebarLoadError = ref(false)
const loadError = ref('')

const readViewModePreference = (): NewsViewMode => {
  if (typeof window === 'undefined') return 'grid'

  try {
    return window.localStorage.getItem(NEWS_VIEW_MODE_STORAGE_KEY) === 'list' ? 'list' : 'grid'
  } catch {
    return 'grid'
  }
}

const viewMode = ref<NewsViewMode>(readViewModePreference())
let routeSyncReady = false
let pageRequestId = 0
let relatedRequestId = 0

const categoryName = (item: NewsItem) => {
  return (
    sidebar.categories.find((category) => category.id === item.newsCategoryId)?.name ?? 'Tin tức'
  )
}

const formatNewsDate = (item: NewsItem, format: string) => {
  const date = getNewsDate(item)
  return date ? dayjs(date).locale('vi').format(format) : ''
}

const getNewsViewCount = (item: NewsItem) => {
  const viewCount = Number(item.viewCount ?? 0)
  return Number.isFinite(viewCount) && viewCount > 0 ? Math.floor(viewCount) : 0
}

const popularNewsId = computed(() => {
  let popularId = ''
  let highestViewCount = POPULAR_VIEW_THRESHOLD - 1

  for (const item of state.items) {
    const viewCount = getNewsViewCount(item)
    if (viewCount > highestViewCount) {
      popularId = String(item.id)
      highestViewCount = viewCount
    }
  }

  return popularId
})

const gridItems = computed(() => {
  const items = [...state.items]
  const popularIndex = items.findIndex((item) => String(item.id) === popularNewsId.value)

  // A full-width card needs to start a row. Only exchange it with the item directly
  // before it, so the page remains as close as possible to chronological order.
  if (popularIndex > 0 && popularIndex % 2 === 1) {
    ;[items[popularIndex - 1], items[popularIndex]] = [items[popularIndex], items[popularIndex - 1]]
  }

  return items
})

const isPopularNews = (item: NewsItem) => {
  return Boolean(popularNewsId.value) && String(item.id) === popularNewsId.value
}

const isGridOrphan = (index: number) => {
  return (
    Boolean(popularNewsId.value) &&
    gridItems.value.length % 2 === 0 &&
    index === gridItems.value.length - 1
  )
}

const formatViewCount = (item: NewsItem) => {
  return new Intl.NumberFormat('vi-VN').format(getNewsViewCount(item))
}

const currentPageFilters = (): Omit<NewsPageFilters, 'year' | 'month'> => ({
  ...(uiState.categoryId ? { categoryId: uiState.categoryId } : {}),
  ...(uiState.tag ? { tag: uiState.tag } : {}),
  ...(uiState.search ? { search: uiState.search } : {})
})

const loadRelatedForCurrentPage = async () => {
  const requestId = ++relatedRequestId
  const first = state.items[0]

  if (!first) {
    sidebar.related = []
    return
  }

  loadingRelated.value = true
  try {
    const related = await getNewsRelated(Number(first.id), 3)
    if (requestId === relatedRequestId) sidebar.related = related
  } catch (error) {
    if (requestId === relatedRequestId) sidebar.related = []
    console.error('Failed to load related news', error)
  } finally {
    if (requestId === relatedRequestId) loadingRelated.value = false
  }
}

const loadPage = async (page: number) => {
  const requestId = ++pageRequestId
  loading.value = true
  loadError.value = ''

  try {
    const filters = currentPageFilters()
    const response =
      archiveFilter.enabled && archiveFilter.year && archiveFilter.month
        ? await getNewsPagedByArchiveMonth(
            archiveFilter.year,
            archiveFilter.month,
            page,
            state.pageSize,
            filters
          )
        : await getNewsPaged(page, state.pageSize, filters)

    if (requestId !== pageRequestId) return

    state.items = response.items
    state.page = response.page
    state.pageSize = response.pageSize
    state.totalPages = response.totalPages
    state.totalCount = response.totalCount
    await loadRelatedForCurrentPage()
  } catch (error) {
    if (requestId !== pageRequestId) return

    state.items = []
    state.page = 1
    state.totalPages = 0
    state.totalCount = 0
    sidebar.related = []
    loadError.value = 'Không thể tải tin tức. Vui lòng thử lại sau.'
    console.error('Failed to load news', error)
  } finally {
    if (requestId === pageRequestId) loading.value = false
  }
}

const loadSidebar = async () => {
  loadingCategories.value = true
  categoryLoadError.value = false
  sidebarLoadError.value = false
  const results = await Promise.allSettled([getNewsCategories(), getNewsArchives(), getNewsTags()])

  const [categoriesResult, archivesResult, tagsResult] = results

  if (categoriesResult.status === 'fulfilled') {
    sidebar.categories = categoriesResult.value
    categoryLoadError.value = false
  } else {
    categoryLoadError.value = true
    sidebarLoadError.value = true
    console.error('Failed to load news categories', categoriesResult.reason)
  }
  loadingCategories.value = false

  if (archivesResult.status === 'fulfilled') sidebar.archives = archivesResult.value
  else {
    sidebarLoadError.value = true
    console.error('Failed to load news archives', archivesResult.reason)
  }

  if (tagsResult.status === 'fulfilled') sidebar.tags = tagsResult.value
  else {
    sidebarLoadError.value = true
    console.error('Failed to load news tags', tagsResult.reason)
  }
}

type PageButton = number | '...'

const pageButtons = computed<PageButton[]>(() => {
  const total = state.totalPages
  if (total <= 0) return []

  const pages = new Set<number>([1, total])
  for (let page = state.page - 2; page <= state.page + 2; page += 1) {
    if (page >= 1 && page <= total) pages.add(page)
  }

  const sortedPages = Array.from(pages).sort((a, b) => a - b)
  const buttons: PageButton[] = []

  sortedPages.forEach((page, index) => {
    const previousPage = sortedPages[index - 1]
    if (previousPage !== undefined && page - previousPage > 1) buttons.push('...')
    buttons.push(page)
  })

  return buttons
})

const displayedTags = computed(() => {
  return uiState.showAllTags ? sidebar.tags : sidebar.tags.slice(0, 12)
})

const totalPublishedCount = computed(() => {
  return sidebar.categories.reduce((total, category) => total + category.publishedCount, 0)
})

const categoriesWithPosts = computed(() => {
  return sidebar.categories.filter((category) => category.publishedCount > 0).length
})

const hasActiveFilters = computed(() => {
  return archiveFilter.enabled || Boolean(uiState.categoryId || uiState.tag || uiState.search)
})

const resultLabel = computed(() => {
  if (loading.value && !state.items.length) return 'Đang tải bài viết...'
  if (!state.totalCount) return 'Chưa có bài viết phù hợp'
  return `${state.totalCount} bài viết`
})

const activeFilterLabel = computed(() => {
  if (uiState.search) return `Kết quả tìm kiếm: “${uiState.search}”`

  if (uiState.categoryId) {
    const category = sidebar.categories.find((item) => item.id === uiState.categoryId)
    return `Danh mục: ${category?.name ?? ''}`
  }

  if (uiState.tag) return `Thẻ: ${uiState.tag}`

  if (archiveFilter.enabled) {
    const archive = sidebar.archives.find(
      (item) => item.year === archiveFilter.year && item.month === archiveFilter.month
    )
    return `${archive?.monthLabel ?? `Tháng ${archiveFilter.month}`} ${archiveFilter.year ?? ''}`
  }

  return ''
})

const resetFiltersWithoutLoading = () => {
  archiveFilter.enabled = false
  archiveFilter.year = null
  archiveFilter.month = null
  uiState.categoryId = null
  uiState.tag = ''
  uiState.search = ''
}

const queryValue = (value: unknown) => (Array.isArray(value) ? value[0] : value)

const setViewMode = (mode: NewsViewMode) => {
  if (viewMode.value === mode) return
  viewMode.value = mode

  try {
    window.localStorage.setItem(NEWS_VIEW_MODE_STORAGE_KEY, mode)
  } catch {
    // Keep the selected view for the current page when local storage is unavailable.
  }
}

const scrollToResults = () => {
  document.querySelector('#news-results')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

const applyRouteFilters = async () => {
  resetFiltersWithoutLoading()
  searchInput.value = ''

  const routeYear = Number(queryValue(route.query.year))
  const routeMonth = Number(queryValue(route.query.month))
  const routeTag = queryValue(route.query.tag)
  const routeCategory = String(queryValue(route.query.category) ?? '')
  const routeSearch = queryValue(route.query.search)
  const requestedPage = Number(queryValue(route.query.page))
  const page = Number.isInteger(requestedPage) && requestedPage > 0 ? requestedPage : 1

  if (
    Number.isInteger(routeYear) &&
    Number.isInteger(routeMonth) &&
    routeMonth >= 1 &&
    routeMonth <= 12
  ) {
    archiveFilter.enabled = true
    archiveFilter.year = routeYear
    archiveFilter.month = routeMonth
  } else if (routeTag) {
    uiState.tag = String(routeTag)
  } else if (routeCategory) {
    const routeCategoryNumber = Number(routeCategory)
    const matchedCategory = sidebar.categories.find(
      (category) =>
        category.slug === routeCategory ||
        (Number.isInteger(routeCategoryNumber) && category.id === routeCategoryNumber)
    )

    if (matchedCategory?.publishedCount) {
      uiState.categoryId = matchedCategory.id
    } else if (categoryLoadError.value && Number.isInteger(routeCategoryNumber)) {
      uiState.categoryId = routeCategoryNumber
    }
  } else if (routeSearch) {
    uiState.search = String(routeSearch)
    searchInput.value = uiState.search
  }

  await loadPage(page)
}

const updateRouteQuery = async (query: Record<string, string | number> = {}) => {
  await router.push({ name: 'news', query })
}

const clearFilters = async () => {
  await updateRouteQuery()
}

const setArchiveFilter = async (year: number, month: number) => {
  await updateRouteQuery({ year, month })
}

const selectCategory = async (categoryId: number) => {
  const category = sidebar.categories.find((item) => item.id === categoryId)
  if (category?.publishedCount === 0) return

  const shouldClear = uiState.categoryId === categoryId && !archiveFilter.enabled
  await updateRouteQuery(shouldClear ? {} : { category: category?.slug ?? categoryId })
}

const selectTag = async (tag: string) => {
  const shouldClear = uiState.tag === tag && !archiveFilter.enabled
  await updateRouteQuery(shouldClear ? {} : { tag })
}

const submitSearch = async () => {
  const search = searchInput.value.trim()
  if (!search) {
    await clearFilters()
    return
  }

  await updateRouteQuery({ search })
}

const clearSearchInput = async () => {
  searchInput.value = ''
  if (uiState.search) await clearFilters()
}

const retryPage = async () => {
  await loadPage(state.page || 1)
}

const retrySidebar = async () => {
  await loadSidebar()
}

const goToPage = async (page: number) => {
  if (page < 1 || page > state.totalPages || page === state.page) return
  const query = { ...route.query } as Record<string, string | number>
  if (page > 1) query.page = page
  else delete query.page
  await router.push({ name: 'news', query })
}

const paginationHref = (page: number) => {
  const safePage = Math.min(Math.max(page, 1), Math.max(state.totalPages, 1))
  const query = { ...route.query } as Record<string, string | number>
  if (safePage > 1) query.page = safePage
  else delete query.page
  return router.resolve({ name: 'news', query }).href
}

watch(
  () => route.fullPath,
  async () => {
    if (!routeSyncReady) return
    await applyRouteFilters()
    await nextTick()
    scrollToResults()
  }
)

onMounted(async () => {
  const sidebarPromise = loadSidebar()
  if (queryValue(route.query.category)) await sidebarPromise

  await Promise.all([sidebarPromise, applyRouteFilters()])
  routeSyncReady = true
})
</script>

<template>
  <main class="news-page">
    <!-- Header Banner -->
    <header
      class="banner-header news-hero section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      :style="{ backgroundImage: `url(${newsBanner})` }"
    >
      <div class="container news-hero-inner">
        <div class="row">
          <div class="col-md-12 text-left caption news-hero-copy">
            <h5>D&amp;L Furniture</h5>
            <h1>Tin tức nội thất</h1>
          </div>
        </div>

        <div class="news-hero-toolbar">
          <div class="news-hero-meta" aria-live="polite">
            <span>{{ resultLabel }}</span>
            <strong v-if="hasActiveFilters">{{ activeFilterLabel }}</strong>
            <span v-else>Góc nhìn, câu chuyện và cảm hứng không gian sống</span>
          </div>

          <div class="news-hero-actions">
            <div class="news-view-switcher" role="group" aria-label="Chế độ hiển thị bài viết">
              <button
                type="button"
                :class="{ active: viewMode === 'grid' }"
                :aria-pressed="viewMode === 'grid'"
                title="Hiển thị dạng lưới"
                @click="setViewMode('grid')"
              >
                <i class="ti-layout-grid3-alt" aria-hidden="true"></i>
                <span class="visually-hidden">Dạng lưới</span>
              </button>
              <button
                type="button"
                :class="{ active: viewMode === 'list' }"
                :aria-pressed="viewMode === 'list'"
                title="Hiển thị dạng danh sách"
                @click="setViewMode('list')"
              >
                <i class="ti-view-list-alt" aria-hidden="true"></i>
                <span class="visually-hidden">Dạng danh sách</span>
              </button>
            </div>
          </div>
        </div>
      </div>
    </header>

    <!-- News 2 -->
    <section
      id="news-results"
      :class="
        viewMode === 'grid'
          ? 'news news-grid-view section-padding bg-blck'
          : 'news2 news-list-view section-padding'
      "
    >
      <div class="container">
        <div class="row">
          <div class="news-content-column" :class="viewMode === 'grid' ? 'col-md-12' : 'col-md-8'">
            <div v-if="hasActiveFilters" class="news-archives-filter-bar">
              <span class="news-archives-filter-label">
                <i class="ti-filter" aria-hidden="true"></i>
                {{ activeFilterLabel }}
              </span>
              <button type="button" class="news-archives-filter-clear" @click="clearFilters">
                Xóa bộ lọc
              </button>
            </div>

            <div
              class="news-results-shell"
              :class="[
                `news-results-shell--${viewMode}`,
                { 'is-refreshing': loading && state.items.length }
              ]"
              :aria-busy="loading"
            >
              <div v-if="loading && state.items.length" class="news-refresh-indicator">
                <span aria-hidden="true"></span>
                Đang cập nhật
              </div>

              <div v-if="loadError" class="news-state news-state--error" role="alert">
                <span class="news-state-icon"><i class="ti-alert" aria-hidden="true"></i></span>
                <h3>Chưa thể tải tin tức</h3>
                <p>{{ loadError }}</p>
                <button type="button" class="news-state-action" @click="retryPage">
                  Thử tải lại
                </button>
              </div>

              <div
                v-else-if="loading && !state.items.length"
                class="news-skeleton-list"
                :class="`news-skeleton-list--${viewMode}`"
              >
                <article
                  v-for="placeholder in viewMode === 'grid' ? 6 : 3"
                  :key="placeholder"
                  class="news-card-skeleton"
                >
                  <div class="news-skeleton-image"></div>
                  <div class="news-skeleton-copy"><span></span><strong></strong><i></i><i></i></div>
                </article>
              </div>

              <div v-else-if="!state.items.length" class="news-state news-state--empty">
                <span class="news-state-icon"><i class="ti-search" aria-hidden="true"></i></span>
                <h3>Không tìm thấy bài viết phù hợp</h3>
                <p>Hãy thử từ khóa hoặc nhóm nội dung khác.</p>
                <button
                  v-if="hasActiveFilters"
                  type="button"
                  class="news-state-action"
                  @click="clearFilters"
                >
                  Xóa bộ lọc
                </button>
              </div>

              <template v-else>
                <div v-if="viewMode === 'grid'" class="news news-grid-view">
                  <div class="news-card-list news-card-list--grid">
                    <div
                      v-for="(item, index) in gridItems"
                      :key="item.id"
                      class="news-card-column"
                      :class="{
                        'news-card-column--popular': isPopularNews(item),
                        'news-card-column--orphan': isGridOrphan(index)
                      }"
                    >
                      <article
                        class="item news-grid-card"
                        :class="{ 'news-grid-card--popular': isPopularNews(item) }"
                      >
                        <div class="position-re o-hidden news-grid-media">
                          <RouterLink
                            class="news-grid-image-link"
                            :to="{ name: 'news-detail', params: { id: item.id } }"
                          >
                            <img
                              :src="resolveNewsImage(item.newsImage, item.id)"
                              :alt="item.titles || 'Tin tức'"
                              :loading="index === 0 ? 'eager' : 'lazy'"
                              decoding="async"
                              @error="handleNewsImageError($event, item.id)"
                            />
                          </RouterLink>
                          <div class="date">
                            <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                              <span>{{ formatNewsDate(item, 'MMM') }}</span>
                              <i>{{ formatNewsDate(item, 'DD') }}</i>
                            </RouterLink>
                          </div>
                        </div>
                        <div class="con">
                          <span class="category">
                            <span v-if="isPopularNews(item)" class="news-popular-badge">
                              <i class="ti-eye" aria-hidden="true"></i>
                              Được quan tâm
                            </span>
                            <button
                              type="button"
                              class="news-grid-category"
                              @click="item.newsCategoryId && selectCategory(item.newsCategoryId)"
                            >
                              {{ categoryName(item) }}
                            </button>
                          </span>
                          <h5>
                            <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                              {{ item.titles }}
                            </RouterLink>
                          </h5>
                          <p v-if="isPopularNews(item)" class="news-popular-summary">
                            {{ item.summary }}
                          </p>
                          <span v-if="isPopularNews(item)" class="news-popular-views">
                            {{ formatViewCount(item) }} lượt đọc
                          </span>
                        </div>
                      </article>
                    </div>
                  </div>
                </div>

                <div v-else class="row">
                  <div
                    v-for="(item, index) in state.items"
                    :key="item.id"
                    class="col-md-12 news-card-column"
                  >
                    <article class="item">
                      <div class="post-img">
                        <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                          <img
                            :src="resolveNewsImage(item.newsImage, item.id)"
                            :alt="item.titles || 'Tin tức'"
                            :loading="index === 0 ? 'eager' : 'lazy'"
                            decoding="async"
                            @error="handleNewsImageError($event, item.id)"
                          />
                        </RouterLink>
                        <div class="date">
                          <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                            <span>{{ formatNewsDate(item, 'MMM') }}</span>
                            <i>{{ formatNewsDate(item, 'DD') }}</i>
                          </RouterLink>
                        </div>
                      </div>
                      <div class="post-cont">
                        <button
                          type="button"
                          class="news-card-category"
                          @click="item.newsCategoryId && selectCategory(item.newsCategoryId)"
                        >
                          <span class="tag">{{ categoryName(item) }}</span>
                        </button>
                        <h5>
                          <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                            {{ item.titles }}
                          </RouterLink>
                        </h5>
                        <p>{{ item.summary }}</p>
                        <div class="butn-dark">
                          <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                            <span>Chi tiết</span>
                          </RouterLink>
                        </div>
                      </div>
                    </article>
                  </div>
                </div>

                <div v-if="state.totalPages > 1" class="col-md-12">
                  <nav aria-label="Phân trang tin tức">
                    <ul class="news-pagination-wrap align-center mb-30 mt-30">
                      <li>
                        <a
                          :href="paginationHref(state.page - 1)"
                          :class="{ 'is-disabled': state.page <= 1 || loading }"
                          :aria-disabled="state.page <= 1 || loading"
                          aria-label="Trang trước"
                          @click.prevent="goToPage(state.page - 1)"
                        >
                          <i class="ti-angle-left" aria-hidden="true"></i>
                        </a>
                      </li>

                      <li v-for="(page, pageIndex) in pageButtons" :key="`${page}-${pageIndex}`">
                        <span v-if="page === '...'" class="news-pagination-ellipsis">...</span>
                        <a
                          v-else
                          :href="paginationHref(page)"
                          :class="{ active: page === state.page, 'is-disabled': loading }"
                          :aria-current="page === state.page ? 'page' : undefined"
                          :aria-disabled="loading"
                          @click.prevent="goToPage(page)"
                        >
                          {{ page }}
                        </a>
                      </li>

                      <li>
                        <a
                          :href="paginationHref(state.page + 1)"
                          :class="{ 'is-disabled': state.page >= state.totalPages || loading }"
                          :aria-disabled="state.page >= state.totalPages || loading"
                          aria-label="Trang sau"
                          @click.prevent="goToPage(state.page + 1)"
                        >
                          <i class="ti-angle-right" aria-hidden="true"></i>
                        </a>
                      </li>
                    </ul>
                  </nav>
                </div>
              </template>
            </div>
          </div>

          <aside v-if="viewMode === 'list'" class="col-md-4 news-sidebar-column">
            <div class="news2-sidebar row">
              <div class="col-md-12">
                <div class="widget search">
                  <form role="search" @submit.prevent="submitSearch">
                    <input
                      v-model="searchInput"
                      type="search"
                      name="search"
                      placeholder="Tìm kiếm bài viết..."
                      aria-label="Tìm kiếm bài viết"
                      @keydown.enter.prevent="submitSearch"
                    />
                    <button
                      v-if="searchInput"
                      type="button"
                      class="news-search-clear"
                      aria-label="Xóa nội dung tìm kiếm"
                      @click="clearSearchInput"
                    >
                      <i class="ti-close" aria-hidden="true"></i>
                    </button>
                    <button class="news-search-submit" type="submit" aria-label="Tìm kiếm">
                      <i class="ti-search" aria-hidden="true"></i>
                    </button>
                  </form>
                </div>
              </div>

              <div
                v-if="loadingRelated || sidebar.related.length"
                class="col-md-12 news-related-desktop"
              >
                <NewsRelatedList :items="sidebar.related" :loading="loadingRelated" />
              </div>

              <div v-if="sidebar.archives.length" class="col-md-12">
                <NewsArchives
                  :archives="sidebar.archives"
                  :active-year="archiveFilter.year"
                  :active-month="archiveFilter.month"
                  @select="setArchiveFilter"
                  @clear="clearFilters"
                />
              </div>

              <div class="col-md-12">
                <div class="widget news-category-widget">
                  <div class="widget-title">
                    <h6>Chuyên mục</h6>
                    <p v-if="totalPublishedCount">
                      {{ totalPublishedCount }} bài viết trong {{ categoriesWithPosts }} chủ đề
                    </p>
                  </div>

                  <p v-if="loadingCategories" class="news-category-status">
                    Đang tải chuyên mục...
                  </p>
                  <p v-else-if="categoryLoadError" class="news-category-status is-error">
                    Chưa thể tải chuyên mục.
                    <button type="button" @click="retrySidebar">Thử lại</button>
                  </p>
                  <p v-else-if="!sidebar.categories.length" class="news-category-status">
                    Chưa có chuyên mục tin tức.
                  </p>

                  <ul v-else class="news-category-list">
                    <li>
                      <button
                        type="button"
                        class="news-category-link"
                        :class="{ active: !hasActiveFilters }"
                        :aria-pressed="!hasActiveFilters"
                        @click="clearFilters"
                      >
                        <span class="news-category-name">
                          <i class="ti-layout-grid2" aria-hidden="true"></i>
                          Tất cả bài viết
                        </span>
                        <span class="news-category-count">{{ totalPublishedCount }}</span>
                      </button>
                    </li>
                    <li v-for="category in sidebar.categories" :key="category.id">
                      <button
                        type="button"
                        class="news-category-link"
                        :class="{
                          active: uiState.categoryId === category.id,
                          'is-empty': category.publishedCount === 0
                        }"
                        :disabled="category.publishedCount === 0"
                        :aria-pressed="uiState.categoryId === category.id"
                        :title="
                          category.publishedCount === 0
                            ? 'Chuyên mục chưa có bài viết công khai'
                            : `${category.publishedCount} bài viết`
                        "
                        @click="selectCategory(category.id)"
                      >
                        <span class="news-category-name">
                          <i class="ti-angle-right" aria-hidden="true"></i>
                          {{ category.name }}
                        </span>
                        <span class="news-category-count">{{ category.publishedCount }}</span>
                      </button>
                    </li>
                  </ul>
                </div>
              </div>

              <div v-if="sidebar.tags.length" class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <div
                      class="d-flex align-items-center justify-content-between"
                      style="width: 100%"
                    >
                      <h6 class="mb-0">Thẻ nội dung</h6>
                      <button
                        v-if="sidebar.tags.length > 12"
                        type="button"
                        class="view-more"
                        @click="uiState.showAllTags = !uiState.showAllTags"
                      >
                        {{ uiState.showAllTags ? 'Thu gọn' : 'Xem thêm' }}
                      </button>
                    </div>
                  </div>
                  <ul class="tags">
                    <li v-for="tag in displayedTags" :key="tag.name">
                      <button
                        type="button"
                        :class="{ active: uiState.tag === tag.name }"
                        :title="`${tag.count} bài viết`"
                        @click="selectTag(tag.name)"
                      >
                        {{ tag.name }}
                      </button>
                    </li>
                  </ul>
                </div>
              </div>

              <div v-if="sidebarLoadError" class="col-md-12 news-sidebar-retry">
                <button type="button" @click="retrySidebar">
                  <i class="ti-reload" aria-hidden="true"></i>
                  Tải lại dữ liệu bộ lọc
                </button>
              </div>
            </div>
          </aside>
        </div>
      </div>
    </section>

    <BookingFormComponent v-if="viewMode === 'grid'" />
    <ClientsComponent v-if="viewMode === 'grid'" />
  </main>
</template>

<style scoped>
.visually-hidden {
  position: absolute !important;
  overflow: hidden;
  width: 1px !important;
  height: 1px !important;
  padding: 0 !important;
  border: 0 !important;
  margin: -1px !important;
  clip: rect(0, 0, 0, 0) !important;
  white-space: nowrap !important;
}

#news-results {
  scroll-margin-top: 90px;
}

#news-results.news-grid-view {
  padding-top: 72px;
  padding-bottom: 88px;
}

.news-state-action:focus-visible,
.news-card-category:focus-visible,
.news-sidebar-retry button:focus-visible,
.news-category-status button:focus-visible,
.news2-sidebar ul.tags li button:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 3px;
}

.news-archives-filter-label {
  display: inline-flex;
  align-items: center;
  gap: 8px;
}

.news-archives-filter-label i {
  flex: 0 0 auto;
  color: #aa8453;
  font-size: 12px;
}

.news-archives-filter-clear {
  padding: 4px 0;
  border: 0;
  background: transparent;
  cursor: pointer;
}

.news-results-shell {
  position: relative;
  min-height: 220px;
}

.news-card-list {
  transition: opacity 0.2s ease;
}

.news-results-shell.is-refreshing .news-card-list {
  opacity: 0.45;
  pointer-events: none;
}

.news-refresh-indicator {
  position: absolute;
  z-index: 3;
  top: 14px;
  right: 14px;
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 8px 12px;
  background: rgba(255, 255, 255, 0.94);
  box-shadow: 0 8px 24px rgba(34, 34, 34, 0.08);
  color: #666;
  font-size: 12px;
}

.news-refresh-indicator span {
  width: 14px;
  height: 14px;
  border: 2px solid rgba(170, 132, 83, 0.25);
  border-top-color: #aa8453;
  border-radius: 50%;
  animation: news-spin 0.8s linear infinite;
}

@keyframes news-spin {
  to {
    transform: rotate(360deg);
  }
}

.news-state {
  display: flex;
  min-height: 420px;
  padding: 70px 40px;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  background: #f8f5f0;
  text-align: center;
}

.news-state-icon {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 62px;
  height: 62px;
  margin-bottom: 22px;
  border: 1px solid rgba(170, 132, 83, 0.35);
  border-radius: 50%;
  color: #aa8453;
  font-size: 23px;
}

.news-state h3 {
  margin-bottom: 10px;
  color: #222;
  font-size: 28px;
}

.news-state p {
  max-width: 430px;
  margin-bottom: 24px;
}

.news-state-action {
  min-height: 44px;
  padding: 11px 24px;
  border: 1px solid #aa8453;
  background: #aa8453;
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  cursor: pointer;
  transition:
    background-color 0.2s ease,
    color 0.2s ease;
}

.news-state-action:hover {
  background: transparent;
  color: #aa8453;
}

.news-skeleton-list {
  display: grid;
  gap: 36px;
}

.news-card-skeleton {
  overflow: hidden;
}

.news-skeleton-image,
.news-skeleton-copy span,
.news-skeleton-copy strong,
.news-skeleton-copy i {
  position: relative;
  display: block;
  overflow: hidden;
  background: #eeeae4;
}

.news-skeleton-image::after,
.news-skeleton-copy span::after,
.news-skeleton-copy strong::after,
.news-skeleton-copy i::after {
  position: absolute;
  inset: 0;
  content: '';
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.72), transparent);
  transform: translateX(-100%);
  animation: news-shimmer 1.35s infinite;
}

@keyframes news-shimmer {
  to {
    transform: translateX(100%);
  }
}

.news-skeleton-image {
  width: 100%;
  aspect-ratio: 16 / 9;
}

.news-skeleton-copy {
  display: grid;
  gap: 12px;
  padding: 28px 0 4px;
}

.news-skeleton-copy span {
  width: 22%;
  height: 12px;
}

.news-skeleton-copy strong {
  width: 72%;
  height: 29px;
}

.news-skeleton-copy i {
  width: 100%;
  height: 12px;
}

.news-skeleton-copy i:last-child {
  width: 78%;
}

.news2 .post-img {
  background: #eeeae4;
}

.news2 .post-img::after {
  position: absolute;
  right: 0;
  bottom: 0;
  left: 0;
  height: 40%;
  content: '';
  background: linear-gradient(to top, rgba(15, 13, 10, 0.46), transparent);
  pointer-events: none;
}

.news2 .post-img img {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

.news2 .post-img .date {
  z-index: 1;
  background: rgba(22, 19, 15, 0.18);
  backdrop-filter: blur(3px);
}

.news2 .post-cont p {
  display: -webkit-box;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
}

.news-card-category {
  display: inline-block;
  padding: 0;
  border: 0;
  background: transparent;
  text-align: left;
  cursor: pointer;
}

.news-card-category:hover .tag {
  color: #7f603b;
}

.news2-sidebar .search form input {
  min-height: 44px;
  padding-right: 82px;
}

.news2-sidebar .search form .news-search-clear {
  right: 40px;
  color: #8a8177;
}

.news2-sidebar .search form .news-search-submit {
  right: 0;
  color: #aa8453;
}

.news2-sidebar .search form button {
  min-width: 40px;
  min-height: 44px;
}

.news2-sidebar .search form button:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: -2px;
}

.news-category-status button {
  padding: 0;
  border: 0;
  border-bottom: 1px solid currentcolor;
  background: transparent;
  color: inherit;
  cursor: pointer;
}

.news2-sidebar .widget-title .view-more {
  padding: 5px 0;
  border: 0;
  background: transparent;
  color: #666;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 1px;
  text-transform: uppercase;
  cursor: pointer;
}

.news2-sidebar .widget-title .view-more:hover {
  color: #aa8453;
}

.news2-sidebar .tags {
  display: flex;
  flex-wrap: wrap;
  gap: 7px;
}

.news2-sidebar .tags li {
  float: none;
  padding: 0;
  border: 0;
  margin: 0 !important;
  background: transparent;
}

.news2-sidebar ul.tags li button {
  display: block;
  padding: 8px 16px;
  border: 1px solid #fff;
  background: #fff;
  color: #666;
  font-family: inherit;
  font-size: 14px;
  line-height: 1.5;
  cursor: pointer;
  transition:
    border-color 0.2s ease,
    background-color 0.2s ease,
    color 0.2s ease;
}

.news2-sidebar ul.tags li button:hover,
.news2-sidebar ul.tags li button.active {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

.news-sidebar-retry {
  margin-bottom: 30px;
}

.news-sidebar-retry button {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  width: 100%;
  min-height: 44px;
  padding: 10px 18px;
  border: 1px solid rgba(170, 132, 83, 0.45);
  background: transparent;
  color: #8b5e4a;
  cursor: pointer;
}

.news-hero {
  min-height: 540px;
  padding: 0;
  background-position: center;
}

.news-hero-inner {
  position: relative;
  z-index: 2;
  display: flex;
  min-height: 540px;
  flex-direction: column;
  justify-content: center;
  padding-top: 90px;
  padding-bottom: 130px;
}

.news-hero-copy {
  margin: 0;
}

.news-hero .caption h1 {
  font-size: 60px;
  line-height: 1.1;
}

.news-hero-toolbar {
  position: absolute;
  right: 15px;
  bottom: 24px;
  left: 15px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  min-height: 58px;
  padding: 8px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.28);
  border-bottom: 1px solid rgba(255, 255, 255, 0.18);
}

.news-hero-meta {
  display: flex;
  min-width: 0;
  flex-direction: column;
  gap: 2px;
  color: rgba(255, 255, 255, 0.58);
  /* font-size: 11px; */
  line-height: 1.5;
}

.news-hero-meta strong {
  display: block;
  overflow: hidden;
  max-width: 520px;
  color: #d8b98d;
  font-weight: 400;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.news-hero-actions,
.news-view-switcher {
  display: inline-flex;
  align-items: center;
}

.news-hero-actions {
  flex: 0 0 auto;
}

.news-view-switcher {
  gap: 4px;
}

.news-view-switcher button {
  display: inline-grid;
  width: 38px;
  height: 38px;
  padding: 0;
  border: 1px solid transparent;
  background: transparent;
  color: rgba(255, 255, 255, 0.52);
  place-items: center;
  cursor: pointer;
  transition:
    border-color 0.2s ease,
    background-color 0.2s ease,
    color 0.2s ease;
}

.news-view-switcher button i {
  margin: 0;
  font-size: 15px;
}

.news-view-switcher button:hover {
  color: #fff;
}

.news-view-switcher button.active {
  border-color: rgba(216, 185, 141, 0.68);
  background: rgba(170, 132, 83, 0.28);
  color: #fff;
}

.news-view-switcher button:focus-visible {
  outline: 2px solid #d8b98d;
  outline-offset: 3px;
}

.news-card-list--list {
  max-width: 1000px;
  margin-right: auto;
  margin-left: auto;
}

.news-card-list--grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  align-items: stretch;
  gap: 54px 30px;
}

.news-card-column {
  min-width: 0;
}

.news-card-column--popular {
  grid-column: 1 / -1;
}

.news-card-column--orphan {
  grid-column: 1 / -1;
  width: calc((100% - 30px) / 2);
  justify-self: center;
}

.news-grid-card {
  height: auto;
  margin-bottom: 0 !important;
}

.news-grid-card--popular {
  display: grid;
  min-height: 390px;
  grid-template-columns: minmax(0, 1.55fr) minmax(300px, 0.85fr);
  overflow: hidden;
  background: #f8f5f0;
}

.news-grid-media {
  aspect-ratio: 4 / 3;
  background: #171717;
}

.news-grid-card--popular .news-grid-media {
  min-height: 390px;
  aspect-ratio: auto;
}

.news-grid-image-link {
  display: block;
  height: 100%;
}

.news-grid-view .item img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.news-grid-view .news-grid-card .con {
  z-index: 2;
  bottom: 0;
  display: flex;
  width: calc(100% - 48px);
  min-height: 0;
  margin: -54px 24px 0;
  padding: 26px 28px 24px;
  flex-direction: column;
}

.news-grid-view .news-grid-card--popular .con {
  position: static;
  bottom: auto;
  width: auto;
  min-height: 100%;
  margin: 0;
  padding: 42px 40px;
  justify-content: center;
  border: 0;
}

.news-grid-view .news-grid-card .con h5 {
  margin-bottom: 0;
}

.news-grid-view .news-grid-card .con h5 a {
  display: -webkit-box;
  overflow: hidden;
  line-height: 1.32;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
}

.news-grid-view .news-grid-card--popular .con h5 a {
  font-size: 31px;
  line-height: 1.25;
}

.news-grid-view .news-grid-card--popular .con .category {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 8px 14px;
  margin-bottom: 14px;
}

.news-popular-badge {
  display: inline-flex;
  align-items: center;
  gap: 7px;
  color: #aa8453;
}

.news-grid-view .item .con .category .news-popular-badge i {
  color: currentColor;
  font-size: 13px;
}

.news-grid-view .news-grid-card--popular .news-grid-category {
  position: relative;
  padding-left: 15px !important;
}

.news-grid-view .news-grid-card--popular .news-grid-category::before {
  position: absolute;
  top: 50%;
  left: 0;
  width: 1px;
  height: 12px;
  background: #c9c1b6;
  content: '';
  transform: translateY(-50%);
}

.news-grid-view .news-grid-card--popular .news-popular-summary {
  display: -webkit-box;
  overflow: hidden;
  margin: 18px 0 22px;
  color: #666;
  font-size: 16px;
  line-height: 1.65;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
}

.news-popular-views {
  color: #8a8177;
  font-family: 'Barlow', sans-serif;
  font-size: 12px;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.news-grid-view .item .con .category .news-grid-category {
  padding: 0;
  border: 0;
  background: transparent;
  color: #666;
  font: inherit;
  letter-spacing: inherit;
  text-transform: inherit;
  cursor: pointer;
  transition: color 0.2s ease;
}

.news-grid-view .item .con .category .news-grid-category:hover {
  color: #222;
}

.news-grid-view .item .con .category .news-grid-category:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 3px;
}

.news-results-shell--list .news-refresh-indicator {
  right: max(14px, calc((100% - 1000px) / 2 + 14px));
}

.news-skeleton-list--list {
  max-width: 1000px;
  margin: 0 auto;
}

.news-skeleton-list--grid {
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 36px 30px;
}

.news-skeleton-list--grid .news-skeleton-image {
  aspect-ratio: 4 / 3;
}

.news-skeleton-list--grid .news-skeleton-copy {
  width: calc(100% - 32px);
  min-height: 132px;
  margin: -30px auto 0;
  padding: 24px;
  background: #fff;
}

@media screen and (min-width: 768px) and (max-width: 991px) {
  .news-grid-card--popular {
    min-height: 340px;
    grid-template-columns: minmax(0, 1.15fr) minmax(280px, 0.85fr);
  }

  .news-grid-card--popular .news-grid-media {
    min-height: 340px;
  }

  .news-grid-view .news-grid-card--popular .con {
    padding: 32px 28px;
  }

  .news-grid-view .news-grid-card--popular .con h5 a {
    font-size: 27px;
  }
}

@media screen and (max-width: 767px) {
  #news-results.news-grid-view {
    padding-top: 54px;
    padding-bottom: 70px;
  }

  .news-card-list--grid {
    grid-template-columns: minmax(0, 1fr);
    row-gap: 38px;
  }

  .news-card-column {
    margin-bottom: 0;
  }

  .news-card-column--popular,
  .news-card-column--orphan {
    grid-column: auto;
    width: auto;
  }

  .news-grid-card--popular {
    display: block;
    min-height: 0;
    background: transparent;
  }

  .news-grid-media {
    aspect-ratio: 4 / 3;
  }

  .news-grid-card--popular .news-grid-media {
    min-height: 0;
    aspect-ratio: 4 / 3;
  }

  .news-grid-view .news-grid-card .con {
    width: calc(100% - 28px);
    min-height: 0;
    margin: -36px 14px 0;
    padding: 22px 20px 24px;
  }

  .news-grid-view .news-grid-card--popular .con {
    position: relative;
    bottom: 0;
    width: calc(100% - 28px);
    min-height: 0;
    margin: -36px 14px 0;
    padding: 24px 20px 25px;
  }

  .news-grid-view .news-grid-card--popular .con .category {
    gap: 7px 11px;
    margin-bottom: 9px;
  }

  .news-grid-view .news-grid-card--popular .con h5 a {
    font-size: 22px;
    line-height: 1.3;
  }

  .news-grid-view .news-grid-card--popular .news-popular-summary {
    margin: 12px 0 13px;
    font-size: 15px;
    line-height: 1.55;
    -webkit-line-clamp: 2;
  }

  .news-grid-view .news-grid-card .con h5 a {
    -webkit-line-clamp: 2;
  }

  .news-grid-view .item .con .category {
    letter-spacing: 2px;
  }

  .news-skeleton-list--grid {
    grid-template-columns: minmax(0, 1fr);
    gap: 30px;
  }

  .news-skeleton-list--grid .news-skeleton-copy {
    width: calc(100% - 28px);
    min-height: 124px;
    margin: -30px 14px 0;
  }
}

.news-pagination-wrap {
  display: block;
  padding: 0;
  margin: 0;
  text-align: center;
}

.news-pagination-wrap li {
  display: inline-block;
  margin: 0 5px;
}

.news-pagination-wrap a {
  cursor: pointer;
}

.news-pagination-wrap a.is-disabled {
  opacity: 0.35;
  pointer-events: none;
}

.news-pagination-ellipsis {
  display: inline-block;
  width: 40px;
  height: 40px;
  border: 0;
  border-radius: 0;
  background: transparent;
  color: #666;
  font-family: 'Barlow', sans-serif;
  font-size: 16px;
  line-height: 37px;
  text-align: center;
}
</style>
