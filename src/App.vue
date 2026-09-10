<script setup lang="ts">
import { nextTick, onMounted } from 'vue'
import { RouterView, useRouter } from 'vue-router'
import NavbarComponent from './template/01_NavbarComponent.vue'
import FooterComponent from './template/13_FooterComponent.vue'
import StickyContact from './components/StickyContact.vue'
import { initScrollAnimations } from './utils/animations'
import { initProgressBar } from './utils/progressBar'

const router = useRouter()

// Đưa focus vào <main> (mỗi view tự render main của nó) — phục vụ skip link
// và việc chuyển focus sau điều hướng cho keyboard/screen reader.
function focusMainContent(preventScroll = true) {
  const main = document.querySelector('main')
  if (!main) return
  main.setAttribute('tabindex', '-1')
  main.focus({ preventScroll })
}

onMounted(() => {
  initScrollAnimations()
  // Nút scroll-to-top (vòng tròn tiến độ) — phần tử tĩnh trong index.html
  initProgressBar()
})

// Section được Vue render lại sau mỗi lần điều hướng → re-bind hiệu ứng scroll.
// Ngoài ra đưa focus vào nội dung chính sau điều hướng (bỏ lần đầu để không
// đánh cắp focus khi mới tải trang).
let isFirstNavigation = true
router.afterEach(() => {
  void nextTick(() => {
    initScrollAnimations()
    if (isFirstNavigation) {
      isFirstNavigation = false
      return
    }
    focusMainContent()
  })
})
</script>

<template>
  <a class="skip-link" href="#main-content" @click.prevent="focusMainContent(false)">
    Nhảy đến nội dung chính
  </a>
  <NavbarComponent />
  <RouterView />
  <FooterComponent />
  <!-- Nút liên hệ nổi đa kênh (Gọi/Zalo/Messenger) — cố định khi cuộn, toàn site -->
  <StickyContact />
</template>

<style scoped></style>
