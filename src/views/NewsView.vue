<script setup lang="ts">
import { computed, onMounted, reactive, ref, watch } from 'vue'
import dayjs from 'dayjs'
import type { News } from '../generated/api-client/models'
import { getNewsPaged } from '../api/newsPagedClient'
import { getNewsArchives, getNewsCategories, getNewsRelated, getNewsTags } from '../api/newsSidebarClient'

const state = reactive({
  items: [] as News[],
  page: 1,
  pageSize: 6,
  totalPages: 0,
  totalCount: 0
})

const sidebar = reactive({
  categories: [] as Array<{ id: number; name: string; slug: string }>,
  archives: [] as Array<{ year: number; month: number; monthLabel: string; count: number }>,
  tags: [] as Array<{ name: string; count: number }>,
  related: [] as News[]
})

const uiState = reactive({
  showAllArchives: false,
  showAllTags: false
})

const loadingRelated = ref(false)

const loadPage = async (page: number) => {
  try {
    const res = await getNewsPaged(page, state.pageSize)
    state.items = res.items
    state.page = res.page
    state.pageSize = res.pageSize
    state.totalPages = res.totalPages
    state.totalCount = res.totalCount
  } catch (error) {
    console.error('Failed to load news', error)
  }
}

const loadSidebar = async () => {
  const [categoriesRes, archivesRes, tagsRes] = await Promise.all([
    getNewsCategories(),
    getNewsArchives(),
    getNewsTags()
  ])
  sidebar.categories = categoriesRes
  sidebar.archives = archivesRes
  sidebar.tags = tagsRes
}

const loadRelatedForCurrentPage = async () => {
  if (!state.items.length) {
    sidebar.related = []
    return
  }

  loadingRelated.value = true
  try {
    // Related posts for the first item on current page
    const first = state.items[0]
    sidebar.related = await getNewsRelated(Number(first.id), 3)
  } catch (e) {
    console.error('Failed to load related news', e)
  } finally {
    loadingRelated.value = false
  }
}


type PageButton = number | '...'

const pageButtons = computed<PageButton[]>(() => {
  const total = state.totalPages
  if (!total || total <= 0) return []

  const current = state.page
  const windowSize = 2 // show 2 pages on each side of current

  const set = new Set<number>()
  set.add(1)
  set.add(total)

  for (let p = current - windowSize; p <= current + windowSize; p++) {
    if (p >= 1 && p <= total) set.add(p)
  }

  const sorted = Array.from(set).sort((a, b) => a - b)
  const result: PageButton[] = []

  for (let i = 0; i < sorted.length; i++) {
    const p = sorted[i]
    const prev = sorted[i - 1]
    if (i > 0 && prev !== undefined && p - prev > 1) {
      result.push('...')
    }
    result.push(p)
  }

  return result
})

const numberedPages = computed(() => pageButtons.value.filter((p) => typeof p === 'number') as number[])

const archivesByYear = computed(() => {
  const map = new Map<number, { year: number; count: number }>()

  // backend returns desc by year/month; normalize to safety
  for (const a of sidebar.archives) {
    const existing = map.get(a.year)
    if (existing) existing.count += a.count
    else map.set(a.year, { year: a.year, count: a.count })
  }

  return Array.from(map.values()).sort((x, y) => y.year - x.year)
})

type MonthArchive = { year: number; month: number; monthLabel: string; count: number }

const displayArchives = computed(() => {
  if (uiState.showAllArchives) return sidebar.archives as MonthArchive[]
  // gộp theo năm (chỉ hiển thị year)
  return archivesByYear.value.map((y) => ({ year: y.year, month: 0, monthLabel: '', count: y.count })) as any
})

const displayedTags = computed(() => {
  const max = 12
  if (uiState.showAllTags) return sidebar.tags
  return sidebar.tags.slice(0, max)
})

onMounted(async () => {
  await loadPage(1)
  await loadSidebar()
  await loadRelatedForCurrentPage()
})

watch(
  () => state.items,
  () => {
    // refresh related when page items change
    loadRelatedForCurrentPage()
  },
  { deep: false }
)
</script>





