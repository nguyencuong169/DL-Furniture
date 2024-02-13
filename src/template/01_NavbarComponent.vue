<script setup lang="ts">
import { useRoute } from 'vue-router'
import { computed } from 'vue'

const route = useRoute()
const currentRouteName = computed(() => route.name)
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
      <div class="collapse navbar-collapse" id="navbar">
        <ul class="navbar-nav ms-auto">
          <li class="nav-item">
            <a class="nav-link" href="/">Home</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/about">Giới thiệu</a>
          </li>
          <li class="nav-item dropdown">
            <a
              class="nav-link dropdown-toggle"
              href="#"
              role="button"
              data-bs-toggle="dropdown"
              data-bs-auto-close="outside"
              aria-expanded="false"
              >Sản phẩm <i class="ti-angle-down"></i
            ></a>
            <ul class="dropdown-menu">
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="outside"
                  aria-expanded="false"
                  href="/product/phong-khach"
                  ><span>Phòng khách <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="/product/phong-khach/1" class="dropdown-item"><span>Sofa gỗ</span></a>
                  </li>
                  <li>
                    <a href="/product/phong-khach/2" class="dropdown-item"><span>Bàn trà</span></a>
                  </li>
                  <li>
                    <a href="/product/phong-khach/3" class="dropdown-item"><span>Kệ ti vi</span></a>
                  </li>
                </ul>
              </li>
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="outside"
                  aria-expanded="false"
                  href="/product/phong-ngu"
                  ><span>Phòng ngủ <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="/product/phong-ngu/1" class="dropdown-item"><span>Giường ngủ</span></a>
                  </li>
                  <li>
                    <a href="/product/phong-ngu/2" class="dropdown-item"><span>Tủ quần áo</span></a>
                  </li>
                  <li>
                    <a href="/product/phong-ngu/3" class="dropdown-item"
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
                  href="/product/phong-bep"
                  ><span>Phòng bếp <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="/product/phong-bep/1" class="dropdown-item"><span>Bàn ghế ăn</span></a>
                  </li>
                  <li>
                    <a href="/product/phong-bep/2" class="dropdown-item"
                      ><span>Tủ bếp<picture></picture></span
                    ></a>
                  </li>
                </ul>
              </li>
            </ul>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/project">Dự án</a>
          </li>
          <li class="nav-item">
            <a class="nav-link" href="/gallery">Thư viện</a>
          </li>
          <li class="nav-item dropdown">
            <a
              class="nav-link dropdown-toggle"
              href="#"
              role="button"
              data-bs-toggle="dropdown"
              data-bs-auto-close="outside"
              aria-expanded="false"
              >Pages <i class="ti-angle-down"></i
            ></a>
            <ul class="dropdown-menu">
              <li>
                <a href="services.html" class="dropdown-item"><span>Services</span></a>
              </li>
              <li>
                <a href="facilities.html" class="dropdown-item"><span>Facilities</span></a>
              </li>
              <li>
                <a href="gallery.html" class="dropdown-item"><span>Gallery</span></a>
              </li>
              <li>
                <a href="team.html" class="dropdown-item"><span>Team</span></a>
              </li>
              <li>
                <a href="pricing.html" class="dropdown-item"><span>Pricing</span></a>
              </li>
              <li>
                <a href="careers.html" class="dropdown-item"><span>Careers</span></a>
              </li>
              <li>
                <a href="faq.html" class="dropdown-item"><span>F.A.Qs</span></a>
              </li>
              <li class="dropdown-submenu dropdown">
                <a
                  class="dropdown-item dropdown-toggle"
                  data-bs-toggle="dropdown"
                  data-bs-auto-close="outside"
                  aria-expanded="false"
                  href="#"
                  ><span>Other Pages <i class="ti-angle-right"></i></span
                ></a>
                <ul class="dropdown-menu">
                  <li>
                    <a href="404.html" class="dropdown-item"><span>404 Page</span></a>
                  </li>
                  <li>
                    <a href="coming-soon.html" class="dropdown-item"><span>Coming Soon</span></a>
                  </li>
                </ul>
              </li>
            </ul>
          </li>
          <li class="nav-item dropdown">
            <a
              class="nav-link dropdown-toggle"
              href="#"
              role="button"
              data-bs-toggle="dropdown"
              data-bs-auto-close="outside"
              aria-expanded="false"
              >News <i class="ti-angle-down"></i
            ></a>
            <ul class="dropdown-menu">
              <li>
                <a href="news.html" class="dropdown-item"><span>News 1</span></a>
              </li>
              <li>
                <a href="news2.html" class="dropdown-item"><span>News 2</span></a>
              </li>
              <li>
                <a href="post.html" class="dropdown-item"><span>Post Page</span></a>
              </li>
            </ul>
          </li>
          <li class="nav-item"><a class="nav-link" href="contact.html">Contact</a></li>
        </ul>
      </div>
    </div>
  </nav>
</template>

<style scoped></style>
