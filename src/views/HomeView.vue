<script setup lang="ts">
import { onBeforeUnmount, onMounted } from 'vue'
import SliderComponent from '../template/02_SliderComponent.vue'
import AboutComponent from '../template/03_AboutComponent.vue'
import StatsComponent from '../template/12_StatsComponent.vue'
import HomeCollectionComponent from '../components/HomeCollectionComponent.vue'
import HomeFeaturedProjectsComponent from '../components/HomeFeaturedProjectsComponent.vue'
import PricingComponent from '../template/05_PricingComponent.vue'
import StatementComponent from '../template/13_StatementComponent.vue'
import HomeCraftComponent from '../template/06_PromoVideoComponent.vue'
import FaciltiesComponent from '../template/07_FaciltiesComponent.vue'
import TestiominalsComponent from '../template/08_TestiominalsComponent.vue'
import ServicesComponent from '../template/09_ServicesComponent.vue'
import NewsComponent from '../template/10_NewsComponent.vue'
import BookingFormComponent from '../template/11_BookingFormComponent.vue'

const HOME_SEO_MARKER = 'data-dl-home-seo'
const defaultTitle = document.title
const homeTitle = 'D&L Furniture | Thiết kế & thi công nội thất gỗ óc chó'
const homeDescription =
  'D&L Furniture thiết kế và thi công nội thất gỗ óc chó theo hiện trạng, đồng hành từ khảo sát, sản xuất đến lắp đặt hoàn thiện.'

const removeHomeSeo = () => {
  document.head.querySelectorAll(`[${HOME_SEO_MARKER}]`).forEach((element) => element.remove())
}

const addMeta = (attribute: 'name' | 'property', key: string, content: string) => {
  const meta = document.createElement('meta')
  meta.setAttribute(attribute, key)
  meta.setAttribute('content', content)
  meta.setAttribute(HOME_SEO_MARKER, '')
  document.head.appendChild(meta)
}

const updateHomeSeo = () => {
  removeHomeSeo()

  const canonicalUrl = new URL('/', window.location.origin).toString()
  const socialImage = new URL(
    '/media/gallery/walnut-home-library.webp',
    window.location.origin
  ).toString()

  document.title = homeTitle
  addMeta('name', 'description', homeDescription)
  addMeta('name', 'robots', 'index, follow, max-image-preview:large')
  addMeta('property', 'og:type', 'website')
  addMeta('property', 'og:locale', 'vi_VN')
  addMeta('property', 'og:site_name', 'D&L Furniture')
  addMeta('property', 'og:title', homeTitle)
  addMeta('property', 'og:description', homeDescription)
  addMeta('property', 'og:url', canonicalUrl)
  addMeta('property', 'og:image', socialImage)
  addMeta('name', 'twitter:card', 'summary_large_image')
  addMeta('name', 'twitter:title', homeTitle)
  addMeta('name', 'twitter:description', homeDescription)
  addMeta('name', 'twitter:image', socialImage)

  const canonical = document.createElement('link')
  canonical.rel = 'canonical'
  canonical.href = canonicalUrl
  canonical.setAttribute(HOME_SEO_MARKER, '')
  document.head.appendChild(canonical)

  const structuredData = document.createElement('script')
  structuredData.type = 'application/ld+json'
  structuredData.setAttribute(HOME_SEO_MARKER, '')
  structuredData.textContent = JSON.stringify({
    '@context': 'https://schema.org',
    '@type': 'LocalBusiness',
    name: 'D&L Furniture',
    url: canonicalUrl,
    image: socialImage,
    telephone: '+84961109897',
    email: 'info@dl-furniture.com',
    address: {
      '@type': 'PostalAddress',
      streetAddress: 'Đường Cầu Liêu, Thạch Xá',
      addressLocality: 'Thạch Thất',
      addressRegion: 'Hà Nội',
      addressCountry: 'VN'
    },
    description: homeDescription
  })
  document.head.appendChild(structuredData)
}

onMounted(() => {
  document.body.classList.add('home-page-active')
  updateHomeSeo()
})

onBeforeUnmount(() => {
  document.body.classList.remove('home-page-active')
  removeHomeSeo()
  document.title = defaultTitle
})
</script>

<template>
  <main>
    <SliderComponent />
    <AboutComponent />
    <StatsComponent />
    <HomeCollectionComponent />
    <PricingComponent />
    <StatementComponent />
    <HomeFeaturedProjectsComponent />
    <HomeCraftComponent />
    <FaciltiesComponent />
    <ServicesComponent />
    <TestiominalsComponent />
    <NewsComponent :limit="6" :loop="false" variant="grid" />
    <BookingFormComponent />
  </main>
</template>

<style scoped>
:global(body.home-page-active) {
  overflow-x: clip;
}

@media (max-width: 575px) {
  :global(body.home-page-active .progress-wrap) {
    display: none !important;
  }
}
</style>
