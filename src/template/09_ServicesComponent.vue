<script setup lang="ts"></script>

<template>
  <section class="services section-padding">
    <div class="container">
      <!-- <div class="services-intro"> -->
      <div class="section-subtitle">Từ xưởng đến công trình</div>
      <div class="section-title">Vật liệu và kỹ nghệ hoàn thiện</div>
      <!-- <p>
          Chất lượng được tạo nên từ những quyết định nhất quán: chọn vật liệu phù hợp, chế tác
          chính xác và kiểm tra kỹ trước khi bàn giao.
        </p> -->
      <!-- </div> -->
      <!-- Row 1 -->
      <div class="row">
        <div class="col-md-6 p-0 order1 animate-box" data-animate-effect="fadeInLeft">
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
        <div
          class="col-md-6 bg-cream p-0 order2 valign animate-box"
          data-animate-effect="fadeInRight"
        >
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>NGUYÊN LIỆU</h6>
              </div>
              <h4>Gỗ óc chó được tuyển chọn</h4>
              <!-- <p>
                <strong>D&L Furniture</strong> sử dụng 100% gỗ óc chó nhập khẩu từ Bắc Mỹ, được kiểm
                định chất lượng nghiêm ngặt. Vân gỗ tự nhiên, màu sắc đặc trưng, độ bền vượt thời
                gian — nguyên liệu hoàn hảo cho nội thất đẳng cấp.
              </p>
              <div class="butn-dark">
                <router-link to="/san-pham"><span>Khám phá ngay</span></router-link>
              </div> -->
              <p>
                Màu sắc, hướng vân và đặc tính của từng phôi gỗ được cân nhắc theo vị trí sử dụng.
                Việc tuyển chọn đồng đều giúp các module giữ được sự liên tục trong tổng thể.
              </p>
              <div class="butn-dark">
                <router-link to="/san-pham"><span>Khám phá bộ sưu tập</span></router-link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Row 2 -->
      <div class="row">
        <div class="col-md-6 p-0 bg-cream valign animate-box" data-animate-effect="fadeInLeft">
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>CHẾ TÁC</h6>
              </div>
              <h4>Chính xác trong từng chi tiết</h4>
              <p>
                Kỹ thuật chế tác được thể hiện ở độ khít của mối ghép, sự liền mạch của cạnh tiếp
                xúc và cảm giác dễ chịu tại những bề mặt được sử dụng mỗi ngày.
              </p>
              <div class="butn-dark">
                <router-link to="/thu-vien"><span>Xem kỹ nghệ chế tác</span></router-link>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-6 p-0 animate-box" data-animate-effect="fadeInRight">
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
      </div>

      <!-- Row 3 -->
      <div class="row">
        <div class="col-md-6 p-0 order1 animate-box" data-animate-effect="fadeInLeft">
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
        <div
          class="col-md-6 bg-cream p-0 order2 valign animate-box"
          data-animate-effect="fadeInRight"
        >
          <div class="content">
            <div class="cont text-left">
              <div class="info">
                <h6>KIỂM ĐỊNH</h6>
              </div>
              <h4>Kiểm tra trước khi bàn giao</h4>
              <p>
                Bề mặt, mối ghép và cơ cấu vận hành được kiểm tra trước khi lắp đặt. Tại công trình,
                đội ngũ tiếp tục hiệu chỉnh theo điều kiện sử dụng thực tế.
              </p>
              <p><strong>D&L Furniture</strong> luôn cam kết chất lượng tốt nhất.</p>
              <div class="butn-dark">
                <router-link to="/du-an"><span>Dự án hoàn thiện</span></router-link>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Row 4 -->
      <div class="row">
        <div class="col-md-6 p-0 bg-cream valign animate-box" data-animate-effect="fadeInLeft">
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
        <div class="col-md-6 p-0 animate-box" data-animate-effect="fadeInRight">
          <div class="img left">
            <router-link to="/san-pham">
              <img
                src="/media/gallery/walnut-joinery-detail.webp"
                alt="Bộ bàn ăn gỗ óc chó bền bỉ trường tồn - D&L Furniture"
                loading="lazy"
              />
            </router-link>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.services .img img {
  height: 380px;
  /* object-fit: cover; */
}
</style>
