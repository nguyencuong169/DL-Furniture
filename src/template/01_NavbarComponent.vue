<script setup lang="ts">
import { useRoute } from 'vue-router'
import { computed, ref, watch } from 'vue'

const route = useRoute()
const currentRouteName = computed(() => route.name)
const navbarToggler = ref<HTMLButtonElement | null>(null)
const navbarCollapse = ref<HTMLElement | null>(null)
const isProductMenuOpen = ref(false)
const activeProductSubmenu = ref<'living' | 'bedroom' | 'kitchen' | null>(null)

const closeMobileMenu = () => {
  isProductMenuOpen.value = false
  activeProductSubmenu.value = null
  if (!navbarCollapse.value?.classList.contains('show')) return
  navbarToggler.value?.click()
}

const isMobileNavigation = () => window.matchMedia('(max-width: 991px)').matches

const toggleProductMenu = (event: MouseEvent) => {
  if (!isMobileNavigation()) return
  event.preventDefault()
  isProductMenuOpen.value = !isProductMenuOpen.value
  if (!isProductMenuOpen.value) activeProductSubmenu.value = null
}

const toggleProductSubmenu = (
  event: MouseEvent,
  submenu: 'living' | 'bedroom' | 'kitchen'
) => {
  if (!isMobileNavigation()) return
  event.preventDefault()
  activeProductSubmenu.value = activeProductSubmenu.value === submenu ? null : submenu
}

const handleNavbarClick = (event: MouseEvent) => {
  const link = (event.target as HTMLElement | null)?.closest('a')
  if (!link || link.classList.contains('dropdown-toggle')) return
  closeMobileMenu()
}

watch(
  () => route.fullPath,
  () => closeMobileMenu()
)
</script>

<template>
  <nav class="navbar navbar-expand-lg">
    <div class="container">
      <!-- Logo -->
      <div class="logo-wrapper">
        <!-- <a class="logo" href="index.html">
          <img src="@/assets/img/logo.png" class="logo-img" alt="" />
        </a> -->
        <RouterLink class="logo" to="/" aria-label="D&L Furniture - Trang chủ">
          <div class="logo-wordmark">D&amp;L Furniture <span>Nội thất Dũng Linh</span></div>
        </RouterLink>
      </div>
      <!-- Button -->
      <button
        ref="navbarToggler"
        class="navbar-toggler"
        type="button"
        data-bs-toggle="collapse"
        data-bs-target="#navbar"
        aria-controls="navbar"
        aria-expanded="false"
        aria-label="Mở menu điều hướng"
      >
        <span class="navbar-toggler-icon"><i class="ti-menu"></i></span>
      </button>
      <!-- Menu -->
      <div id="navbar" ref="navbarCollapse" class="collapse navbar-collapse">
        <ul class="navbar-nav ms-auto" @click="handleNavbarClick">
          <li class="nav-item">
            <a
              :class="currentRouteName == 'home' || currentRouteName == '' ? 'active' : ''"
              class="nav-link"
              href="/"
              >Trang chủ</a
            >
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              href="/gioi-thieu"
              :class="
                currentRouteName == 'about' || route.path.startsWith('/about') ? 'active' : ''
              "
              >Giới thiệu</a
            >
          </li>
          <li class="nav-item dropdown">
            <a
              class="nav-link dropdown-toggle"
              href="/san-pham"
              role="button"
              :aria-expanded="isProductMenuOpen"
              :class="
                currentRouteName == 'product' || route.path.startsWith('/san-pham') ? 'active' : ''
              "
              @click="toggleProductMenu"
              >Sản phẩm <i class="ti-angle-down"></i
            ></a>
            <ul class="dropdown-menu" :class="{ show: isProductMenuOpen }">
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  :class="{
                    active: route.path.startsWith('/san-pham/phong-khach'),
                    show: activeProductSubmenu === 'living'
                  }"
                  :aria-expanded="activeProductSubmenu === 'living'"
                  href="/san-pham/phong-khach"
                  @click="toggleProductSubmenu($event, 'living')"
                  ><span>Phòng khách <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu" :class="{ show: activeProductSubmenu === 'living' }">
                  <li>
                    <a href="/san-pham/phong-khach/sofa" class="dropdown-item"
                      ><span>Sofa gỗ</span></a
                    >
                  </li>
                  <li>
                    <a href="/san-pham/phong-khach/ban-tra" class="dropdown-item"
                      ><span>Bàn trà</span></a
                    >
                  </li>
                  <li>
                    <a href="/san-pham/phong-khach/ke-ti-vi" class="dropdown-item"
                      ><span>Kệ ti vi</span></a
                    >
                  </li>
                </ul>
              </li>
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  :class="{
                    active: route.path.startsWith('/san-pham/phong-ngu'),
                    show: activeProductSubmenu === 'bedroom'
                  }"
                  :aria-expanded="activeProductSubmenu === 'bedroom'"
                  href="/san-pham/phong-ngu"
                  @click="toggleProductSubmenu($event, 'bedroom')"
                  ><span>Phòng ngủ <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu" :class="{ show: activeProductSubmenu === 'bedroom' }">
                  <li>
                    <a href="/san-pham/phong-ngu/giuong-ngu" class="dropdown-item"
                      ><span>Giường ngủ</span></a
                    >
                  </li>
                  <li>
                    <a href="/san-pham/phong-ngu/tu-quan-ao" class="dropdown-item"
                      ><span>Tủ quần áo</span></a
                    >
                  </li>
                  <li>
                    <a href="/san-pham/phong-ngu/ke-trang-diem" class="dropdown-item"
                      ><span>Kệ trang điểm</span></a
                    >
                  </li>
                </ul>
              </li>
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  :class="{
                    active: route.path.startsWith('/san-pham/phong-bep'),
                    show: activeProductSubmenu === 'kitchen'
                  }"
                  :aria-expanded="activeProductSubmenu === 'kitchen'"
                  href="/san-pham/phong-bep"
                  @click="toggleProductSubmenu($event, 'kitchen')"
                  ><span>Phòng bếp <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu" :class="{ show: activeProductSubmenu === 'kitchen' }">
                  <li>
                    <a href="/san-pham/phong-bep/ban-an" class="dropdown-item"
                      ><span>Bàn ăn</span></a
                    >
                  </li>
                  <li>
                    <a href="/san-pham/phong-bep/tu-bep" class="dropdown-item"
                      ><span>Tủ bếp<picture></picture></span
                    ></a>
                  </li>
                </ul>
              </li>
            </ul>
          </li>
          <li class="nav-item">
            <a class="nav-link" :class="currentRouteName == 'project' ? 'active' : ''" href="/du-an"
              >Dự án</a
            >
          </li>
          <li class="nav-item">
            <RouterLink
              class="nav-link"
              :class="currentRouteName == 'gallery' ? 'active' : ''"
              to="/thu-vien"
              >Thư viện</RouterLink
            >
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/tin-tuc" :class="currentRouteName == 'news' ? 'active' : ''"
              >Tin tức</a
            >
          </li>
          <li class="nav-item">
            <a
              class="nav-link"
              :class="currentRouteName == 'contacts' ? 'active' : ''"
              href="/lien-he"
              >Liên hệ</a
            >
          </li>
          <li class="nav-item navbar-consultation-item">
            <RouterLink
              class="navbar-consultation"
              :to="{ name: 'home', hash: '#consultation' }"
              active-class="navbar-consultation--active"
              exact-active-class="navbar-consultation--active"
            >
              Đặt lịch tư vấn
            </RouterLink>
          </li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<style scoped>
