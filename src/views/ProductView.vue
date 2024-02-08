<script setup lang="ts"></script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="src/assets/img/slider/1.jpg"
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
            <h1>Rooms & Suites</h1>
          </div>
        </div>
      </div>
    </div>
    <section class="rooms1 section-padding bg-cream" data-scroll-index="1">
      <div class="container">
        <div class="row">
          <div class="col-md-4">
            <div class="item">
              <div class="position-re o-hidden">
                <img src="@/assets/img/rooms/1.jpg" alt="" />
              </div>
              <span class="category"><a href="rooms2.html">Book</a></span>
              <div class="con">
                <h6><a href="/product/detail/1">150$ / Night</a></h6>
                <h5><a href="/product/detail/1">Junior Suite</a></h5>
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
                      <a href="/product/detail/1">Details <i class="ti-arrow-right"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="item">
              <div class="position-re o-hidden">
                <img src="@/assets/img/rooms/2.jpg" alt="" />
              </div>
              <span class="category"><a href="rooms2.html">Book</a></span>
              <div class="con">
                <h6><a href="/product/detail/1">200$ / Night</a></h6>
                <h5><a href="/product/detail/1">Family Room</a></h5>
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
                      <a href="/product/detail/1">Details <i class="ti-arrow-right"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="item">
              <div class="position-re o-hidden">
                <img src="@/assets/img/rooms/3.jpg" alt="" />
              </div>
              <span class="category"><a href="rooms2.html">Book</a></span>
              <div class="con">
                <h6><a href="/product/detail/1">250$ / Night</a></h6>
                <h5><a href="/product/detail/1">Double Room</a></h5>
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
                      <a href="/product/detail/1">Details <i class="ti-arrow-right"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="item">
              <div class="position-re o-hidden">
                <img src="@/assets/img/rooms/4.jpg" alt="" />
              </div>
              <span class="category"><a href="rooms2.html">Book</a></span>
              <div class="con">
                <h6><a href="/product/detail/1">300$ / Night</a></h6>
                <h5><a href="/product/detail/1">Deluxe Room</a></h5>
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
                      <a href="/product/detail/1">Details <i class="ti-arrow-right"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="item">
              <div class="position-re o-hidden">
                <img src="@/assets/img/rooms/7.jpg" alt="" />
              </div>
              <span class="category"><a href="rooms2.html">Book</a></span>
              <div class="con">
                <h6><a href="/product/detail/1">150$ / Night</a></h6>
                <h5><a href="/product/detail/1">Superior Room</a></h5>
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
                      <a href="/product/detail/1">Details <i class="ti-arrow-right"></i></a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    <RouterView></RouterView>
  </main>
</template>
