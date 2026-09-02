<script setup lang="ts">
import { setPageSeo } from '../utils/seo'

setPageSeo({
  title: 'Không tìm thấy trang (404)',
  description:
    'Trang bạn tìm kiếm không tồn tại trên D&L Furniture. Hãy quay về trang chủ hoặc xem các sản phẩm và dự án của chúng tôi.'
})
</script>

<template>
  <main>
    <!-- 404 Page -->
    <section class="comming section-padding">
      <div class="v-middle">
        <div class="container">
          <div class="row">
            <div class="col-md-12 text-center">
              <h1>404</h1>
              <h2>Không tìm thấy trang</h2>
            </div>
          </div>
          <div class="row text-center">
            <div class="col-md-6 offset-md-3 text-center">
              <p>
                Trang bạn đang tìm kiếm đã bị di chuyển, xóa, đổi tên hoặc chưa bao giờ tồn tại.
              </p>
              <div class="butn-light mt-30 mb-30">
                <RouterLink to="/">
                  <span>Về trang chủ</span>
                </RouterLink>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style></style>
