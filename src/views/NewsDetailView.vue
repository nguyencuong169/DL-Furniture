<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
import type { NewsItem } from '../types/news'
import {
  getNewsArchives,
  getNewsById,
  getNewsCategories,
  getNewsRelated
} from '../api/newsSidebarClient'
import { getNewsDate, handleNewsImageError, resolveNewsImage, splitNewsTags } from '../utils/news'
import type { ArchiveDto, CategoryDto } from '../api/newsSidebarClient'
import NewsArchives from '../components/NewsArchives.vue'

const route = useRoute()
const router = useRouter()
const item = ref<NewsItem | null>(null)
const related = ref<NewsItem[]>([])
const categories = ref<CategoryDto[]>([])
const archives = ref<ArchiveDto[]>([])
const loading = ref(true)
const errorMessage = ref('')
let requestId = 0

const categoryName = computed(() => {
  return (
    categories.value.find((category) => category.id === item.value?.newsCategoryId)?.name ??
    'Tin tức'
  )
})

const tags = computed(() => splitNewsTags(item.value?.tags))

const publishedDate = computed(() => {
  if (!item.value) return ''
  const date = getNewsDate(item.value)
  return date ? dayjs(date).locale('vi').format('DD MMMM, YYYY') : ''
})

const bannerStyle = computed(() => ({
  backgroundImage: `url(${resolveNewsImage(item.value?.newsImage, item.value?.id ?? 0)})`
}))

const loadArticle = async (id: number) => {
  const currentRequest = ++requestId
  loading.value = true
  errorMessage.value = ''

  try {
    const [article, categoryItems, archiveItems] = await Promise.all([
      getNewsById(id),
      getNewsCategories().catch(() => []),
      getNewsArchives().catch(() => [])
    ])

    if (currentRequest !== requestId) return

    item.value = article
    categories.value = categoryItems
    archives.value = archiveItems
    related.value = await getNewsRelated(id, 3).catch(() => [])
  } catch (error) {
    if (currentRequest !== requestId) return
    item.value = null
    related.value = []
    errorMessage.value = 'Không tìm thấy bài viết hoặc bài viết không còn khả dụng.'
    console.error('Failed to load news article', error)
  } finally {
    if (currentRequest === requestId) loading.value = false
  }
}

const openArchive = (year: number, month: number) => {
  void router.push({ name: 'news', query: { year, month } })
}

const openLatestNews = () => {
  void router.push({ name: 'news' })
}

watch(
  () => route.params.id,
  (value) => {
    const id = Number(value)
    if (Number.isInteger(id) && id > 0) loadArticle(id)
    else {
      loading.value = false
      item.value = null
      errorMessage.value = 'Bài viết không hợp lệ.'
    }
  },
  { immediate: true }
)
</script>

<template>
  <main>
    <section v-if="loading" class="news-post-section section-padding">
      <div class="container">
        <p>Đang tải bài viết...</p>
      </div>
    </section>

    <section v-else-if="errorMessage || !item" class="news-post-section section-padding">
      <div class="container">
        <p>{{ errorMessage }}</p>
        <div class="butn-dark mt-30">
          <RouterLink :to="{ name: 'news' }"><span>Quay lại tin tức</span></RouterLink>
        </div>
      </div>
    </section>

    <template v-else>
      <div
        class="banner-header section-padding valign bg-img bg-fixed"
        data-overlay-dark="5"
        :style="bannerStyle"
      >
        <div class="container">
          <div class="row">
            <div class="col-md-12 text-left caption mt-90 news-post-caption">
              <h5>
                {{ categoryName }}<span v-if="publishedDate"> · {{ publishedDate }}</span>
              </h5>
              <h1>{{ item.titles }}</h1>
            </div>
          </div>
        </div>
      </div>

      <section class="news-post-section section-padding">
        <div class="container">
          <div class="row">
            <div class="col-md-8">
              <img
                :src="resolveNewsImage(item.newsImage, item.id)"
                :alt="item.titles || 'Tin tức'"
                class="mb-30"
                @error="handleNewsImageError($event, item.id)"
              />
              <h5 v-if="item.summary">{{ item.summary }}</h5>
              <p>{{ item.content || item.summary }}</p>

              <div class="butn-dark mt-30 mb-30">
                <RouterLink :to="{ name: 'news' }"><span>Quay lại tin tức</span></RouterLink>
              </div>
            </div>

            <div class="col-md-4">
              <div class="news2-sidebar row">
                <div v-if="related.length" class="col-md-12">
                  <div class="widget">
                    <div class="widget-title">
                      <h6>Bài viết liên quan</h6>
                    </div>
                    <ul class="recent">
                      <li v-for="relatedItem in related" :key="relatedItem.id">
                        <div class="thum">
                          <img
                            :src="resolveNewsImage(relatedItem.newsImage, relatedItem.id)"
                            :alt="relatedItem.titles || 'Tin tức liên quan'"
                            @error="handleNewsImageError($event, relatedItem.id)"
                          />
                        </div>
                        <RouterLink :to="{ name: 'news-detail', params: { id: relatedItem.id } }">
                          {{ relatedItem.titles }}
                        </RouterLink>
                      </li>
                    </ul>
                  </div>
                </div>

                <div class="col-md-12">
                  <NewsArchives
                    :archives="archives"
                    @select="openArchive"
                    @clear="openLatestNews"
                  />
                </div>

                <div v-if="tags.length" class="col-md-12">
                  <div class="widget">
                    <div class="widget-title">
                      <h6>Tags</h6>
                    </div>
                    <ul class="tags">
                      <li v-for="tag in tags" :key="tag">
                        <RouterLink :to="{ name: 'news', query: { tag } }">{{ tag }}</RouterLink>
                      </li>
                    </ul>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>
    </template>
  </main>
</template>
