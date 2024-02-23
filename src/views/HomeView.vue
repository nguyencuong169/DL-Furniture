<script setup lang="ts">
import SliderComponent from '../template/02_SliderComponent.vue'
import AboutComponent from '../template/03_AboutComponent.vue'
import ProductComponent from '../template/04_ProductComponent.vue'
import PricingComponent from '../template/05_PricingComponent.vue'
import PromoVideoComponent from '../template/06_PromoVideoComponent.vue'
import FaciltiesComponent from '../template/07_FaciltiesComponent.vue'
import TestiominalsComponent from '../template/08_TestiominalsComponent.vue'
import ServicesComponent from '../template/09_ServicesComponent.vue'
import NewsComponent from '../template/10_NewsComponent.vue'
import BookingFormComponent from '../template/11_BookingFormComponent.vue'
import ClientsComponent from '../template/12_ClientsComponent.vue'
</script>

<template>
  <main>
    <SliderComponent />
    <AboutComponent />
    <ProductComponent :need-header="true" title-header="Mẫu nội thất nổi bật" />
    <PricingComponent />
    <PromoVideoComponent />
    <FaciltiesComponent />
    <TestiominalsComponent />
    <ServicesComponent />
    <NewsComponent />
    <BookingFormComponent />
    <ClientsComponent />
  </main>
</template>
