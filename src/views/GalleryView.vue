<script setup lang="ts">
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue'
import { getFallbackGallery, getGallery } from '../api/galleryClient'
import type {
  GalleryCategory,
  GalleryCounts,
  GalleryItem,
  GalleryMediaType,
  GalleryQuery,
  GalleryResponse
} from '../types/gallery'

const IMAGE_PAGE_SIZE = 10
const VIDEO_PAGE_SIZE = 4

type SectionResult = {
  response: GalleryResponse
  fallback: boolean
}

const imageItems = ref<GalleryItem[]>([])
const videoItems = ref<GalleryItem[]>([])
const categories = ref<GalleryCategory[]>([])
const counts = ref<GalleryCounts>({ all: 0, images: 0, videos: 0 })
const mediaType = ref<GalleryMediaType | 'all'>('all')
const category = ref('all')
const searchDraft = ref('')
const search = ref('')
const imagePage = ref(1)
const videoPage = ref(1)
const imageTotalPages = ref(0)
const videoTotalPages = ref(0)
const imageTotalCount = ref(0)
const videoTotalCount = ref(0)
const totalCount = ref(0)
const loading = ref(false)
const usingFallback = ref(false)
const notice = ref('')
const activeIndex = ref(-1)
const filterSidebarOpen = ref(true)
let originalBodyOverflow = ''
let requestSerial = 0

const items = computed(() => [...imageItems.value, ...videoItems.value])
const activeItem = computed(() =>
  activeIndex.value >= 0 ? items.value[activeIndex.value] : null
)
const isInitialLoading = computed(() => loading.value && items.value.length === 0)
const showImageSection = computed(
  () => mediaType.value !== 'video' && (isInitialLoading.value || imageItems.value.length > 0)
)
const showVideoSection = computed(
  () => mediaType.value !== 'image' && (isInitialLoading.value || videoItems.value.length > 0)
)
const hasMoreImages = computed(() => imagePage.value < imageTotalPages.value)
const hasMoreVideos = computed(() => videoPage.value < videoTotalPages.value)
const canCollapseImages = computed(() => imagePage.value > 1 && !hasMoreImages.value)
const canCollapseVideos = computed(() => videoPage.value > 1 && !hasMoreVideos.value)
const isBodyLocked = computed(() => Boolean(activeItem.value))
const activeFilterCount = computed(
  () => Number(mediaType.value !== 'all') + Number(category.value !== 'all') + Number(Boolean(search.value))
)
const resultLabel = computed(() => {
  if (loading.value && items.value.length === 0) return 'Đang tải bộ sưu tập...'
  if (totalCount.value === 0) return 'Không tìm thấy nội dung phù hợp'
  return `${totalCount.value} tác phẩm trong bộ sưu tập`
})

function imageCardColumn(index: number, total: number) {
  if (total % 5 === 1 && index === total - 1) return 'col-md-12 gallery-item--wide'
  return index % 5 < 3 ? 'col-md-4' : 'col-md-6'
}

function previewUrl(item: GalleryItem) {
  return item.thumbnailUrl || item.mediaUrl
}

function projectRoute(item: GalleryItem) {
  return item.projectId
    ? { name: 'project', hash: `#project-${item.projectId}` }
    : { name: 'project' }
}

function videoEmbedUrl(item: GalleryItem) {
  if (item.provider === 'vimeo' || item.mediaUrl.includes('vimeo.com')) {
    const id = item.mediaUrl.match(/vimeo\.com\/(?:video\/)?(\d+)/)?.[1]
    return id ? `https://player.vimeo.com/video/${id}?autoplay=1&title=0&byline=0&portrait=0` : ''
  }

  if (item.provider === 'youtube' || item.mediaUrl.includes('youtu')) {
    const id = item.mediaUrl.match(/(?:youtu\.be\/|v=|embed\/)([\w-]{6,})/)?.[1]
    return id ? `https://www.youtube-nocookie.com/embed/${id}?autoplay=1&rel=0` : ''
  }

  return ''
}

function sectionQuery(type: GalleryMediaType, page: number): GalleryQuery {
  return {
    type,
    category: category.value,
    search: search.value,
    page,
    pageSize: type === 'image' ? IMAGE_PAGE_SIZE : VIDEO_PAGE_SIZE
  }
}

async function fetchSection(type: GalleryMediaType, page: number): Promise<SectionResult> {
  const query = sectionQuery(type, page)

  try {
    return { response: await getGallery(query), fallback: false }
  } catch {
    return { response: getFallbackGallery(query), fallback: true }
  }
}

function applySharedResponse(result: SectionResult) {
  categories.value = result.response.categories
  counts.value = result.response.counts
}

function applyFallbackState(fallback: boolean) {
  usingFallback.value = fallback
  notice.value = fallback
    ? 'API đang ngoại tuyến — hiện đang hiển thị bộ sưu tập mẫu trong website.'
    : ''
}

