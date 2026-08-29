// Khôi phục hiệu ứng scroll-reveal của theme gốc (custom.js — "05. Animations").
//
// custom.js chỉ bind jQuery Waypoints một lần lúc document.ready. Trong SPA,
// Vue render lại các section khi điều hướng, nên những `.animate-box` sinh ra
// sau đó không được bind và mất hiệu ứng. Hàm này dùng IntersectionObserver
// để kích hoạt lại hiệu ứng cho mọi `.animate-box` chưa animate, giữ đúng
// hành vi của bản gốc:
//   - `<html>` có class `js` → `.animate-box` ẩn ban đầu (opacity 0)
//   - khi cuộn tới ngưỡng 85% viewport → thêm class hiệu ứng
//     (mặc định fadeInUp) với độ trễ so le 200ms giữa các phần tử.

const EFFECT_CLASSES: Record<string, string> = {
  fadeIn: 'fadeIn',
  fadeInLeft: 'fadeInLeft',
  fadeInRight: 'fadeInRight'
}

let intersectionObserver: IntersectionObserver | null = null
let mutationObserver: MutationObserver | null = null
let scheduleTimer = 0

function revealElement(target: HTMLElement): void {
  const effect = EFFECT_CLASSES[target.dataset.animateEffect ?? ''] ?? 'fadeInUp'
  target.classList.add(effect, 'animated')
  target.classList.remove('item-animate')
}

function observePending(): void {
  if (!intersectionObserver) return
  document
    .querySelectorAll<HTMLElement>('.animate-box:not(.animated):not(.item-animate)')
    .forEach((el) => intersectionObserver?.observe(el))
}

export function initScrollAnimations(): void {
  if (typeof document === 'undefined') return

  // Giống modernizr của theme gốc: bật trạng thái ẩn ban đầu cho .animate-box
  document.documentElement.classList.add('js')

  const pending = document.querySelectorAll<HTMLElement>(
    '.animate-box:not(.animated):not(.item-animate)'
  )
  if (!pending.length) return

  if (typeof IntersectionObserver === 'undefined') {
    // Trình duyệt quá cũ: không ẩn, hiển thị luôn để không mất nội dung
    pending.forEach(revealElement)
    return
  }

  if (!intersectionObserver) {
    intersectionObserver = new IntersectionObserver(
      (entries, obs) => {
        entries.forEach((entry) => {
          if (!entry.isIntersecting) return
          const el = entry.target as HTMLElement
          el.classList.add('item-animate')
          obs.unobserve(el)
          // Giống custom.js: gom các phần tử đang chờ, animate so le 200ms
          window.setTimeout(() => {
            document.querySelectorAll<HTMLElement>('.animate-box.item-animate').forEach((target, k) => {
              window.setTimeout(() => revealElement(target), k * 200)
            })
          }, 100)
        })
      },
      // Tương đương offset '85%' của Waypoints
      { rootMargin: '0px 0px -15% 0px' }
    )

    // Section render muộn (dữ liệu API về sau, v-if...) vẫn được bắt
    if (typeof MutationObserver !== 'undefined' && !mutationObserver) {
      mutationObserver = new MutationObserver(() => {
        window.clearTimeout(scheduleTimer)
        scheduleTimer = window.setTimeout(observePending, 200)
      })
      mutationObserver.observe(document.body, { childList: true, subtree: true })
    }
  }

  pending.forEach((el) => intersectionObserver?.observe(el))
}