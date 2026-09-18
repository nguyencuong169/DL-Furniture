/* Full-page visual review of localhost home page.
 * Captures every major section + checks console errors, overflow, contrast basics.
 * Run: node scripts/review-full-home.cjs
 */
const puppeteer = require('puppeteer')

// Ưu tiên Chrome hệ thống (bundle Chromium của puppeteer quá cũ với Vite dev ESM)
const CHROME_PATHS = [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
]
const executablePath = CHROME_PATHS.find((p) => require('fs').existsSync(p))

const BASE = process.argv[2] || 'http://localhost:5173'
const sleep = (ms) => new Promise((r) => setTimeout(r, ms))

;(async () => {
  const browser = await puppeteer.launch({ headless: 'new', executablePath })
  const page = await browser.newPage()
  await page.setViewport({ width: 1440, height: 900 })

  const consoleErrors = []
  page.on('console', (msg) => {
    if (msg.type() === 'error') consoleErrors.push(msg.text())
  })
  page.on('pageerror', (err) => consoleErrors.push(`PAGEERROR: ${err.message}`))

  await page.goto(BASE, { waitUntil: 'networkidle2', timeout: 60000 })
  await sleep(3000)

  // Sections cần chụp, theo thứ tự xuất hiện trên trang
  const sections = [
    ['hero', '.header, .slider, section'],
    ['about', '.about'],
    ['pricing', '.pricing, .packages'],
    ['collection', '.home-collection'],
    ['projects', '#featured-projects'],
    ['statement', '.statement, .lm-testing'],
    ['craft', '.craft'],
    ['testimonials', '.testimonials'],
    ['booking', '#consultation']
  ]

  const results = {}
  let idx = 0
  for (const [name, selector] of sections) {
    const found = await page.evaluate((sel) => {
      const el = document.querySelector(sel)
      if (!el) return false
      el.scrollIntoView({ block: 'start' })
      return true
    }, selector)
    if (!found) {
      results[name] = 'NOT_FOUND: ' + selector
      continue
    }
    await sleep(1800)
    idx++
    const file = `docs/review-full-${String(idx).padStart(2, '0')}-${name}.png`
    await page.screenshot({ path: file })
    results[name] = file
  }

  // Kiểm tra overflow ngang + font
  const audit = await page.evaluate(() => {
    const doc = document.documentElement
    const overflow = doc.scrollWidth > doc.clientWidth
    const overflowEls = []
    document.querySelectorAll('body *').forEach((el) => {
      const r = el.getBoundingClientRect()
      if (r.right > doc.clientWidth + 8 && r.width > 40) {
        const cls = (el.className && typeof el.className === 'string') ? el.className.split(' ')[0] : el.tagName
        overflowEls.push(cls + ' | right=' + Math.round(r.right))
      }
    })
    return {
      horizontalOverflow: overflow,
      overflowElements: overflowEls.slice(0, 10),
      fonts: {
        gilda: document.fonts.check('400 20px "Gilda Display"'),
        barlow: document.fonts.check('400 15px "Barlow"'),
        dancing: document.fonts.check('600 30px "Dancing Script"')
      },
      projectsCards: document.querySelectorAll('#featured-projects .fp-card').length
    }
  })

  console.log(JSON.stringify({ consoleErrors: consoleErrors.slice(0, 10), sections: results, audit }, null, 2))
  await browser.close()
})()