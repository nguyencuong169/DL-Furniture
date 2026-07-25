<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref, watch } from 'vue'
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
const mobileFiltersOpen = ref(false)
const isMobileLayout = ref(false)
const mobileFilterToggle = ref<HTMLButtonElement | null>(null)
const mobileFilterClose = ref<HTMLButtonElement | null>(null)
const mobileFilterMedia =
  typeof window === 'undefined' ? null : window.matchMedia('(max-width: 991px)')
let originalBodyOverflow = ''
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

const activeFilterCount = computed(() => (hasActiveFilters.value ? 1 : 0))

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

const restoreBodyScroll = () => {
  if (typeof document === 'undefined') return
  document.body.style.overflow = originalBodyOverflow
}

const openMobileFilters = async () => {
  mobileFiltersOpen.value = true
  await nextTick()
  mobileFilterClose.value?.focus()
}

const closeMobileFilters = async (returnFocus = false) => {
  mobileFiltersOpen.value = false
  if (returnFocus) {
    await nextTick()
    mobileFilterToggle.value?.focus()
  }
}

const handleMobileFilterMediaChange = (event: MediaQueryListEvent) => {
  isMobileLayout.value = event.matches
  if (!event.matches) void closeMobileFilters()
}

const handleNewsKeydown = (event: KeyboardEvent) => {
  if (event.key === 'Escape' && mobileFiltersOpen.value) void closeMobileFilters(true)
}

const scrollToResults = () => {
  document
    .querySelector('#news-results')
    ?.scrollIntoView({ behavior: 'smooth', block: 'start' })
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
  await closeMobileFilters()
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

watch(
  () => route.fullPath,
  async () => {
    if (!routeSyncReady) return
    await applyRouteFilters()
    await nextTick()
    scrollToResults()
  }
)

watch(mobileFiltersOpen, async (isOpen) => {
  if (typeof document === 'undefined') return

  if (isOpen && isMobileLayout.value) {
    originalBodyOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
  } else {
    restoreBodyScroll()
  }
})

onMounted(async () => {
  isMobileLayout.value = mobileFilterMedia?.matches ?? false
  mobileFilterMedia?.addEventListener('change', handleMobileFilterMediaChange)
  window.addEventListener('keydown', handleNewsKeydown)

  const sidebarPromise = loadSidebar()
  if (queryValue(route.query.category)) await sidebarPromise

  await Promise.all([sidebarPromise, applyRouteFilters()])
  routeSyncReady = true
})

onBeforeUnmount(() => {
  mobileFilterMedia?.removeEventListener('change', handleMobileFilterMediaChange)
  window.removeEventListener('keydown', handleNewsKeydown)
  restoreBodyScroll()
})
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      :style="{ backgroundImage: `url(${newsBanner})` }"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-left caption mt-90">
            <h5>D&amp;L Furniture</h5>
            <h1>Tin tức nội thất</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- News 2 -->
    <section id="news-results" class="news2 section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-8 news-content-column">
            <button
              ref="mobileFilterToggle"
              type="button"
              class="news-filter-toggle-mobile"
              aria-controls="news-filter-panel"
              :aria-expanded="mobileFiltersOpen"
              @click="openMobileFilters"
            >
              <i class="ti-filter" aria-hidden="true"></i>
              <span>Tìm kiếm &amp; bộ lọc</span>
              <strong v-if="activeFilterCount">{{ activeFilterCount }}</strong>
            </button>

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
              :class="{ 'is-refreshing': loading && state.items.length }"
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

              <div v-else-if="loading && !state.items.length" class="news-skeleton-list">
                <article v-for="placeholder in 3" :key="placeholder" class="news-card-skeleton">
                  <div class="news-skeleton-image"></div>
                  <div class="news-skeleton-copy">
                    <span></span><strong></strong><i></i><i></i>
                  </div>
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

              <div v-else class="row news-card-list">
                <div
                  v-for="(item, index) in state.items"
                  :key="item.id"
                  class="col-md-12"
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

                <div v-if="state.totalPages > 1" class="col-md-12">
                  <nav aria-label="Phân trang tin tức">
                    <ul class="news-pagination-wrap align-center mb-30 mt-30">
                      <li>
                        <button
                          type="button"
                          :disabled="state.page <= 1 || loading"
                          aria-label="Trang trước"
                          @click="goToPage(state.page - 1)"
                        >
                          <i class="ti-angle-left" aria-hidden="true"></i>
                        </button>
                      </li>

                      <li v-for="(page, pageIndex) in pageButtons" :key="`${page}-${pageIndex}`">
                        <span v-if="page === '...'" class="news-pagination-ellipsis">...</span>
                        <button
                          v-else
                          type="button"
                          :class="{ active: page === state.page }"
                          :aria-current="page === state.page ? 'page' : undefined"
                          :disabled="loading"
                          @click="goToPage(page)"
                        >
                          {{ page }}
                        </button>
                      </li>

                      <li>
                        <button
                          type="button"
                          :disabled="state.page >= state.totalPages || loading"
                          aria-label="Trang sau"
                          @click="goToPage(state.page + 1)"
                        >
                          <i class="ti-angle-right" aria-hidden="true"></i>
                        </button>
                      </li>
                    </ul>
                  </nav>
                </div>
              </div>
            </div>

            <div
              v-if="loadingRelated || sidebar.related.length"
              class="news2-sidebar news-mobile-related"
            >
              <NewsRelatedList :items="sidebar.related" :loading="loadingRelated" />
            </div>
          </div>

          <Transition name="news-filter-backdrop">
            <button
              v-if="mobileFiltersOpen && isMobileLayout"
              type="button"
              class="news-filter-backdrop"
              aria-label="Đóng tìm kiếm và bộ lọc"
              @click="closeMobileFilters(true)"
            ></button>
          </Transition>

          <aside
            id="news-filter-panel"
            class="col-md-4 news-sidebar-column"
            :class="{ 'is-open': mobileFiltersOpen }"
            :role="isMobileLayout ? 'dialog' : undefined"
            :aria-modal="isMobileLayout ? mobileFiltersOpen : undefined"
            :aria-hidden="isMobileLayout && !mobileFiltersOpen"
            aria-labelledby="news-filter-title"
          >
            <div class="news-sidebar-mobile-header">
              <div>
                <span>Bài viết D&amp;L</span>
                <h2 id="news-filter-title">Tìm kiếm &amp; bộ lọc</h2>
              </div>
              <button
                ref="mobileFilterClose"
                type="button"
                class="news-sidebar-mobile-close"
                aria-label="Đóng tìm kiếm và bộ lọc"
                @click="closeMobileFilters(true)"
              >
                <i></i><i></i>
              </button>
            </div>

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
  </main>
</template>
