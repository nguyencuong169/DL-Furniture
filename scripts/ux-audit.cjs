/* UX metrics audit: section rhythm, tap targets, heading hierarchy, alt coverage.
 * Run: node scripts/ux-audit.cjs [baseURL]
 */
const puppeteer = require('puppeteer')

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
  await page.goto(BASE, { waitUntil: 'networkidle2', timeout: 60000 })
  await sleep(2500)

  // Cuộn hết trang để lazy content render
  await page.evaluate(async () => {
    for (let y = 0; y < document.body.scrollHeight; y += 800) {
      window.scrollTo(0, y)
      await new Promise((r) => setTimeout(r, 120))
    }
    window.scrollTo(0, 0)
  })
  await sleep(1200)

  const audit = await page.evaluate(() => {
    const res = {}

    // 1. Section rhythm: chiều cao + nền từng section chính
    res.sections = Array.from(document.querySelectorAll('main > *')).map((el) => {
      const r = el.getBoundingClientRect()
      const bg = getComputedStyle(el).backgroundColor
      const cls = el.className && typeof el.className === 'string' ? el.className.split(' ')[0] : el.tagName
      return { section: cls, height: Math.round(r.height), bg }
    })

    // 2. Tap targets nhỏ (<24px) trên link/nút khả dụng
    const smallTargets = []
    document.querySelectorAll('main a, main button').forEach((el) => {
      const r = el.getBoundingClientRect()
      if (r.width > 0 && r.height > 0 && (r.height < 24 || r.width < 24)) {
        const txt = (el.textContent || '').trim().slice(0, 24)
        const cls = typeof el.className === 'string' ? el.className.split(' ')[0] : el.tagName
        smallTargets.push(`${el.tagName}.${cls} "${txt}" ${Math.round(r.width)}x${Math.round(r.height)}`)
      }
    })
    res.smallTapTargets = smallTargets.slice(0, 12)
    res.smallTapTargetCount = smallTargets.length

    // 3. Heading hierarchy
    res.headings = {
      h1: document.querySelectorAll('main h1').length,
      h2: document.querySelectorAll('main h2').length,
      h3: document.querySelectorAll('main h3').length
    }

    // 4. Ảnh thiếu alt
    res.imgsMissingAlt = Array.from(document.querySelectorAll('main img'))
      .filter((i) => !i.getAttribute('alt'))
      .length
    res.imgsTotal = document.querySelectorAll('main img').length

    // 5. Hero: chiều cao so với viewport
    const hero = document.querySelector('.header') || document.querySelector('main > *')
    res.heroHeightVsViewport = hero
      ? Math.round((hero.getBoundingClientRect().height / window.innerHeight) * 100) / 100
      : null

    return res
  })

  console.log(JSON.stringify(audit, null, 2))
  await browser.close()
})()