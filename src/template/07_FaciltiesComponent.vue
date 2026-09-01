<script setup lang="ts">
// Đồng bộ 1 bộ icon outline duy nhất (Lucide) với phần Quy trình (09)
import { Globe, Hammer, Paintbrush, PencilRuler, ShieldCheck, Thermometer } from 'lucide-vue-next'
</script>

<template>
  <section class="facilties section-padding">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle"><span>Cam kết chất lượng</span></div>
          <div class="section-title">Vì sao chọn chúng tôi</div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <div class="facility-head">
              <span><Globe :size="40" :stroke-width="1.5" /></span>
              <span class="facility-tag">Nguyên liệu</span>
            </div>
            <h5>Gỗ óc chó Bắc Mỹ, chuẩn FAS</h5>
            <p>
              100% gỗ óc chó nhập khẩu loại 1 từ vùng Bắc Mỹ, sở hữu sắc trầm và vân gỗ cuộn sóng
              độc bản.
            </p>
            <div class="facility-shape"><span><Globe :size="140" :stroke-width="1" /></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <div class="facility-head">
              <span><Hammer :size="40" :stroke-width="1.5" /></span>
              <span class="facility-tag">Chế tác</span>
            </div>
            <h5>Kỹ thuật nghệ nhân</h5>
            <p>
              Gia công thủ công bởi những nghệ nhân hơn 15 năm kinh nghiệm, xử lý mượt mà từng
              đường bo và góc cạnh.
            </p>
            <div class="facility-shape"><span><Hammer :size="140" :stroke-width="1" /></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <div class="facility-head">
              <span><Paintbrush :size="40" :stroke-width="1.5" /></span>
              <span class="facility-tag">Hoàn thiện</span>
            </div>
            <h5>Bề mặt sơn cao cấp</h5>
            <p>
              Hệ sơn nhập khẩu giữ trọn vẻ đẹp tự nhiên của gỗ, không mùi, an toàn cho sức khỏe
              gia đình.
            </p>
            <div class="facility-shape"><span><Paintbrush :size="140" :stroke-width="1" /></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <div class="facility-head">
              <span><PencilRuler :size="40" :stroke-width="1.5" /></span>
              <span class="facility-tag">Cá nhân hóa</span>
            </div>
            <h5>Thiết kế riêng theo gia chủ</h5>
            <p>
              Đo đạc và thiết kế dựa trên phong thủy, tỉ lệ nhân trắc học và kiến trúc riêng của
              từng không gian.
            </p>
            <div class="facility-shape"><span><PencilRuler :size="140" :stroke-width="1" /></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <div class="facility-head">
              <span><Thermometer :size="40" :stroke-width="1.5" /></span>
              <span class="facility-tag">Kỹ thuật</span>
            </div>
            <h5>Sấy gỗ đạt chuẩn</h5>
            <p>
              Gỗ được tẩm sấy theo công nghệ hiện đại, đạt độ ẩm dưới 12%, hạn chế cong vênh, co
              ngót trong khí hậu Việt Nam.
            </p>
            <div class="facility-shape"><span><Thermometer :size="140" :stroke-width="1" /></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <div class="facility-head">
              <span><ShieldCheck :size="40" :stroke-width="1.5" /></span>
              <span class="facility-tag">Dịch vụ</span>
            </div>
            <h5>Đồng hành trọn đời</h5>
            <p>
              Bảo hành 5 năm cùng dịch vụ bảo trì định kỳ, giúp lớp gỗ luôn sáng đẹp theo thời
              gian.
            </p>
            <div class="facility-shape"><span><ShieldCheck :size="140" :stroke-width="1" /></span></div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.facilties .container > .row:first-child {
  margin-bottom: 46px;
}

.facilties .section-title {
  margin-bottom: 0;
}

/* Grid: các card trong cùng một hàng luôn cao bằng nhau */
.facilties .container > .row:last-child {
  --bs-gutter-x: 2rem;
  align-items: stretch;
}

.facilties .container > .row:last-child > [class*='col-'] {
  display: flex;
  margin-bottom: 30px; /* nhận thay margin-bottom cũ của card */
}

/* Lucide SVG: bỏ khoảng trắng baseline */
.facilties .single-facility .facility-head svg,
.facilties .single-facility .facility-shape span svg {
  display: block;
}

/* Header card: icon + tag trên cùng một hàng để gọn chiều cao */
.facilties .single-facility .facility-head {
  display: flex;
  align-items: center;
  gap: 14px;
  margin-bottom: 16px;
}

.facilties .single-facility .facility-head > span:first-child {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  margin-bottom: 0; /* đè margin 20px của span global */
  transition: transform 0.35s ease;
}

.facilties .single-facility:hover .facility-head > span:first-child {
  transform: translateY(-3px);
}

/* Hover đồng nhất với hệ card toàn homepage: nâng nhẹ, viền gold, đổ bóng mảnh */
.facilties .single-facility {
  display: flex;
  flex-direction: column;
  align-items: flex-start;
  width: 100%;
  height: 100%;
  margin-bottom: 0;
  padding: 32px 28px;
  line-height: 1.5;
  overflow: hidden;
  border-color: #f1eeeb;
  box-shadow: none;
  transition:
    border-color 0.35s ease,
    box-shadow 0.35s ease,
    transform 0.35s ease;
}

.facilties .single-facility:hover {
  border-color: #d8c29b;
  box-shadow: 0 16px 34px rgba(34, 29, 22, 0.08);
  transform: translateY(-5px);
}

.facilties .single-facility .facility-tag {
  display: block;
  margin-bottom: 0;
  color: #9e7746;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 500;
  letter-spacing: 0.18em;
  line-height: 1;
  text-transform: uppercase;
}

.facilties .single-facility h5 {
  margin-bottom: 10px;
  color: #221f1a;
  font-size: 22px;
  transition: color 0.35s ease;
}

.facilties .single-facility:hover h5 {
  color: #8a6a3f;
}

.facilties .single-facility p {
  margin: 0;
  color: #666;
  font-size: 15px;
  line-height: 1.7;
}

/* Watermark icon: neo góc phải-dưới thay vì left cố định để không chồng lên nội dung */
.facilties .single-facility .facility-shape {
  left: auto;
  right: 18px;
  bottom: 10px;
}

@media (max-width: 767.98px) {
  .facilties .container > .row:last-child > [class*='col-'] {
    margin-bottom: 20px;
  }
}

@media (max-width: 575.98px) {
  .facilties .container > .row:first-child {
    margin-bottom: 34px;
  }

  .facilties .container > .row:last-child > [class*='col-'] {
    margin-bottom: 16px;
  }

  .facilties .single-facility {
    padding: 26px 22px;
  }

  .facilties .single-facility .facility-head {
    gap: 12px;
    margin-bottom: 14px;
  }

  .facilties .single-facility .facility-tag {
    font-size: 12px;
  }

  .facilties .single-facility h5 {
    font-size: 20px;
  }
}
</style>
