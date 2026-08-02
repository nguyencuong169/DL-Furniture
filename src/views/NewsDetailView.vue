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
  getNewsTags,
  recordNewsView
} from '../api/newsSidebarClient'
import { resolveNewsImage, splitNewsTags } from '../utils/news'
import type { ArchiveDto, CategoryDto } from '../api/newsSidebarClient'
import NewsArchives from '../components/NewsArchives.vue'
import NewsComponent from '../template/10_NewsComponent.vue'
import BookingFormComponent from '../template/11_BookingFormComponent.vue'

const ROUTE_NAME_NEWS = 'news'
const DEFAULT_RELATED_COUNT = 6

const route = useRoute()
const router = useRouter()
const item = ref<NewsItem | null>(null)
const related = ref<NewsItem[]>([])
const categories = ref<CategoryDto[]>([])
const archives = ref<ArchiveDto[]>([])
const sidebarTags = ref<{ name: string; count: number }[]>([])
const loading = ref(true)
const errorMessage = ref('')
const readProgress = ref(0)
const showBackToTop = ref(false)
const articleElement = ref<HTMLElement | null>(null)
const newsReturnTo = ref('/tin-tuc')
const defaultDocumentTitle = typeof document === 'undefined' ? 'D&L Furniture' : document.title
const NEWS_SEO_MARKER = 'data-dl-news-seo'

let requestId = 0
let scrollListenerAttached = false
const trackedArticleIds = new Set<number>()
const trackingArticleIds = new Set<number>()
const newsViewSessionKey = (id: number) => `dl-furniture:news:viewed:${id}`

// ───── Track view ─────

const trackArticleViewOnce = async (id: number) => {
  if (trackedArticleIds.has(id) || trackingArticleIds.has(id)) return

  const sessionKey = newsViewSessionKey(id)

  try {
    if (sessionStorage.getItem(sessionKey)) {
      trackedArticleIds.add(id)
      return
    }
  } catch {
    // Keep an in-memory fallback when sessionStorage is unavailable.
  }

  trackingArticleIds.add(id)

  try {
    const response = await recordNewsView(id)

    if (item.value?.id === id) item.value.viewCount = response.viewCount
    trackedArticleIds.add(id)

    try {
      sessionStorage.setItem(sessionKey, '1')
    } catch {
      // The in-memory set still prevents duplicate requests for this page session.
    }
  } catch (error) {
    console.warn('Failed to record news article view', error)
  } finally {
    trackingArticleIds.delete(id)
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
  const date = item.value.createdDate ?? item.value.updatedDate
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
  const candidate = (item.value?.updatedUser || item.value?.createdUser || '').trim()
  return /^(?:content-seed|admin|system)$/i.test(candidate)
    ? 'D&L Furniture'
    : candidate || 'D&L Furniture'
})

const bannerStyle = computed(() => ({
  backgroundImage: `url(${resolveNewsImage(item.value?.newsImage, item.value?.id ?? 0)})`
}))

const shareUrl = computed(() => {
  const currentPath = route.fullPath
  if (typeof window === 'undefined') return currentPath
  return new URL(currentPath, window.location.origin).href
})

const removeNewsSeo = () => {
  if (typeof document === 'undefined') return
  document.head.querySelectorAll(`[${NEWS_SEO_MARKER}]`).forEach((element) => element.remove())
}

const appendNewsMeta = (attribute: 'name' | 'property', key: string, content: string) => {
  const meta = document.createElement('meta')
  meta.setAttribute(attribute, key)
  meta.setAttribute('content', content)
  meta.setAttribute(NEWS_SEO_MARKER, '')
  document.head.appendChild(meta)
}

const cleanSeoText = (value: string) => {
  const template = document.createElement('template')
  template.innerHTML = value
  return (template.content.textContent || '').replace(/\s+/g, ' ').trim()
}

const createSeoDescription = (current: NewsItem) => {
  const source = cleanSeoText(current.summary || current.content || '')
  if (source.length <= 160) return source
  return `${source.slice(0, 157).trimEnd()}…`
}

const toIsoDate = (value?: Date) => {
  if (!value) return undefined
  const date = dayjs(value)
  return date.isValid() ? date.toISOString() : undefined
}

