<script setup lang="ts">
const collections = [
  {
    title: 'Phòng khách gỗ óc chó',
    description: 'Tỷ lệ cân bằng, vật liệu có chiều sâu và những điểm chạm được hoàn thiện chỉn chu.',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian phòng khách gỗ óc chó với bảng màu sáng',
    to: '/thu-vien'
  },
  {
    title: 'Phòng ngủ thư thái',
    description: 'Không gian nghỉ ngơi được tổ chức gọn gàng, ấm áp và phù hợp với nhịp sống riêng.',
    image: '/media/gallery/villa-bedroom-earth.webp',
    alt: 'Phòng ngủ với nội thất gỗ và bảng màu trung tính',
    to: '/thu-vien'
  },
  {
    title: 'Bếp và bàn ăn',
    description: 'Công năng liền mạch cùng chất liệu tự nhiên tạo nên trải nghiệm sum họp gần gũi.',
    image: '/media/gallery/arched-dining.jpg',
    alt: 'Bộ bàn ăn trong không gian nội thất có vòm cong',
    to: '/thu-vien'
  },
  {
    title: 'Hệ tủ và không gian làm việc',
    description: 'Giải pháp may đo tích hợp lưu trữ, làm việc và trưng bày trên cùng một mặt đứng.',
    image: '/media/gallery/walnut-home-library.webp',
    alt: 'Hệ tủ gỗ óc chó tích hợp bàn làm việc tại gia',
    to: '/du-an'
  }
]
</script>

<template>
  <section class="home-collection section-padding" aria-labelledby="home-collection-title">
    <div class="container">
      <div class="home-collection-heading">
        <div>
          <p class="section-subtitle">D&amp;L Furniture</p>
          <h2 id="home-collection-title" class="section-title">Bộ sưu tập được tuyển chọn</h2>
        </div>
        <RouterLink class="home-collection-all" to="/thu-vien">
          Khám phá toàn bộ bộ sưu tập <i class="ti-arrow-right" aria-hidden="true"></i>
        </RouterLink>
      </div>

      <div class="home-collection-grid">
        <article v-for="collection in collections" :key="collection.title" class="collection-card">
          <RouterLink :to="collection.to" class="collection-card-image">
            <img
              :src="collection.image"
              :alt="collection.alt"
              width="1600"
              height="1100"
              loading="lazy"
              decoding="async"
            />
          </RouterLink>
          <div class="collection-card-content">
            <p>Sản phẩm nổi bật</p>
            <h3>
              <RouterLink :to="collection.to">{{ collection.title }}</RouterLink>
            </h3>
            <span>{{ collection.description }}</span>
            <RouterLink :to="collection.to" class="collection-card-link">
              Xem chi tiết <i class="ti-arrow-right" aria-hidden="true"></i>
            </RouterLink>
          </div>
        </article>
      </div>
    </div>
  </section>
</template>

<style scoped>
.home-collection {
  background: #f8f5f0;
}

.home-collection-heading {
  display: flex;
  align-items: flex-end;
  justify-content: space-between;
  gap: 30px;
  margin-bottom: 42px;
}

.home-collection-heading .section-subtitle {
  margin-bottom: 6px;
}

.home-collection-heading .section-title {
  margin: 0;
}

.home-collection-all,
.collection-card-link {
  display: inline-flex;
  align-items: center;
  gap: 9px;
  color: #8e6c41;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.14em;
  text-transform: uppercase;
}

.home-collection-all {
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(170, 132, 83, 0.45);
}

.home-collection-grid {
  display: grid;
  grid-template-columns: repeat(2, minmax(0, 1fr));
  gap: 28px;
}

.collection-card {
  display: grid;
  grid-template-columns: minmax(0, 1.15fr) minmax(240px, 0.85fr);
  min-height: 360px;
  overflow: hidden;
  background: #fff;
}

.collection-card-image {
  min-width: 0;
  overflow: hidden;
}

.collection-card-image img {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.6s ease;
}

.collection-card:hover .collection-card-image img {
  transform: scale(1.035);
}

.collection-card-content {
  display: flex;
  align-items: flex-start;
  flex-direction: column;
  justify-content: center;
  padding: 34px 30px;
}

.collection-card-content > p {
  margin: 0 0 12px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.22em;
  text-transform: uppercase;
}

.collection-card h3 {
  margin: 0 0 15px;
  color: #222;
  font-family: 'Gilda Display', serif;
  font-size: 28px;
  font-weight: 400;
  line-height: 1.2;
}

.collection-card h3 a {
  color: inherit;
}

.collection-card-content > span {
  display: block;
  margin-bottom: 24px;
  color: #666;
  font-size: 14px;
  line-height: 1.75;
}

.collection-card-link {
  margin-top: auto;
}

@media (max-width: 1199px) {
  .collection-card {
    display: block;
  }

  .collection-card-image {
    display: block;
    aspect-ratio: 4 / 3;
  }

  .collection-card-content {
    min-height: 270px;
  }
}

@media (max-width: 767px) {
  .home-collection {
    padding: 78px 0;
    overflow: hidden;
  }

  .home-collection-heading {
    display: block;
    margin-bottom: 30px;
  }

  .home-collection-heading .section-title {
    font-size: 40px;
    line-height: 1.14;
  }

  .home-collection-all {
    margin-top: 20px;
  }

  .home-collection-grid {
    grid-auto-columns: 86%;
    grid-auto-flow: column;
    grid-template-columns: none;
    gap: 14px;
    margin-right: -15px;
    padding-right: 15px;
    overflow-x: auto;
    scroll-snap-type: x mandatory;
    scrollbar-width: none;
  }

  .home-collection-grid::-webkit-scrollbar {
    display: none;
  }

  .collection-card {
    min-height: 0;
    scroll-snap-align: start;
  }

  .collection-card-image {
    aspect-ratio: 5 / 4;
  }

  .collection-card-content {
    min-height: 272px;
    padding: 27px 24px;
  }

  .collection-card h3 {
    font-size: 26px;
  }
}
</style>
