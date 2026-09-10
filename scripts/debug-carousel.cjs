// Debug DOM của các carousel Swiper-adapter — đo kích thước/vị trí thực tế
// Chạy: node scripts/debug-carousel.js (dev server phải đang chạy ở :5173)
const puppeteer = require('puppeteer')

;(async () => {
  const browser = await puppeteer.launch({
    executablePath: 'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe',
    headless: true,
    args: ['--no-sandbox', '--disable-setuid-sandbox']
  })
  const page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 800 })
  page.on('pageerror', (e) => console.log('PAGE ERROR:', e.message))
  await page.goto('http://localhost:5173/', { waitUntil: 'networkidle2', timeout: 60000 })
  await new Promise((r) => setTimeout(r, 5000))

  const info = await page.evaluate(() => {
    const out = {}
    const measure = (name, sel) => {
      const el = document.querySelector(sel)
      if (!el) { out[name] = 'NOT FOUND'; return }
      const r = el.getBoundingClientRect()
      const cs = getComputedStyle(el)
      out[name] = {
        x: Math.round(r.x), w: Math.round(r.width), h: Math.round(r.height),
        display: cs.display, overflow: cs.overflow, position: cs.position,
        cls: el.className.slice(0, 100)
      }
    }
    measure('hero-carousel', '.slider-fade .owl-carousel')
    measure('hero-stage', '.slider-fade .owl-stage')
    measure('hero-nav', '.slider-fade .owl-nav')
    measure('hero-prev', '.slider-fade .owl-prev')
    const hs = document.querySelector('.slider-fade .owl-item')
    if (hs) {
      const r = hs.getBoundingClientRect()
      out.heroSlide = { x: Math.round(r.x), w: Math.round(r.width), h: Math.round(r.height), inlineW: hs.style.width, opacity: getComputedStyle(hs).opacity }
    }
    out.heroDots = {
      count: document.querySelectorAll('.slider-fade .owl-dot').length,
      navHidden: document.querySelector('.slider-fade .owl-nav')?.hidden
    }
    const testi = document.querySelector('.home-testimonials .owl-carousel')
    if (testi) {
      const r = testi.getBoundingClientRect()
      out.testi = { x: Math.round(r.x), w: Math.round(r.width) }
      out.testiSlides = Array.from(testi.querySelectorAll('.owl-item')).slice(0, 4).map((s) => {
        const sr = s.getBoundingClientRect()
        return { x: Math.round(sr.x), w: Math.round(sr.width), inlineW: s.style.width }
      })
    } else { out.testi = 'SECTION NOT RENDERED (fetch chậm?)' }
    const pricing = document.querySelector('.pricing .owl-carousel')
    if (pricing) {
      const r = pricing.getBoundingClientRect()
      out.pricing = { x: Math.round(r.x), w: Math.round(r.width) }
      out.pricingSlides = Array.from(pricing.querySelectorAll('.owl-item')).slice(0, 5).map((s) => Math.round(s.getBoundingClientRect().x))
      const title = document.querySelector('.pricing .section-title')
      if (title) { const tr = title.getBoundingClientRect(); out.pricingTitle = { x: Math.round(tr.x), w: Math.round(tr.width) } }
    }
    return out
  })
  console.log(JSON.stringify(info, null, 1))
  await page.screenshot({ path: 'docs/debug-hero.png' })
  await page.evaluate(() => document.querySelector('.home-testimonials')?.scrollIntoView({ block: 'center' }))
  await new Promise((r) => setTimeout(r, 1500))
  await page.screenshot({ path: 'docs/debug-testimonials.png' })
  await page.evaluate(() => document.querySelector('.pricing')?.scrollIntoView({ block: 'center' }))
  await new Promise((r) => setTimeout(r, 1500))
  await page.screenshot({ path: 'docs/debug-pricing.png' })
  console.log('Screenshots saved: docs/debug-{hero,testimonials,pricing}.png')
  await browser.close()
})().catch((e) => { console.error('FATAL', e.message); process.exit(1) })