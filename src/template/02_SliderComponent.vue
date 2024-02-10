<script setup lang="ts">
import { reactive } from 'vue'

const state = reactive({
  overlayDark: 2
})
</script>

<template>
  <header class="header slider-fade">
    <div class="owl-carousel owl-theme">
      <!-- The opacity on the image is made with "data-overlay-dark="number". You can change it using the numbers 0-9. -->
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        data-background="https://dl-furniture.netlify.app/assets/2-xOjvuLYK.jpg"
      >
        <img src="../assets/img/slider/2.jpg" v-show="false" />
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-10 offset-md-1">
                <span>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                </span>
                <h4>Thiết kế & thi công</h4>
                <h1>
                  Phong cách <br />
                  thiết kế đa dạng
                </h1>
                <div class="butn-light mt-30 mb-30">
                  <a href="#" data-scroll-nav="1"><span>Khám phá ngay</span></a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        data-background="https://dl-furniture.netlify.app/assets/3-DTrcElLx.jpg"
      >
        <img src="../assets/img/slider/3.jpg" v-show="false" />
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-10 offset-md-1">
                <span>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                </span>
                <h4>Sựa lựa chọn tốt nhất</h4>
                <h1>Biến ước mơ thành hiện thực</h1>
                <div class="butn-light mt-30 mb-30">
                  <a href="#" data-scroll-nav="1"><span>Khám phá ngay</span></a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div
        class="text-center item bg-img"
        :data-overlay-dark="state.overlayDark"
        data-background="https://dl-furniture.netlify.app/assets/1-FQ5yJaaV.jpg"
      >
        <img src="../assets/img/slider/1.jpg" v-show="false" />
        <div class="v-middle caption">
          <div class="container">
            <div class="row">
              <div class="col-md-10 offset-md-1">
                <span>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                  <i class="star-rating"></i>
                </span>
                <h4>Trải nghiệm sống đích thực</h4>
                <h1>
                  Không gian <br />
                  tiện nghi đẳng cấp
                </h1>
                <div class="butn-light mt-30 mb-30">
                  <a href="#" data-scroll-nav="1"><span>Khám phá ngay</span></a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <!-- slider reservation -->
    <div class="reservation">
      <a href="tel:8551004444">
        <div class="icon d-flex justify-content-center align-items-center">
          <i class="flaticon-call"></i>
        </div>
        <div class="call"><span>(+84) 945-366-622</span> <br />Tư vấn thiết kế</div>
      </a>
    </div>
  </header>
</template>

<style scoped></style>