<template>

  <main>

    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/7-jvnrfz_x.jpg"
    >
      <img src="../assets/img/slider/7.jpg" v-show="false" />
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-left caption mt-90">
            <h5>D&L Furniture</h5>
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
            <div class="row">
              <div class="col-md-12" v-for="item in state.items" :key="item.id">
                <div class="item">

                  <div class="post-img">
                    <a href="post.html"> <img src="../assets/img/restaurant/2.png" alt="" /> </a>
                    <div class="date">
                      <a href="post.html">
                        <span>{{ dayjs(item.updatedDate).format('MMMM') }}</span>
                        <i>{{ dayjs(item.updatedDate).format('MM') }}</i>
                      </a>
                    </div>
                  </div>
                  <div class="post-cont">
                    <a href="news.html"><span class="tag">NHÀ ĐẸP</span></a>
                    <h5>
                      <a href="post.html">{{ item.titles }}</a>
                    </h5>
                    <p>
                      {{ item.summary }}
                    </p>
                    <div class="butn-dark">
                      <a href="post.html"><span>Chi tiết</span></a>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-12" v-if="state.totalPages > 0">
                <!-- Pagination -->
                <ul class="news-pagination-wrap align-center mb-30 mt-30">
                  <li>
                    <a href="#" :class="{ disabled: state.page <= 1 }" @click.prevent="state.page > 1 && loadPage(state.page - 1)">
                      <i class="ti-angle-left"></i>
                    </a>
                  </li>

                  <li
                    v-for="(p, idx) in numberedPages"
                    :key="`num-${p}-${idx}`"
                    :class="{ active: p === state.page }"
                  >
                    <a href="#" @click.prevent="loadPage(p)">{{ p }}</a>
                  </li>





                  <li>
                    <a href="#" :class="{ disabled: state.page >= state.totalPages }" @click.prevent="state.page < state.totalPages && loadPage(state.page + 1)">
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
                  <form>
                    <input type="text" name="search" placeholder="Type here ..." />
                    <button type="submit"><i class="ti-search" aria-hidden="true"></i></button>
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
                      <a href="#">Đang tải...</a>
                    </li>
                    <li v-for="r in sidebar.related" :key="r.id">
                      <div class="thum">
                        <img :src="r.newsImage || '../assets/img/restaurant/2.png'" alt="" />
                      </div>
                      <a href="post.html">{{ r.titles }}</a>
                    </li>
                  </ul>
                </div>
              </div>

              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <div class="d-flex align-items-center justify-content-between" style="gap: 15px; width: 100%;">
                      <h6 class="mb-0">Archives</h6>


                      <a
                        v-if="sidebar.archives.length > 0 && !uiState.showAllArchives"
                        href="javascript:void(0)"
                        class="view-more"
                        @click.prevent="uiState.showAllArchives = true"
                      >
                        Xem thêm
                      </a>
                      <a
                        v-if="sidebar.archives.length > 0 && uiState.showAllArchives"
                        href="javascript:void(0)"
                        class="view-more"
                        @click.prevent="uiState.showAllArchives = false"
                      >
                        Thu gọn
                      </a>
                    </div>
                  </div>
                  <ul>
                    <li v-for="a in displayArchives" :key="`${a.year}-${a.monthLabel || a.month}`">
                      <a href="#">
                        <span v-if="!uiState.showAllArchives">{{ a.year }}</span>
                        <span v-else>{{ a.monthLabel }} {{ a.year }}</span>
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Categories</h6>
                  </div>
                  <ul>
                    <li v-for="c in sidebar.categories" :key="c.id">
                      <a href="news.html"><i class="ti-angle-right"></i>{{ c.name }}</a>
                    </li>
                  </ul>
                </div>
              </div>
              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <div class="d-flex align-items-center justify-content-between" style="width: 100%;">
                      <h6 class="mb-0">Tags</h6>
                      <a
                        v-if="sidebar.tags.length > 0 && !uiState.showAllTags"
                        href="#"
                        class="view-more"
                        @click.prevent="uiState.showAllTags = true"
                      >
                        Xem thêm
                      </a>
                      <a
                        v-if="sidebar.tags.length > 0 && uiState.showAllTags"
                        href="#"
                        class="view-more"
                        @click.prevent="uiState.showAllTags = false"
                      >
                        Thu gọn
                      </a>
                    </div>
                  </div>
                  <ul class="tags">
                    <li v-for="t in displayedTags" :key="t.name">
                      <a href="#">{{ t.name }}</a>
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