async function loadGallery() {
  const requestId = ++requestSerial
  const requestedTypes: GalleryMediaType[] =
    mediaType.value === 'all' ? ['image', 'video'] : [mediaType.value]

  loading.value = true
  notice.value = ''
  activeIndex.value = -1
  imageItems.value = []
  videoItems.value = []
  imagePage.value = 1
  videoPage.value = 1
  imageTotalPages.value = 0
  videoTotalPages.value = 0
  imageTotalCount.value = 0
  videoTotalCount.value = 0

  try {
    const results = await Promise.all(requestedTypes.map((type) => fetchSection(type, 1)))
    if (requestId !== requestSerial) return

    results.forEach((result, index) => {
      const type = requestedTypes[index]
      if (type === 'image') {
        imageItems.value = result.response.items
        imagePage.value = result.response.page
        imageTotalPages.value = result.response.totalPages
        imageTotalCount.value = result.response.totalCount
      } else {
        videoItems.value = result.response.items
        videoPage.value = result.response.page
        videoTotalPages.value = result.response.totalPages
        videoTotalCount.value = result.response.totalCount
      }
    })

    applySharedResponse(results[0])
    totalCount.value = imageTotalCount.value + videoTotalCount.value
    applyFallbackState(results.some((result) => result.fallback))
  } finally {
    if (requestId === requestSerial) loading.value = false
  }
}

async function loadSectionPages(type: GalleryMediaType, showAll = false) {
  if (loading.value) return

  const currentPage = type === 'image' ? imagePage.value : videoPage.value
  const totalPages = type === 'image' ? imageTotalPages.value : videoTotalPages.value
  if (currentPage >= totalPages) return

  const pages = showAll
    ? Array.from({ length: totalPages - currentPage }, (_, index) => currentPage + index + 1)
    : [currentPage + 1]
  const requestId = ++requestSerial
  loading.value = true

  try {
    const results = await Promise.all(pages.map((pageNumber) => fetchSection(type, pageNumber)))
    if (requestId !== requestSerial) return

    const newItems = results.flatMap((result) => result.response.items)
    const lastResponse = results[results.length - 1].response

    if (type === 'image') {
      imageItems.value = [...imageItems.value, ...newItems]
      imagePage.value = lastResponse.page
      imageTotalPages.value = lastResponse.totalPages
      imageTotalCount.value = lastResponse.totalCount
    } else {
      videoItems.value = [...videoItems.value, ...newItems]
      videoPage.value = lastResponse.page
      videoTotalPages.value = lastResponse.totalPages
      videoTotalCount.value = lastResponse.totalCount
    }

    applySharedResponse(results[0])
    totalCount.value = imageTotalCount.value + videoTotalCount.value
    applyFallbackState(usingFallback.value || results.some((result) => result.fallback))
  } finally {
    if (requestId === requestSerial) loading.value = false
  }
}

async function collapseSection(type: GalleryMediaType) {
  if (loading.value) return
  const requestId = ++requestSerial
  loading.value = true

  try {
    const result = await fetchSection(type, 1)
    if (requestId !== requestSerial) return

    if (type === 'image') {
      imageItems.value = result.response.items
      imagePage.value = 1
      imageTotalPages.value = result.response.totalPages
      imageTotalCount.value = result.response.totalCount
    } else {
      videoItems.value = result.response.items
      videoPage.value = 1
      videoTotalPages.value = result.response.totalPages
      videoTotalCount.value = result.response.totalCount
    }

    applySharedResponse(result)
    totalCount.value = imageTotalCount.value + videoTotalCount.value
    applyFallbackState(usingFallback.value || result.fallback)
    document.querySelector(`#gallery-${type}s`)?.scrollIntoView({ behavior: 'smooth', block: 'start' })
  } finally {
    if (requestId === requestSerial) loading.value = false
  }
}

function selectMediaType(value: GalleryMediaType | 'all') {
  if (mediaType.value === value) return
  mediaType.value = value
  void loadGallery()
}

function selectCategory(value: string) {
  if (category.value === value) return
  category.value = value
  void loadGallery()
}

function submitSearch() {
  search.value = searchDraft.value.trim()
  void loadGallery()
}

function clearFilters() {
  mediaType.value = 'all'
  category.value = 'all'
  searchDraft.value = ''
  search.value = ''
  void loadGallery()
}

function toggleFilterSidebar() {
  filterSidebarOpen.value = !filterSidebarOpen.value
}

function closeFilterSidebar() {
  filterSidebarOpen.value = false
}

function openItem(itemId: number) {
  activeIndex.value = items.value.findIndex((item) => item.id === itemId)
}

function closeViewer() {
  activeIndex.value = -1
}

