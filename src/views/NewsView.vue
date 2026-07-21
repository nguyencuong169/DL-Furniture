<script setup lang="ts">
import { computed, onMounted, reactive, ref } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
import type { NewsItem } from '../types/news'
import type { NewsPageFilters } from '../api/newsPagedClient'
import { getNewsPaged, getNewsPagedByArchiveMonth } from '../api/newsPagedClient'
import {
  getNewsArchives,
  getNewsCategories,
  getNewsRelated,
  getNewsTags
} from '../api/newsSidebarClient'
import { getNewsDate, handleNewsImageError, resolveNewsImage } from '../utils/news'
import NewsArchives from '../components/NewsArchives.vue'

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
  categories: [] as Array<{ id: number; name: string; slug: string }>,
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
const loading = ref(false)
const loadingRelated = ref(false)
const loadError = ref('')
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
  const results = await Promise.allSettled([getNewsCategories(), getNewsArchives(), getNewsTags()])

  const [categoriesResult, archivesResult, tagsResult] = results

  if (categoriesResult.status === 'fulfilled') sidebar.categories = categoriesResult.value
  else console.error('Failed to load news categories', categoriesResult.reason)

  if (archivesResult.status === 'fulfilled') sidebar.archives = archivesResult.value
  else console.error('Failed to load news archives', archivesResult.reason)

  if (tagsResult.status === 'fulfilled') sidebar.tags = tagsResult.value
  else console.error('Failed to load news tags', tagsResult.reason)
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

