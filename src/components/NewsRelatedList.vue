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
