<script setup lang="ts">
const commitments = [
  {
    icon: 'ti-ruler-pencil',
    title: 'Thiết kế theo hiện trạng',
    description:
      'Giải pháp được phát triển từ số liệu khảo sát, kiến trúc sẵn có và thói quen sử dụng thực tế.'
  },
  {
    icon: 'ti-layers',
    title: 'Vật liệu được tuyển chọn',
    description:
      'Mỗi vật liệu được cân nhắc về sắc độ, độ bền và khả năng phối hợp trong tổng thể không gian.'
  },
  {
    icon: 'ti-settings',
    title: 'Sản xuất có kiểm soát',
    description:
      'Tỷ lệ, mối ghép và bề mặt hoàn thiện được kiểm tra xuyên suốt trước khi đưa tới công trình.'
  },
  {
    icon: 'ti-check-box',
    title: 'Thi công đồng bộ',
    description:
      'Thiết kế, sản xuất và lắp đặt được kết nối trong cùng một quy trình để hạn chế sai lệch.'
  },
  {
    icon: 'ti-shield',
    title: 'Bảo hành minh bạch',
    description:
      'Phạm vi bảo hành và hướng dẫn chăm sóc được trao đổi rõ ràng theo từng hạng mục bàn giao.'
  },
  {
    icon: 'ti-comments',
    title: 'Tư vấn theo nhu cầu',
    description:
      'Đề xuất được cân bằng giữa thẩm mỹ, công năng, vật liệu và ngân sách của từng gia đình.'
  }
]
</script>

<template>
  <section class="facilties section-padding">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle">Vì sao chọn chúng tôi</div>
          <div class="section-title">Giải pháp của chúng tôi</div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-4" v-for="item in commitments" :key="item.title">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span :class="item.icon"></span>
            <h5>{{ item.title }}</h5>
            <p>
              {{ item.description }}
            </p>
            <div class="facility-shape"><span :class="item.icon"></span></div>
          </div>
        </div>
        <!-- <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-car"></span>
            <h5>Cập nhật xu hướng mới nhất hiện đại</h5>
            <p>
              <strong>D&L Furniture</strong> mang đến cho ngôi nhà bạn những xu thế thiết kế mới
              nhất, vật liệu và phương pháp thi công hiện đại nhất.
            </p>
            <div class="facility-shape"><span class="flaticon-car"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-bed"></span>
            <h5>Giám sát tiến độ chính xác tới khách hàng</h5>
            <p>
              Luôn luôn cố gắng hoàn thành dự án một cách chính xác, nhanh chóng, chuyên nghiệp nhất
              và tiết kiệm chi phí ”thời gian” cho bạn và gia đình.
            </p>
            <div class="facility-shape"><span class="flaticon-bed"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-swimming"></span>
            <h5>Bảo hành công trình lâu dài</h5>
            <p>
              Luôn đồng hành cùng quý khách trong suốt quá trình sử dụng. Bảo hành 2 năm và bảo trì
              3 năm, 5 năm và hơn thế nữa.
            </p>
            <div class="facility-shape"><span class="flaticon-swimming"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-wifi"></span>
            <h5>Giá cả hợp lý phải chăng</h5>
            <p>
              Với lợi thế về xưởng sản xuất và kinh nghiệm lâu năm, chúng tôi cam kết đem lại giá
              trị tốt nhất cho khách hàng và phù hợp nhất về chất lượng.
            </p>
            <div class="facility-shape"><span class="flaticon-wifi"></span></div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="single-facility animate-box" data-animate-effect="fadeInUp">
            <span class="flaticon-breakfast"></span>
            <h5>Hỗ trợ tư vấn miễn phí 24/7</h5>
            <p>
              Thời gian có mặt nhanh chóng, luôn luôn sẵn sàng phục vụ tư vấn miễn phí khách hàng
              24/24. Hãy liên hệ ngay với chúng tôi.
            </p>
            <div class="facility-shape"><span class="flaticon-breakfast"></span></div>
          </div>
        </div> -->
      </div>
    </div>
  </section>
</template>

<style scoped></style>
