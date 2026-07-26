<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import dayjs from 'dayjs'
import 'dayjs/locale/vi'
import type { NewsItem } from '../types/news'
import {
  getNewsArchives,
  getNewsById,
  getNewsCategories,
  getNewsRelated,
  recordNewsView
} from '../api/newsSidebarClient'
import { getNewsDate, handleNewsImageError, resolveNewsImage, splitNewsTags } from '../utils/news'
import type { ArchiveDto, CategoryDto } from '../api/newsSidebarClient'
import NewsArchives from '../components/NewsArchives.vue'

const ROUTE_NAME_NEWS = 'news'
const DEFAULT_RELATED_COUNT = 4

const route = useRoute()
const router = useRouter()
const item = ref<NewsItem | null>(null)
const related = ref<NewsItem[]>([])
const categories = ref<CategoryDto[]>([])
const archives = ref<ArchiveDto[]>([])
const loading = ref(true)
const errorMessage = ref('')
const readProgress = ref(0)
const showBackToTop = ref(false)

let requestId = 0
let scrollListenerAttached = false
const trackedArticleIds = new Set<number>()
const newsViewSessionKey = (id: number) => `dl-furniture:news:viewed:${id}`

// ───── Track view ─────

const trackArticleViewOnce = async (id: number) => {
  if (trackedArticleIds.has(id)) return

  const sessionKey = newsViewSessionKey(id)

  try {
    if (sessionStorage.getItem(sessionKey)) {
      trackedArticleIds.add(id)
      return
    }

    sessionStorage.setItem(sessionKey, '1')
  } catch {
    // Keep an in-memory fallback when sessionStorage is unavailable.
  }

  trackedArticleIds.add(id)

  try {
    await recordNewsView(id)
  } catch (error) {
    console.warn('Failed to record news article view', error)
  }
}

// ───── Computed ─────

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

const createdDateFormatted = computed(() => {
  if (!item.value?.createdDate) return ''
  return dayjs(item.value.createdDate).locale('vi').format('DD MMMM, YYYY')
})

const updatedDateFormatted = computed(() => {
  if (!item.value?.updatedDate) return ''
  return dayjs(item.value.updatedDate).locale('vi').format('DD MMMM, YYYY')
})

const isUpdated = computed(() => {
  if (!item.value?.createdDate || !item.value?.updatedDate) return false
  return dayjs(item.value.updatedDate).isAfter(dayjs(item.value.createdDate))
})

const viewCount = computed(() => {
  const count = Number(item.value?.viewCount ?? 0)
  return Number.isFinite(count) && count > 0
    ? new Intl.NumberFormat('vi-VN').format(Math.floor(count))
    : '0'
})

const authorName = computed(() => {
  return item.value?.updatedUser || item.value?.createdUser || 'D&L Furniture'
})

const bannerStyle = computed(() => ({
  backgroundImage: `url(${resolveNewsImage(item.value?.newsImage, item.value?.id ?? 0)})`
}))

const shareUrl = computed(() => {
  if (typeof window === 'undefined') return ''
  return window.location.href
})

const articleContent = computed(() => {
  return item.value?.content || item.value?.summary || ''
})

// ───── Load article ─────

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
    void trackArticleViewOnce(article.id)
    categories.value = categoryItems
    archives.value = archiveItems
    related.value = await getNewsRelated(id, DEFAULT_RELATED_COUNT).catch(() => [])
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

const retryLoad = () => {
  const id = Number(route.params.id)
  if (Number.isInteger(id) && id > 0) loadArticle(id)
}

// ───── Share functions ─────

const shareOnFacebook = () => {
  window.open(
    `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(shareUrl.value)}`,
    '_blank',
    'noopener,noreferrer'
  )
}

const shareOnTwitter = () => {
  const text = item.value?.titles || ''
  window.open(
    `https://twitter.com/intent/tweet?text=${encodeURIComponent(text)}&url=${encodeURIComponent(shareUrl.value)}`,
    '_blank',
    'noopener,noreferrer'
  )
}

