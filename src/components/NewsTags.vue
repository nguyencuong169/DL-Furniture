<script setup lang="ts">
import { computed, ref, watch } from 'vue'

type NewsTag = {
  name: string
  count: number
}

const props = withDefaults(
  defineProps<{
    tags: NewsTag[]
    activeTag?: string
    title?: string
    maxVisible?: number
    showViewMore?: boolean
    showCounts?: boolean
  }>(),
  {
    tags: () => [],
    activeTag: '',
    title: 'Thẻ nội dung',
    maxVisible: 12,
    showViewMore: true,
    showCounts: false
  }
)

const emit = defineEmits<{
  select: [tagName: string]
}>()

const showAll = ref(false)

watch(
  () => props.activeTag,
  () => {
    // Reset expansion when the active tag changes.
    showAll.value = false
  }
)

const canExpand = computed(() => props.showViewMore && props.tags.length > props.maxVisible)

const displayedTags = computed(() => {
  return canExpand.value && !showAll.value ? props.tags.slice(0, props.maxVisible) : props.tags
})
</script>

<template>
  <div class="widget news-tags-widget">
    <div class="widget-title">
      <div class="d-flex align-items-center justify-content-between" style="width: 100%">
        <h6 class="mb-0">{{ title }}</h6>
        <button v-if="canExpand" type="button" class="view-more" @click="showAll = !showAll">
          {{ showAll ? 'Thu gọn' : 'Xem thêm' }}
        </button>
      </div>
    </div>
    <ul class="tags">
      <li v-for="tag in displayedTags" :key="tag.name">
        <button
          type="button"
          :class="{ active: activeTag === tag.name }"
          :title="`${tag.count} bài viết`"
          @click="emit('select', tag.name)"
        >
          {{ tag.name }}
          <small v-if="showCounts">{{ tag.count }}</small>
        </button>
      </li>
    </ul>
  </div>
</template>

<style scoped>
.news-tags-widget .widget-title .view-more {
  padding: 5px 0;
  border: 0;
  background: transparent;
  color: #666;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 1px;
  text-transform: uppercase;
  cursor: pointer;
}

.news-tags-widget .widget-title .view-more:hover {
  color: #aa8453;
}

.news-tags-widget .tags {
  display: flex;
  flex-wrap: wrap;
  gap: 7px;
}

.news-tags-widget .tags li {
  float: none;
  padding: 0;
  border: 0;
  margin: 0 !important;
  background: transparent;
}

.news-tags-widget ul.tags li button {
  display: block;
  padding: 8px 16px;
  border: 1px solid #fff;
  background: #fff;
  color: #666;
  font-family: inherit;
  font-size: 14px;
  line-height: 1.5;
  cursor: pointer;
  transition:
    border-color 0.2s ease,
    background-color 0.2s ease,
    color 0.2s ease;
}

.news-tags-widget ul.tags li button small {
  margin-left: 6px;
  font-size: 11px;
  opacity: 0.75;
}

.news-tags-widget ul.tags li button:hover,
.news-tags-widget ul.tags li button.active {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

.news-tags-widget ul.tags li button:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 3px;
}
</style>
