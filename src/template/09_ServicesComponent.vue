<script setup lang="ts">
const processSteps = [
  {
    number: '01',
    title: 'Lắng nghe & định hướng',
    description:
      'Làm rõ nhu cầu, phong cách, công năng ưu tiên và khung đầu tư phù hợp với gia đình.'
  },
  {
    number: '02',
    title: 'Khảo sát hiện trạng',
    description:
      'Đo đạc, ghi nhận kiến trúc, hạ tầng kỹ thuật và những điều kiện ảnh hưởng đến phương án.'
  },
  {
    number: '03',
    title: 'Phát triển thiết kế',
    description:
      'Thống nhất mặt bằng, ngôn ngữ vật liệu, tỷ lệ và các chi tiết cần kiểm soát khi sản xuất.'
  },
  {
    number: '04',
    title: 'Sản xuất & kiểm soát',
    description: 'Kiểm tra kích thước, mối ghép, bề mặt hoàn thiện và sự đồng đều giữa các module.'
  },
  {
    number: '05',
    title: 'Lắp đặt & hiệu chỉnh',
    description:
      'Tổ chức lắp đặt tại công trình, phối hợp các hạng mục và hiệu chỉnh theo sử dụng thực tế.'
  },
  {
    number: '06',
    title: 'Nghiệm thu & đồng hành',
    description: 'Bàn giao hướng dẫn sử dụng, phạm vi bảo hành và đầu mối tiếp nhận khi cần hỗ trợ.'
  }
]
</script>

<template>
  <section id="home-process" class="home-process section-padding" aria-labelledby="process-title">
    <div class="container home-process-container">
      <header class="home-process-heading">
        <div class="home-process-title-wrap">
          <p class="section-subtitle"><span>Quy trình kiểm soát</span></p>
          <h2 id="process-title" class="section-title">Từ ý tưởng đến bàn giao</h2>
        </div>
      </header>

      <div class="home-process-layout">
        <figure class="home-process-media">
          <img
            src="/media/gallery/walnut-joinery-detail.webp"
            alt="Chi tiết mối ghép gỗ được kiểm soát trong quá trình sản xuất nội thất"
            width="960"
            height="1200"
            loading="lazy"
            decoding="async"
          />
          <span class="home-process-media-number" aria-hidden="true">06</span>
          <figcaption>
            <span>Kỹ nghệ D&amp;L</span>
            Kiểm soát từ bản vẽ đến bề mặt hoàn thiện.
          </figcaption>
        </figure>

        <div class="home-process-body">
          <p class="home-process-intro">
            Mỗi giai đoạn có một mục tiêu, một đầu ra và một điểm kiểm soát rõ ràng. Nhờ đó, ý tưởng
            thiết kế được bảo toàn khi chuyển sang sản xuất, lắp đặt và bàn giao.
          </p>

          <ol class="home-process-list">
            <li v-for="step in processSteps" :key="step.number">
              <span class="home-process-number" aria-hidden="true">{{ step.number }}</span>
              <div>
                <h3>{{ step.title }}</h3>
                <p>{{ step.description }}</p>
              </div>
            </li>
          </ol>

          <footer class="home-process-footer">
            <p>Bạn đã có mặt bằng hoặc ý tưởng ban đầu?</p>
            <div>
              <RouterLink class="home-process-link" :to="{ name: 'home', hash: '#consultation' }">
                Đặt lịch tư vấn <i class="ti-arrow-right" aria-hidden="true"></i>
              </RouterLink>
              <RouterLink class="home-process-link home-process-link--muted" to="/du-an">
                Xem dự án đã hoàn thiện
              </RouterLink>
            </div>
          </footer>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-process {
  padding: 108px 0 110px;
  scroll-margin-top: 100px;
  background: #f1ede6;
}

.home-process-heading {
  padding-bottom: 41px;
  border-bottom: 1px solid #d1c8bb;
}

.home-process-title-wrap .section-title {
  margin-bottom: 0;
}

.home-process-layout {
  display: grid;
  grid-template-columns: minmax(330px, 0.68fr) minmax(0, 1.32fr);
  align-items: start;
  gap: clamp(48px, 6vw, 84px);
  margin-top: 56px;
}

.home-process-media {
  position: sticky;
  top: 118px;
  min-height: 730px;
  margin: 0;
  overflow: hidden;
  background: #24211d;
}

.home-process-media::after {
  position: absolute;
  inset: 35% 0 0;
  background: linear-gradient(0deg, rgba(14, 12, 10, 0.86), transparent);
  content: '';
  pointer-events: none;
}

.home-process-media img {
  display: block;
  width: 100%;
  height: 100%;
  min-height: 730px;
  object-fit: cover;
  filter: saturate(0.84) contrast(1.03);
  transition:
    filter 0.5s ease,
    transform 0.5s ease;
}

