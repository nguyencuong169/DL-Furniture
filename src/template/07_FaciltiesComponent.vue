<script setup lang="ts"></script>

<template>
  <section class="facilties section-padding">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle"><span>D&L Furniture</span></div>
          <div class="section-title">Vì sao chọn chúng tôi</div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-world"></span>
            <span class="facility-tag">Nguyên liệu</span>
            <h5>Gỗ óc chó Bắc Mỹ, chuẩn FAS</h5>
            <p>
              100% gỗ óc chó nhập khẩu loại 1 từ vùng Bắc Mỹ, sở hữu sắc trầm và vân gỗ cuộn sóng
              độc bản.
            </p>
            <div class="facility-shape"><span class="flaticon-world"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-man"></span>
            <span class="facility-tag">Chế tác</span>
            <h5>Kỹ thuật nghệ nhân</h5>
            <p>
              Gia công thủ công bởi những nghệ nhân hơn 15 năm kinh nghiệm, xử lý mượt mà từng
              đường bo và góc cạnh.
            </p>
            <div class="facility-shape"><span class="flaticon-man"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="ti-paint-roller"></span>
            <span class="facility-tag">Hoàn thiện</span>
            <h5>Bề mặt sơn cao cấp</h5>
            <p>
              Hệ sơn nhập khẩu giữ trọn vẻ đẹp tự nhiên của gỗ, không mùi, an toàn cho sức khỏe
              gia đình.
            </p>
            <div class="facility-shape"><span class="ti-paint-roller"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="ti-ruler-pencil"></span>
            <span class="facility-tag">Cá nhân hóa</span>
            <h5>Thiết kế riêng theo gia chủ</h5>
            <p>
              Đo đạc và thiết kế dựa trên phong thủy, tỉ lệ nhân trắc học và kiến trúc riêng của
              từng không gian.
            </p>
            <div class="facility-shape"><span class="ti-ruler-pencil"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="ti-settings"></span>
            <span class="facility-tag">Kỹ thuật</span>
            <h5>Sấy gỗ đạt chuẩn</h5>
            <p>
              Gỗ được tẩm sấy theo công nghệ hiện đại, đạt độ ẩm dưới 12%, hạn chế cong vênh, co
              ngót trong khí hậu Việt Nam.
            </p>
            <div class="facility-shape"><span class="ti-settings"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-shield"></span>
            <span class="facility-tag">Dịch vụ</span>
            <h5>Đồng hành trọn đời</h5>
            <p>
              Bảo hành 5 năm cùng dịch vụ bảo trì định kỳ, giúp lớp gỗ luôn sáng đẹp theo thời
              gian.
            </p>
            <div class="facility-shape"><span class="flaticon-shield"></span></div>
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

/* Hover đồng nhất với hệ card toàn homepage: nâng nhẹ, viền gold, đổ bóng mảnh */
.facilties .single-facility {
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

.facilties .single-facility > span:first-child {
  transition: transform 0.35s ease;
}

.facilties .single-facility:hover > span:first-child {
  transform: translateY(-3px);
}

.facilties .single-facility .facility-tag {
  display: block;
  margin-bottom: 10px;
  color: #9e7746;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 500;
  letter-spacing: 0.16em;
  line-height: 1;
  text-transform: uppercase;
}

.facilties .single-facility h5 {
  margin-bottom: 12px;
  color: #221f1a;
  transition: color 0.35s ease;
}

.facilties .single-facility:hover h5 {
  color: #8a6a3f;
}

.facilties .single-facility p {
  line-height: 1.7;
}

@media (max-width: 575.98px) {
  .facilties .container > .row:first-child {
    margin-bottom: 34px;
  }
}
</style>
