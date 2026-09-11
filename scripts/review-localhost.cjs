/* Visual review of localhost:5173 via Puppeteer (headless).
 * Checks: console errors, Dancing Script font, new polish elements
 * (new hero, assurances row, rotating badge, rail taglines, cream body bg).
 * Run: node scripts/review-localhost.cjs
 */
const puppeteer = require('puppeteer')

const BASE = 'http://localhost:5173'
const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

// Puppeteer 1.20 bundle Chromium ~84 — không đọc được syntax ES2022 mà Vite dev
// serve (optional chaining trong module graph) → dùng Chrome hệ thống.
const CHROME_PATHS = [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
]
const executablePath = CHROME_PATHS.find((p) => require('fs').existsSync(p))

;(async () => {
  const browser = await puppeteer.launch({ headless: 'new', executablePath })
  const page = await browser.newPage()
  await page.setViewport({ width: 1280, height: 800 })

  const consoleErrors = []
  page.on('console', (msg) => {
    if (msg.type() === 'error') consoleErrors.push(msg.text())
  })
  page.on('pageerror', (err) => consoleErrors.push(`PAGEERROR: ${err.message}\n${err.stack}`))

  await page.goto(BASE, { waitUntil: 'networkidle2', timeout: 60000 })
  await sleep(3000)

  const report = await page.evaluate(() => {
    const results = {}
    const text = (sel) => {
      const el = document.querySelector(sel)
      return el ? el.textContent.trim() : null
    }

    // 1. Hero (P1-1 + P3-7)
    results.heroH1 = text('#home-hero-title')
    results.heroH4 = text('.header .caption h4')
    const heroCta = document.querySelector('.header .caption .butn-dark a span')
    results.heroCtaHasSvg = heroCta ? Boolean(heroCta.querySelector('svg')) : null

    // 2. Cream body background (P3-6)
    results.bodyBg = getComputedStyle(document.body).backgroundColor

    // 3. Fonts (P2-3)
    results.fontDancingScript = document.fonts.check('600 30px "Dancing Script"')
    results.fontGildaDisplay = document.fonts.check('400 20px "Gilda Display"')
    results.fontBarlow = document.fonts.check('400 15px "Barlow"')
    const aboutScript = document.querySelector('.about-script')
    results.aboutScript = {
      exists: Boolean(aboutScript),
      text: aboutScript ? aboutScript.textContent.trim() : null,
      fontFamily: aboutScript ? getComputedStyle(aboutScript).fontFamily : null,
      fontLoaded: aboutScript
        ? document.fonts.check(
            getComputedStyle(aboutScript).fontWeight + ' 30px "Dancing Script"'
          )
        : null
    }

    // 4. Rotating badge (P2-5)
    const ring = document.querySelector('.about-badge-ring')
    results.badgeRing = {
      exists: Boolean(ring),
      ringText: ring && ring.querySelector('textPath') ? ring.querySelector('textPath').textContent.trim() : null,
      animation: ring ? getComputedStyle(ring).animationName : null
    }

    // 5. Rail taglines (P2-4)
    const tags = Array.from(document.querySelectorAll('.collection-rail-tag'))
    results.railTags = {
      count: tags.length,
      values: tags.map((t) => t.textContent.trim()).slice(0, 5)
    }

    // 6. Horizontal overflow check
    results.horizontalOverflow =
      document.documentElement.scrollWidth > document.documentElement.clientWidth

    return results
  })

  // Scroll to #consultation to render booking form + assurances row
  await page.evaluate(() => {
    const el = document.querySelector('#consultation')
    if (el) el.scrollIntoView()
  })
  await new Promise((r) => setTimeout(r, 2500))

  const assurances = await page.evaluate(() => {
    const row = document.querySelector('.consultation-assurances')
    if (!row) return { exists: false }
    const rect = row.getBoundingClientRect()
    const items = Array.from(row.querySelectorAll('li')).map((li) => {
      const liRect = li.getBoundingClientRect()
      return {
        title: li.querySelector('strong') ? li.querySelector('strong').textContent.trim() : null,
        detail: li.querySelector('small') ? li.querySelector('small').textContent.trim() : null,
        iconSvg: Boolean(li.querySelector('svg')),
        visible: liRect.width > 0 && liRect.height > 0
      }
    })
    const script = document.querySelector('.consultation-script')
    return {
      exists: true,
      itemCount: items.length,
      items,
      rowPosition: rect.bottom > window.innerHeight ? 'below-fold' : 'in-view',
      scriptFontFamily: script ? getComputedStyle(script).fontFamily : null,
      scriptFontLoaded: script
        ? document.fonts.check(getComputedStyle(script).fontWeight + ' 27px "Dancing Script"')
        : null
    }
  })

  // Screenshots of key areas
  await page.evaluate(() => window.scrollTo(0, 0))
  await new Promise((r) => setTimeout(r, 1200))
  await page.screenshot({ path: 'docs/review-hero.png' })
  await page.evaluate(() => {
    const el = document.querySelector('.about')
    if (el) el.scrollIntoView({ block: 'center' })
  })
  await new Promise((r) => setTimeout(r, 1500))
  await page.screenshot({ path: 'docs/review-about.png' })
  await page.evaluate(() => {
    const el = document.querySelector('.home-collection')
    if (el) el.scrollIntoView()
  })
  await new Promise((r) => setTimeout(r, 1500))
  await page.screenshot({ path: 'docs/review-collection.png' })
  await page.evaluate(() => {
    const el = document.querySelector('#consultation')
    if (el) el.scrollIntoView()
  })
  await new Promise((r) => setTimeout(r, 1500))
  await page.screenshot({ path: 'docs/review-booking.png' })

  console.log(JSON.stringify({ consoleErrors, page: report, assurances }, null, 2))
  await browser.close()
})()