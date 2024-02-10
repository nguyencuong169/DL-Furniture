<script setup lang="ts">
import { reactive } from 'vue'

const state = reactive({
  displayDetail: 'false'
})
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/1-FQ5yJaaV.jpg"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <span>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
            </span>
            <h5>D&L Furniture</h5>
            <h1>Các dự án đã thực hiện</h1>
          </div>
        </div>
      </div>
    </div>
    <!-- Projects -->
    <section class="section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="rooms2 mb-90 animate-box" data-animate-effect="fadeInUp">
              <figure><img src="../assets/img/slider/4.jpg" alt="" class="img-fluid" /></figure>
              <div class="caption">
                <h3>Anh Tuấn <span>/ Thủ Thiêm</span></h3>
                <h4><a href="room-details.html">Thiết kế nội thất Saroma Villa</a></h4>
                <p>Nội thất Villa - Biệt Thự</p>
                <div class="row room-facilities" :v-show="state.displayDetail">
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-group"></i> 1-2 Persons</li>
                      <li><i class="flaticon-wifi"></i> Free Wifi</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-bed"></i> Twin Bed</li>
                      <li><i class="flaticon-breakfast"></i> Breakfast</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-clock-1"></i> 200 sqft room</li>
                      <li><i class="flaticon-swimming"></i> Swimming Pool</li>
                    </ul>
                  </div>
                </div>
                <hr class="border-2" />
                <div class="info-wrapper">
                  <div class="more">
                    <a href="room-details.html" class="link-btn" tabindex="0"
                      >Chi tiết <i class="ti-arrow-right"></i
                    ></a>
                  </div>
                  <div class="butn-dark">
                    <a href="#" data-scroll-nav="1"><span>Book Now</span></a>
                  </div>
                </div>
              </div>
            </div>
            <div class="rooms2 mb-90 left animate-box" data-animate-effect="fadeInUp">
              <figure><img src="../assets/img/slider/3.jpg" alt="" class="img-fluid" /></figure>
              <div class="caption">
                <h3>Anh Cường <span>/ Quận 9</span></h3>
                <h4>
                  <a href="room-details.html">Thiết kế nội thất biệt thự Vinhomes Grand Park</a>
                </h4>
                <p>Nội thất Villa - Biệt Thự</p>
                <div class="row room-facilities" :v-show="state.displayDetail">
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-group"></i> 1-2 Persons</li>
                      <li><i class="flaticon-wifi"></i> Free Wifi</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-bed"></i> Twin Bed</li>
                      <li><i class="flaticon-breakfast"></i> Breakfast</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-clock-1"></i> 200 sqft Room</li>
                      <li><i class="flaticon-swimming"></i> Swimming Pool</li>
                    </ul>
                  </div>
                </div>
                <hr class="border-2" />
                <div class="info-wrapper">
                  <div class="more">
                    <a href="room-details.html" class="link-btn" tabindex="0"
                      >Chi tiết <i class="ti-arrow-right"></i
                    ></a>
                  </div>
                  <div class="butn-dark">
                    <a href="#" data-scroll-nav="1"><span>Book Now</span></a>
                  </div>
                </div>
              </div>
            </div>
            <div class="rooms2 mb-90 animate-box" data-animate-effect="fadeInUp">
              <figure><img src="../assets/img/slider/3.jpg" alt="" class="img-fluid" /></figure>
              <div class="caption">
                <h3>Chị Hằng <span>/ Vĩnh Yên</span></h3>
                <h4><a href="room-details.html">Thiết kế nội thất biệt thự KĐT Vĩnh Yên</a></h4>
                <p>Nội thất Villa - Biệt Thự</p>
                <div class="row room-facilities" :v-show="state.displayDetail">
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-group"></i> 2-3 Persons</li>
                      <li><i class="flaticon-wifi"></i> Free Wifi</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-bed"></i> Twin Bed</li>
                      <li><i class="flaticon-breakfast"></i> Breakfast</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-clock-1"></i> 200 sqft room</li>
                      <li><i class="flaticon-swimming"></i> Swimming Pool</li>
                    </ul>
                  </div>
                </div>
                <hr class="border-2" />
                <div class="info-wrapper">
                  <div class="more">
                    <a href="room-details.html" class="link-btn" tabindex="0"
                      >Chi tiết <i class="ti-arrow-right"></i
                    ></a>
                  </div>
                  <div class="butn-dark">
                    <a href="#" data-scroll-nav="1"><span>Book Now</span></a>
                  </div>
                </div>
              </div>
            </div>
            <div class="rooms2 left animate-box" data-animate-effect="fadeInUp">
              <figure><img src="../assets/img/slider/2.jpg" alt="" class="img-fluid" /></figure>
              <div class="caption">
                <h3>Chị Nguyệt <span>/ Liễu Giai</span></h3>
                <h4>
                  <a href="room-details.html"
                    >Thiết kế nội thất căn hộ chung cư Vinhomes Metropolis</a
                  >
                </h4>
                <p>Nội thất Căn hộ chung cư</p>
                <div class="row room-facilities" :v-show="state.displayDetail">
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-group"></i> 2-4 Persons</li>
                      <li><i class="flaticon-wifi"></i> Free Wifi</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-bed"></i> Twin Bed</li>
                      <li><i class="flaticon-breakfast"></i> Breakfast</li>
                    </ul>
                  </div>
                  <div class="col-md-4">
                    <ul>
                      <li><i class="flaticon-clock-1"></i> 200 sqft Room</li>
                      <li><i class="flaticon-swimming"></i> Swimming Pool</li>
                    </ul>
                  </div>
                </div>
                <hr class="border-2" />
                <div class="info-wrapper">
                  <div class="more">
                    <a href="room-details.html" class="link-btn" tabindex="0"
                      >Chi tiết <i class="ti-arrow-right"></i
                    ></a>
                  </div>
                  <div class="butn-dark">
                    <a href="#" data-scroll-nav="1"><span>Book Now</span></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>
