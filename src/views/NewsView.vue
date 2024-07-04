<script setup lang="ts">
import NewsComponent from '../template/10_NewsComponent.vue'
import { onMounted, reactive } from 'vue'
import { NewsApi } from '../generated/api-client/api'
import { News } from '../generated/api-client/models'
import dayjs from 'dayjs'

const state = reactive({
  items: [] as News[],
  page: 1
})

onMounted(async () => {
  await new NewsApi().newsGetAll().then((res) => {
    state.items = res.data as News[]
  })
})
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/7-CbzaxWf1.jpg"
    >
      <img src="../assets/img/slider/7.jpg" v-show="false" />
      <div class="container">
        <div class="row">
          <div class="col-md-12 text-left caption mt-90">
            <h5>D&L Furniture</h5>
            <h1>Tin tức nội thất</h1>
          </div>
        </div>
      </div>
    </div>
    <!-- News 2 -->
    <section class="news2 section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-8">
            <div class="row">
              <div class="col-md-12" v-for="item in state.items">
                <div class="item">
                  <div class="post-img">
                    <a href="post.html"> <img src="../assets/img/restaurant/2.png" alt="" /> </a>
                    <div class="date">
                      <a href="post.html">
                        <span>{{ dayjs(item.updatedDate).format('MMMM') }}</span>
                        <i>{{ dayjs(item.updatedDate).format('MM') }}</i>
                      </a>
                    </div>
                  </div>
                  <div class="post-cont">
                    <a href="news.html"><span class="tag">NHÀ ĐẸP</span></a>
                    <h5>
                      <a href="post.html">{{ item.titles }}</a>
                    </h5>
                    <p>
                      {{ item.summary }}
                    </p>
                    <div class="butn-dark">
                      <a href="post.html"><span>Chi tiết</span></a>
                    </div>
                  </div>
                </div>
              </div>

              <div class="col-md-12">
                <!-- Pagination -->
                <ul class="news-pagination-wrap align-center mb-30 mt-30">
                  <li>
                    <a href="blog2.html#"><i class="ti-angle-left"></i></a>
                  </li>
                  <li><a href="blog2.html#">1</a></li>
                  <li><a href="blog2.html#" class="active">2</a></li>
                  <li><a href="blog2.html#">3</a></li>
                  <li>
                    <a href="blog2.html#"><i class="ti-angle-right"></i></a>
                  </li>
                </ul>
                <div class="text-xs-center">
                  <v-pagination v-model="state.page" :length="4" circle></v-pagination>
                </div>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class="news2-sidebar row">
              <div class="col-md-12">
                <div class="widget search">
                  <form>
                    <input type="text" name="search" placeholder="Type here ..." />
                    <button type="submit"><i class="ti-search" aria-hidden="true"></i></button>
                  </form>
                </div>
              </div>
              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Bài viết liên quan</h6>
                  </div>
                  <ul class="recent">
                    <li>
                      <div class="thum"><img src="../assets/img/restaurant/2.png" alt="" /></div>
                      <a href="post.html"
                        >Ngất ngây trước mẫu thiết kế nội thất biệt thự 100m2 ấn tượng</a
                      >
                    </li>
                    <li>
                      <div class="thum"><img src="../assets/img/spa/3.png" alt="" /></div>
                      <a href="post.html">Mẫu thiết kế phòng ngủ đẹp như mơ</a>
                    </li>
                    <li>
                      <div class="thum"><img src="../assets/img/slider/7.jpg" alt="" /></div>
                      <a href="post.html"
                        >Ý tưởng thiết kế nội thất căn hộ chung cư 45m2 tuyệt đẹp
                      </a>
                    </li>
                  </ul>
                </div>
              </div>
              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Archives</h6>
                  </div>
                  <ul>
                    <li><a href="#">December 2022</a></li>
                    <li><a href="#">November 2022</a></li>
                    <li><a href="#">October 2022</a></li>
                  </ul>
                </div>
              </div>
              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Categories</h6>
                  </div>
                  <ul>
                    <li>
                      <a href="news.html"><i class="ti-angle-right"></i>Restaurant</a>
                    </li>
                    <li>
                      <a href="news.html"><i class="ti-angle-right"></i>Hotel Design</a>
                    </li>
                    <li>
                      <a href="news.html"><i class="ti-angle-right"></i>Span Center</a>
                    </li>
                  </ul>
                </div>
              </div>
              <div class="col-md-12">
                <div class="widget">
                  <div class="widget-title">
                    <h6>Tags</h6>
                  </div>
                  <ul class="tags">
                    <li><a href="#">Restaurant</a></li>
                    <li><a href="#">Hotel</a></li>
                    <li><a href="#">Spa</a></li>
                    <li><a href="#">Health Club</a></li>
                    <li><a href="#">Luxury Hotel</a></li>
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
