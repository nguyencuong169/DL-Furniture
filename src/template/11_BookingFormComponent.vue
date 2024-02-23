<script setup lang="ts">
import { bookingUseStore } from '../stores/bookingstore'

const bookingStore = bookingUseStore()
</script>

<template>
  <section class="testimonials" v-show="bookingStore.isDisplay">
    <div
      class="background bg-img bg-fixed section-padding pb-0"
      data-background="https://dl-furniture.netlify.app/assets/2-xOjvuLYK.jpg"
      data-overlay-dark="2"
    >
      <div class="container">
        <div class="row">
          <!-- Reservation -->
          <div class="col-md-5 mb-30 mt-30">
            <p>
              <i class="star-rating"></i><i class="star-rating"></i><i class="star-rating"></i
              ><i class="star-rating"></i><i class="star-rating"></i>
            </p>
            <h5>
              Xây dựng và khẳng định vị thế thương hiệu bằng uy tín, chất lượng với những sản phẩm
              mang tính độc bản.
              <strong>D&L Furniture</strong> luôn đón đầu xu hướng thiết kế đẹp và đẳng cấp nhất
              hiện nay, đem lại cho khách hàng giá trị sống vẹn cùng sự trải nghiệm có một không hai
              tại Việt Nam..
            </h5>
            <div class="reservations mb-30">
              <div class="icon color-1"><span class="flaticon-call"></span></div>
              <div class="text">
                <p class="color-1">Tư vấn thiết kế</p>
                <a class="color-1" href="tel:0945366622">(+84) 961-109-897</a>
              </div>
            </div>
            <p><i class="ti-check"></i><small>Gọi cho chúng tôi để được tư vấn miễn phí.</small></p>
          </div>
          <!-- Booking From -->
          <div class="col-md-5 offset-md-2">
            <div class="booking-box">
              <div class="head-box">
                <h6>D&L Furniture</h6>
                <h4>Tư vấn thiết kế miễn phí</h4>
              </div>
              <div class="booking-inner clearfix">
                <form action="#" class="form1 clearfix">
                  <div class="row">
                    <div class="col-md-12">
                      <div class="input1_wrapper">
                        <label>Họ và tên</label>
                        <div class="full_name">
                          <input type="text" class="form-control input" placeholder="Họ và tên" />
                        </div>
                      </div>
                    </div>
                    <div class="col-md-12">
                      <div class="input1_wrapper">
                        <label>Email</label>
                        <div class="full_name">
                          <input type="email" class="form-control input" placeholder="Email" />
                        </div>
                      </div>
                    </div>
                    <div class="col-md-12">
                      <div class="input1_wrapper">
                        <label>Số điện thoại</label>
                        <div class="full_name">
                          <input
                            type="text"
                            class="form-control input"
                            placeholder="Số điện thoại"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="col-md-12">
                      <div class="input1_wrapper">
                        <label>Nội dung</label>
                        <div class="full_name">
                          <textarea
                            class="form-control input"
                            placeholder="Nội dung tin nhắn"
                          ></textarea>
                        </div>
                      </div>
                    </div>
                    <!-- <div class="col-md-12">
                      <div class="input1_wrapper">
                        <label>Check in</label>
                        <div class="input1_inner">
                          <input
                            type="text"
                            class="form-control input datepicker"
                            placeholder="Check in"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="col-md-12">
                      <div class="input1_wrapper">
                        <label>Check out</label>
                        <div class="input1_inner">
                          <input
                            type="text"
                            class="form-control input datepicker"
                            placeholder="Check out"
                          />
                        </div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="select1_wrapper">
                        <label>Adults</label>
                        <div class="select1_inner">
                          <select class="select2 select" style="width: 100%">
                            <option value="0">Adults</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                          </select>
                        </div>
                      </div>
                    </div>
                    <div class="col-md-6">
                      <div class="select1_wrapper">
                        <label>Children</label>
                        <div class="select1_inner">
                          <select class="select2 select" style="width: 100%">
                            <option value="0">Children</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                            <option value="3">3</option>
                            <option value="4">4</option>
                          </select>
                        </div>
                      </div>
                    </div> -->
                    <div class="col-md-12">
                      <button type="submit" class="btn-form1-submit mt-15">Gửi tin nhắn</button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.full_name::after {
  content: '' !important;
}
</style>
