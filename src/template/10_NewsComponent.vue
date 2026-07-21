<script setup lang="ts">
import { onMounted, reactive } from 'vue'
import dayjs from 'dayjs'
import { newsApi } from '../api/newsClient'
import type { News } from '../generated/api-client/models'
import { handleNewsImageError, resolveNewsImage } from '../utils/news'

const state = reactive({
  items: [] as News[]
})

onMounted(async () => {
  try {
    const res = await newsApi.newsGetAll()
    state.items = (res.data ?? []).slice(0, 6) as News[]
  } catch (error) {
    console.error('Failed to load homepage news', error)
  }
})
</script>

<template>
  <section class="news section-padding bg-blck">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle"><span>D&L Furniture News</span></div>
          <div class="section-title"><span>Tin tức nội thất</span></div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12">
          <div class="owl-carousel owl-theme">
            <div class="item" v-for="item in state.items" :key="item.id">
              <div class="position-re o-hidden">
                <img
                  :src="resolveNewsImage(item.newsImage, item.id)"
                  :alt="item.titles || 'Tin tức'"
                  @error="handleNewsImageError($event, item.id)"
                />
                <div class="date">
                  <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                    <span>{{ dayjs(item.updatedDate).format('MMM') }}</span>
                    <i>{{ dayjs(item.updatedDate).format('DD') }}</i>
                  </RouterLink>
                </div>
              </div>
              <div class="con">
                <span class="category">
                  <RouterLink :to="{ name: 'news' }">TIN TỨC</RouterLink>
                </span>
                <h5>
                  <RouterLink :to="{ name: 'news-detail', params: { id: item.id } }">
                    {{ item.titles }}
                  </RouterLink>
                </h5>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