function showPrevious() {
  if (items.value.length < 2) return
  activeIndex.value = (activeIndex.value - 1 + items.value.length) % items.value.length
}

function showNext() {
  if (items.value.length < 2) return
  activeIndex.value = (activeIndex.value + 1) % items.value.length
}

function handleKeydown(event: KeyboardEvent) {
  if (event.key === 'Escape') {
    if (activeItem.value) closeViewer()
    else if (filterSidebarOpen.value) closeFilterSidebar()
    return
  }

  if (!activeItem.value) return
  if (event.key === 'ArrowLeft') showPrevious()
  if (event.key === 'ArrowRight') showNext()
}

watch(isBodyLocked, (locked, wasLocked) => {
  if (locked && !wasLocked) {
    originalBodyOverflow = document.body.style.overflow
    document.body.style.overflow = 'hidden'
  } else if (!locked && wasLocked) {
    document.body.style.overflow = originalBodyOverflow
  }
})

onMounted(() => {
  window.addEventListener('keydown', handleKeydown)
  void loadGallery()
})

onBeforeUnmount(() => {
  window.removeEventListener('keydown', handleKeydown)
  document.body.style.overflow = originalBodyOverflow
})
</script>

<template>
  <main>
    <header
      class="banner-header gallery-hero section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      :style="{ backgroundImage: `url('/media/gallery/walnut-villa-living.webp')` }"
    >
      <div class="container gallery-hero-inner">
        <div class="row">
          <div class="col-md-12 text-left caption gallery-hero-copy">
            <h5>Hình ảnh &amp; thước phim</h5>
            <h1>Thư viện</h1>
          </div>
        </div>

        <div class="gallery-hero-panel gallery-hero-summary">
          <div class="gallery-meta" aria-live="polite">
            <span>{{ resultLabel }}</span>
            <span v-if="notice" class="gallery-notice">
              <i class="ti-info-alt" aria-hidden="true"></i> {{ notice }}
            </span>
          </div>
          <button
            type="button"
            class="gallery-filter-toggle"
            data-testid="gallery-filter-toggle"
            aria-controls="gallery-filter-sidebar"
            :aria-expanded="filterSidebarOpen"
            @click="toggleFilterSidebar"
          >
            <span class="gallery-filter-toggle-icon" aria-hidden="true"><i></i><i></i></span>
            <span>Tìm kiếm &amp; bộ lọc</span>
            <strong v-if="activeFilterCount">{{ activeFilterCount }}</strong>
          </button>
        </div>
      </div>
    </header>

    <section
      v-if="showImageSection"
      id="gallery-images"
      class="section-padding gallery-media-section gallery-images-section"
    >
      <div class="container">
        <div class="row gallery-section-heading">
          <div class="col-md-12">
            <div class="section-subtitle">Hình ảnh</div>
            <div class="section-title">Thư viện hình ảnh</div>
          </div>
        </div>

        <div v-if="isInitialLoading" class="row" aria-hidden="true">
          <div v-for="placeholder in 6" :key="`image-${placeholder}`" class="col-md-4 gallery-item">
            <div class="gallery-skeleton"></div>
          </div>
        </div>

        <div v-else class="row gallery-grid">
          <div
            v-for="(item, index) in imageItems"
            :key="item.id"
            class="gallery-item"
            :class="imageCardColumn(index, imageItems.length)"
          >
            <button
              type="button"
              class="gallery-card gallery-box gallery-image-card"
              :aria-label="`Mở ảnh: ${item.title}`"
              @click="openItem(item.id)"
            >
              <span class="gallery-img">
                <img
                  :src="previewUrl(item)"
                  class="img-fluid mx-auto d-block"
                  :alt="item.altText || item.title"
                  loading="lazy"
                  decoding="async"
                />
                <span class="gallery-hover" aria-hidden="true">
                  <span class="gallery-hover-copy">
                    <span>{{ item.categoryName }}</span>
                    <strong>{{ item.title }}</strong>
                  </span>
                  <span class="gallery-zoom"><i class="ti-zoom-in"></i></span>
                </span>
              </span>
            </button>
          </div>
        </div>

        <div
          v-if="imageTotalCount > 0 && (hasMoreImages || canCollapseImages)"
          class="gallery-section-actions"
        >
          <p>Đang hiển thị {{ imageItems.length }} / {{ imageTotalCount }} hình ảnh</p>
          <div>
            <button
              v-if="hasMoreImages"
              type="button"
              :disabled="loading"
              @click="loadSectionPages('image')"
            >
              Xem thêm
            </button>
            <button
              v-if="hasMoreImages"
              type="button"
              class="gallery-show-all"
              :disabled="loading"
              @click="loadSectionPages('image', true)"
            >
              Xem tất cả {{ imageTotalCount }} ảnh
            </button>
            <button
              v-else-if="canCollapseImages"
              type="button"
              class="butn-dark"
              :disabled="loading"
              @click="collapseSection('image')"
            >
              Thu gọn
            </button>
          </div>
        </div>
      </div>
    </section>

    <section
      v-if="showVideoSection"
      id="gallery-videos"
      class="section-padding gallery-media-section gallery-videos-section"
    >
      <div class="container">
        <div class="row gallery-section-heading">
          <div class="col-md-12">
            <div class="section-subtitle">Video</div>
            <div class="section-title">Thư viện video</div>
          </div>
        </div>

        <div v-if="isInitialLoading" class="row" aria-hidden="true">
          <div v-for="placeholder in 4" :key="`video-${placeholder}`" class="col-md-6 gallery-item">
            <div class="gallery-skeleton gallery-skeleton--video"></div>
          </div>
        </div>

        <div v-else class="row gallery-grid gallery-video-grid">
          <div v-for="item in videoItems" :key="item.id" class="col-md-6 gallery-item">
            <button
              type="button"
              class="gallery-card gallery-box gallery-video-card"
              :aria-label="`Mở video: ${item.title}`"
              @click="openItem(item.id)"
            >
              <span class="gallery-img">
                <img
                  :src="previewUrl(item)"
                  class="img-fluid mx-auto d-block"
                  :alt="item.altText || item.title"
                  loading="lazy"
                  decoding="async"
                />
                <span class="gallery-play" aria-hidden="true">
                  <i class="ti-control-play"></i>
                </span>
                <span class="gallery-hover" aria-hidden="true">
                  <span class="gallery-hover-copy">
                    <span>{{ item.categoryName }}<template v-if="item.duration"> · {{ item.duration }}</template></span>
                    <strong>{{ item.title }}</strong>
                  </span>
                </span>
              </span>
            </button>
          </div>
        </div>

        <div
          v-if="videoTotalCount > 0 && (hasMoreVideos || canCollapseVideos)"
          class="gallery-section-actions"
        >
          <p>Đang hiển thị {{ videoItems.length }} / {{ videoTotalCount }} video</p>
          <div>
            <button
              v-if="hasMoreVideos"
              type="button"
              :disabled="loading"
              @click="loadSectionPages('video')"
            >
              Xem thêm
            </button>
            <button
              v-if="hasMoreVideos"
              type="button"
              class="gallery-show-all"
              :disabled="loading"
              @click="loadSectionPages('video', true)"
            >
              Xem tất cả {{ videoTotalCount }} video
            </button>
            <button
              v-else-if="canCollapseVideos"
              type="button"
              class="butn-dark"
              :disabled="loading"
              @click="collapseSection('video')"
            >
              Thu gọn
            </button>
          </div>
        </div>
      </div>
    </section>

    <section v-if="!loading && items.length === 0" class="section-padding gallery-empty-section">
      <div class="container">
        <div class="gallery-empty">
          <span class="gallery-empty-icon"><i class="ti-gallery"></i></span>
          <h3>Chưa có nội dung phù hợp</h3>
          <p>Hãy thử một từ khóa hoặc nhóm nội dung khác.</p>
          <button type="button" class="gallery-reset" @click="clearFilters">Xóa bộ lọc</button>
        </div>
      </div>
    </section>

    <section v-if="usingFallback" class="gallery-footer-actions">
      <div class="container">
        <p class="gallery-fallback-note">
          Nội dung mẫu sẽ tự động được thay bằng dữ liệu từ API khi backend hoạt động.
        </p>
      </div>
    </section>

    <Teleport to="body">
      <Transition name="gallery-filter-panel">
        <aside
          v-if="filterSidebarOpen"
          id="gallery-filter-sidebar"
          class="gallery-filter-sidebar"
          role="complementary"
          aria-labelledby="gallery-filter-title"
        >
          <div class="gallery-filter-header">
            <div>
              <span>Thư viện D&amp;L</span>
              <h2 id="gallery-filter-title">Tìm kiếm &amp; bộ lọc</h2>
            </div>
            <button
              type="button"
              class="gallery-filter-close"
              data-testid="gallery-filter-close"
              aria-label="Đóng"
              @click="closeFilterSidebar"
            >
              <i></i><i></i>
            </button>
          </div>

          <div class="gallery-filter-body">
            <form class="gallery-sidebar-search" role="search" @submit.prevent="submitSearch">
              <label for="gallery-sidebar-search">Tìm trong thư viện</label>
              <div>
                <input
                  id="gallery-sidebar-search"
                  v-model="searchDraft"
                  type="search"
                  placeholder="Không gian, chất liệu, dự án..."
                />
                <button type="submit" aria-label="Tìm kiếm">
                  <i class="ti-search" aria-hidden="true"></i>
                </button>
              </div>
            </form>

            <div class="gallery-filter-group">
              <h3>Loại nội dung</h3>
              <div class="gallery-filter-list" role="group" aria-label="Loại nội dung">
                <button
                  type="button"
                  :class="{ active: mediaType === 'all' }"
                  @click="selectMediaType('all')"
                >
                  <span>Tất cả</span><strong>{{ counts.all }}</strong>
                </button>
                <button
                  type="button"
                  :class="{ active: mediaType === 'image' }"
                  @click="selectMediaType('image')"
                >
                  <span>Hình ảnh</span><strong>{{ counts.images }}</strong>
                </button>
                <button
                  type="button"
                  :class="{ active: mediaType === 'video' }"
                  @click="selectMediaType('video')"
                >
                  <span>Video</span><strong>{{ counts.videos }}</strong>
                </button>
              </div>
            </div>

            <div class="gallery-filter-group">
              <h3>Không gian</h3>
              <div class="gallery-filter-list" role="group" aria-label="Danh mục không gian">
                <button
                  type="button"
                  :class="{ active: category === 'all' }"
                  @click="selectCategory('all')"
                >
                  <span>Mọi không gian</span><strong>{{ counts.all }}</strong>
                </button>
                <button
                  v-for="item in categories"
                  :key="item.id"
                  type="button"
                  :class="{ active: category === item.slug }"
                  @click="selectCategory(item.slug)"
                >
                  <span>{{ item.name }}</span><strong>{{ item.itemCount }}</strong>
                </button>
              </div>
            </div>
          </div>

          <div class="gallery-filter-footer">
            <p>{{ resultLabel }}</p>
            <button v-if="activeFilterCount" type="button" @click="clearFilters">
              Xóa bộ lọc <i class="ti-close" aria-hidden="true"></i>
            </button>
          </div>
        </aside>
      </Transition>
    </Teleport>

    <Teleport to="body">
      <Transition name="gallery-viewer">
        <div
          v-if="activeItem"
          class="gallery-viewer"
          role="dialog"
          aria-modal="true"
          :aria-label="activeItem.title"
          @click.self="closeViewer"
        >
          <button class="viewer-close" type="button" aria-label="Đóng" @click="closeViewer">
            <i class="ti-close"></i>
          </button>
          <button
            v-if="items.length > 1"
            class="viewer-arrow viewer-arrow--prev"
            type="button"
            aria-label="Nội dung trước"
            @click="showPrevious"
          >
            <i class="ti-angle-left"></i>
          </button>

          <div class="viewer-content">
            <img
              v-if="activeItem.mediaType === 'image'"
              :src="activeItem.mediaUrl"
              :alt="activeItem.altText || activeItem.title"
            />
            <div v-else-if="videoEmbedUrl(activeItem)" class="viewer-video">
              <iframe
                :src="videoEmbedUrl(activeItem)"
                :title="activeItem.title"
                allow="autoplay; fullscreen; picture-in-picture"
                allowfullscreen
              ></iframe>
            </div>
            <video v-else :src="activeItem.mediaUrl" controls autoplay playsinline></video>

            <div class="viewer-caption">
              <span>{{ activeItem.categoryName }}</span>
              <h2>{{ activeItem.title }}</h2>
              <p v-if="activeItem.description">{{ activeItem.description }}</p>
              <RouterLink
                :to="projectRoute(activeItem)"
                class="viewer-project-link"
                @click="closeViewer"
              >
                {{ activeItem.projectId ? 'Xem dự án liên quan' : 'Khám phá các dự án' }}
                <i class="ti-arrow-right" aria-hidden="true"></i>
              </RouterLink>
            </div>
          </div>

          <button
            v-if="items.length > 1"
            class="viewer-arrow viewer-arrow--next"
            type="button"
            aria-label="Nội dung tiếp theo"
            @click="showNext"
          >
            <i class="ti-angle-right"></i>
          </button>
        </div>
      </Transition>
    </Teleport>
  </main>
