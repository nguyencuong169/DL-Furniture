<script setup lang="ts">
defineProps<{
  modelValue: string
  placeholder?: string
  label?: string
}>()

const emit = defineEmits<{
  'update:modelValue': [value: string]
  submit: []
  clear: []
}>()

const submitSearch = () => emit('submit')
const clearSearch = () => emit('clear')
</script>

<template>
  <div class="widget search news-sidebar-search">
    <form role="search" @submit.prevent="submitSearch">
      <input
        :value="modelValue"
        type="search"
        name="search"
        :placeholder="placeholder || 'Tìm kiếm bài viết...'"
        :aria-label="label || 'Tìm kiếm bài viết'"
        @input="emit('update:modelValue', ($event.target as HTMLInputElement).value)"
        @keydown.enter.prevent="submitSearch"
      />
      <button
        v-if="modelValue"
        type="button"
        class="news-search-clear"
        :aria-label="label || 'Xóa nội dung tìm kiếm'"
        @click="clearSearch"
      >
        <i class="ti-close" aria-hidden="true"></i>
      </button>
      <button class="news-search-submit" type="submit" :aria-label="label || 'Tìm kiếm'">
        <i class="ti-search" aria-hidden="true"></i>
      </button>
    </form>
  </div>
</template>

<style scoped>
.news-sidebar-search form input {
  min-height: 44px;
  padding-right: 82px;
}

.news-sidebar-search form .news-search-clear {
  right: 40px;
  color: #8a8177;
}

.news-sidebar-search form .news-search-submit {
  right: 0;
  color: #aa8453;
}

.news-sidebar-search form button {
  min-width: 40px;
  min-height: 44px;
}

.news-sidebar-search form button:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: -2px;
}
</style>
