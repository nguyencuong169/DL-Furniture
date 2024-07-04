<script setup lang="ts">
import PricingComponent from '../template/05_PricingComponent.vue'
</script>

<template>
  <main>
    <!-- Room Page Slider -->
    <header class="header slider">
      <div class="owl-carousel owl-theme">
        <!-- The opacity on the image is made with "data-overlay-dark="number". You can change it using the numbers 0-9. -->
        <div
          class="text-center item bg-img"
          data-overlay-dark="3"
          data-background="/src/assets/img/slider/3.jpg"
        ></div>
        <div
          class="text-center item bg-img"
          data-overlay-dark="3"
          data-background="/src/assets/img/slider/2.jpg"
        ></div>
        <div
          class="text-center item bg-img"
          data-overlay-dark="3"
          data-background="/src/assets/img/slider/5.jpg"
        ></div>
      </div>
      <!-- arrow down -->
      <div class="arrow bounce text-center">
        <a href="#" data-scroll-nav="1" class=""> <i class="ti-arrow-down"></i> </a>
      </div>
    </header>
    <!-- Room Content -->
    <section class="rooms-page section-padding" data-scroll-index="1">
      <div class="container">
        <!-- project content -->
        <div class="row">
          <div class="col-md-12">
            <span>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
              <i class="star-rating"></i>
            </span>
            <div class="section-subtitle">D&L Furniture</div>
            <div class="section-title">Giường óc chó</div>
          </div>
          <div class="col-md-8">
            <p class="mb-30">
              Nét cuốn hút của các đường vân gỗ cùng sắc nâu sang trọng của gỗ óc chó chắc chắn sẽ
              khiến căn phòng tỏa sáng hơn bao giờ hết. Không những vậy, các sản phẩm nội thất gỗ óc
              chó tự nhiên có sắc độ nâu vừa phải nên không khiến cho không gian bị ngộp hay bí
              bách.
            </p>
            <p class="mb-30">
              Màu sắc và chất liệu gỗ rất quan trọng trong việc tạo dựng phong cách cho các không
              gian. Với chất gỗ mịn, thớ dày dặn cùng màu sắc không trùng lặp, gỗ óc chó tự nhiên
              cực phù hợp để trang trí cho các không gian mang phong cách thiết kế hiện đại.
            </p>
            <div class="row">
              <div class="col-md-6">
                <h6>Check-in</h6>
                <ul class="list-unstyled page-list mb-30">
                  <li>
                    <div class="page-list-icon"><span class="ti-check"></span></div>
                    <div class="page-list-text">
                      <p>Check-in from 9:00 AM - anytime</p>
                    </div>
                  </li>
                  <li>
                    <div class="page-list-icon"><span class="ti-check"></span></div>
                    <div class="page-list-text">
                      <p>Early check-in subject to availability</p>
                    </div>
                  </li>
                </ul>
              </div>
              <div class="col-md-6">
                <h6>Check-out</h6>
                <ul class="list-unstyled page-list mb-30">
                  <li>
                    <div class="page-list-icon"><span class="ti-check"></span></div>
                    <div class="page-list-text">
                      <p>Check-out before noon</p>
                    </div>
                  </li>
                  <li>
                    <div class="page-list-icon"><span class="ti-check"></span></div>
                    <div class="page-list-text">
                      <p>Express check-out</p>
                    </div>
                  </li>
                </ul>
              </div>
              <div class="col-md-12">
                <h6>Special check-in instructions</h6>
                <p>
                  Guests will receive an email 5 days before arrival with check-in instructions;
                  front desk staff will greet guests on arrival For more details, please contact the
                  property using the information on the booking confirmation.
                </p>
              </div>
              <div class="col-md-12">
                <h6>Pets</h6>
                <p>Pets not allowed</p>
              </div>
              <div class="col-md-12">
                <h6>Children and extra beds</h6>
                <p>
                  Children are welcome Kids stay free! Children stay free when using existing
                  bedding; children may not be eligible for complimentary breakfast Rollaway/extra
                  beds are available for $ 10 per day.
                </p>
              </div>
              <div class="col-md-12">
                <div class="butn-dark mt-15 mb-30">
                  <a href="rooms2.html"><span>Check Now</span></a>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-3 offset-md-1">
            <h6>Amenities</h6>
            <ul class="list-unstyled page-list mb-30">
              <li>
                <div class="page-list-icon"><span class="flaticon-group"></span></div>
                <div class="page-list-text">
                  <p>1-2 Persons</p>
                </div>
              </li>
              <li>
                <div class="page-list-icon"><span class="flaticon-wifi"></span></div>
                <div class="page-list-text">
                  <p>Free Wifi</p>
                </div>
              </li>
              <li>
                <div class="page-list-icon"><span class="flaticon-clock-1"></span></div>
                <div class="page-list-text">
                  <p>200 sqft room</p>
                </div>
              </li>
              <li>
                <div class="page-list-icon"><span class="flaticon-breakfast"></span></div>
                <div class="page-list-text">
                  <p>Breakfast</p>
                </div>
              </li>
              <li>
                <div class="page-list-icon"><span class="flaticon-towel"></span></div>
                <div class="page-list-text">
                  <p>Towels</p>
                </div>
              </li>
              <li>
                <div class="page-list-icon"><span class="flaticon-swimming"></span></div>
                <div class="page-list-text">
                  <p>Swimming Pool</p>
                </div>
              </li>
            </ul>
          </div>
        </div>
      </div>
    </section>
    <!-- Similar Room -->
    <section class="rooms1 section-padding bg-blck">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <div class="section-subtitle"><span>D&L Furniture</span></div>
            <div class="section-title"><span>Similar Rooms</span></div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <div class="owl-carousel owl-theme">
              <div class="item">
                <div class="position-re o-hidden">
                  <img src="@/assets/img/rooms/1.jpg" alt="" />
                </div>
                <span class="category"><a href="rooms2.html">Book</a></span>
                <div class="con">
                  <h6><a href="room-details.html">150$ / Night</a></h6>
                  <h5><a href="room-details.html">Junior Suite</a></h5>
                  <div class="line"></div>
                  <div class="row facilities">
                    <div class="col col-md-7">
                      <ul>
                        <li><i class="flaticon-bed"></i></li>
                        <li><i class="flaticon-bath"></i></li>
                        <li><i class="flaticon-breakfast"></i></li>
                        <li><i class="flaticon-towel"></i></li>
                      </ul>
                    </div>
                    <div class="col col-md-5 text-end">
                      <div class="permalink">
                        <a href="room-details.html">Details <i class="ti-arrow-right"></i></a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="position-re o-hidden">
                  <img src="@/assets/img/rooms/2.jpg" alt="" />
                </div>
                <span class="category"><a href="rooms2.html">Book</a></span>
                <div class="con">
                  <h6><a href="room-details.html">200$ / Night</a></h6>
                  <h5><a href="room-details.html">Family Room</a></h5>
                  <div class="line"></div>
                  <div class="row facilities">
                    <div class="col col-md-7">
                      <ul>
                        <li><i class="flaticon-bed"></i></li>
                        <li><i class="flaticon-bath"></i></li>
                        <li><i class="flaticon-breakfast"></i></li>
                        <li><i class="flaticon-towel"></i></li>
                      </ul>
                    </div>
                    <div class="col col-md-5 text-end">
                      <div class="permalink">
                        <a href="room-details.html">Details <i class="ti-arrow-right"></i></a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="position-re o-hidden">
                  <img src="@/assets/img/rooms/5.jpg" alt="" />
                </div>
                <span class="category"><a href="rooms2.html">Book</a></span>
                <div class="con">
                  <h6><a href="room-details.html">250$ / Night</a></h6>
                  <h5><a href="room-details.html">Double Room</a></h5>
                  <div class="line"></div>
                  <div class="row facilities">
                    <div class="col col-md-7">
                      <ul>
                        <li><i class="flaticon-bed"></i></li>
                        <li><i class="flaticon-bath"></i></li>
                        <li><i class="flaticon-breakfast"></i></li>
                        <li><i class="flaticon-towel"></i></li>
                      </ul>
                    </div>
                    <div class="col col-md-5 text-end">
                      <div class="permalink">
                        <a href="room-details.html">Details <i class="ti-arrow-right"></i></a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="position-re o-hidden">
                  <img src="@/assets/img/rooms/6.jpg" alt="" />
                </div>
                <span class="category"><a href="rooms2.html">Book</a></span>
                <div class="con">
                  <h6><a href="room-details.html">300$ / Night</a></h6>
                  <h5><a href="room-details.html">Deluxe Room</a></h5>
                  <div class="line"></div>
                  <div class="row facilities">
                    <div class="col col-md-7">
                      <ul>
                        <li><i class="flaticon-bed"></i></li>
                        <li><i class="flaticon-bath"></i></li>
                        <li><i class="flaticon-breakfast"></i></li>
                        <li><i class="flaticon-towel"></i></li>
                      </ul>
                    </div>
                    <div class="col col-md-5 text-end">
                      <div class="permalink">
                        <a href="room-details.html">Details <i class="ti-arrow-right"></i></a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="position-re o-hidden">
                  <img src="@/assets/img/rooms/8.jpg" alt="" />
                </div>
                <span class="category"><a href="rooms2.html">Book</a></span>
                <div class="con">
                  <h6><a href="room-details.html">150$ / Night</a></h6>
                  <h5><a href="room-details.html">Superior Room</a></h5>
                  <div class="line"></div>
                  <div class="row facilities">
                    <div class="col col-md-7">
                      <ul>
                        <li><i class="flaticon-bed"></i></li>
                        <li><i class="flaticon-bath"></i></li>
                        <li><i class="flaticon-breakfast"></i></li>
                        <li><i class="flaticon-towel"></i></li>
                      </ul>
                    </div>
                    <div class="col col-md-5 text-end">
                      <div class="permalink">
                        <a href="room-details.html">Details <i class="ti-arrow-right"></i></a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
              <div class="item">
                <div class="position-re o-hidden">
                  <img src="@/assets/img/rooms/5.jpg" alt="" />
                </div>
                <span class="category"><a href="rooms2.html">Book</a></span>
                <div class="con">
                  <h6><a href="room-details.html">400$ / Night</a></h6>
                  <h5><a href="room-details.html">Wellness Room</a></h5>
                  <div class="line"></div>
                  <div class="row facilities">
                    <div class="col col-md-7">
                      <ul>
                        <li><i class="flaticon-bed"></i></li>
                        <li><i class="flaticon-bath"></i></li>
                        <li><i class="flaticon-breakfast"></i></li>
                        <li><i class="flaticon-towel"></i></li>
                      </ul>
                    </div>
                    <div class="col col-md-5 text-end">
                      <div class="permalink">
                        <a href="room-details.html">Details <i class="ti-arrow-right"></i></a>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <!-- Pricing -->
    <PricingComponent></PricingComponent>
  </main>
</template>