</template>

<style scoped>
.gallery-hero {
  min-height: 540px;
  padding: 0;
  background-position: center;
}

.gallery-hero-inner {
  position: relative;
  z-index: 2;
  display: flex;
  min-height: 540px;
  flex-direction: column;
  justify-content: center;
  padding-top: 90px;
  padding-bottom: 130px;
}

.gallery-hero-copy {
  margin: 0;
}

.gallery-hero .caption h1 {
  font-size: 60px;
  line-height: 1.1;
}

.gallery-hero-panel {
  position: absolute;
  right: 15px;
  bottom: 24px;
  left: 15px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  padding: 12px 0;
  border-top: 1px solid rgba(255, 255, 255, 0.28);
  border-bottom: 1px solid rgba(255, 255, 255, 0.18);
  background: transparent;
}

.gallery-meta {
  display: flex;
  min-width: 0;
  flex-direction: column;
  gap: 2px;
  color: rgba(255, 255, 255, 0.58);
  font-size: 11px;
}

.gallery-notice {
  color: #d8b98d;
}

.gallery-filter-toggle {
  display: inline-flex;
  flex: 0 0 auto;
  align-items: center;
  gap: 12px;
  padding: 8px 0;
  border: 0;
  background: transparent;
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 2px;
  text-transform: uppercase;
  cursor: pointer;
}