const updateNewsSeo = (current: NewsItem | null, section: string) => {
  if (typeof document === 'undefined' || typeof window === 'undefined') return

  removeNewsSeo()
  if (!current) {
    document.title = defaultDocumentTitle
    return
  }

  const title = (current.titles || 'Tin tức nội thất').trim()
  const pageTitle = `${title} | D&L Furniture`
  const description = createSeoDescription(current)
  const canonicalUrl = new URL(route.path, window.location.origin).href
  const imageUrl = new URL(resolveNewsImage(current.newsImage, current.id), window.location.origin)
    .href
  const publishedTime = toIsoDate(current.createdDate)
  const modifiedTime = toIsoDate(current.updatedDate) || publishedTime

  document.title = pageTitle
  appendNewsMeta('name', 'description', description)
  appendNewsMeta('name', 'robots', 'index, follow, max-image-preview:large')
  appendNewsMeta('property', 'og:type', 'article')
  appendNewsMeta('property', 'og:locale', 'vi_VN')
  appendNewsMeta('property', 'og:site_name', 'D&L Furniture')
  appendNewsMeta('property', 'og:title', pageTitle)
  appendNewsMeta('property', 'og:description', description)
  appendNewsMeta('property', 'og:url', canonicalUrl)
  appendNewsMeta('property', 'og:image', imageUrl)
  appendNewsMeta('name', 'twitter:card', 'summary_large_image')
  appendNewsMeta('name', 'twitter:title', pageTitle)
  appendNewsMeta('name', 'twitter:description', description)
  appendNewsMeta('name', 'twitter:image', imageUrl)
  if (publishedTime) appendNewsMeta('property', 'article:published_time', publishedTime)
  if (modifiedTime) appendNewsMeta('property', 'article:modified_time', modifiedTime)

  const canonical = document.createElement('link')
  canonical.rel = 'canonical'
  canonical.href = canonicalUrl
  canonical.setAttribute(NEWS_SEO_MARKER, '')
  document.head.appendChild(canonical)

  const structuredData = document.createElement('script')
  structuredData.type = 'application/ld+json'
  structuredData.setAttribute(NEWS_SEO_MARKER, '')
  structuredData.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'Article',
    headline: title,
    description,
    image: [imageUrl],
    datePublished: publishedTime,
    dateModified: modifiedTime,
    articleSection: section,
    keywords: splitNewsTags(current.tags).join(', '),
    author: {
      '@type': 'Organization',
      name: authorName.value
    },
    publisher: {
      '@type': 'Organization',
      name: 'D&L Furniture'
    },
    mainEntityOfPage: {
      '@type': 'WebPage',
      '@id': canonicalUrl
    }
  })
  document.head.appendChild(structuredData)
}

const isSafeMediaUrl = (value: string, embed = false) => {
  try {
    const url = new URL(value, window.location.origin)
    if (!['http:', 'https:'].includes(url.protocol)) return false
    if (!embed || url.origin === window.location.origin) return true

    return ['www.youtube.com', 'www.youtube-nocookie.com', 'player.vimeo.com'].includes(
      url.hostname
    )
  } catch {
    return false
  }
}

const sanitizeArticleHtml = (content: string) => {
  if (typeof document === 'undefined') return ''

  const template = document.createElement('template')
  template.innerHTML = content
  template.content
    .querySelectorAll('script, style, object, embed, form, input, button, textarea, select')
    .forEach((element) => element.remove())

  const allowedAttributes: Record<string, Set<string>> = {
    A: new Set(['href', 'target', 'title', 'class']),
    IMG: new Set(['src', 'alt', 'title', 'loading', 'width', 'height', 'class']),
    VIDEO: new Set([
      'src',
      'poster',
      'controls',
      'autoplay',
      'muted',
      'loop',
      'playsinline',
      'preload',
      'class'
    ]),
    SOURCE: new Set(['src', 'type']),
    IFRAME: new Set([
      'src',
      'title',
      'allow',
      'allowfullscreen',
      'loading',
      'referrerpolicy',
      'class'
    ])
  }
  const globalAttributes = new Set(['class', 'title'])

  template.content.querySelectorAll('*').forEach((element) => {
    Array.from(element.attributes).forEach((attribute) => {
      const allowedForElement = allowedAttributes[element.tagName]
      if (!globalAttributes.has(attribute.name) && !allowedForElement?.has(attribute.name)) {
        element.removeAttribute(attribute.name)
      }
    })

    if (element instanceof HTMLAnchorElement) {
      if (!isSafeMediaUrl(element.href)) element.removeAttribute('href')
      else {
        element.rel = 'noopener noreferrer'
        if (element.target !== '_blank') element.removeAttribute('target')
      }
    }

    if (element instanceof HTMLImageElement && !isSafeMediaUrl(element.src)) {
      element.removeAttribute('src')
    }

    if (element instanceof HTMLVideoElement) {
      if (element.src && !isSafeMediaUrl(element.src)) element.removeAttribute('src')
      element.setAttribute('controls', '')
      element.setAttribute('playsinline', '')
    }

    if (element instanceof HTMLSourceElement && !isSafeMediaUrl(element.src)) {
      element.remove()
    }

    if (element instanceof HTMLIFrameElement && !isSafeMediaUrl(element.src, true)) {
      element.remove()
    }
  })

  return template.innerHTML
}