.home-process-media:hover img,
.home-process-media:focus-within img {
  filter: brightness(75%);
  transform: scale(1.09);
  transition:
    filter 1s ease,
    transform 1s ease;
}

.home-process-media-number {
  position: absolute;
  z-index: 1;
  top: 26px;
  right: 29px;
  color: rgba(255, 255, 255, 0.42);
  font-family: 'Gilda Display', serif;
  font-size: 78px;
  line-height: 1;
}

.home-process-media figcaption {
  position: absolute;
  z-index: 1;
  right: 36px;
  bottom: 34px;
  left: 36px;
  color: rgba(255, 255, 255, 0.86);
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  line-height: 1.35;
}

.home-process-media figcaption span {
  display: block;
  margin-bottom: 9px;
  color: #d5ae7c;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.19em;
  text-transform: uppercase;
}

.home-process-intro {
  max-width: 760px;
  margin: 0 0 34px;
  color: #59534c;
  font-size: 16px;
  line-height: 1.85;
}

.home-process-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  padding: 0;
  margin: 0;
  border-top: 1px solid #d1c8bb;
  border-left: 1px solid #d1c8bb;
  list-style: none;
}

.home-process-list li {
  display: grid;
  min-height: 218px;
  grid-template-columns: 52px minmax(0, 1fr);
  gap: 18px;
  padding: 34px 29px 31px;
  border-right: 1px solid #d1c8bb;
  border-bottom: 1px solid #d1c8bb;
}

.home-process-number {
  color: rgba(158, 119, 70, 0.58);
  font-family: 'Gilda Display', serif;
  font-size: 32px;
  line-height: 1;
}

.home-process-list h3 {
  margin: 0 0 13px;
  color: #28241f;
  font-family: 'Gilda Display', serif;
  font-size: 25px;
  font-weight: 400;
  line-height: 1.22;
}

.home-process-list p {
  margin: 0;
  color: #5f5951;
  font-size: 14px;
  line-height: 1.72;
}

.home-process-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 34px;
  padding-top: 34px;
  margin-top: 35px;
  border-top: 1px solid #d1c8bb;
}

.home-process-footer > p {
  /* max-width: 390px; */
  margin: 0;
  color: #2c2924;
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  line-height: 1.25;
}

.home-process-footer > div {
  display: flex;
  align-items: center;
  gap: 24px;
}

.home-process-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(137, 103, 61, 0.48);
  color: #89673d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.14em;
  text-transform: uppercase;
  transition:
    gap 0.3s ease,
    border-color 0.3s ease,
    color 0.3s ease;
}

.home-process-link--muted {
  border-color: transparent;
  color: #4f4a43;
}

.home-process-link:hover,
.home-process-link:focus-visible {
  gap: 15px;
  border-color: #8e6738;
  color: #8e6738;
}

.home-process-link:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 5px;
}

@media (max-width: 1199.98px) {
  .home-process-heading {
    grid-template-columns: minmax(0, 1fr) minmax(220px, 0.38fr);
  }

  .home-process-layout {
    grid-template-columns: minmax(300px, 0.62fr) minmax(0, 1.38fr);
    gap: 42px;
  }

  .home-process-media,
  .home-process-media img {
    min-height: 690px;
  }

  .home-process-list li {
    grid-template-columns: 42px minmax(0, 1fr);
    padding: 29px 22px 27px;
  }
}

@media (max-width: 991.98px) {
  .home-process-heading {
    grid-template-columns: 1fr;
  }

  .home-process-layout {
    grid-template-columns: 1fr;
  }

  .home-process-media {
    position: relative;
    top: auto;
    min-height: 0;
    aspect-ratio: 16 / 9;
  }

  .home-process-media img {
    min-height: 0;
  }
}

@media (max-width: 767.98px) {
  .home-process {
    padding: 76px 0;
  }

  .home-process-heading {
    padding-bottom: 31px;
  }

  .home-process-layout {
    gap: 38px;
    margin-top: 42px;
  }

  .home-process-media {
    aspect-ratio: 4 / 3;
  }

  .home-process-media-number {
    top: 19px;
    right: 21px;
    font-size: 58px;
  }

  .home-process-media figcaption {
    right: 24px;
    bottom: 22px;
    left: 24px;
    font-size: 19px;
  }

  .home-process-list {
    grid-template-columns: 1fr;
  }

  .home-process-list li {
    min-height: 0;
    grid-template-columns: 45px minmax(0, 1fr);
    padding: 27px 20px 25px;
  }

  .home-process-footer,
  .home-process-footer > div {
    align-items: flex-start;
    flex-direction: column;
  }

  .home-process-footer > div {
    gap: 18px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .home-process-media img,
  .home-process-link {
    transition: none;
  }
}
</style>
