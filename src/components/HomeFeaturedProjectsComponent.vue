<script setup lang="ts">
import { reactive } from 'vue'

const projects = [
  {
    id: 1,
    client: 'Anh Tuấn',
    location: 'Thủ Thiêm',
    title: 'Thiết kế nội thất Saroma Villa',
    type: 'Nội thất Villa - Biệt Thự',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian phòng khách gỗ óc chó mở ra khu vườn tại Saroma Villa'
  },
  {
    id: 2,
    client: 'Anh Cường',
    location: 'Vinhomes Grand Park',
    title: 'Thiết kế nội thất biệt thự Vinhomes Grand Park',
    type: 'Nội thất Villa - Biệt Thự',
    image: '/media/gallery/villa-bedroom-lounge.webp',
    alt: 'Không gian phòng ngủ biệt thự Vinhomes Grand Park'
  },
  {
    id: 3,
    client: 'Chị Hằng',
    location: 'Vĩnh Yên',
    title: 'Thiết kế nội thất biệt thự KĐT Vĩnh Yên',
    type: 'Nội thất Villa - Biệt Thự',
    image: '/media/gallery/arched-dining.jpg',
    alt: 'Không gian phòng ăn biệt thự tại khu đô thị Vĩnh Yên'
  },
  {
    id: 4,
    client: 'Chị Nguyệt',
    location: 'Thảo Điền',
    title: 'Thiết kế nội thất chung cư Vinhomes Metropolis',
    type: 'Nội thất Căn hộ chung cư',
    image: '/media/gallery/walnut-villa-living.webp',
    alt: 'Không gian biệt thự cao cấp Thảo Điền'
  }
]

const state = reactive({
  displayDetail: 'false'
})
</script>

<template>
  <section class="room2 section-padding bg-cream">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div id="project-1" class="rooms2 mb-90 animate-box" data-animate-effect="fadeInUp">
            <figure><img src="../assets/img/slider/4.jpg" alt="" class="img-fluid" /></figure>
            <div class="caption">
              <h3>Anh Tuấn <span>/ Thủ Thiêm</span></h3>
              <h4><a href="room-details.html">Thiết kế nội thất căn hộ Saroma Villa</a></h4>
              <p>Nội thất Villa - Biệt Thự</p>
              <div class="row room-facilities" :v-show="state.displayDetail">
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-group"></i> 1-2 Persons</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-bed"></i> Twin Bed</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-clock-1"></i> 200 sqft room</li>
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
          <div id="project-2" class="rooms2 mb-90 left animate-box" data-animate-effect="fadeInUp">
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
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-bed"></i> Twin Bed</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-clock-1"></i> 200 sqft Room</li>
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
          <div id="project-3" class="rooms2 mb-90 animate-box" data-animate-effect="fadeInUp">
            <figure><img src="../assets/img/slider/3.jpg" alt="" class="img-fluid" /></figure>
            <div class="caption">
              <h3>Chị Hằng <span>/ Vĩnh Yên</span></h3>
              <h4><a href="room-details.html">Thiết kế nội thất biệt thự KĐT Vĩnh Yên</a></h4>
              <p>Nội thất Villa - Biệt Thự</p>
              <div class="row room-facilities" :v-show="state.displayDetail">
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-group"></i> 2-3 Persons</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-bed"></i> Twin Bed</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-clock-1"></i> 200 sqft room</li>
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
          <div id="project-4" class="rooms2 left animate-box" data-animate-effect="fadeInUp">
            <figure><img src="../assets/img/slider/2.jpg" alt="" class="img-fluid" /></figure>
            <div class="caption">
              <h3>Chị Nguyệt <span>/ Liễu Giai</span></h3>
              <h4>
                <a href="room-details.html">Thiết kế nội thất chung cư Vinhomes Metropolis</a>
              </h4>
              <p>Nội thất Căn hộ chung cư</p>
              <div class="row room-facilities" :v-show="state.displayDetail">
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-group"></i> 2-4 Persons</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-bed"></i> Twin Bed</li>
                  </ul>
                </div>
                <div class="col-md-4">
                  <ul>
                    <li><i class="flaticon-clock-1"></i> 200 sqft Room</li>
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
</template>

<style scoped>
.bg-screamer-2 {
  background: #f1ede6;
}
.rooms2[id] {
  scroll-margin-top: 115px;
}

.rooms2[id]:target {
  outline: 1px solid rgba(170, 132, 83, 0.55);
  outline-offset: 12px;
}
</style>
