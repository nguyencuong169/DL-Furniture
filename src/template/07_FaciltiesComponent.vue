<script setup lang="ts">
const capabilities = [
  {
    number: '01',
    context: 'Tại công trình',
    title: 'Thiết kế bám sát hiện trạng',
    description:
      'Đội ngũ trực tiếp đo đạc, ghi nhận kiến trúc và điều kiện kỹ thuật trước khi phát triển phương án.'
  },
  {
    number: '02',
    context: 'Tại xưởng',
    title: 'Sản xuất và kiểm soát trực tiếp',
    description:
      'Vật liệu, kích thước, mối ghép và bề mặt hoàn thiện được kiểm soát trước khi đưa đến công trình.'
  },
  {
    number: '03',
    context: 'Sau bàn giao',
    title: 'Bảo hành có đầu mối',
    description:
      'Phạm vi bảo hành, hướng dẫn chăm sóc và đầu mối hỗ trợ được thống nhất rõ ràng theo từng hạng mục.'
  }
]
</script>

<template>
  <section class="facilties section-padding" aria-labelledby="facilities-title">
    <div class="container">
      <header class="facilities-heading">
        <div>
          <div class="section-subtitle">Năng lực D&amp;L Furniture</div>
          <h2 id="facilities-title" class="section-title">Năng lực phía sau mỗi công trình</h2>
        </div>
        <p class="facilities-intro">
          Chất lượng hoàn thiện được bảo chứng bằng khả năng kiểm soát tại công trình, trong xưởng
          và cả sau khi bàn giao.
        </p>
      </header>
      <div class="row commitment-row">
        <div class="col-md-4" v-for="item in capabilities" :key="item.title">
          <article class="single-facility">
            <div class="capability-meta">
              <span class="commitment-number" aria-hidden="true">{{ item.number }}</span>
              <span class="capability-context">{{ item.context }}</span>
            </div>
            <h3>{{ item.title }}</h3>
            <p>
              {{ item.description }}
            </p>
          </article>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.facilties {
  padding: 78px 0 82px;
  background: #f7f4ef;
}

.facilties > .container {
  width: min(1280px, calc(100% - 60px));
  max-width: none;
  padding: 0;
}

.facilities-heading {
  display: grid;
  grid-template-columns: minmax(0, 1.3fr) minmax(320px, 0.7fr);
  align-items: end;
  gap: 70px;
}

.facilities-heading .section-title {
  max-width: 720px;
  margin-bottom: 0;
}

.facilities-intro {
  max-width: 700px;
  margin: 0 0 5px;
  color: #69645d;
  font-size: 16px;
  line-height: 1.8;
}

.commitment-row {
  margin-top: 34px;
}

.facilties .single-facility {
  position: relative;
  height: 100%;
  min-height: 238px;
  padding: 31px 32px 32px;
  border-color: #e5ddd3;
  background: rgba(255, 255, 255, 0.78);
}

.facilties .single-facility:hover {
  border-color: rgba(170, 132, 83, 0.58);
  background: #fff;
  transform: translateY(-4px);
}

.capability-meta {
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 29px;
}

.facilties .single-facility .commitment-number,
.capability-context {
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.18em;
  text-transform: uppercase;
}

.facilties .single-facility .capability-context {
  color: #80766a;
  font-size: 11px;
  white-space: nowrap;
}

.facilties .single-facility h3 {
  margin-bottom: 14px;
  color: #2b2722;
  font-family: 'Gilda Display', serif;
  font-size: 24px;
  font-weight: 400;
  line-height: 1.25;
}

.facilties .single-facility p {
  color: #6d6861;
  font-size: 14px;
  line-height: 1.75;
}

@media (max-width: 767.98px) {
  .facilties {
    padding: 68px 0;
  }

  .facilties > .container {
    width: calc(100% - 30px);
  }

  .facilities-heading {
    grid-template-columns: 1fr;
    gap: 18px;
  }

  .facilities-intro {
    font-size: 15px;
  }

  .commitment-row {
    margin-top: 30px;
  }

  .commitment-row > div + div {
    margin-top: 14px;
  }

  .facilties .single-facility {
    min-height: 0;
  }
}

@media (prefers-reduced-motion: reduce) {
  .facilties .single-facility:hover {
    transform: none;
  }
}
</style>
