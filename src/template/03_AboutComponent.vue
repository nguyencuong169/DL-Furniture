<script setup lang="ts"></script>

<template>
  <section class="about home-about section-padding" aria-labelledby="home-about-title">
    <div class="container">
      <div class="row align-items-center">
        <div class="col-lg-6 mb-30">
          <div class="section-subtitle">D&L Furniture</div>
          <h2 id="home-about-title" class="section-title">
            Không gian được thiết kế từ cách bạn sống
          </h2>
          <p class="home-about-intro">
            Mỗi dự án bắt đầu bằng việc lắng nghe nhu cầu, khảo sát hiện trạng và nhận diện những
            thói quen tạo nên nhịp sống riêng của gia chủ. Từ đó,
            <strong>D&L Furniture</strong> phát triển giải pháp cân bằng giữa thẩm mỹ, công năng và
            cảm giác sử dụng lâu dài.
          </p>

          <ul class="home-about-signals" aria-label="Cách D&L Furniture tiếp cận mỗi dự án">
            <li>
              <span>01</span>
              <strong>Khảo sát thực tế</strong>
              <small>Đọc đúng hiện trạng trước khi đề xuất.</small>
            </li>
            <li>
              <span>02</span>
              <strong>Cá nhân hóa công năng</strong>
              <small>Thiết kế theo thói quen của gia chủ.</small>
            </li>
            <li>
              <span>03</span>
              <strong>Một đầu mối xuyên suốt</strong>
              <small>Kết nối thiết kế, sản xuất và lắp đặt.</small>
            </li>
          </ul>

          <div class="home-about-actions">
            <RouterLink class="home-about-link" to="/gioi-thieu">
              Câu chuyện D&amp;L <i class="ti-arrow-right" aria-hidden="true"></i>
            </RouterLink>
            <a class="home-about-phone" href="tel:+84961109897">
              <i class="flaticon-call" aria-hidden="true"></i>
              <span>Tư vấn trực tiếp <strong>(+84) 961-109-897</strong></span>
            </a>
          </div>
        </div>

        <div class="col-lg-5 offset-lg-1">
          <div class="home-about-visuals">
            <figure class="home-about-visual home-about-visual--primary">
              <img
                src="/media/gallery/villa-art-wall.webp"
                alt="Không gian nội thất biệt thự với tủ gỗ và mảng tường nghệ thuật"
                width="700"
                height="900"
                loading="lazy"
                decoding="async"
              />
            </figure>
            <figure class="home-about-visual home-about-visual--secondary">
              <img
                src="/media/gallery/villa-bedroom-earth.webp"
                alt="Phòng ngủ được tổ chức theo tỷ lệ và thói quen sử dụng"
                width="620"
                height="760"
                loading="lazy"
                decoding="async"
              />
            </figure>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-about {
  padding: 68px 0 70px;
  background: #fff;
}

.home-about .section-title {
  max-width: 560px;
  margin-bottom: 18px;
}

.home-about-intro {
  max-width: 590px;
  margin-bottom: 24px;
  color: #595550;
  font-size: 17px;
  line-height: 1.85;
}

.home-about-signals {
  display: grid;
  grid-template-columns: repeat(3, minmax(0, 1fr));
  gap: 0;
  padding: 0;
  margin: 0;
  border-top: 1px solid #e9e3da;
  list-style: none;
}

.home-about-signals li {
  display: flex;
  min-width: 0;
  flex-direction: column;
  padding: 16px 17px 15px;
  border-bottom: 1px solid #e9e3da;
  border-right: 1px solid #e9e3da;
}

.home-about-signals li:first-child {
  padding-left: 0;
}

.home-about-signals li:last-child {
  padding-right: 0;
  border-right: 0;
}

.home-about-signals li > span {
  margin-bottom: 8px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.14em;
}

.home-about-signals strong {
  color: #292621;
  font-family: 'Gilda Display', serif;
  font-size: 17px;
  font-weight: 400;
  line-height: 1.25;
}

.home-about-signals small {
  margin-top: 3px;
  color: #68625c;
  font-size: 14px;
  line-height: 1.5;
}

.home-about-actions {
  display: flex;
  align-items: center;
  gap: 28px;
  margin-top: 23px;
}

.home-about-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 6px;
  border-bottom: 1px solid rgba(170, 132, 83, 0.45);
  color: #89673d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}

.home-about-phone {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  color: #555;
  font-size: 12px;
  line-height: 1.35;
}

.home-about-phone i {
  color: #aa8453;
  font-size: 25px;
}

.home-about-phone span,
.home-about-phone strong {
  display: block;
}

.home-about-phone strong {
  color: #292621;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  font-weight: 500;
  letter-spacing: 0.04em;
}

.home-about-visuals {
  position: relative;
  min-height: 400px;
}

.home-about-visual {
  position: absolute;
  overflow: hidden;
  margin: 0;
  background: #eee9e2;
}

.home-about-visual img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.home-about-visual--primary {
  top: 0;
  right: 0;
  width: 61%;
  height: 345px;
}

.home-about-visual--secondary {
  bottom: 0;
  left: 0;
  width: 55%;
  height: 265px;
  border: 11px solid #fff;
}

.home-about-link:hover,
.home-about-link:focus-visible,
.home-about-phone:hover,
.home-about-phone:focus-visible {
  color: #aa8453;
}

.home-about-link:focus-visible,
.home-about-phone:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 5px;
}

@media (max-width: 991.98px) {
  .home-about-signals {
    max-width: 720px;
  }

  .home-about-visuals {
    min-height: 470px;
    margin-top: 34px;
  }
}

@media (max-width: 575.98px) {
  .home-about {
    padding: 68px 0;
  }

  .home-about .section-title {
    font-size: 40px;
  }

  .home-about-intro {
    font-size: 15px;
  }

  .home-about-signals {
    grid-template-columns: 1fr;
  }

  .home-about-signals li,
  .home-about-signals li:first-child,
  .home-about-signals li:last-child {
    padding: 13px 0;
    border-right: 0;
  }

  .home-about-actions {
    align-items: flex-start;
    flex-direction: column;
    gap: 21px;
  }

  .home-about-visuals {
    min-height: 390px;
  }

  .home-about-visual--primary {
    width: 69%;
    height: 330px;
  }

  .home-about-visual--secondary {
    width: 58%;
    height: 245px;
    border-width: 9px;
  }
}
</style>