.gallery-filter-toggle strong {
  display: grid;
  width: 21px;
  height: 21px;
  place-items: center;
  border-radius: 50%;
  background: #aa8453;
  color: #fff;
  font-size: 10px;
  font-weight: 400;
  letter-spacing: 0;
}

.gallery-filter-toggle-icon {
  position: relative;
  display: block;
  width: 26px;
  height: 16px;
}

.gallery-filter-toggle-icon i {
  position: absolute;
  right: 0;
  width: 26px;
  height: 1px;
  background: #d8b98d;
  transition: width 0.25s ease;
}

.gallery-filter-toggle-icon i:first-child {
  top: 4px;
}

.gallery-filter-toggle-icon i:last-child {
  top: 11px;
  width: 18px;
}

.gallery-filter-toggle:hover .gallery-filter-toggle-icon i:last-child {
  width: 26px;
}

.gallery-filter-sidebar {
  position: fixed;
  z-index: 99991;
  top: 0;
  right: 0;
  bottom: 0;
  display: flex;
  width: min(410px, calc(100vw - 24px));
  flex-direction: column;
  overflow-y: auto;
  background: #fff;
  box-shadow: -20px 0 45px rgba(25, 23, 20, 0.12);
}

.gallery-filter-header {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 30px;
  padding: 44px 38px 31px;
  border-bottom: 1px solid #eeeae5;
}

