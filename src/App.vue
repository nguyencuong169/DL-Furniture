<script setup lang="ts">
import { RouterView } from 'vue-router'
import NavbarComponent from './template/01_NavbarComponent.vue'
import FooterComponent from './template/13_FooterComponent.vue'
</script>

<template>
  <NavbarComponent />
  <RouterView />
  <FooterComponent />
</template>

<style scoped></style>
