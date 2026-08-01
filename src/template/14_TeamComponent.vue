<script setup lang="ts">
import { ref, onMounted, nextTick } from 'vue'
import { fetchTeamMembers, type TeamMemberResponse } from '../api/teamClient'
import { initOwlCarousel } from '../utils/carousel'

const teamMembers = ref<TeamMemberResponse[]>([])

onMounted(async () => {
  teamMembers.value = await fetchTeamMembers()
  await nextTick()
  initOwlCarousel('.team .owl-carousel', {
    loop: true,
    margin: 30,
    dots: true,
    mouseDrag: true,
    autoplay: true,
    autoplayHoverPause: true,
    nav: false,
    navText: [
      "<span class='lnr ti-angle-left'></span>",
      "<span class='lnr ti-angle-right'></span>"
    ],
    responsiveClass: true,
    responsive: {
      0: { items: 1, dots: true },
      600: { items: 2 },
      1000: { items: 3 }
    }
  })
})
</script>

<template>
  <section class="team section-padding bg-cream">
    <div class="container">
      <div class="row">
        <div class="col-md-12">
          <div class="section-subtitle">Đội ngũ</div>
          <div class="section-title">Nhà thiết kế</div>
        </div>
      </div>
      <div class="row">
        <div class="col-md-12 owl-carousel owl-theme">
          <div class="item" v-for="member in teamMembers" :key="member.id">
            <div class="img"><img :src="member.avatarImage" :alt="member.fullName" /></div>
            <div class="info">
              <h6>{{ member.fullName }}</h6>
              <p>{{ member.role }}</p>
              <div class="social valign">
                <div class="full-width">
                  <a :href="member.instagramUrl || '#'"><i class="ti-instagram"></i></a>
                  <a :href="member.twitterUrl || '#'"><i class="ti-twitter"></i></a>
                  <a :href="member.facebookUrl || '#'"><i class="ti-facebook"></i></a>
                  <a :href="member.pinterestUrl || '#'"><i class="ti-pinterest"></i></a>
                  <p>{{ member.email }}</p>
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
