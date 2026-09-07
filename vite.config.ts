import { fileURLToPath, URL } from 'node:url'
import { createRequire } from 'node:module'

import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import vueJsx from '@vitejs/plugin-vue-jsx'

// vite-plugin-prerender có bản ESM (.mjs) bị lỗi (dùng require trong ES scope)
// → nạp thẳng bản CJS qua createRequire để tránh ReferenceError khi Vite load config.
const requireCjs = createRequire(import.meta.url)
const prerenderModule = requireCjs('vite-plugin-prerender') as
  | ((options: { routes: string[] }) => import('vite').Plugin)
  | { default: (options: { routes: string[] }) => import('vite').Plugin }
const prerender =
  typeof prerenderModule === 'function' ? prerenderModule : prerenderModule.default
// Chromium đi kèm puppeteer 1.20 là bản ~77 (2019) không chạy được cú pháp ES2020
// (optional chaining…) trong bundle Vite → Vue không mount → HTML rỗng.
// Dùng Edge/Chrome hiện đại trên máy để render thay thế.
const { PuppeteerRenderer } = prerenderModule as unknown as {
  PuppeteerRenderer: new (opts: Record<string, unknown>) => unknown
}
const fsCjs = requireCjs('node:fs') as typeof import('node:fs')
const browserCandidates = [
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Microsoft/Edge/Application/msedge.exe',
  'C:/Program Files/Google/Chrome/Application/chrome.exe'
]
const browserPath = browserCandidates.find((p) => fsCjs.existsSync(p))

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [
    vue(),
    vueJsx(),
    // HM4: prerender 3 trang kéo traffic chính thành HTML tĩnh lúc build
    // để Google đọc được nội dung ngay (không phải chờ chạy JavaScript).
    prerender({
      routes: ['/', '/san-pham', '/du-an'],
      // Plugin không tự suy ra staticDir từ outDir (bug nội bộ) → truyền đường dẫn tuyệt đối
      staticDir: fileURLToPath(new URL('./dist', import.meta.url)),
      renderer: new PuppeteerRenderer({
        ...(browserPath ? { executablePath: browserPath } : {}),
        headless: true,
        args: ['--no-sandbox', '--disable-setuid-sandbox'],
        // Chờ app Vue mount + fetch dữ liệu fallback trước khi chụp HTML
        renderAfterTime: 8000
      })
    })
  ],
  build: { chunkSizeWarningLimit: 1600 },
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url))
    }
  },
  clearScreen: false,
  base: '/',
  server: {
    watch: {
      ignored: ['**/DLFurniture.Api/**', '**/node_modules/**']
    }
  }
})
