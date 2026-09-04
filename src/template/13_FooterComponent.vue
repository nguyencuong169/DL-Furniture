<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'
import { FALLBACK_MENU, fetchMenus, type MenuResponse } from '../api/menuClient'
import { Facebook, Instagram, MessageCircle, Phone } from 'lucide-vue-next'

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

              <!-- GIỜ HOẠT ĐỘNG — TODO: sửa theo giờ thật của xưởng/showroom.
                   Đặt cột TRÁI để cân 3 cột (cột Liên hệ bên phải đã có địa chỉ
                   + social, thêm giờ vào đó sẽ dài vượt trội) -->
              <div class="footer-hours">
                <h4 class="footer-hours-title">Giờ hoạt động</h4>
                <p class="footer-hours-line"><span>Thứ 2 – Thứ 7</span><span>8:00 – 17:30</span></p>
                <p class="footer-hours-line"><span>Chủ nhật</span><span>Theo lịch hẹn</span></p>
              </div>
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
              <!-- SOCIAL — TODO: thay href '#' bằng link thật của D&L
                   (Facebook/Instagram/Zalo). Zalo tạm dùng icon MessageCircle
                   — Lucide đã loại các icon thương hiệu nên không có icon Zalo -->
              <div class="footer-about-social-list">
                <a href="#" aria-label="Facebook của D&L Furniture">
                  <Facebook :size="15" :stroke-width="1.5" aria-hidden="true" />
                </a>
                <a href="#" aria-label="Instagram của D&L Furniture">
                  <Instagram :size="15" :stroke-width="1.5" aria-hidden="true" />
                </a>
                <a href="#" aria-label="Zalo của D&L Furniture">
                  <MessageCircle :size="15" :stroke-width="1.5" aria-hidden="true" />
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
                © {{ currentYear }} D&amp;L Furniture — Thiết kế &amp; thi công nội thất gỗ óc chó
                tại Hà Nội.
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

/* ── GIỜ HOẠT ĐỘNG ─────────────────────────────────────────────────────── */
.footer-hours {
  margin-top: 22px;
  padding-top: 18px;
  border-top: 1px solid rgba(255, 255, 255, 0.08);
}

.footer-hours-title {
  margin: 0 0 10px;
  font-family: 'Barlow', sans-serif;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 0.2em;
  color: #aa8453;
  text-transform: uppercase;
}

.footer-hours-line {
  display: flex;
  justify-content: space-between;
  gap: 12px;
  margin: 0 0 6px;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
  color: rgba(255, 255, 255, 0.72);
}
</style>