<script setup lang="ts"></script>

<template>
  <section class="about section-padding">
    <div class="container">
      <div class="row">
        <div class="col-md-6 mb-30 animate-box" data-animate-effect="fadeInUp">
          <span class="hero-line" aria-hidden="true"></span>
          <p class="section-subtitle"><span>D&L Furniture</span></p>
          <div class="section-title">Không gian được thiết kế từ cách bạn sống</div>
          <p>
            Mỗi dự án bắt đầu bằng việc lắng nghe nhu cầu, khảo sát hiện trạng và nhận diện những
            thói quen tạo nên nhịp sống riêng của gia chủ. Từ đó,
            <strong>D&L Furniture</strong> phát triển giải pháp cân bằng giữa thẩm mỹ, công năng và
            cảm giác sử dụng lâu dài.
          </p>
          <p>
            Vật liệu, tỷ lệ và từng điểm tiếp xúc được đặt trong cùng một hệ ngôn ngữ để nội thất
            trở thành một phần tự nhiên của kiến trúc — chỉn chu nhưng không phô trương.
          </p>
          <!-- call -->
          <div class="reservations">
            <div class="icon"><span class="flaticon-call"></span></div>
            <div class="text">
              <p>Tư vấn thiết kế</p>
              <a href="tel:+84961109897">(+84) 961-109-897</a>
            </div>
          </div>
        </div>
        <div class="col col-md-3 animate-box" data-animate-effect="fadeInUp">
          <img src="@/assets/img/intros/intro3.jpg" alt="" />
        </div>
        <div class="col col-md-3 animate-box" data-animate-effect="fadeInUp">
          <img src="@/assets/img/intros/intro4.jpg" alt="" class="mt-90 mb-30" />
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.about .hero-line {
  display: block;
  width: 64px;
  height: 2px;
  margin-bottom: 22px;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
}
</style>