.navbar::before {
  position: absolute;
  inset: 0 0 auto;
  height: 138px;
  background: linear-gradient(180deg, rgba(13, 12, 10, 0.64) 0%, rgba(13, 12, 10, 0) 100%);
  content: '';
  pointer-events: none;
  transition: opacity 0.35s ease;
}

.navbar.nav-scroll::before {
  opacity: 0;
}

.navbar .container {
  position: relative;
  z-index: 1;
}

@media (min-width: 1200px) {
  .navbar .navbar-nav .nav-link {
    font-size: 14px;
    letter-spacing: 2.1px;
  }
}

.logo-wordmark {
  display: block;
  width: 100%;
  padding: 20px 0;
  color: #aa8453;
  font-family: 'Gilda Display', serif;
  font-size: 27px;
  font-weight: 400;
  line-height: 1.2;
  letter-spacing: 1px;
  text-align: center;
}

.navbar-consultation-item {
  display: flex;
  align-items: center;
  margin-left: 12px;
}

.navbar-consultation {
  display: inline-flex;
  min-height: 44px;
  align-items: center;
  justify-content: center;
  padding: 0 20px;
  border: 1px solid rgba(255, 255, 255, 0.62);
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  transition:
    border-color 0.3s ease,
    background 0.3s ease,
    color 0.3s ease;
}

.navbar-consultation:hover,
.navbar-consultation:focus-visible,
.navbar-consultation--active {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

.navbar-consultation:focus-visible {
  outline: 2px solid #fff;
  outline-offset: 3px;
}

.nav-scroll .navbar-consultation {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

@media (max-width: 1199.98px) and (min-width: 992px) {
  .navbar .navbar-nav .nav-link {
    padding-right: 8px;
    padding-left: 8px;
    font-size: 13px;
    letter-spacing: 2px;
  }

  .navbar-consultation-item {
    margin-left: 6px;
  }

  .navbar-consultation {
    padding: 0 14px;
    font-size: 11px;
  }
}

@media (max-width: 991.98px) {
  .navbar::before {
    height: 110px;
  }

  .navbar-consultation-item {
    display: block;
    margin: 14px 0 0;
  }

  .navbar-consultation {
    width: 100%;
    border-color: #aa8453;
    background: #aa8453;
    color: #fff;
  }
}
</style>
