<script setup lang="ts"></script>

<template>
  <section class="home-craft" aria-labelledby="home-craft-title">
    <div class="home-craft-media">
      <img
        src="/media/gallery/artisan-walnut-chair.webp"
        alt="Nghệ nhân hoàn thiện chi tiết nội thất gỗ óc chó"
        width="1672"
        height="941"
        loading="lazy"
        decoding="async"
      />
    </div>
    <div class="home-craft-content">
      <p class="home-craft-eyebrow">Kỹ nghệ D&amp;L Furniture</p>
      <h2 id="home-craft-title">Kỹ nghệ phía sau bề mặt hoàn thiện</h2>
      <p>
        Một chi tiết đẹp không chỉ được nhìn thấy. Nó được cảm nhận qua hướng vân, độ mịn của bề
        mặt, sự chính xác của mối ghép và chuyển động nhẹ nhàng trong từng thao tác sử dụng.
      </p>
      <ul>
        <li>Chọn phôi và cân sắc độ giữa các module.</li>
        <li>Kiểm soát mối ghép, cạnh tiếp xúc và bề mặt chạm.</li>
        <li>Hiệu chỉnh tại công trình theo điều kiện sử dụng thực tế.</li>
      </ul>
      <RouterLink to="/thu-vien" class="home-craft-link">
        Khám phá thư viện vật liệu <i class="ti-arrow-right" aria-hidden="true"></i>
      </RouterLink>
    </div>
  </section>
</template>

<style scoped>
.home-craft {
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(420px, 0.9fr);
  min-height: 540px;
  background: #1f1d1a;
}

.home-craft-media {
  min-height: 540px;
  overflow: hidden;
}

.home-craft-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.home-craft-content {
  display: flex;
  align-items: flex-start;
  flex-direction: column;
  justify-content: center;
  padding: 62px clamp(46px, 6vw, 90px);
}

.home-craft-eyebrow {
  margin: 0 0 18px;
  color: #c39a62;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.28em;
  text-transform: uppercase;
}

.home-craft h2 {
  max-width: 570px;
  margin: 0;
  color: #fff;
  font-family: 'Gilda Display', serif;
  font-size: clamp(44px, 4vw, 62px);
  font-weight: 400;
  line-height: 1.1;
}

.home-craft-content > p:not(.home-craft-eyebrow) {
  max-width: 590px;
  margin: 28px 0 0;
  color: rgba(255, 255, 255, 0.74);
  font-size: 16px;
  line-height: 1.85;
}

.home-craft ul {
  display: grid;
  gap: 13px;
  margin: 28px 0 0;
  padding: 0;
  list-style: none;
}

.home-craft li {
  position: relative;
  padding-left: 23px;
  color: rgba(255, 255, 255, 0.82);
  font-size: 16px;
}

.home-craft li::before {
  position: absolute;
  top: 9px;
  left: 0;
  width: 8px;
  height: 1px;
  background: #c39a62;
  content: '';
}

.home-craft-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-top: 36px;
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(195, 154, 98, 0.5);
  color: #c39a62;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.home-craft-link:hover {
  color: #fff;
}

@media (max-width: 991px) {
  .home-craft {
    grid-template-columns: minmax(0, 1fr);
  }

  .home-craft-media {
    min-height: 0;
    aspect-ratio: 16 / 9;
  }

  .home-craft-content {
    padding: 70px 48px;
  }
}

@media (max-width: 575px) {
  .home-craft-media {
    aspect-ratio: 4 / 3;
  }

  .home-craft-content {
    padding: 58px 24px 64px;
  }

  .home-craft h2 {
    font-size: 40px;
  }

  .home-craft-content > p:not(.home-craft-eyebrow) {
    font-size: 15px;
  }
}
</style>
