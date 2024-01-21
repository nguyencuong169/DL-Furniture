<script setup lang="ts">
import AboutComponent from '../template/03_AboutComponent.vue'
import PricingComponent from '../template/05_PricingComponent.vue'
import FaciltiesComponent from '../template/07_FaciltiesComponent.vue'
import TeamComponent from '../template/14_TeamComponent.vue'
import TestiominalsComponent from '../template/08_TestiominalsComponent.vue'
</script>

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
            <h5>Luxury Hotel</h5>
            <h1>About Us</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- About -->
    <AboutComponent />

    <!-- Pricing -->
    <PricingComponent />

    <!-- Facilties -->
    <FaciltiesComponent />

    <!-- Team -->
    <TeamComponent />

    <!-- Testiominals -->
    <TestiominalsComponent />
  </main>
</template>

<style></style>