.gallery-filter-header span,
.gallery-sidebar-search label,
.gallery-filter-group h3 {
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 400;
  letter-spacing: 2.6px;
  text-transform: uppercase;
}

.gallery-filter-header h2 {
  margin: 5px 0 0;
  color: #222;
  font-size: 30px;
  font-weight: 400;
}

.gallery-filter-close {
  position: relative;
  flex: 0 0 32px;
  width: 32px;
  height: 32px;
  padding: 0;
  border: 0;
  background: transparent;
  cursor: pointer;
}

.gallery-filter-close i {
  position: absolute;
  top: 15px;
  left: 2px;
  width: 28px;
  height: 1px;
  background: #aa8453;
}

.gallery-filter-close i:first-child {
  transform: rotate(45deg);
}

.gallery-filter-close i:last-child {
  transform: rotate(-45deg);
}

.gallery-filter-body {
  flex: 1 0 auto;
  padding: 32px 38px 20px;
}

.gallery-sidebar-search label {
  display: block;
  margin-bottom: 12px;
}

.gallery-sidebar-search > div {
  position: relative;
  border-bottom: 1px solid #d8d3cd;
}

.gallery-sidebar-search input {
  width: 100%;
  height: 44px;
  padding: 0 42px 0 0;
  border: 0;
  outline: 0;
  background: transparent;
  color: #222;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
}

.gallery-sidebar-search input::placeholder {
  color: #999;
}

.gallery-sidebar-search button {
  position: absolute;
  top: 0;
  right: 0;
  width: 40px;
  height: 44px;
  border: 0;
  background: transparent;
  color: #aa8453;
  cursor: pointer;
}

.gallery-filter-group {
  margin-top: 34px;
}

.gallery-filter-group h3 {
  margin-bottom: 9px;
}

.gallery-filter-list button {
  display: flex;
  width: 100%;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  padding: 12px 0;
  border: 0;
  border-bottom: 1px solid #eeeae5;
  background: transparent;
  color: #555;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  letter-spacing: 0.8px;
  text-align: left;
  text-transform: uppercase;
  cursor: pointer;
  transition: color 0.2s ease;
}

.gallery-filter-list button strong {
  color: #aaa;
  font-size: 11px;
  font-weight: 400;
}

.gallery-filter-list button:hover,
.gallery-filter-list button.active,
.gallery-filter-list button.active strong {
  color: #aa8453;
}

.gallery-filter-footer {
  padding: 24px 38px 32px;
  border-top: 1px solid #eeeae5;
}

.gallery-filter-footer p {
  margin: 0;
  color: #777;
  font-size: 12px;
}

.gallery-filter-footer button {
  margin-top: 11px;
  padding: 0;
  border: 0;
  background: transparent;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 1.6px;
  text-transform: uppercase;
  cursor: pointer;
}

.gallery-filter-panel-enter-active,
.gallery-filter-panel-leave-active {
  transition: transform 0.42s cubic-bezier(0.77, 0, 0.18, 1);
}