const hasActiveFilters = computed(() => {
  return archiveFilter.enabled || Boolean(uiState.categoryId || uiState.tag || uiState.search)
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

const updateRouteQuery = (query: Record<string, string | number> = {}) => {
  void router.replace({ name: 'news', query })
}

const clearFilters = async () => {
  resetFiltersWithoutLoading()
  searchInput.value = ''
  updateRouteQuery()
  await loadPage(1)
}

const setArchiveFilter = async (year: number, month: number) => {
  resetFiltersWithoutLoading()
  searchInput.value = ''
  archiveFilter.enabled = true
  archiveFilter.year = year
  archiveFilter.month = month
  updateRouteQuery({ year, month })
  await loadPage(1)
}

const selectCategory = async (categoryId: number) => {
  const shouldClear = uiState.categoryId === categoryId && !archiveFilter.enabled
  resetFiltersWithoutLoading()
  searchInput.value = ''
  if (!shouldClear) uiState.categoryId = categoryId
  updateRouteQuery(shouldClear ? {} : { category: categoryId })
  await loadPage(1)
}

const selectTag = async (tag: string) => {
  const shouldClear = uiState.tag === tag && !archiveFilter.enabled
  resetFiltersWithoutLoading()
  searchInput.value = ''
  if (!shouldClear) uiState.tag = tag
  updateRouteQuery(shouldClear ? {} : { tag })
  await loadPage(1)
}

const submitSearch = async () => {
  const search = searchInput.value.trim()
  if (!search) {
    await clearFilters()
    return
  }

  resetFiltersWithoutLoading()
  uiState.search = search
  updateRouteQuery({ search })
  await loadPage(1)
}

const goToPage = async (page: number) => {
  if (page < 1 || page > state.totalPages || page === state.page) return
  await loadPage(page)
  document.querySelector('.news2')?.scrollIntoView({ behavior: 'smooth', block: 'start' })
}

onMounted(async () => {
  await loadSidebar()

  const routeYear = Number(Array.isArray(route.query.year) ? route.query.year[0] : route.query.year)
  const routeMonth = Number(
    Array.isArray(route.query.month) ? route.query.month[0] : route.query.month
  )
  const routeTag = Array.isArray(route.query.tag) ? route.query.tag[0] : route.query.tag
  const routeCategory = Number(
    Array.isArray(route.query.category) ? route.query.category[0] : route.query.category
  )
  const routeSearch = Array.isArray(route.query.search) ? route.query.search[0] : route.query.search

  if (
    Number.isInteger(routeYear) &&
    Number.isInteger(routeMonth) &&
    routeMonth >= 1 &&
    routeMonth <= 12
  ) {
    archiveFilter.enabled = true
    archiveFilter.year = routeYear
    archiveFilter.month = routeMonth
    await loadPage(1)
    return
  }

  if (routeTag) {
    uiState.tag = String(routeTag)
    await loadPage(1)
    return
  }

  if (Number.isInteger(routeCategory) && routeCategory > 0) {
    uiState.categoryId = routeCategory
    await loadPage(1)
    return
  }

  if (routeSearch) {
    uiState.search = String(routeSearch)
    searchInput.value = uiState.search
  }

  await loadPage(1)
})
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/7-jvnrfz_x.jpg"
    >
      <img src="../assets/img/slider/7.jpg" v-show="false" alt="" />
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
    <section class="news2 section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-8">
            <div v-if="hasActiveFilters" class="news-archives-filter-bar">
              <span class="news-archives-filter-label">{{ activeFilterLabel }}</span>
              <a href="#" class="news-archives-filter-clear" @click.prevent="clearFilters">
                Xóa bộ lọc
              </a>
            </div>

            <div class="row">
              <div v-if="loadError" class="col-md-12">
                <p>{{ loadError }}</p>
              </div>
              <div v-else-if="loading && !state.items.length" class="col-md-12">
                <p>Đang tải tin tức...</p>
              </div>
              <div v-else-if="!state.items.length" class="col-md-12">
                <p>Không tìm thấy bài viết phù hợp.</p>
              </div>

              <div v-for="item in state.items" :key="item.id" class="col-md-12">
                <div class="item">
                  <div class="post-img">
                    <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                      <img
                        :src="resolveNewsImage(item.newsImage, item.id)"
                        :alt="item.titles || 'Tin tức'"
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
                    <a
                      href="#"
                      @click.prevent="item.newsCategoryId && selectCategory(item.newsCategoryId)"
                    >
                      <span class="tag">{{ categoryName(item) }}</span>
                    </a>
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
                </div>
              </div>

              <div v-if="state.totalPages > 0" class="col-md-12">
                <ul class="news-pagination-wrap align-center mb-30 mt-30" aria-label="Phân trang">
                  <li>
                    <a
                      href="#"
                      :class="{ disabled: state.page <= 1 }"
                      :aria-disabled="state.page <= 1"
                      aria-label="Trang trước"
                      @click.prevent="goToPage(state.page - 1)"
                    >
                      <i class="ti-angle-left"></i>
                    </a>
                  </li>

                  <li v-for="(page, index) in pageButtons" :key="`${page}-${index}`">
                    <a v-if="page === '...'" href="#" tabindex="-1" @click.prevent>...</a>
                    <a
                      v-else
                      href="#"
                      :class="{ active: page === state.page }"
                      :aria-current="page === state.page ? 'page' : undefined"
                      @click.prevent="goToPage(page)"
                    >
                      {{ page }}
                    </a>
                  </li>

                  <li>
                    <a
                      href="#"
                      :class="{ disabled: state.page >= state.totalPages }"
                      :aria-disabled="state.page >= state.totalPages"
                      aria-label="Trang sau"
                      @click.prevent="goToPage(state.page + 1)"
                    >
                      <i class="ti-angle-right"></i>
                    </a>
                  </li>
                </ul>
              </div>
            </div>
          </div>

          <div class="col-md-4">
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
                    />
                    <button type="submit" aria-label="Tìm kiếm">
                      <i class="ti-search" aria-hidden="true"></i>
                    </button>
                  </form>
                </div>
              </div>

              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Bài viết liên quan</h6>
                  </div>
                  <ul class="recent">
                    <li v-if="loadingRelated && !sidebar.related.length">
                      <a href="#" @click.prevent>Đang tải...</a>
                    </li>
                    <li v-else-if="!sidebar.related.length">
                      <a href="#" @click.prevent>Chưa có bài viết liên quan.</a>
                    </li>
                    <li v-for="related in sidebar.related" :key="related.id">
                      <div class="thum">
                        <img
                          :src="resolveNewsImage(related.newsImage, related.id)"
                          :alt="related.titles || 'Tin tức liên quan'"
                          @error="handleNewsImageError($event, related.id)"
                        />
                      </div>
                      <RouterLink :to="{ name: 'news-detail', params: { id: related.id } }">
                        {{ related.titles }}
                      </RouterLink>
                    </li>
                  </ul>
                </div>
              </div>

              <div class="col-md-12">
                <NewsArchives
                  :archives="sidebar.archives"
                  :active-year="archiveFilter.year"
                  :active-month="archiveFilter.month"
                  @select="setArchiveFilter"
                  @clear="clearFilters"
                />
              </div>

              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Categories</h6>
                  </div>
                  <ul>
                    <li v-for="category in sidebar.categories" :key="category.id">
                      <a
                        href="#"
                        :class="{ active: uiState.categoryId === category.id }"
                        @click.prevent="selectCategory(category.id)"
                      >
                        <i class="ti-angle-right"></i>{{ category.name }}
                      </a>
                    </li>
                  </ul>
                </div>
              </div>

              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <div
                      class="d-flex align-items-center justify-content-between"
                      style="width: 100%"
                    >
                      <h6 class="mb-0">Tags</h6>
                      <a
                        v-if="sidebar.tags.length > 12"
                        href="#"
                        class="view-more"
                        @click.prevent="uiState.showAllTags = !uiState.showAllTags"
                      >
                        {{ uiState.showAllTags ? 'Thu gọn' : 'Xem thêm' }}
                      </a>
                    </div>
                  </div>
                  <ul class="tags">
                    <li v-for="tag in displayedTags" :key="tag.name">
                      <a
                        href="#"
                        :class="{ active: uiState.tag === tag.name }"
                        :title="`${tag.count} bài viết`"
                        @click.prevent="selectTag(tag.name)"
                      >
                        {{ tag.name }}
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>
