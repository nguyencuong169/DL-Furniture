<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { FALLBACK_MENU, fetchMenus, type MenuResponse } from '../api/menuClient'
import { Mail, Phone } from 'lucide-vue-next'

const currentYear = new Date().getFullYear()
const menu = ref<MenuResponse>(FALLBACK_MENU)
const footerLinks = computed(() => menu.value.footer)

onMounted(async () => {
  menu.value = await fetchMenus()
})
</script>

<template>
  <footer class="footer">
    <div class="footer-top">
      <div class="container">
        <div class="row">
          <div class="col-md-4">
            <div class="footer-column footer-about">
              <h3 class="footer-title">D&L Furniture</h3>
              <p class="footer-about-text">
                Thiết kế và thi công nội thất theo hiện trạng, nhu cầu sử dụng và dấu ấn riêng của
                mỗi gia chủ. D&amp;L Furniture đồng hành từ ý tưởng đến khi công trình hoàn thiện.
              </p>
            </div>
          </div>
          <div class="col-md-3 offset-md-1">
            <div class="footer-column footer-explore clearfix">
              <h3 class="footer-title">Danh mục</h3>
              <ul class="footer-explore-list list-unstyled">
                <li v-for="link in footerLinks" :key="link.url">
                  <RouterLink :to="link.url">{{ link.label }}</RouterLink>
                </li>
              </ul>
            </div>
          </div>
          <div class="col-md-4">
            <div class="footer-column footer-contact">
              <h3 class="footer-title">Liên hệ</h3>
              <p class="footer-contact-text">Đường Cầu Liêu<br />Thạch Xá - Thạch Thất - Hà Nội</p>
              <div class="footer-contact-info">
                <p class="footer-contact-phone">
                  <Phone :size="18" :stroke-width="1.5" class="footer-phone-icon" aria-hidden="true" />
                  <a href="tel:+84961109897">(+84) 961-109-897</a>
                </p>
                <p class="footer-contact-mail">
                  <a href="mailto:info@dl-furniture.com">info@dl-furniture.com</a>
                </p>
              </div>
              <div class="footer-about-social-list">
                <a href="mailto:info@dl-furniture.com" aria-label="Gửi email cho D&L Furniture">
                  <Mail :size="15" :stroke-width="1.5" aria-hidden="true" />
                </a>
                <a href="tel:+84961109897" aria-label="Gọi D&L Furniture">
                  <Phone :size="15" :stroke-width="1.5" aria-hidden="true" />
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="footer-bottom">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="footer-bottom-inner">
              <p class="footer-bottom-copy-right">
                © {{ currentYear }} D&amp;L Furniture. All rights reserved.
              </p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </footer>
</template>

<style scoped>
.footer-explore-list .router-link-active,
.footer-explore-list .router-link-exact-active {
  color: #aa8453;
}
.footer-phone-icon {
  margin-right: 8px;
  vertical-align: -3px;
}
</style>