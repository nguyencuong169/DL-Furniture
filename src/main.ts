import './assets/main.css'
import { createApp } from 'vue'
import { createPinia } from 'pinia'

import App from './App.vue'
import router from './router'
import { hidePreloader } from './utils/preloader'
const app = createApp(App)
app.use(createPinia())
app.use(router)

app.mount('#app')

// Gỡ preloader ngay khi app render xong (xem src/utils/preloader.ts)
hidePreloader()
