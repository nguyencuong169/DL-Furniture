<script setup lang="ts">
import { computed } from 'vue'
import type { CategoryDto } from '../api/newsSidebarClient'

const props = defineProps<{
  categories: CategoryDto[]
  loading?: boolean
  error?: boolean
  activeCategoryId?: number | null
  activeAll?: boolean
  title?: string
  totalCount?: number
  categoriesWithPosts?: number
  showAllPostsItem?: boolean
  showTotalDescription?: boolean
  disableEmpty?: boolean
}>()

const emit = defineEmits<{
  selectAll: []
  select: [categoryId: number]
  retry: []
}>()

const total = computed(() => props.totalCount ?? 0)
const withPosts = computed(() => props.categoriesWithPosts ?? props.categories.length)
</script>

<template>
  <div class="widget news-category-widget">
    <div class="widget-title">
      <h6>{{ title || 'Chuyên mục' }}</h6>
      <p v-if="showTotalDescription !== false">{{ total }} bài viết trong {{ withPosts }} chủ đề</p>
    </div>

    <p v-if="loading" class="news-category-status">Đang tải chuyên mục...</p>
    <p v-else-if="error" class="news-category-status is-error">
      Chưa thể tải chuyên mục.
      <button type="button" @click="emit('retry')">Thử lại</button>
    </p>
    <p v-else-if="!categories.length" class="news-category-status">Chưa có chuyên mục tin tức.</p>

    <ul v-else class="news-category-list">
      <li v-if="showAllPostsItem !== false">
        <button
          type="button"
          class="news-category-link"
          :class="{ active: activeAll }"
          :aria-pressed="activeAll"
          @click="emit('selectAll')"
        >
          <span class="news-category-name">
            <i class="ti-layout-grid2" aria-hidden="true"></i>
            Tất cả bài viết
          </span>
          <span class="news-category-count">{{ total }}</span>
        </button>
      </li>
      <li v-for="category in categories" :key="category.id">
        <button
          type="button"
          class="news-category-link"
          :class="{
            active: activeCategoryId === category.id,
            'is-empty': disableEmpty && category.publishedCount === 0
          }"
          :disabled="disableEmpty && category.publishedCount === 0"
          :aria-pressed="activeCategoryId === category.id"
          :title="
            disableEmpty && category.publishedCount === 0
              ? 'Chuyên mục chưa có bài viết công khai'
              : `${category.publishedCount} bài viết`
          "
          @click="emit('select', category.id)"
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
</template>

<style scoped>
.news-category-status button {
  padding: 0;
  border: 0;
  border-bottom: 1px solid currentcolor;
  background: transparent;
  color: inherit;
  cursor: pointer;
}
</style>
