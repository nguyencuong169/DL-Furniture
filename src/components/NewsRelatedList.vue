<script setup lang="ts">
import type { NewsItem } from '../types/news'
import { handleNewsImageError, resolveNewsImage } from '../utils/news'

defineProps<{
  items: NewsItem[]
  loading?: boolean
}>()
</script>

<template>
  <div class="widget news-related-widget">
    <div class="widget-title">
      <h6>Có thể bạn quan tâm</h6>
    </div>

    <ul class="recent">
      <li v-if="loading && !items.length" class="news-related-loading" aria-live="polite">
        <span class="news-related-loading-image" aria-hidden="true"></span>
        <span class="news-related-loading-lines" aria-hidden="true"><i></i><i></i></span>
        <span class="visually-hidden">Đang tải bài viết gợi ý...</span>
      </li>

      <li v-for="related in items" :key="related.id">
        <RouterLink
          class="news-related-link"
          :to="{ name: 'news-detail', params: { id: related.id } }"
        >
          <span class="thum">
            <img
              :src="resolveNewsImage(related.newsImage, related.id)"
              :alt="related.titles || 'Tin tức gợi ý'"
              loading="lazy"
              decoding="async"
              @error="handleNewsImageError($event, related.id)"
            />
          </span>
          <span class="news-related-title">{{ related.titles }}</span>
        </RouterLink>
      </li>
    </ul>
  </div>
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

.news-related-link {
  display: flex !important;
  align-items: center;
  gap: 15px;
  margin-left: 0 !important;
}

.recent .thum {
  display: block;
  flex: 0 0 90px;
  float: none;
  width: 90px;
  height: 68px;
  background: #eeeae4;
}

.recent .thum img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.35s ease;
}

.news-related-link:hover .thum img {
  transform: scale(1.04);
}

.news-related-title {
  display: -webkit-box;
  min-width: 0;
  overflow: hidden;
  -webkit-box-orient: vertical;
  -webkit-line-clamp: 3;
}

.news-related-loading {
  display: flex !important;
  align-items: center;
  gap: 15px;
}

.news-related-loading-image {
  flex: 0 0 90px;
  width: 90px;
  height: 68px;
}

.news-related-loading-lines {
  display: grid;
  flex: 1;
  gap: 10px;
}

.news-related-loading-image,
.news-related-loading-lines i {
  position: relative;
  display: block;
  overflow: hidden;
  background: #eeeae4;
}

.news-related-loading-image::after,
.news-related-loading-lines i::after {
  position: absolute;
  inset: 0;
  content: '';
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.72), transparent);
  transform: translateX(-100%);
  animation: news-related-shimmer 1.35s infinite;
}

.news-related-loading-lines i {
  width: 100%;
  height: 11px;
}

.news-related-loading-lines i:last-child {
  width: 70%;
}

@keyframes news-related-shimmer {
  to {
    transform: translateX(100%);
  }
}
</style>
