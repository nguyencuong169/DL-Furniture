<script setup lang="ts">
import { RouterView } from 'vue-router'
import NavbarComponent from './template/01_NavbarComponent.vue'
import BookingFormComponent from './template/11_BookingFormComponent.vue'
import ClientsComponent from './template/12_ClientsComponent.vue'
import FooterComponent from './template/13_FooterComponent.vue'
</script>

<template>
  <NavbarComponent />
  <RouterView />
  <BookingFormComponent />
  <ClientsComponent />
  <FooterComponent />
</template>

<style scoped></style>