const articleContent = computed(() => {
  const content = (item.value?.content || '').trim()
  if (!content) return ''
  if (/<\/?[a-z][\s\S]*>/i.test(content)) return sanitizeArticleHtml(content)

  const escapedContent = content
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;')
    .replaceAll("'", '&#039;')
  const sentences = escapedContent.split(/(?<=[.!?])\s+/).filter(Boolean)

  if (sentences.length <= 2) return `<p>${escapedContent}</p>`

  return Array.from({ length: Math.ceil(sentences.length / 2) }, (_, index) => {
    return `<p>${sentences.slice(index * 2, index * 2 + 2).join(' ')}</p>`
  }).join('')
})

const categoriesTotal = computed(() => {
  return categories.value.reduce(
    (total, category) => total + ((category as any).publishedCount ?? 0),
    0
  )
})

const readingTime = computed(() => {
  const source = `${item.value?.summary ?? ''} ${item.value?.content ?? ''}`
    .replace(/<[^>]+>/g, ' ')
    .trim()
  const words = source ? source.split(/\s+/).length : 0
  return Math.max(1, Math.ceil(words / 220))
})

// ───── Load article ─────

const loadRelatedNews = async (id: number, currentRequest: number) => {
  const relatedItems = await getNewsRelated(id, DEFAULT_RELATED_COUNT).catch(() => [])

  if (currentRequest !== requestId || item.value?.id !== id) return

  related.value = relatedItems
  window.requestAnimationFrame(handleScroll)
}

const loadArticle = async (id: number) => {
  const currentRequest = ++requestId
  loading.value = true
  errorMessage.value = ''
  related.value = []

  try {
    const [article, categoryItems, archiveItems, tagItems] = await Promise.all([
      getNewsById(id),
      getNewsCategories().catch(() => []),
      getNewsArchives().catch(() => []),
      getNewsTags().catch(() => [])
    ])

    if (currentRequest !== requestId) return

    item.value = article
    void trackArticleViewOnce(article.id)
    categories.value = categoryItems
    archives.value = archiveItems
    sidebarTags.value = tagItems.slice(0, 20)
    void loadRelatedNews(id, currentRequest)
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
  } catch {
    // Fallback
    const textarea = document.createElement('textarea')
    textarea.value = shareUrl.value
    document.body.appendChild(textarea)
    textarea.select()
    document.execCommand('copy')
    document.body.removeChild(textarea)
  }
  showToast('Đã sao chép đường dẫn bài viết!')
}

let toastTimer: ReturnType<typeof setTimeout> | null = null

const showToast = (message: string) => {
  const existing = document.querySelector('.nd-toast')
  if (existing) existing.remove()
  if (toastTimer) clearTimeout(toastTimer)

  const toast = document.createElement('div')
  toast.className = 'nd-toast'
  toast.textContent = message
  toast.setAttribute('role', 'status')
  toast.setAttribute('aria-live', 'polite')
  Object.assign(toast.style, {
    position: 'fixed',
    bottom: '30px',
    left: '50%',
    transform: 'translateX(-50%)',
    zIndex: '99999',
    background: '#222',
    color: '#fff',
    padding: '12px 28px',
    fontFamily: "'Barlow', sans-serif",
    fontSize: '14px',
    lineHeight: '1.4',
    borderRadius: '0',
    boxShadow: '0 6px 24px rgba(0,0,0,0.18)',
    opacity: '0',
    transition: 'opacity 0.3s ease',
    pointerEvents: 'none'
  })
  document.body.appendChild(toast)
  requestAnimationFrame(() => {
    toast.style.opacity = '1'
  })
  toastTimer = setTimeout(() => {
    toast.style.opacity = '0'
    setTimeout(() => toast.remove(), 300)
    toastTimer = null
  }, 2200)
}

// ───── Reading progress ─────

