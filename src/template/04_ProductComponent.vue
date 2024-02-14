<script setup lang="ts">
import { reactive, watch } from 'vue'

const props = defineProps<{
  needHeader?: boolean
  titleHeader?: String
}>()

const state = reactive({
  needHeader: props.needHeader,
  titleHeader: props.titleHeader
})

watch(
  () => props.needHeader,
  (value) => {
    state.needHeader = value
  }
)

watch(
  () => props.titleHeader,
  (value) => {
    state.titleHeader = value
  }
)
</script>

<template>
  <section class="rooms1 section-padding bg-cream" data-scroll-index="1">
    <div class="container">
      <div class="row" v-show="state.needHeader">
        <div class="col-md-12">
          <div class="section-subtitle">D&L Furniture</div>
          <div class="section-title">{{ state.titleHeader }}</div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-4">
          <div class="item">
            <div class="position-re o-hidden"><img src="../assets/img/rooms/1.jpg" alt="" /></div>
            <span class="category"><a href="rooms2.html">Book</a></span>
            <div class="con">
              <h6><a href="san-pham/detail/1">11.000.000 VND</a></h6>
              <h5><a href="san-pham/detail/1">Giường Óc Chó - G01</a></h5>
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
                    <a href="san-pham/detail/1">Chi tiết <i class="ti-arrow-right"></i></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="item">
            <div class="position-re o-hidden"><img src="../assets/img/rooms/2.jpg" alt="" /></div>
            <span class="category"><a href="rooms2.html">Book</a></span>
            <div class="con">
              <h6><a href="san-pham/detail/1">10.700.000 VND</a></h6>
              <h5><a href="san-pham/detail/1">Giường Óc Chó - G02</a></h5>
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
                    <a href="san-pham/detail/1">Chi tiết <i class="ti-arrow-right"></i></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4">
          <div class="item">
            <div class="position-re o-hidden"><img src="../assets/img/rooms/3.jpg" alt="" /></div>
            <span class="category"><a href="rooms2.html">Book</a></span>
            <div class="con">
              <h6><a href="san-pham/detail/1">25.000.000</a></h6>
              <h5><a href="san-pham/detail/1">Giường Óc Chó - G03</a></h5>
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
                    <a href="san-pham/detail/1">Chi tiết <i class="ti-arrow-right"></i></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="item">
            <div class="position-re o-hidden"><img src="../assets/img/rooms/4.jpg" alt="" /></div>
            <span class="category"><a href="rooms2.html">Book</a></span>
            <div class="con">
              <h6><a href="san-pham/detail/1">30.000.000 VNĐ</a></h6>
              <h5><a href="san-pham/detail/1">Giường Nhập Khẩu - G04</a></h5>
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
                    <a href="san-pham/detail/1">Chi tiết <i class="ti-arrow-right"></i></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-6">
          <div class="item">
            <div class="position-re o-hidden"><img src="../assets/img/rooms/7.jpg" alt="" /></div>
            <span class="category"><a href="rooms2.html">Book</a></span>
            <div class="con">
              <h6><a href="san-pham/detail/1">15.000.000</a></h6>
              <h5><a href="san-pham/detail/1">Tủ Óc Chó - T01</a></h5>
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
                    <a href="san-pham/detail/1">Chi tiết <i class="ti-arrow-right"></i></a>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped></style>
