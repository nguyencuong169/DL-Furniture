<script setup lang="ts">
import { useRoute } from 'vue-router'
import { computed, onMounted, ref, watch } from 'vue'
import {
  FALLBACK_MENU,
  fetchMenus,
  type MenuLink,
  type MenuResponse,
} from '../api/menuClient'

const route = useRoute()
const navbarToggler = ref<HTMLButtonElement | null>(null)
const navbarCollapse = ref<HTMLElement | null>(null)
const isProductMenuOpen = ref(false)
const activeProductSubmenu = ref<number | null>(null)

const menu = ref<MenuResponse>(FALLBACK_MENU)
const primaryMenu = computed(() => menu.value.primary)
const consultationLink = computed(() => menu.value.consultation)

onMounted(async () => {
  menu.value = await fetchMenus()
})

/**
 * Kiểm tra 1 đường dẫn có đang active hay không —
 * phủ cả trang chi tiết/con (vd: /tin-tuc/:id sáng menu Tin tức,
 * /san-pham/detail/:id sáng menu Sản phẩm).
 */
const isPathActive = (path: string): boolean => {
  const normalized = path.replace(/\/+$/, '') || '/'
  if (normalized === '/') return route.path === '/'
  return route.path === normalized || route.path.startsWith(normalized + '/')
}

/**
 * Menu item active khi chính nó hoặc 1 trong các mục con active
 * (giữ trạng thái sáng cho cả nhóm dropdown lẫn submenu).
 */
const isItemActive = (item: MenuLink): boolean => {
  if (isPathActive(item.url)) return true
  return item.children?.some((child) => isItemActive(child)) ?? false
}

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

const toggleProductSubmenu = (event: MouseEvent, submenu: number) => {
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
          <li
            v-for="item in primaryMenu"
            :key="item.url"
            class="nav-item"
            :class="{ dropdown: item.children && item.children.length > 0 }"
          >
            <RouterLink
              v-if="!item.children || item.children.length === 0"
              class="nav-link"
              :to="item.url"
              :class="isItemActive(item) ? 'active' : ''"
            >{{ item.label }}</RouterLink
            >
            <template v-else>
              <a
                class="nav-link dropdown-toggle"
                :href="item.url"
                role="button"
                :aria-expanded="isProductMenuOpen"
                :class="isItemActive(item) ? 'active' : ''"
                @click="toggleProductMenu"
              >{{ item.label }} <i class="ti-angle-down"></i
              ></a>
              <ul class="dropdown-menu" :class="{ show: isProductMenuOpen }">
                <li
                  v-for="(group, groupIndex) in item.children"
                  :key="group.url"
                  class="dropdown-submenu dropdown"
                >
                  <a
                    class="dropdown-item dropdown-toggle"
                    :class="{
                      active: isItemActive(group),
                      show: activeProductSubmenu === groupIndex,
                    }"
                    :aria-expanded="activeProductSubmenu === groupIndex"
                    :href="group.url"
                    @click="toggleProductSubmenu($event, groupIndex)"
                  ><span>{{ group.label }} <i class="ti-angle-right"></i></span
                  ></a>
                  <ul class="dropdown-menu" :class="{ show: activeProductSubmenu === groupIndex }">
                    <li v-for="child in group.children || []" :key="child.url">
                      <RouterLink :to="child.url" class="dropdown-item"
                        ><span>{{ child.label }}</span></RouterLink
                      >
                    </li>
                  </ul>
                </li>
              </ul>
            </template>
          </li>
          <li class="nav-item navbar-consultation-item">
            <RouterLink
              class="navbar-consultation"
              :to="consultationLink.url"
              active-class="navbar-consultation--active"
              exact-active-class="navbar-consultation--active"
            >
              {{ consultationLink.label }}
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
  border: 1px solid #aa8453;
  background: #aa8453;
  box-shadow: 0 8px 22px rgba(67, 46, 24, 0.14);
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.16em;
  text-transform: uppercase;
  transition:
    border-color 0.3s ease,
    background 0.3s ease,
    box-shadow 0.3s ease,
    color 0.3s ease,
    transform 0.3s ease;
}

.navbar-consultation:hover,
.navbar-consultation:focus-visible {
  border-color: #c49a66;
  background: #c49a66;
  box-shadow: 0 12px 28px rgba(67, 46, 24, 0.24);
  color: #fff;
  transform: translateY(-2px);
}

.navbar-consultation:focus-visible {
  outline: 2px solid #e0bd8e;
  outline-offset: 3px;
}

.nav-scroll .navbar-consultation {
  border-color: #aa8453;
  background: #aa8453;
  color: #fff;
}

.nav-scroll .navbar-consultation:hover,
.nav-scroll .navbar-consultation:focus-visible {
  border-color: #c49a66;
  background: #c49a66;
}

@media (prefers-reduced-motion: reduce) {
  .navbar-consultation {
    transition: none;
  }

  .navbar-consultation:hover,
  .navbar-consultation:focus-visible {
    transform: none;
  }
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
