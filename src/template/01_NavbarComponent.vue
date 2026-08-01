<script setup lang="ts">
import { useRoute } from 'vue-router'
import { computed, ref, watch } from 'vue'

const route = useRoute()
const currentRouteName = computed(() => route.name)
const navbarToggler = ref<HTMLButtonElement | null>(null)
const navbarCollapse = ref<HTMLElement | null>(null)

const closeMobileMenu = () => {
  if (!navbarCollapse.value?.classList.contains('show')) return
  navbarToggler.value?.click()
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
        <a class="logo" href="index.html">
          <h2>D&L Furniture <span>Nội thất Dũng Linh</span></h2>
        </a>
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
        aria-label="Toggle navigation"
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
              href="#"
              role="button"
              data-bs-toggle="dropdown"
              data-bs-auto-close="outside"
              aria-expanded="false"
              :class="
                currentRouteName == 'product' || route.path.startsWith('/san-pham') ? 'active' : ''
              "
              >Sản phẩm <i class="ti-angle-down"></i
            ></a>
            <ul class="dropdown-menu">
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="outside"
                  aria-expanded="false"
                  href="/san-pham/phong-khach"
                  :class="route.path.startsWith('/san-pham/phong-khach') ? 'active' : ''"
                  ><span>Phòng khách <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
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
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="outside"
                  aria-expanded="false"
                  href="/san-pham/phong-ngu"
                  :class="route.path.startsWith('/san-pham/phong-ngu') ? 'active' : ''"
                  ><span>Phòng ngủ <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
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
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="outside"
                  aria-expanded="false"
                  href="/san-pham/phong-bep"
                  :class="route.path.startsWith('/san-pham/phong-bep') ? 'active' : ''"
                  ><span>Phòng bếp <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
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
        </ul>
      </div>
    </div>
  </nav>
</template>

<style scoped></style>
