// ── Scroll-to-top progress circle ───────────────────────────────────────────
// Thay phần "Scroll back to top" của theme custom.js (jQuery) bằng thuần TS:
//  - Vòng tròn SVG hiển thị % cuộn (stroke-dashoffset)
//  - Class `active-progress` hiện nút khi cuộn quá 150px (CSS theme có sẵn)
//  - Click → cuộn mượt về đầu trang
// Phần tử `.progress-wrap` nằm tĩnh trong index.html → init một lần duy nhất.

export function initProgressBar(): () => void {
  const wrap = document.querySelector<HTMLElement>('.progress-wrap')
  const path = document.querySelector<SVGPathElement>('.progress-wrap path')
  if (!wrap || !path) return () => {}

  const pathLength = path.getTotalLength()
  path.style.transition = path.style.webkitTransition = 'none'
  path.style.strokeDasharray = `${pathLength} ${pathLength}`
  path.style.strokeDashoffset = String(pathLength)
  // Ép browser tính toán layout trước khi bật transition (tránh animation nhảy)
  path.getBoundingClientRect()
  path.style.transition = path.style.webkitTransition = 'stroke-dashoffset 10ms linear'

  const updateProgress = () => {
    const scroll = window.scrollY
    const height = document.documentElement.scrollHeight - window.innerHeight
    if (height <= 0) return
    path.style.strokeDashoffset = String(pathLength - (scroll * pathLength) / height)
  }

  const onScroll = () => {
    updateProgress()
    wrap.classList.toggle('active-progress', window.scrollY > 150)
  }

  const onClick = (event: Event) => {
    event.preventDefault()
    window.scrollTo({ top: 0, behavior: 'smooth' })
  }

  updateProgress()
  window.addEventListener('scroll', onScroll, { passive: true })
  wrap.addEventListener('click', onClick)

  return () => {
    window.removeEventListener('scroll', onScroll)
    wrap.removeEventListener('click', onClick)
  }
}