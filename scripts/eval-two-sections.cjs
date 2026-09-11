/* Chụp 2 section đang gây băn khoăn: .home-collection & #featured-projects
   để phục vụ đánh giá "giữ hay thay". Chạy: node scripts/eval-two-sections.cjs */
const fs = require('fs')
const puppeteer = require('puppeteer')

const CHROME_PATHS = [
  'C:/Program Files/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Google/Chrome/Application/chrome.exe',
  'C:/Program Files (x86)/Microsoft/Edge/Application/msedge.exe'
]

;(async () => {
  const executablePath = CHROME_PATHS.find((p) => fs.existsSync(p))
  const browser = await puppeteer.launch({ headless: 'new', executablePath })
  const page = await browser.newPage()
  await page.setViewport({ width: 1440, height: 900 })
  await page.goto('http://localhost:5173/', { waitUntil: 'networkidle2', timeout: 60000 })
  await new Promise((r) => setTimeout(r, 3000))

  const targets = [
    { sel: '.home-collection', out: 'docs/eval-collection.png' },
    { sel: '#featured-projects', out: 'docs/eval-projects.png' }
  ]

  for (const t of targets) {
    const el = await page.$(t.sel)
    if (!el) {
      console.log('NOT FOUND: ' + t.sel)
      continue
    }
    // Auto-play cua fp-section co the lam mo hinh — thu lai 2 lan
    for (let attempt = 1; attempt <= 2; attempt++) {
      await page.evaluate((sel) => {
        const node = document.querySelector(sel)
        if (node) node.scrollIntoView({ block: 'start' })
      }, t.sel)
      await new Promise((r) => setTimeout(r, attempt === 1 ? 2500 : 1200))
      await el.screenshot({ path: t.out })
    }
    console.log('SAVED: ' + t.out)
  }

  await browser.close()
})().catch((e) => { console.error(e.message); process.exit(1) })