.gallery-filter-panel-enter-from,
.gallery-filter-panel-leave-to {
  transform: translateX(100%);
}

.gallery-media-section {
  overflow: hidden;
  padding: 120px 0;
}

.gallery-images-section {
  background: #fff;
}

.gallery-videos-section {
  border-top: 0;
  background: #f7f5f2;
}

.gallery-section-heading {
  margin-bottom: 30px;
}

.gallery-section-heading .section-title {
  margin-bottom: 20px;
  font-size: 46px;
}

.gallery-card {
  display: block;
  overflow: hidden;
  width: 100%;
  padding: 0;
  border: 0;
  background: #e9e5df;
  color: inherit;
  text-align: left;
  cursor: pointer;
}

.gallery-card .gallery-img {
  position: relative;
  display: block;
  height: 238px;
  overflow: hidden;
}

.gallery-item.col-md-6 .gallery-img {
  height: 338px;
}

.gallery-item--wide .gallery-img {
  height: 430px;
}

.gallery-video-card .gallery-img,
.gallery-item.col-md-6 .gallery-video-card .gallery-img {
  height: 338px;
}

.gallery-card .gallery-img img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.55s ease;
}

.gallery-card:hover .gallery-img img,
.gallery-card:focus-visible .gallery-img img {
  transform: scale(1.045);
}

.gallery-hover {
  position: absolute;
  z-index: 2;
  inset: 0;
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 20px;
  padding: 24px;
  background: linear-gradient(180deg, transparent 38%, rgba(15, 14, 12, 0.78) 100%);
  opacity: 0;
  transition: opacity 0.35s ease;
}

.gallery-card:hover .gallery-hover,
.gallery-card:focus-visible .gallery-hover {
  opacity: 1;
}

.gallery-hover-copy {
  display: block;
}

.gallery-hover-copy span {
  display: block;
  margin-bottom: 5px;
  color: #d8b98d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 2.4px;
  text-transform: uppercase;
}

.gallery-hover-copy strong {
  display: block;
  color: #fff;
  font-family: 'Gilda Display', serif;
  font-size: 20px;
  font-weight: 400;
  line-height: 1.2;
}

.gallery-zoom {
  display: grid;
  width: 42px;
  height: 42px;
  flex: 0 0 42px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.65);
  color: #fff;
  font-size: 15px;
}

.gallery-play {
  position: absolute;
  z-index: 3;
  right: 18px;
  bottom: 18px;
  display: grid;
  width: 42px;
  height: 42px;
  place-items: center;
  border: 1px solid rgba(255, 255, 255, 0.8);
  border-radius: 50%;
  background: rgba(15, 14, 12, 0.24);
  color: #fff;
  transition: 0.25s ease;
}