const shareOnLinkedIn = () => {
  window.open(
    `https://www.linkedin.com/sharing/share-offsite/?url=${encodeURIComponent(shareUrl.value)}`,
    '_blank',
    'noopener,noreferrer'
  )
}

const copyShareLink = async () => {
  try {
    await navigator.clipboard.writeText(shareUrl.value)
    alert('Đã sao chép đường dẫn bài viết!')
  } catch {
    // Fallback
    const textarea = document.createElement('textarea')
    textarea.value = shareUrl.value
    document.body.appendChild(textarea)
    textarea.select()
    document.execCommand('copy')
    document.body.removeChild(textarea)
    alert('Đã sao chép đường dẫn bài viết!')
  }
}

// ───── Reading progress ─────

const handleScroll = () => {
  const scrollTop = window.scrollY
  const docHeight = document.documentElement.scrollHeight - window.innerHeight
  if (docHeight > 0) {
    readProgress.value = Math.min(Math.round((scrollTop / docHeight) * 100), 100)
  }
  showBackToTop.value = scrollTop > 500
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// ───── Navigation ─────

const openArchive = (year: number, month: number) => {
  void router.push({ name: ROUTE_NAME_NEWS, query: { year, month } })
}

const openLatestNews = () => {
  void router.push({ name: ROUTE_NAME_NEWS })
}

const goToCategoryNews = () => {
  if (item.value?.newsCategoryId) {
    void router.push({ name: ROUTE_NAME_NEWS, query: { category: item.value.newsCategoryId } })
  }
}

const goToTagNews = (tag: string) => {
  void router.push({ name: ROUTE_NAME_NEWS, query: { tag } })
}

// ───── Lifecycle ─────

onMounted(() => {
  window.addEventListener('scroll', handleScroll, { passive: true })
  scrollListenerAttached = true
})

onBeforeUnmount(() => {
  if (scrollListenerAttached) {
    window.removeEventListener('scroll', handleScroll)
    scrollListenerAttached = false
  }
})

watch(
  () => route.params.id,
  (value) => {
    const id = Number(value)
    readProgress.value = 0
    showBackToTop.value = false
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
  <main class="news-detail-page">
    <!-- ───── Reading Progress Bar ───── -->
    <div
      v-if="item && !loading"
      class="nd-progress-bar"
      role="progressbar"
      :aria-valuenow="readProgress"
      aria-valuemin="0"
      aria-valuemax="100"
      :style="{ width: readProgress + '%' }"
    ></div>

    <!-- ───── Loading State ───── -->
    <section v-if="loading" class="section-padding">
      <div class="container">
        <div class="nd-skeleton">
          <div class="nd-skeleton-banner"></div>
          <div class="nd-skeleton-body">
            <div class="row">
              <div class="col-md-8">
                <div class="nd-skeleton-image"></div>
                <div class="nd-skeleton-text">
                  <span></span><strong></strong><i></i><i></i><i></i>
                </div>
              </div>
              <div class="col-md-4">
                <div class="nd-skeleton-sidebar"><span></span><i></i><i></i><i></i></div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- ───── Error State ───── -->
    <section v-else-if="errorMessage || !item" class="news-post-section section-padding">
      <div class="container">
        <div class="nd-error-state">
          <div class="nd-error-icon">
            <i class="ti-alert"></i>
          </div>
          <h3>Không thể tải bài viết</h3>
          <p>{{ errorMessage || 'Bài viết không tồn tại hoặc đã bị xóa.' }}</p>
          <div class="nd-error-actions">
            <button type="button" class="nd-btn nd-btn--primary" @click="retryLoad">
              <i class="ti-reload"></i> Thử tải lại
            </button>
            <RouterLink :to="{ name: 'news' }" class="nd-btn nd-btn--outline">
              <i class="ti-arrow-left"></i> Quay lại tin tức
            </RouterLink>
          </div>
        </div>
      </div>
    </section>

    <!-- ───── Article Content ───── -->
    <template v-else>
      <!-- Banner Header -->
      <div
        class="nd-banner section-padding valign bg-img bg-fixed"
        data-overlay-dark="5"
        :style="bannerStyle"
      >
        <div class="container">
          <div class="row">
            <div class="col-md-12 text-left caption mt-90 nd-banner-caption">
              <div class="nd-breadcrumb">
                <RouterLink :to="{ name: 'news' }">Tin tức</RouterLink>
                <span class="nd-breadcrumb-sep">/</span>
                <button type="button" class="nd-breadcrumb-category" @click="goToCategoryNews">
                  {{ categoryName }}
                </button>
              </div>
              <h1>{{ item.titles }}</h1>
              <div class="nd-banner-meta">
                <span class="nd-meta-item">
                  <i class="ti-user"></i>
                  {{ authorName }}
                </span>
                <span class="nd-meta-item">
                  <i class="ti-calendar"></i>
                  {{ publishedDate }}
                  <span
                    v-if="isUpdated"
                    class="nd-updated-badge"
                    :title="'Đã cập nhật: ' + updatedDateFormatted"
                  >
                    (Đã cập nhật)
                  </span>
                </span>
                <span class="nd-meta-item">
                  <i class="ti-eye"></i>
                  {{ viewCount }} lượt xem
                </span>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main Content Area -->
      <section class="news-post-section section-padding">
        <div class="container">
          <div class="row">
            <!-- ─── Left Column: Article Body ─── -->
            <div class="col-md-8">
              <!-- Featured Image -->
              <figure class="nd-featured-image">
                <img
                  :src="resolveNewsImage(item.newsImage, item.id)"
                  :alt="item.titles || 'Tin tức'"
                  @error="handleNewsImageError($event, item.id)"
                />
                <figcaption v-if="item.titles" class="nd-image-caption">
                  Hình ảnh: {{ item.titles }}
                </figcaption>
              </figure>

              <!-- Summary / Lead -->
              <div v-if="item.summary" class="nd-lead">
                {{ item.summary }}
              </div>

              <!-- Article Content (Rendered HTML) -->
              <div v-if="articleContent" class="nd-article-body" v-html="articleContent"></div>

              <!-- ─── Date Details (before separator) ─── -->
              <div class="nd-date-details">
                <span v-if="createdDateFormatted">
                  <i class="ti-pencil-alt"></i> Đăng ngày: {{ createdDateFormatted }}
                </span>
                <span v-if="isUpdated && updatedDateFormatted">
                  <i class="ti-reload"></i> Cập nhật: {{ updatedDateFormatted }}
                </span>
                <span><i class="ti-eye"></i> {{ viewCount }} lượt xem</span>
              </div>

              <!-- ─── Article Footer ─── -->
              <footer class="nd-article-footer">
                <div class="nd-footer-row">
                  <!-- Category (left) -->
                  <div class="nd-category-section">
                    <button type="button" class="nd-category-btn" @click="goToCategoryNews">
                      <i class="ti-folder"></i> {{ categoryName }}
                    </button>
                  </div>

                  <!-- Share (right) -->
                  <div class="nd-share-section">
                    <div class="nd-share-buttons">
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--facebook"
                        title="Chia sẻ lên Facebook"
                        @click="shareOnFacebook"
                      >
                        <i class="ti-facebook"></i>
                      </button>
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--twitter"
                        title="Chia sẻ lên Twitter"
                        @click="shareOnTwitter"
                      >
                        <i class="ti-twitter-alt"></i>
                      </button>
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--linkedin"
                        title="Chia sẻ lên LinkedIn"
                        @click="shareOnLinkedIn"
                      >
                        <i class="ti-linkedin"></i>
                      </button>
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--copy"
                        title="Sao chép đường dẫn"
                        @click="copyShareLink"
                      >
                        <i class="ti-link"></i>
                      </button>
                    </div>
                  </div>
                </div>
              </footer>

              <!-- ─── Author Box ─── -->
              <div class="nd-author-box">
                <div class="nd-author-avatar">
                  <i class="ti-user"></i>
                </div>
                <div class="nd-author-info">
                  <h5 class="nd-author-name">{{ authorName }}</h5>
                  <p class="nd-author-bio">
                    Bài viết được đăng tải bởi đội ngũ <strong>D&amp;L Furniture</strong>, chuyên
                    cung cấp những thông tin hữu ích về nội thất, thiết kế không gian sống và xu
                    hướng trang trí nhà cửa.
                  </p>
                </div>
              </div>

              <!-- Navigation Buttons -->
              <div class="nd-post-navigation">
                <RouterLink :to="{ name: 'news' }" class="nd-btn nd-btn--outline">
                  <i class="ti-arrow-left"></i> Quay lại tin tức
                </RouterLink>
              </div>
            </div>

            <!-- ─── Right Column: Sidebar ─── -->
            <div class="col-md-4">
              <div class="news2-sidebar row">
                <!-- Related Articles -->
                <div class="col-md-12">
                  <div class="widget nd-related-widget">
                    <div class="widget-title">
                      <h6>Bài viết liên quan</h6>
                    </div>
                    <ul v-if="related.length" class="recent nd-related-list">
                      <li v-for="relatedItem in related" :key="relatedItem.id">
                        <div class="thum">
                          <img
                            :src="resolveNewsImage(relatedItem.newsImage, relatedItem.id)"
                            :alt="relatedItem.titles || 'Tin tức liên quan'"
                            loading="lazy"
                            @error="handleNewsImageError($event, relatedItem.id)"
                          />
                        </div>
                        <RouterLink
                          class="nd-related-link"
                          :to="{ name: 'news-detail', params: { id: relatedItem.id } }"
                        >
                          <span class="nd-related-title">{{ relatedItem.titles }}</span>
                          <span class="nd-related-date">
                            {{
                              getNewsDate(relatedItem)
                                ? dayjs(getNewsDate(relatedItem)).locale('vi').format('DD/MM/YYYY')
                                : ''
                            }}
                          </span>
                        </RouterLink>
                      </li>
                    </ul>
                    <p v-else class="nd-related-empty">Chưa có bài viết liên quan.</p>
                  </div>
                </div>

                <!-- Archives -->
                <div class="col-md-12">
                  <NewsArchives
                    :archives="archives"
                    @select="openArchive"
                    @clear="openLatestNews"
                  />
                </div>

                <!-- Tags Sidebar -->
                <div v-if="tags.length" class="col-md-12">
                  <div class="widget">
                    <div class="widget-title">
                      <h6>Thẻ nội dung</h6>
                    </div>
                    <ul class="tags nd-sidebar-tags">
                      <li v-for="tag in tags" :key="tag">
                        <button type="button" class="nd-sidebar-tag-btn" @click="goToTagNews(tag)">
                          {{ tag }}
                        </button>
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

    <!-- ───── Back to Top Button ───── -->
    <Transition name="nd-backtop">
      <button
        v-if="showBackToTop"
        type="button"
        class="nd-back-to-top"
        aria-label="Lên đầu trang"
        title="Lên đầu trang"
        @click="scrollToTop"
      >
        <i class="ti-angle-up"></i>
      </button>
    </Transition>
  </main>
</template>

<style scoped>
/* ─── Reading Progress Bar ─── */
.nd-progress-bar {
  position: fixed;
  top: 0;
  left: 0;
  z-index: 9999;
  height: 3px;
  background: linear-gradient(90deg, #aa8453, #d4a96a);
  transition: width 0.15s ease-out;
  pointer-events: none;
}

/* ─── Skeleton Loading ─── */
.nd-skeleton-banner {
  width: 100%;
  height: 380px;
  margin-bottom: 40px;
  background: #eeeae4;
}

.nd-skeleton-body {
  padding-top: 10px;
}

.nd-skeleton-image {
  width: 100%;
  aspect-ratio: 16 / 9;
  margin-bottom: 30px;
  background: #eeeae4;
}

.nd-skeleton-text {
  display: grid;
  gap: 14px;
  padding: 10px 0;
}

.nd-skeleton-text span {
  width: 30%;
  height: 13px;
  background: #eeeae4;
}

.nd-skeleton-text strong {
  width: 75%;
  height: 30px;
  background: #eeeae4;
}

.nd-skeleton-text i {
  width: 100%;
  height: 13px;
  background: #eeeae4;
}

.nd-skeleton-text i:last-child {
  width: 65%;
}

.nd-skeleton-sidebar {
  display: grid;
  gap: 14px;
  padding: 10px 0;
}

.nd-skeleton-sidebar span {
  width: 55%;
  height: 24px;
  background: #eeeae4;
}

.nd-skeleton-sidebar i {
  width: 100%;
  height: 52px;
  background: #eeeae4;
}

.nd-skeleton-sidebar i:last-child {
  width: 80%;
}

.nd-skeleton-banner,
.nd-skeleton-image,
.nd-skeleton-text span,
.nd-skeleton-text strong,
.nd-skeleton-text i,
.nd-skeleton-sidebar span,
.nd-skeleton-sidebar i {
  position: relative;
  overflow: hidden;
  border-radius: 0;
}

.nd-skeleton-banner::after,
.nd-skeleton-image::after,
.nd-skeleton-text span::after,
.nd-skeleton-text strong::after,
.nd-skeleton-text i::after,
.nd-skeleton-sidebar span::after,
.nd-skeleton-sidebar i::after {
  position: absolute;
  inset: 0;
  content: '';
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.72), transparent);
  transform: translateX(-100%);
  animation: nd-shimmer 1.35s infinite;
}

@keyframes nd-shimmer {
  to {
    transform: translateX(100%);
  }
}

/* ─── Error State ─── */
.nd-error-state {
  display: flex;
  min-height: 420px;
  padding: 70px 40px;
  align-items: center;
  justify-content: center;
  flex-direction: column;
  background: #f8f5f0;
  text-align: center;
}

.nd-error-icon {
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

.nd-error-state h3 {
  margin-bottom: 10px;
  color: #222;
  font-size: 28px;
}

.nd-error-state p {
  max-width: 430px;
  margin-bottom: 24px;
  color: #666;
}

.nd-error-actions {
  display: flex;
  align-items: center;
  gap: 12px;
  flex-wrap: wrap;
  justify-content: center;
}

/* ─── Shared Buttons ─── */
.nd-btn {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  min-height: 44px;
  padding: 10px 24px;
  border: 1px solid #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  text-decoration: none;
  cursor: pointer;
  transition:
    background-color 0.2s ease,
    color 0.2s ease,
    border-color 0.2s ease;
}

.nd-btn--primary {
  background: #aa8453;
  color: #fff;
}

.nd-btn--primary:hover {
  background: transparent;
  color: #aa8453;
}

.nd-btn--outline {
  background: transparent;
  color: #aa8453;
}

.nd-btn--outline:hover {
  background: #aa8453;
  color: #fff;
}

/* ─── Banner ─── */
.nd-banner {
  position: relative;
  min-height: 520px;
  padding: 0;
  background-position: center;
  background-size: cover;
}

.nd-banner-caption {
  position: relative;
  z-index: 2;
}

.nd-breadcrumb {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 18px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.nd-breadcrumb a,
.nd-breadcrumb-category {
  color: rgba(255, 255, 255, 0.72);
  text-decoration: none;
  transition: color 0.2s ease;
}

.nd-breadcrumb a:hover,
.nd-breadcrumb-category:hover {
  color: #d4a96a;
}

.nd-breadcrumb-category {
  padding: 0;
  border: 0;
  background: transparent;
  cursor: pointer;
  font-family: inherit;
  font-size: inherit;
  letter-spacing: inherit;
  text-transform: inherit;
}

.nd-breadcrumb-sep {
  color: rgba(255, 255, 255, 0.35);
}

.nd-banner-caption h1 {
  color: #fff;
  font-size: 52px;
  line-height: 1.15;
  margin-bottom: 20px;
}

.nd-banner-meta {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 10px 24px;
  margin-top: 4px;
}

.nd-meta-item {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  color: rgba(255, 255, 255, 0.7);
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
}

.nd-meta-item i {
  font-size: 13px;
  color: #d4a96a;
}

.nd-updated-badge {
  display: inline-block;
  padding: 1px 8px;
  border: 1px solid rgba(212, 169, 106, 0.4);
  background: rgba(170, 132, 83, 0.2);
  color: #d4a96a;
  font-size: 11px;
  letter-spacing: 0.5px;
  cursor: help;
}

/* ─── Featured Image ─── */
.nd-featured-image {
  margin: 0 0 30px;
  background: #eeeae4;
}

.nd-featured-image img {
  display: block;
  width: 100%;
  aspect-ratio: 16 / 9;
  object-fit: cover;
}

.nd-image-caption {
  padding: 10px 14px;
  background: #f8f5f0;
  color: #7a7168;
  font-size: 13px;
  font-style: italic;
  line-height: 1.5;
}

/* ─── Lead / Summary ─── */
.nd-lead {
  position: relative;
  margin-bottom: 32px;
  padding: 20px 24px;
  border-left: 3px solid #aa8453;
  background: #f8f5f0;
  color: #3a342c;
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  line-height: 1.65;
}

/* ─── Article Body (v-html content) ─── */
.nd-article-body {
  color: #3a342c;
  font-family: 'Barlow', sans-serif;
  font-size: 16px;
  line-height: 1.85;
  word-wrap: break-word;
}

.nd-article-body h1,
.nd-article-body h2,
.nd-article-body h3,
.nd-article-body h4,
.nd-article-body h5,
.nd-article-body h6 {
  margin-top: 1.6em;
  margin-bottom: 0.7em;
  color: #1a1816;
  font-family: 'Gilda Display', serif;
  font-weight: 400;
  line-height: 1.3;
}

.nd-article-body h2 {
  font-size: 28px;
}

.nd-article-body h3 {
  font-size: 24px;
}

.nd-article-body h4 {
  font-size: 20px;
}

.nd-article-body p {
  margin-bottom: 1.2em;
}

.nd-article-body a {
  color: #aa8453;
  text-decoration: underline;
  transition: color 0.2s ease;
}

.nd-article-body a:hover {
  color: #7f603b;
}

.nd-article-body blockquote {
  position: relative;
  margin: 1.8em 0;
  padding: 20px 24px 20px 40px;
  border-left: 3px solid #aa8453;
  background: #f8f5f0;
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  font-style: italic;
  line-height: 1.7;
  color: #4a443b;
}

.nd-article-body blockquote::before {
  position: absolute;
  top: 14px;
  left: 14px;
  content: '\201C';
  color: #aa8453;
  font-family: 'Gilda Display', serif;
  font-size: 32px;
  line-height: 1;
}

.nd-article-body blockquote p {
  margin-bottom: 0;
}

.nd-article-body ul,
.nd-article-body ol {
  margin-bottom: 1.2em;
  padding-left: 1.5em;
}

.nd-article-body li {
  margin-bottom: 0.45em;
}

.nd-article-body img {
  display: block;
  max-width: 100%;
  height: auto;
  margin: 1.4em auto;
  border-radius: 0;
}

.nd-article-body figure {
  margin: 1.6em 0;
  text-align: center;
}

.nd-article-body figcaption {
  margin-top: 8px;
  color: #7a7168;
  font-size: 13px;
  font-style: italic;
}

.nd-article-body table {
  width: 100%;
  margin: 1.4em 0;
  border-collapse: collapse;
}

.nd-article-body th,
.nd-article-body td {
  padding: 10px 14px;
  border: 1px solid #e0d8cc;
  text-align: left;
}

.nd-article-body th {
  background: #f0ece6;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.nd-article-body hr {
  margin: 1.8em 0;
  border: 0;
  border-top: 1px solid #e0d8cc;
}

.nd-article-body strong {
  font-weight: 600;
}

.nd-article-body code {
  padding: 2px 6px;
  background: #f0ece6;
  font-family: 'Courier New', monospace;
  font-size: 0.9em;
}

.nd-article-body pre {
  overflow-x: auto;
  margin: 1.4em 0;
  padding: 16px 20px;
  background: #1a1816;
  color: #f0ece6;
  font-size: 14px;
  line-height: 1.6;
}

.nd-article-body pre code {
  padding: 0;
  background: transparent;
  color: inherit;
}

/* ─── Article Footer ─── */
.nd-article-footer {
  padding-top: 10px;
  border-top: 1px solid #e0d8cc;
}

.nd-footer-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  gap: 16px;
  flex-wrap: wrap;
}

.nd-category-section,
.nd-share-section {
  display: flex;
  align-items: flex-start;
  gap: 12px;
}

.nd-tags-label {
  flex: 0 0 auto;
  padding-top: 3px;
  color: #5a5248;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.nd-category-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  padding: 6px 16px;
  border: 1px solid #aa8453;
  background: transparent;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 1px;
  text-transform: uppercase;
  cursor: pointer;
  transition:
    background-color 0.2s ease,
    color 0.2s ease;
}

.nd-category-btn:hover {
  background: #aa8453;
  color: #fff;
}

.nd-category-btn i {
  font-size: 12px;
}

.nd-share-buttons {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.nd-share-btn {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 40px;
  height: 40px;
  padding: 0;
  border: 1px solid #e0d8cc;
  background: #fff;
  color: #5a5248;
  font-size: 16px;
  cursor: pointer;
  transition:
    border-color 0.2s ease,
    background-color 0.2s ease,
    color 0.2s ease;
}

.nd-share-btn:hover {
  border-color: #aa8453;
}

.nd-share-btn--facebook:hover {
  background: #1877f2;
  color: #fff;
  border-color: #1877f2;
}

.nd-share-btn--twitter:hover {
  background: #1da1f2;
  color: #fff;
  border-color: #1da1f2;
}

.nd-share-btn--linkedin:hover {
  background: #0a66c2;
  color: #fff;
  border-color: #0a66c2;
}

.nd-share-btn--copy:hover {
  background: #4a4a4a;
  color: #fff;
  border-color: #4a4a4a;
}

/* ─── Date Details (before footer) ─── */
.nd-date-details {
  display: flex;
  flex-wrap: wrap;
  gap: 10px 22px;
  padding: 16px 0;
  justify-content: flex-end;
  color: #7a7168;
  font-size: 13px;
}

.nd-date-details span {
  display: inline-flex;
  align-items: center;
  gap: 6px;
}

.nd-date-details i {
  color: #aa8453;
  font-size: 12px;
}

/* ─── Author Box ─── */
.nd-author-box {
  display: flex;
  gap: 20px;
  margin-top: 28px;
  padding: 24px;
  background: #f8f5f0;
  border: 1px solid #e0d8cc;
}

.nd-author-avatar {
  flex: 0 0 70px;
  width: 70px;
  height: 70px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  background: #aa8453;
  color: #fff;
  font-size: 28px;
  border-radius: 50%;
}

.nd-author-info {
  min-width: 0;
}

.nd-author-name {
  margin: 0 0 8px;
  font-family: 'Gilda Display', serif;
  font-size: 20px;
  color: #222;
}

.nd-author-bio {
  margin: 0;
  color: #5a5248;
  font-size: 14px;
  line-height: 1.6;
}

/* ─── Post Navigation ─── */
.nd-post-navigation {
  display: flex;
  align-items: center;
  gap: 12px;
  margin-top: 30px;
  padding-top: 16px;
}

/* ─── Sidebar Related ─── */
.nd-related-widget .widget-title h6 {
  margin-bottom: 0;
}

.nd-related-list {
  list-style: none;
  padding: 0;
  margin: 0;
}

.nd-related-list li {
  display: flex;
  gap: 14px;
  padding: 12px 0;
  border-bottom: 1px solid #e8dece;
}

.nd-related-list li:last-child {
  border-bottom: 0;
}

.nd-related-list .thum {
  flex: 0 0 80px;
  width: 80px;
  height: 60px;
  background: #eeeae4;
}

.nd-related-list .thum img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.nd-related-link {
  display: flex;
  min-width: 0;
  flex-direction: column;
  gap: 4px;
  text-decoration: none;
}

.nd-related-title {
  display: -webkit-box;
  overflow: hidden;
  color: #222;
  font-family: 'Gilda Display', serif;
  font-size: 15px;
  line-height: 1.35;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 2;
  transition: color 0.2s ease;
}

.nd-related-link:hover .nd-related-title {
  color: #aa8453;
}

.nd-related-date {
  color: #8a8177;
  font-family: 'Barlow', sans-serif;
  font-size: 12px;
}

.nd-related-empty {
  margin: 0;
  padding: 14px 0;
  color: #8a8177;
  font-size: 14px;
}

.nd-sidebar-tags {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.nd-sidebar-tags li {
  float: none;
  padding: 0;
  border: 0;
  margin: 0 !important;
  background: transparent;
}

.nd-sidebar-tag-btn {
  display: block;
  padding: 6px 12px;
  border: 1px solid #e0d8cc;
  background: #f8f5f0;
  color: #5a5248;
  font-family: inherit;
  font-size: 13px;
  cursor: pointer;
  transition:
    border-color 0.2s ease,
    background-color 0.2s ease,
    color 0.2s ease;
}

.nd-sidebar-tag-btn:hover {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

/* ─── Back to Top ─── */
.nd-back-to-top {
  position: fixed;
  right: 24px;
  bottom: 30px;
  z-index: 999;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  width: 44px;
  height: 44px;
  padding: 0;
  border: 1px solid #aa8453;
  background: rgba(255, 255, 255, 0.92);
  color: #aa8453;
  font-size: 18px;
  cursor: pointer;
  transition:
    background-color 0.25s ease,
    color 0.25s ease,
    transform 0.25s ease,
    box-shadow 0.25s ease;
  box-shadow: 0 4px 14px rgba(53, 42, 29, 0.1);
}

.nd-back-to-top:hover {
  background: #aa8453;
  color: #fff;
  transform: translateY(-3px);
  box-shadow: 0 8px 18px rgba(170, 132, 83, 0.25);
}

.nd-backtop-enter-active,
.nd-backtop-leave-active {
  transition:
    opacity 0.25s ease,
    transform 0.25s ease;
}

.nd-backtop-enter-from,
.nd-backtop-leave-to {
  opacity: 0;
  transform: translateY(12px);
}

/* ─── Focus & Accessibility ─── */
.nd-breadcrumb-category:focus-visible,
.nd-category-btn:focus-visible,
.nd-share-btn:focus-visible,
.nd-btn:focus-visible,
.nd-back-to-top:focus-visible,
.nd-sidebar-tag-btn:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 3px;
}

/* ─── Responsive ─── */
@media screen and (max-width: 991px) {
  .nd-banner-caption h1 {
    font-size: 38px;
  }

  .nd-banner {
    min-height: 420px;
  }

  .nd-author-box {
    flex-direction: column;
    align-items: center;
    text-align: center;
  }

  .nd-category-section,
  .nd-share-section {
    flex-direction: column;
    gap: 8px;
  }
}

@media screen and (max-width: 767px) {
  .nd-banner-caption h1 {
    font-size: 30px;
  }

  .nd-banner {
    min-height: 360px;
  }

  .nd-banner-meta {
    flex-direction: column;
    align-items: flex-start;
    gap: 6px;
  }

  .nd-lead {
    padding: 16px 18px;
    font-size: 16px;
  }

  .nd-article-body {
    font-size: 15px;
  }

  .nd-article-body h2 {
    font-size: 24px;
  }

  .nd-article-body h3 {
    font-size: 20px;
  }

  .nd-article-body blockquote {
    padding: 16px 18px 16px 32px;
    font-size: 16px;
  }

  .nd-date-details {
    flex-direction: column;
    gap: 6px;
  }

  .nd-author-box {
    padding: 18px;
  }
}

@media screen and (max-width: 575px) {
  .nd-banner-caption h1 {
    font-size: 26px;
  }

  .nd-banner {
    min-height: 320px;
  }

  .nd-error-state {
    padding: 50px 24px;
    min-height: 320px;
  }

  .nd-error-state h3 {
    font-size: 22px;
  }

  .nd-error-actions {
    flex-direction: column;
    width: 100%;
  }

  .nd-error-actions .nd-btn {
    width: 100%;
    justify-content: center;
  }

  .nd-share-buttons {
    gap: 6px;
  }

  .nd-share-btn {
    width: 36px;
    height: 36px;
    font-size: 14px;
  }

  .nd-back-to-top {
    right: 16px;
    bottom: 20px;
    width: 38px;
    height: 38px;
    font-size: 16px;
  }
}
</style>
