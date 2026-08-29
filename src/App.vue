<script setup lang="ts">
import { nextTick, onMounted } from 'vue'
import { RouterView, useRouter } from 'vue-router'
import NavbarComponent from './template/01_NavbarComponent.vue'
import FooterComponent from './template/13_FooterComponent.vue'
import { initScrollAnimations } from './utils/animations'

const router = useRouter()

onMounted(() => {
  initScrollAnimations()
})

// Section được Vue render lại sau mỗi lần điều hướng → re-bind hiệu ứng scroll
router.afterEach(() => {
  void nextTick(() => initScrollAnimations())
})
</script>

<template>
  <NavbarComponent />
  <RouterView />
  <FooterComponent />
</template>

<style scoped></style>
