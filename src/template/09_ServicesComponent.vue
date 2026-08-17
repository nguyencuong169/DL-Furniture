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
    description:
      'Kiểm tra kích thước, mối ghép, bề mặt hoàn thiện và sự đồng đều giữa các module.'
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
    description:
      'Bàn giao hướng dẫn sử dụng, phạm vi bảo hành và đầu mối tiếp nhận khi cần hỗ trợ.'
  }
]
</script>

<template>
  <section id="home-process" class="home-process section-padding" aria-labelledby="process-title">
    <div class="container">
      <header class="home-process-heading">
        <div>
          <p class="section-subtitle">Từ ý tưởng đến bàn giao</p>
          <h2 id="process-title" class="section-title">Một quy trình, một đầu mối xuyên suốt</h2>
        </div>
        <p>
          Mỗi giai đoạn có mục tiêu và điểm kiểm soát rõ ràng để ý tưởng thiết kế không bị đứt gãy
          khi chuyển sang sản xuất và thi công.
        </p>
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
          <figcaption>
            <span>Kỹ nghệ D&amp;L</span>
            Kiểm soát từ bản vẽ đến bề mặt hoàn thiện.
          </figcaption>
        </figure>

        <ol class="home-process-list">
          <li v-for="step in processSteps" :key="step.number">
            <span class="home-process-number" aria-hidden="true">{{ step.number }}</span>
            <div>
              <h3>{{ step.title }}</h3>
              <p>{{ step.description }}</p>
            </div>
          </li>
        </ol>
      </div>

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
  </section>
</template>

<style scoped>
.home-process {
  padding: 78px 0 82px;
  scroll-margin-top: 100px;
  background: #f7f4ef;
}

.home-process > .container {
  width: min(1280px, calc(100% - 60px));
  max-width: none;
  padding: 0;
}

.home-process-heading {
  display: grid;
  grid-template-columns: minmax(0, 1.25fr) minmax(300px, 0.75fr);
  align-items: end;
  gap: 70px;
  margin-bottom: 32px;
}

.home-process-heading .section-title {
  max-width: 720px;
  margin-bottom: 0;
}

.home-process-heading > p {
  margin: 0 0 5px;
  color: #6c675f;
  font-size: 16px;
  line-height: 1.8;
}

.home-process-layout {
  display: grid;
  grid-template-columns: minmax(320px, 0.78fr) minmax(0, 1.22fr);
  gap: 50px;
}

.home-process-media {
  position: relative;
  min-height: 550px;
  margin: 0;
  overflow: hidden;
  background: #24211d;
}

.home-process-media::after {
  position: absolute;
  inset: 45% 0 0;
  background: linear-gradient(0deg, rgba(14, 12, 10, 0.82), transparent);
  content: '';
  pointer-events: none;
}

.home-process-media img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.home-process-media figcaption {
  position: absolute;
  z-index: 1;
  right: 34px;
  bottom: 31px;
  left: 34px;
  color: rgba(255, 255, 255, 0.82);
  font-family: 'Gilda Display', serif;
  font-size: 21px;
  line-height: 1.35;
}

.home-process-media figcaption span {
  display: block;
  margin-bottom: 8px;
  color: #d5ae7c;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.home-process-list {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  align-content: start;
  gap: 0 34px;
  padding: 0;
  margin: 0;
  list-style: none;
}

.home-process-list li {
  display: grid;
  min-height: 175px;
  grid-template-columns: 44px 1fr;
  gap: 15px;
  padding: 24px 0;
  border-top: 1px solid #dbd3c9;
}

.home-process-number {
  padding-top: 3px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.17em;
}

.home-process-list h3 {
  margin: 0 0 12px;
  color: #28241f;
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  font-weight: 400;
  line-height: 1.25;
}

.home-process-list p {
  margin: 0;
  color: #625d56;
  font-size: 15px;
  line-height: 1.75;
}

.home-process-footer {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 36px;
  padding-top: 32px;
  margin-top: 0;
  border-top: 1px solid #d5ccc0;
}

.home-process-footer > p {
  margin: 0;
  color: #2c2924;
  font-family: 'Gilda Display', serif;
  font-size: 22px;
}

.home-process-footer > div {
  display: flex;
  align-items: center;
  gap: 25px;
}

.home-process-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  padding-bottom: 7px;
  border-bottom: 1px solid rgba(170, 132, 83, 0.5);
  color: #89673d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 500;
  letter-spacing: 0.13em;
  text-transform: uppercase;
}

.home-process-link--muted {
  border-color: transparent;
  color: #5e5952;
}

.home-process-link:hover,
.home-process-link:focus-visible {
  border-color: #aa8453;
  color: #aa8453;
}

.home-process-link:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 5px;
}

@media (max-width: 991.98px) {
  .home-process-heading {
    grid-template-columns: 1fr;
    gap: 18px;
  }

  .home-process-layout {
    grid-template-columns: 1fr;
    gap: 34px;
  }

  .home-process-media {
    min-height: 0;
    aspect-ratio: 16 / 9;
  }
}

@media (max-width: 767.98px) {
  .home-process {
    padding: 68px 0;
  }

  .home-process > .container {
    width: calc(100% - 30px);
  }

  .home-process-heading .section-title {
    font-size: 40px;
  }

  .home-process-list {
    grid-template-columns: 1fr;
  }

  .home-process-list li {
    min-height: 0;
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

@media (max-width: 575.98px) {
  .home-process-media {
    aspect-ratio: 4 / 3;
  }

  .home-process-media figcaption {
    right: 24px;
    bottom: 22px;
    left: 24px;
    font-size: 18px;
  }
}
</style>