const handleScroll = () => {
  const scrollTop = window.scrollY
  const article = articleElement.value
  let articleBottom = 0

  if (!article) {
    readProgress.value = 0
  } else {
    const articleTop = article.getBoundingClientRect().top + scrollTop
    articleBottom = articleTop + article.offsetHeight
    const readableDistance = article.offsetHeight - window.innerHeight

    if (readableDistance <= 0) {
      readProgress.value = scrollTop >= articleTop ? 100 : 0
    } else {
      const progress = ((scrollTop - articleTop) / readableDistance) * 100
      readProgress.value = Math.round(Math.min(Math.max(progress, 0), 100))
    }
  }

  showBackToTop.value =
    Boolean(article) && scrollTop > 500 && scrollTop + window.innerHeight * 0.35 < articleBottom
}

const scrollToTop = () => {
  window.scrollTo({ top: 0, behavior: 'smooth' })
}

// ───── Navigation ─────

const isSafeNewsReturnPath = (value: unknown): value is string => {
  return typeof value === 'string' && /^\/tin-tuc(?:[?#]|$)/.test(value)
}

const getSafeReferrerPath = () => {
  if (typeof document === 'undefined' || typeof window === 'undefined') return null
  try {
    const url = new URL(document.referrer)
    const candidate = url.pathname + url.search
    if (url.origin === window.location.origin && isSafeNewsReturnPath(candidate)) {
      return candidate
    }
  } catch {
    // Invalid or cross-origin referrer — fall back to the default.
  }
  return null
}

const goBackToNews = () => {
  const browserBackPath = window.history.state?.back

  if (browserBackPath === newsReturnTo.value) {
    router.back()
    return
  }

  void router.push(newsReturnTo.value)
}

const openArchive = (year: number, month: number) => {
  void router.push({ name: ROUTE_NAME_NEWS, query: { year, month } })
}

const openLatestNews = () => {
  void router.push({ name: ROUTE_NAME_NEWS })
}

const goToCategoryNews = (categoryId = item.value?.newsCategoryId) => {
  if (categoryId) {
    void router.push({ name: ROUTE_NAME_NEWS, query: { category: categoryId } })
  }
}

const goToTagNews = (tag: string) => {
  void router.push({ name: ROUTE_NAME_NEWS, query: { tag } })
}

// ───── Lifecycle ─────

onMounted(() => {
  const returnPath = window.history.state?.newsReturnTo
  if (isSafeNewsReturnPath(returnPath)) {
    newsReturnTo.value = returnPath
  } else {
    const referrerPath = getSafeReferrerPath()
    if (referrerPath) newsReturnTo.value = referrerPath
  }

  document.body.classList.add('news-detail-active')
  window.addEventListener('scroll', handleScroll, { passive: true })
  window.addEventListener('resize', handleScroll, { passive: true })
  scrollListenerAttached = true
  handleScroll()
})

onBeforeUnmount(() => {
  document.body.classList.remove('news-detail-active')

  if (scrollListenerAttached) {
    window.removeEventListener('scroll', handleScroll)
    window.removeEventListener('resize', handleScroll)
    scrollListenerAttached = false
  }

  document.title = defaultDocumentTitle
  removeNewsSeo()
})

watch(
  () => route.params.id,
  (value) => {
    const id = Number(value)
    readProgress.value = 0
    if (Number.isInteger(id) && id > 0) loadArticle(id)
    else {
      loading.value = false
      item.value = null
      errorMessage.value = 'Bài viết không hợp lệ.'
    }
  },
  { immediate: true }
)

watch([item, categoryName], ([current, section]) => updateNewsSeo(current, section), {
  immediate: true
})
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
            <button type="button" class="nd-btn nd-btn--outline" @click="goBackToNews">
              <i class="ti-arrow-left"></i> Quay lại tin tức
            </button>
          </div>
        </div>
      </div>
    </section>

    <!-- ───── Article Content ───── -->
    <template v-else>
      <!-- Banner Header -->
      <div
        class="banner-header nd-banner section-padding valign bg-img bg-fixed"
        data-overlay-dark="5"
        :style="bannerStyle"
      >
        <div class="container">
          <div class="row">
            <div class="col-md-12 text-left caption mt-90 nd-banner-caption">
              <div class="nd-breadcrumb">
                <button
                  type="button"
                  class="nd-breadcrumb-back"
                  aria-label="Quay lại trang tin tức"
                  @click="goBackToNews"
                >
                  Tin tức
                </button>
                <span class="nd-breadcrumb-sep" aria-hidden="true">/</span>
                <button
                  type="button"
                  class="nd-breadcrumb-category"
                  aria-label="Xem các bài viết trong chuyên mục"
                  @click="goToCategoryNews()"
                >
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
                <span class="nd-meta-item">
                  <i class="ti-time"></i>
                  {{ readingTime }} phút đọc
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
            <article ref="articleElement" class="col-md-8">
              <!-- Summary / Lead -->
              <div v-if="item.summary" class="nd-lead">
                <span class="nd-lead-label">Tóm tắt biên tập</span>
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
                    <button type="button" class="nd-category-btn" @click="goToCategoryNews()">
                      <i class="ti-folder"></i> {{ categoryName }}
                    </button>
                  </div>

                  <!-- Share (right) -->
                  <div class="nd-share-section">
                    <div class="nd-share-buttons">
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--facebook"
                        aria-label="Chia sẻ bài viết lên Facebook"
                        title="Chia sẻ lên Facebook"
                        @click="shareOnFacebook"
                      >
                        <i class="ti-facebook" aria-hidden="true"></i>
                      </button>
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--twitter"
                        aria-label="Chia sẻ bài viết lên Twitter"
                        title="Chia sẻ lên Twitter"
                        @click="shareOnTwitter"
                      >
                        <i class="ti-twitter-alt" aria-hidden="true"></i>
                      </button>
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--linkedin"
                        aria-label="Chia sẻ bài viết lên LinkedIn"
                        title="Chia sẻ lên LinkedIn"
                        @click="shareOnLinkedIn"
                      >
                        <i class="ti-linkedin" aria-hidden="true"></i>
                      </button>
                      <button
                        type="button"
                        class="nd-share-btn nd-share-btn--copy"
                        aria-label="Sao chép đường dẫn bài viết"
                        title="Sao chép đường dẫn"
                        @click="copyShareLink"
                      >
                        <i class="ti-link" aria-hidden="true"></i>
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
                  <h2 class="nd-author-name">{{ authorName }}</h2>
                  <p class="nd-author-bio">
                    Bài viết được đăng tải bởi đội ngũ <strong>D&amp;L Furniture</strong>, chuyên
                    cung cấp những thông tin hữu ích về nội thất, thiết kế không gian sống và xu
                    hướng trang trí nhà cửa.
                  </p>
                </div>
              </div>

              <!-- Navigation Buttons -->
              <div class="nd-post-navigation">
                <button type="button" class="nd-btn nd-btn--outline" @click="goBackToNews">
                  <i class="ti-arrow-left"></i> Quay lại tin tức
                </button>
              </div>
            </article>

            <!-- ─── Right Column: Sidebar ─── -->
            <div class="col-md-4">
              <div class="news2-sidebar row">
                <!-- Categories -->
                <div class="col-md-12">
                  <div class="widget news-category-widget">
                    <div class="widget-title">
                      <h2 class="nd-sidebar-heading">Chuyên mục</h2>
                      <p v-if="categories.length">{{ categoriesTotal }} bài viết</p>
                    </div>
                    <ul class="news-category-list">
                      <li>
                        <button type="button" class="news-category-link" @click="openLatestNews">
                          <span class="news-category-name">
                            <i class="ti-layout-grid2" aria-hidden="true"></i>
                            Tất cả bài viết
                          </span>
                        </button>
                      </li>
                      <li v-for="category in categories" :key="category.id">
                        <button
                          type="button"
                          class="news-category-link"
                          :class="{ active: item?.newsCategoryId === category.id }"
                          :aria-pressed="item?.newsCategoryId === category.id"
                          @click="goToCategoryNews(category.id)"
                        >
                          <span class="news-category-name">
                            <i class="ti-angle-right" aria-hidden="true"></i>
                            {{ category.name }}
                          </span>
                          <span class="news-category-count">{{
                            (category as any).publishedCount ?? 0
                          }}</span>
                        </button>
                      </li>
                    </ul>
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
                <div v-if="sidebarTags.length" class="col-md-12">
                  <div class="widget">
                    <div class="widget-title">
                      <h2 class="nd-sidebar-heading">Thẻ nội dung</h2>
                    </div>
                    <ul class="tags nd-sidebar-tags">
                      <li v-for="tag in sidebarTags" :key="tag.name">
                        <button
                          type="button"
                          class="nd-sidebar-tag-btn"
                          @click="goToTagNews(tag.name)"
                        >
                          {{ tag.name }}
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

      <BookingFormComponent :background-image="resolveNewsImage(item.newsImage, item.id)" />
      <NewsComponent
        v-if="related.length"
        :items="related"
        :loop="false"
        title="Tin tức liên quan"
      />
    </template>

    <Transition name="nd-backtop">
      <button
        v-if="showBackToTop"
        type="button"
        class="nd-back-to-top"
        aria-label="Quay lên đầu bài viết"
        @click="scrollToTop"
      >
        <i class="ti-arrow-up" aria-hidden="true"></i>
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
  /* padding: 0; */
  background-position: center;
  background-size: cover;
  height: 60vh;
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
.nd-breadcrumb-back,
.nd-breadcrumb-category {
  /* color: rgba(255, 255, 255, 0.72); */
  text-decoration: none;
  transition: color 0.2s ease;
  color: #aa8453;
  font-weight: 500;
  font-size: 15px;
  letter-spacing: 6px;
}

.nd-breadcrumb a:hover,
.nd-breadcrumb-back:hover,
.nd-breadcrumb-category:hover {
  color: #d4a96a;
}

.nd-breadcrumb-back,
.nd-breadcrumb-category {
  cursor: pointer;
  text-transform: inherit;
}

.nd-breadcrumb-sep {
  color: rgba(255, 255, 255, 0.35);
}

.nd-banner-caption h1 {
  max-width: 980px;
  color: #fff;
  font-size: clamp(42px, 4.1vw, 52px);
  line-height: 1.25;
  margin-bottom: 20px;
  /* text-wrap: balance; */
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

/* ─── Lead / Summary ─── */
.nd-lead {
  position: relative;
  margin-bottom: 32px;
  padding: 24px 28px 25px;
  border-top: 1px solid rgba(170, 132, 83, 0.42);
  border-bottom: 1px solid rgba(170, 132, 83, 0.42);
  background: #f8f5f0;
  color: #3a342c;
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  line-height: 1.65;
}

.nd-lead-label {
  display: block;
  margin-bottom: 8px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-style: normal;
  letter-spacing: 2px;
  text-transform: uppercase;
}

/* ─── Article Body (v-html content) ─── */
.nd-article-body {
  color: #3a342c;
  font-family: 'Barlow', sans-serif;
  font-size: 17px;
  line-height: 1.9;
  word-wrap: break-word;
}

.nd-article-body :deep(h1),
.nd-article-body :deep(h2),
.nd-article-body :deep(h3),
.nd-article-body :deep(h4),
.nd-article-body :deep(h5),
.nd-article-body :deep(h6) {
  margin-top: 1.6em;
  margin-bottom: 0.7em;
  color: #1a1816;
  font-family: 'Gilda Display', serif;
  font-weight: 400;
  line-height: 1.3;
}

.nd-article-body :deep(h2) {
  font-size: 32px;
}

.nd-article-body :deep(h3) {
  font-size: 25px;
}

.nd-article-body :deep(h4) {
  font-size: 20px;
}

.nd-article-body :deep(p) {
  margin-bottom: 1.35em;
}

.nd-article-body :deep(p:first-child::first-letter) {
  float: left;
  margin: 8px 10px 0 0;
  color: #aa8453;
  font-family: 'Gilda Display', serif;
  font-size: 58px;
  line-height: 0.72;
}

.nd-article-body :deep(a) {
  color: #aa8453;
  text-decoration: underline;
  transition: color 0.2s ease;
}

.nd-article-body :deep(a:hover) {
  color: #7f603b;
}

.nd-article-body :deep(blockquote) {
  position: relative;
  margin: 2.2em 0;
  padding: 32px 34px 32px 56px;
  border: 0;
  background: #1f1c18;
  color: #f5efe7;
  font-family: 'Gilda Display', serif;
  font-size: 23px;
  font-style: italic;
  line-height: 1.55;
}

.nd-article-body :deep(blockquote)::before {
  position: absolute;
  top: 21px;
  left: 22px;
  content: '\201C';
  color: #aa8453;
  font-family: 'Gilda Display', serif;
  font-size: 44px;
  line-height: 1;
}

.nd-article-body :deep(blockquote p) {
  margin-bottom: 0;
}

.nd-article-body :deep(ul),
.nd-article-body :deep(ol) {
  margin-bottom: 1.2em;
  padding-left: 1.5em;
}

.nd-article-body :deep(li) {
  margin-bottom: 0.45em;
}

.nd-article-body :deep(img) {
  display: block;
  width: 100%;
  max-width: 100%;
  height: auto;
  margin: 2em auto;
  border-radius: 0;
}

.nd-article-body :deep(figure) {
  margin: 2.2em 0;
  text-align: center;
}

.nd-article-body :deep(figure img) {
  margin-bottom: 0;
}

.nd-article-body :deep(figcaption) {
  margin-top: 10px;
  color: #7a7168;
  font-size: 13px;
  font-style: italic;
}

.nd-article-body :deep(video),
.nd-article-body :deep(iframe) {
  display: block;
  width: 100%;
  margin: 2.2em 0;
  border: 0;
  background: #15130f;
  aspect-ratio: 16 / 9;
}

.nd-article-body :deep(video) {
  height: auto;
}

.nd-article-body :deep(.news-media-gallery) {
  display: grid;
  overflow: visible;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
  margin: 2.5em 0;
  padding: 0;
}

.nd-article-body :deep(.news-media-gallery > *) {
  min-width: 0;
  margin: 0;
  scroll-snap-align: start;
}

.nd-article-body :deep(.news-media-gallery img) {
  width: 100%;
  aspect-ratio: 8 / 5;
  height: auto;
  margin: 0;
  object-fit: cover;
}

.nd-article-body :deep(.news-story-grid) {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 18px;
  margin: 2.4em 0;
}

.nd-article-body :deep(.news-story-grid figure) {
  margin: 0;
}

.nd-article-body :deep(.news-story-grid figure:first-child:last-child) {
  grid-column: 1 / -1;
}

.nd-article-body :deep(.news-project-facts) {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 1px;
  margin: 0 0 2.5em;
  border: 1px solid #ded5c8;
  background: #ded5c8;
}

.nd-article-body :deep(.news-project-facts > div) {
  padding: 20px 22px;
  background: #f8f5f0;
}

.nd-article-body :deep(.news-project-facts span) {
  display: block;
  margin-bottom: 5px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.nd-article-body :deep(.news-project-facts strong) {
  display: block;
  color: #26211c;
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  font-weight: 400;
  line-height: 1.4;
}

.nd-article-body :deep(.news-media-feature) {
  margin: 2.6em 0;
}

.nd-article-body :deep(.news-media-feature img) {
  height: clamp(360px, 44vw, 560px);
  margin: 0;
  object-fit: cover;
}

.nd-article-body :deep(.news-media-feature--detail img) {
  height: clamp(320px, 40vw, 500px);
}

.nd-article-body :deep(.news-editor-note) {
  margin: 2em 0 2.6em;
  padding: 24px 28px;
  border-left: 3px solid #aa8453;
  background: #f3eee7;
}

.nd-article-body :deep(.news-editor-note span),
.nd-article-body :deep(.news-craft-eyebrow) {
  display: block;
  margin-bottom: 8px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.nd-article-body :deep(.news-editor-note p) {
  margin: 0;
  color: #40382f;
  font-family: 'Gilda Display', serif;
  font-size: 20px;
  line-height: 1.6;
}

.nd-article-body :deep(.news-design-principles) {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 1px;
  margin: 2.2em 0 2.8em;
  border: 1px solid #ded5c8;
  background: #ded5c8;
}

.nd-article-body :deep(.news-design-principles > div) {
  padding: 25px 22px;
  background: #f8f5f0;
}

.nd-article-body :deep(.news-design-principles > div > span) {
  display: block;
  margin-bottom: 18px;
  color: #aa8453;
  font-family: 'Gilda Display', serif;
  font-size: 30px;
  line-height: 1;
}

.nd-article-body :deep(.news-design-principles h3) {
  margin: 0 0 10px;
  font-size: 21px;
}

.nd-article-body :deep(.news-design-principles p) {
  margin: 0;
  color: #665c51;
  font-size: 14px;
  line-height: 1.65;
}

.nd-article-body :deep(.news-process-list) {
  display: grid;
  gap: 0;
  padding: 0;
  margin: 2.1em 0 2.8em;
  list-style: none;
  counter-reset: news-process;
}

.nd-article-body :deep(.news-process-list li) {
  display: grid;
  grid-template-columns: 42px minmax(150px, 0.55fr) minmax(0, 1fr);
  gap: 16px;
  align-items: baseline;
  padding: 18px 0;
  margin: 0;
  border-bottom: 1px solid #ddd4c8;
  counter-increment: news-process;
}

.nd-article-body :deep(.news-process-list li)::before {
  color: #aa8453;
  content: '0' counter(news-process);
  font-family: 'Gilda Display', serif;
  font-size: 20px;
}

.nd-article-body :deep(.news-process-list strong) {
  color: #26211c;
  font-family: 'Gilda Display', serif;
  font-size: 18px;
  font-weight: 400;
}

.nd-article-body :deep(.news-process-list span) {
  color: #665c51;
  font-size: 14px;
  line-height: 1.65;
}

.nd-article-body :deep(.news-care-list) {
  padding: 20px 24px 10px 46px;
  border-top: 1px solid #ded5c8;
  border-bottom: 1px solid #ded5c8;
  background: #fbf9f6;
}

.nd-article-body :deep(.news-care-list li) {
  padding-left: 4px;
  margin-bottom: 12px;
}

.nd-article-body :deep(.news-craft-feature) {
  display: grid;
  grid-template-columns: minmax(0, 0.9fr) minmax(0, 1.1fr);
  gap: 30px;
  align-items: stretch;
  margin: 3em 0;
  padding: 34px;
  background: #1f1c18;
  color: #f5efe7;
}

.nd-article-body :deep(.news-craft-feature__copy) {
  align-self: center;
}

.nd-article-body :deep(.news-craft-feature h2) {
  margin: 0 0 14px;
  color: #fff;
}

.nd-article-body :deep(.news-craft-feature p) {
  margin-bottom: 20px;
  color: rgba(255, 255, 255, 0.7);
}

.nd-article-body :deep(.news-craft-feature ul) {
  padding-left: 19px;
  margin: 0;
  color: rgba(255, 255, 255, 0.82);
}

.nd-article-body :deep(.news-craft-feature li) {
  margin-bottom: 8px;
}

.nd-article-body :deep(.news-craft-feature figure) {
  margin: 0;
}

.nd-article-body :deep(.news-craft-feature img) {
  width: 100%;
  height: 100%;
  min-height: 360px;
  margin: 0;
  object-fit: cover;
}

.nd-article-body :deep(.news-craft-feature figcaption) {
  color: rgba(255, 255, 255, 0.58);
}

.nd-article-body :deep(table) {
  width: 100%;
  margin: 1.4em 0;
  border-collapse: collapse;
}

.nd-article-body :deep(th),
.nd-article-body :deep(td) {
  padding: 10px 14px;
  border: 1px solid #e0d8cc;
  text-align: left;
}

.nd-article-body :deep(th) {
  background: #f0ece6;
  font-family: 'Barlow Condensed', sans-serif;
  font-weight: 600;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}

.nd-article-body :deep(hr) {
  margin: 1.8em 0;
  border: 0;
  border-top: 1px solid #e0d8cc;
}

.nd-article-body :deep(strong) {
  font-weight: 600;
}

.nd-article-body :deep(code) {
  padding: 2px 6px;
  background: #f0ece6;
  font-family: 'Courier New', monospace;
  font-size: 0.9em;
}

.nd-article-body :deep(pre) {
  overflow-x: auto;
  margin: 1.4em 0;
  padding: 16px 20px;
  background: #1a1816;
  color: #f0ece6;
  font-size: 14px;
  line-height: 1.6;
}

.nd-article-body :deep(pre code) {
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

.nd-sidebar-heading {
  padding: 0;
  margin: 0;
  color: #222;
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  font-weight: 400;
  line-height: 1.3;
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
:global(body.news-detail-active .progress-wrap) {
  display: none !important;
}

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
.nd-breadcrumb-back:focus-visible,
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
    font-size: 16px;
    line-height: 1.85;
  }

  .nd-article-body :deep(h2) {
    font-size: 24px;
  }

  .nd-article-body :deep(h3) {
    font-size: 20px;
  }

  .nd-article-body :deep(blockquote) {
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

  .nd-article-body :deep(.news-story-grid) {
    grid-template-columns: minmax(0, 1fr);
  }

  .nd-article-body :deep(.news-project-facts) {
    grid-template-columns: minmax(0, 1fr);
  }

  .nd-article-body :deep(.news-design-principles) {
    grid-template-columns: minmax(0, 1fr);
  }

  .nd-article-body :deep(.news-process-list li) {
    grid-template-columns: 34px minmax(0, 1fr);
    gap: 8px 12px;
  }

  .nd-article-body :deep(.news-process-list span) {
    grid-column: 2;
  }

  .nd-article-body :deep(.news-craft-feature) {
    grid-template-columns: minmax(0, 1fr);
    gap: 22px;
    padding: 24px 18px;
  }

  .nd-article-body :deep(.news-craft-feature img) {
    height: auto;
    min-height: 0;
    aspect-ratio: 16 / 9;
  }

  .nd-article-body :deep(.news-media-feature img),
  .nd-article-body :deep(.news-media-feature--detail img) {
    height: auto;
  }

  .nd-article-body :deep(.news-media-gallery) {
    overflow-x: auto;
    grid-template-columns: none;
    grid-auto-columns: 88%;
    grid-auto-flow: column;
    gap: 16px;
    padding-bottom: 14px;
    overscroll-behavior-inline: contain;
    scroll-snap-type: inline mandatory;
    scrollbar-color: #aa8453 #eee8df;
    scrollbar-width: thin;
  }
}
</style>
