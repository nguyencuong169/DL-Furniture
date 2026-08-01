<script setup lang="ts"></script>

<template>
  <section class="services section-padding">
    <div class="container">
      <!-- Row 1 -->
      <div class="row">
        <div
          class="col-md-6 bg-cream p-0 order2 valign animate-box"
          data-animate-effect="fadeInLeft"
        >
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>NGUYÊN LIỆU</h6>
              </div>
              <h4>GỖ ÓC CHÓ BẮC MỸ NHẬP KHẨU</h4>
              <p>
                <strong>D&L Furniture</strong> sử dụng 100% gỗ óc chó nhập khẩu từ Bắc Mỹ, được kiểm
                định chất lượng nghiêm ngặt. Vân gỗ tự nhiên, màu sắc đặc trưng, độ bền vượt thời
                gian — nguyên liệu hoàn hảo cho nội thất đẳng cấp.
              </p>
              <div class="butn-dark">
                <router-link to="/san-pham"><span>Khám phá ngay</span></router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-6 p-0 order1 animate-box" data-animate-effect="fadeInRight">
          <div class="img">
            <router-link to="/san-pham">
              <img
                src="/media/gallery/walnut-joinery-detail.webp"
                alt="Vân gỗ óc chó Bắc Mỹ - D&L Furniture"
                loading="lazy"
              />
            </router-link>
          </div>
        </div>
      </div>

      <!-- Row 2 -->
      <div class="row">
        <div class="col-md-6 p-0 animate-box" data-animate-effect="fadeInLeft">
          <div class="img left">
            <router-link to="/san-pham">
              <img
                src="/media/gallery/artisan-walnut-chair.webp"
                alt="Chế tác gỗ óc chó thủ công - D&L Furniture"
                loading="lazy"
              />
            </router-link>
          </div>
        </div>
        <div class="col-md-6 p-0 bg-cream valign animate-box" data-animate-effect="fadeInRight">
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>CHẾ TÁC</h6>
              </div>
              <h4>THỦ CÔNG TINH XẢO</h4>
              <p>
                Từng chi tiết đều được chế tác bởi đội ngũ thợ lành nghề với hơn 15 năm kinh nghiệm.
                Sự kết hợp giữa kỹ thuật truyền thống và công nghệ hiện đại, mỗi sản phẩm là một tác
                phẩm nghệ thuật mang hồn cốt riêng.
              </p>
              <div class="butn-dark">
                <router-link to="/san-pham"><span>Khám phá ngay</span></router-link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Row 3 -->
      <div class="row">
        <div
          class="col-md-6 bg-cream p-0 order2 valign animate-box"
          data-animate-effect="fadeInLeft"
        >
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>KIỂM ĐỊNH</h6>
              </div>
              <h4>CHẤT LƯỢNG ĐẠT CHUẨN</h4>
              <p>
                Mỗi sản phẩm trước khi đến tay khách hàng đều trải qua quy trình kiểm định nghiêm
                ngặt 3 bước. Từ độ ẩm gỗ, độ bền mối ghép đến hoàn thiện bề mặt —
                <strong>D&L Furniture</strong> cam kết chất lượng tốt nhất.
              </p>
              <div class="butn-dark">
                <router-link to="/san-pham"><span>Khám phá ngay</span></router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-6 p-0 order1 animate-box" data-animate-effect="fadeInRight">
          <div class="img">
            <router-link to="/san-pham">
              <img
                src="/media/gallery/walnut-suite.jpg"
                alt="Sản phẩm gỗ óc chó hoàn thiện đạt chuẩn - D&L Furniture"
                loading="lazy"
              />
            </router-link>
          </div>
        </div>
      </div>

      <!-- Row 4 -->
      <div class="row">
        <div class="col-md-6 p-0 animate-box" data-animate-effect="fadeInLeft">
          <div class="img left">
            <router-link to="/san-pham">
              <img
                src="/media/gallery/arched-dining.jpg"
                alt="Bộ bàn ăn gỗ óc chó bền bỉ trường tồn - D&L Furniture"
                loading="lazy"
              />
            </router-link>
          </div>
        </div>
        <div class="col-md-6 p-0 bg-cream valign animate-box" data-animate-effect="fadeInRight">
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>BẢO HÀNH</h6>
              </div>
              <h4>ĐỒNG HÀNH TRỌN ĐỜI</h4>
              <p>
                <strong>D&L Furniture</strong> cam kết bảo hành 2 năm, bảo trì trọn đời cho mọi sản
                phẩm nội thất gỗ óc chó. Đội ngũ kỹ thuật sẵn sàng phục vụ quý khách 24/7, đảm bảo
                sản phẩm luôn bền đẹp theo thời gian.
              </p>
              <div class="butn-dark">
                <router-link to="/lien-he"><span>Liên hệ tư vấn</span></router-link>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
/* Đồng bộ chiều cao ảnh & box text */
.services .img {
  height: 380px;
  overflow: hidden;
}
.services .img img {
  width: 100%;
  height: 380px;
  object-fit: cover;
}
.services .content {
  height: 380px;
}
</style>