.gallery-card:hover .gallery-play {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

.gallery-skeleton {
  height: 238px;
  background: linear-gradient(100deg, #eee 20%, #f7f5f2 40%, #eee 60%);
  background-size: 200% 100%;
  animation: gallery-shimmer 1.3s linear infinite;
}

.gallery-skeleton--video {
  height: 338px;
}

.gallery-empty-section {
  background: #fff;
}

.gallery-empty {
  padding: 90px 20px 40px;
  text-align: center;
}

.gallery-empty-icon {
  display: block;
  margin-bottom: 18px;
  color: #aa8453;
  font-size: 42px;
}

.gallery-empty h3 {
  margin-bottom: 10px;
  color: #222;
  font-size: 30px;
}

.gallery-reset,
.gallery-section-actions button {
  padding: 13px 25px;
  border: 1px solid #aa8453;
  background: #aa8453;
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 2px;
  text-transform: uppercase;
  cursor: pointer;
}

.gallery-section-actions {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 24px;
  margin-top: 28px;
  padding-top: 28px;
  border-top: 1px solid #e7e2dc;
}

.gallery-section-actions p {
  margin: 0;
  color: #888;
  font-size: 12px;
}

.gallery-section-actions > div {
  display: flex;
  align-items: center;
  gap: 10px;
}

.gallery-section-actions .gallery-show-all {
  background: transparent;
  color: #aa8453;
}

.gallery-section-actions button:hover {
  background: #222;
  border-color: #222;
  color: #fff;
}

.gallery-footer-actions {
  padding: 0 0 50px;
  background: #f7f5f2;
}

.gallery-section-actions button:disabled {
  cursor: wait;
  opacity: 0.65;
}

.gallery-fallback-note {
  margin: 16px 0 0;
  color: #999;
  font-size: 12px;
  text-align: center;
}

.sr-only {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

@keyframes gallery-shimmer {
  to {
    background-position-x: -200%;
  }
}

@media (max-width: 767px) {
  .gallery-hero {
    min-height: 540px;
    background-attachment: scroll;
  }

  .gallery-hero-inner {
    min-height: 540px;
    justify-content: flex-start;
    padding-top: 165px;
    padding-bottom: 120px;
  }

  .gallery-hero .caption h1 {
    font-size: 48px;
  }

  .gallery-hero-panel {
    right: 15px;
    bottom: 22px;
    left: 15px;
    align-items: flex-start;
    padding: 12px 0;
  }

  .gallery-meta {
    gap: 3px;
  }

  .gallery-filter-toggle > span:nth-child(2) {
    display: none;
  }

  .gallery-filter-sidebar {
    width: min(360px, calc(100vw - 18px));
  }

  .gallery-filter-header {
    padding: 32px 26px 25px;
  }

  .gallery-filter-body {
    padding: 26px 26px 18px;
  }

  .gallery-filter-footer {
    padding: 21px 26px 27px;
  }

  .gallery-media-section {
    padding: 80px 0;
  }

  .gallery-section-heading .section-title {
    font-size: 38px;
  }

  .gallery-card .gallery-img,
  .gallery-item.col-md-6 .gallery-img,
  .gallery-item--wide .gallery-img,
  .gallery-video-card .gallery-img,
  .gallery-item.col-md-6 .gallery-video-card .gallery-img,
  .gallery-skeleton,
  .gallery-skeleton--video {
    height: 285px;
  }

  .gallery-hover {
    padding: 20px;
    opacity: 1;
  }

  .gallery-section-actions {
    align-items: flex-start;
    flex-direction: column;
    gap: 16px;
  }

  .gallery-section-actions > div {
    width: 100%;
    align-items: stretch;
    flex-direction: column;
  }

  .gallery-section-actions button {
    width: 100%;
  }
}
</style>

<style>
.gallery-viewer {
  position: fixed;
  z-index: 99999;
  inset: 0;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 60px 90px;
  background: rgba(10, 9, 8, 0.94);
}

.viewer-content {
  width: min(1180px, 100%);
  max-height: calc(100vh - 120px);
}

.viewer-content > img,
.viewer-content > video {
  display: block;
  width: 100%;
  max-height: calc(100vh - 250px);
  object-fit: contain;
}

.viewer-video {
  position: relative;
  width: 100%;
  padding-top: 56.25%;
  background: #000;
}

.viewer-video iframe {
  position: absolute;
  inset: 0;
  width: 100%;
  height: 100%;
  border: 0;
}

.viewer-caption {
  max-width: 850px;
  padding-top: 20px;
  color: rgba(255, 255, 255, 0.68);
}

.viewer-caption span {
  color: #caa16d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 3px;
  text-transform: uppercase;
}

.viewer-caption h2 {
  margin: 5px 0 3px;
  color: #fff;
  font-size: 28px;
  font-weight: 400;
}

.viewer-caption p {
  margin: 0;
  color: rgba(255, 255, 255, 0.62);
}

.viewer-project-link {
  display: inline-flex;
  align-items: center;
  gap: 12px;
  margin-top: 13px;
  color: #caa16d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 1.8px;
  text-transform: uppercase;
  transition: color 0.2s ease;
}

.viewer-project-link:hover {
  color: #fff;
}

.viewer-project-link i {
  font-size: 11px;
}

.viewer-close,
.viewer-arrow {
  position: absolute;
  border: 0;
  background: transparent;
  color: #fff;
  cursor: pointer;
}

.viewer-close {
  top: 28px;
  right: 34px;
  font-size: 22px;
}

.viewer-arrow {
  top: 50%;
  width: 60px;
  height: 60px;
  border: 1px solid rgba(255, 255, 255, 0.28);
  border-radius: 50%;
  font-size: 20px;
  transform: translateY(-50%);
  transition: 0.2s ease;
}

.viewer-arrow:hover {
  border-color: #aa8453;
  background: #aa8453;
}

.viewer-arrow--prev {
  left: 22px;
}

.viewer-arrow--next {
  right: 22px;
}

.gallery-viewer-enter-active,
.gallery-viewer-leave-active {
  transition: opacity 0.25s ease;
}

.gallery-viewer-enter-from,
.gallery-viewer-leave-to {
  opacity: 0;
}

@media (max-width: 767px) {
  .gallery-viewer {
    padding: 70px 15px 30px;
  }

  .viewer-content {
    max-height: calc(100vh - 100px);
  }

  .viewer-content > img,
  .viewer-content > video {
    max-height: calc(100vh - 260px);
  }

  .viewer-close {
    top: 20px;
    right: 20px;
  }

  .viewer-arrow {
    top: auto;
    bottom: 18px;
    width: 48px;
    height: 48px;
  }

  .viewer-arrow--prev {
    left: 15px;
  }

  .viewer-arrow--next {
    right: 15px;
  }
}
</style>
