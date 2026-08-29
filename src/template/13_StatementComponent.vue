<script setup lang="ts"></script>

<template>
  <section class="dl-statement" aria-label="Triết lý kiến tạo của D&L Furniture">
    <div class="container dl-statement-container">
      <p class="section-subtitle"><span>Triết lý kiến tạo</span></p>
      <blockquote class="dl-statement-quote">
        Không gian đẹp không nằm ở sự cầu kỳ,<br />
        mà nằm ở sự tận tâm trong từng chi tiết.
      </blockquote>
      <p class="dl-statement-note">
        Ở D&amp;L, mỗi đường vân gỗ, mỗi mối ghép đều có lý do tồn tại — và lý do đó bắt đầu từ
        cách bạn sống.
      </p>
    </div>
  </section>
</template>

<style scoped>
.dl-statement {
  position: relative;
  padding: 96px 0 100px;
  background: #f1ede6;
  text-align: center;
}

/* Đồng bộ khung 1140px chuẩn Cappa */
.dl-statement-container {
  width: 100%;
  max-width: 1140px;
  margin-right: auto;
  margin-left: auto;
  padding-right: 15px;
  padding-left: 15px;
}

@media (min-width: 576px) {
  .dl-statement-container {
    max-width: 540px;
  }
}

@media (min-width: 768px) {
  .dl-statement-container {
    max-width: 720px;
  }
}

@media (min-width: 992px) {
  .dl-statement-container {
    max-width: 960px;
  }
}

@media (min-width: 1200px) {
  .dl-statement-container {
    max-width: 1140px;
  }
}

.dl-statement .section-subtitle {
  margin-bottom: 18px;
}

.dl-statement-quote {
  margin: 0;
  color: #221f1a;
  font-family: 'Gilda Display', serif;
  font-size: clamp(30px, 4vw, 48px);
  font-weight: 400;
  letter-spacing: -0.01em;
  line-height: 1.35;
}

.dl-statement-note {
  max-width: 640px;
  margin: 26px auto 0;
  color: #6e6962;
  font-size: 15px;
  line-height: 1.8;
}

.dl-statement::before,
.dl-statement::after {
  position: absolute;
  left: 50%;
  width: 64px;
  height: 2px;
  transform: translateX(-50%);
  background: linear-gradient(90deg, #aa8453, #d7b98a);
  content: '';
}

.dl-statement::before {
  top: 48px;
}

.dl-statement::after {
  bottom: 50px;
}

@media (max-width: 767.98px) {
  .dl-statement {
    padding: 80px 0 84px;
  }
}

@media (max-width: 575.98px) {
  .dl-statement {
    padding: 72px 0 76px;
  }
}
</style>