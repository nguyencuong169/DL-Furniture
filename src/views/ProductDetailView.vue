<script setup lang="ts"></script>

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
            <div class="section-subtitle">Luxury Hotel</div>
            <div class="section-title">Junior Suite</div>
          </div>
          <div class="col-md-8">
            <p class="mb-30">
              Hotel non lorem ac erat suscipit bibendum nulla facilisi. Sedeuter nunc volutpat miss
              sapien vel conseyen turpeutionyer masin libero sevenion vusetion viventa augue sit
              amet hendrerit vestibulum. Duisteyerion venenatis lacus gravida eros ut turpis
              interdum ornare.
            </p>
            <p class="mb-30">
              Interdum et malesu they adamale fames ac anteipsu pimsine faucibus curabitur arcu site
              feugiat in tortor in, volutpat sollicitudin libero. Hotel non lorem acer suscipit
              bibendum vulla facilisi nedeuter nunc volutpa mollis sapien velet conseyer
              turpeutionyer masin libero sempe mollis.
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
            <div class="section-subtitle"><span>Luxury Hotel</span></div>
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
    <section class="pricing section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-4">
            <div class="section-subtitle"><span>Best Prices</span></div>
            <div class="section-title">Extra Services</div>
            <p>
              The best prices for your relaxing vacation. The utanislen quam nestibulum ac quame
              odion elementum sceisue the aucan.
            </p>
            <p>
              Orci varius natoque penatibus et magnis disney parturient monte nascete ridiculus mus
              nellen etesque habitant morbine.
            </p>
            <div class="reservations mb-30">
              <div class="icon"><span class="flaticon-call"></span></div>
              <div class="text">
                <p>For information</p>
                <a href="tel:855-100-4444">855 100 4444</a>
              </div>
            </div>
          </div>
          <div class="col-md-8">
            <div class="owl-carousel owl-theme">
              <div class="pricing-card">
                <img src="@/assets/img/pricing/1.jpg" alt="" />
                <div class="desc">
                  <div class="name">Room cleaning</div>
                  <div class="amount">$50<span>/ month</span></div>
                  <ul class="list-unstyled list">
                    <li><i class="ti-check"></i> Hotel ut nisan the duru</li>
                    <li><i class="ti-check"></i> Orci miss natoque vasa ince</li>
                    <li><i class="ti-close unavailable"></i>Clean sorem ipsum morbin</li>
                  </ul>
                </div>
              </div>
              <div class="pricing-card">
                <img src="@/assets/img/pricing/2.jpg" alt="" />
                <div class="desc">
                  <div class="name">Drinks included</div>
                  <div class="amount">$30<span>/ daily</span></div>
                  <ul class="list-unstyled list">
                    <li><i class="ti-check"></i> Hotel ut nisan the duru</li>
                    <li><i class="ti-check"></i> Orci miss natoque vasa ince</li>
                    <li><i class="ti-close unavailable"></i>Clean sorem ipsum morbin</li>
                  </ul>
                </div>
              </div>
              <div class="pricing-card">
                <img src="@/assets/img/pricing/3.jpg" alt="" />
                <div class="desc">
                  <div class="name">Room Breakfast</div>
                  <div class="amount">$30<span>/ daily</span></div>
                  <ul class="list-unstyled list">
                    <li><i class="ti-check"></i> Hotel ut nisan the duru</li>
                    <li><i class="ti-check"></i> Orci miss natoque vasa ince</li>
                    <li><i class="ti-close unavailable"></i>Clean sorem ipsum morbin</li>
                  </ul>
                </div>
              </div>
              <div class="pricing-card">
                <img src="@/assets/img/pricing/4.jpg" alt="" />
                <div class="desc">
                  <div class="name">Safe & Secure</div>
                  <div class="amount">$15<span>/ daily</span></div>
                  <ul class="list-unstyled list">
                    <li><i class="ti-check"></i> Hotel ut nisan the duru</li>
                    <li><i class="ti-check"></i> Orci miss natoque vasa ince</li>
                    <li><i class="ti-close unavailable"></i>Clean sorem ipsum morbin</li>
                  </ul>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>
