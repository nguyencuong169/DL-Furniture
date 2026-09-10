// ── Swiper adapter với "ngôn ngữ class" của Owl Carousel ────────────────────
// Thay thế jQuery + owl.carousel bằng Swiper 11 (thuần ES, ~40KB vs ~350KB
// jQuery stack) mà KHÔNG phải sửa 166 rule CSS của theme vốn nhắm vào các
// class owl (.owl-carousel/.owl-item/.owl-dots/.owl-nav/.owl-loaded/active).
//
// Adapter phát ra đúng cấu trúc DOM mà Owl từng tạo:
//   .owl-carousel.owl-theme (container, Swiper thêm class .swiper)
//     └ .owl-stage            (wrapper — tương đương .owl-stage-outer cũ)
//         └ .item.owl-item.swiper-slide (slide)
//     └ .owl-nav  (nút prev/next — do adapter tạo, theme CSS định vị)
//     └ .owl-dots (chấm điều hướng — do adapter tạo, theme CSS style)
// và đồng bộ class `active` trên slide đang hiển thị (tương đương
// .owl-item.active của Owl) để caption animation của hero chạy đúng.

import Swiper from 'swiper'
import { Autoplay, EffectFade, Navigation, Pagination } from 'swiper/modules'
import 'swiper/css'
import 'swiper/css/effect-fade'
import '../assets/css/swiper-owl-compat.css'

export interface OwlCarouselOptions {
  items?: number
  loop?: boolean
  margin?: number
  mouseDrag?: boolean
  autoplay?: boolean
  autoplayTimeout?: number
  autoplayHoverPause?: boolean
  animateOut?: string
  dots?: boolean
  nav?: boolean
  navText?: string[]
  responsiveClass?: boolean
  responsive?: Record<string, { items?: number; dots?: boolean; nav?: boolean; margin?: number }>
}

interface SwiperAutoplayControl {
  stop(): void
  start(): void
}

interface SwiperLike {
  slides: HTMLElement[]
  activeIndex: number
  params: { slidesPerView?: number | string | 'auto' }
  autoplay?: SwiperAutoplayControl
  destroy(deleteInstance?: boolean, cleanStyles?: boolean): void
  on(event: string, handler: () => void): void
}

declare global {
  interface HTMLElement {
    swiper?: SwiperLike
  }
}

const SLIDE_CLASS = 'swiper-slide'

/** Đồng bộ class `active` trên các slide đang hiển thị (như Owl làm). */
const syncActiveClasses = (swiper: SwiperLike) => {
  // Phòng thủ: sau destroy() Swiper có thể để params/slides ở trạng thái lạ
  if (!swiper || !swiper.params || !swiper.slides) return
  const perView =
    typeof swiper.params.slidesPerView === 'number'
      ? Math.max(1, Math.round(swiper.params.slidesPerView))
      : 1
  swiper.slides.forEach((slide) => slide.classList.remove('active'))
  for (let i = swiper.activeIndex; i < swiper.activeIndex + perView; i += 1) {
    swiper.slides[i]?.classList.add('active')
  }
}

/** Map `responsive` của Owl → breakpoints của Swiper + danh sách media query
 * để bật/tắt nav/dots đúng theo từng breakpoint (Owl hỗ trợ, Swiper không). */
const buildBreakpoints = (options: OwlCarouselOptions) => {
  const breakpoints: Record<number, Record<string, unknown>> = {}
  const visibilityRules: Array<{ query: MediaQueryList; nav: boolean; dots: boolean }> = []

  if (options.responsive) {
    for (const [rawWidth, config] of Object.entries(options.responsive)) {
      const width = Number(rawWidth)
      breakpoints[width] = {
        slidesPerView: config.items ?? 1,
        spaceBetween: config.margin ?? options.margin ?? 0
      }
      visibilityRules.push({
        query: window.matchMedia(`(min-width: ${width}px)`),
        nav: config.nav ?? options.nav ?? false,
        dots: config.dots ?? options.dots ?? false
      })
    }
  }

  return { breakpoints, visibilityRules }
}

/** Bật/tắt nav & dots theo breakpoint đang hiệu lực (rule khớp cuối cùng). */
const applyNavDotsVisibility = (
  rules: Array<{ query: MediaQueryList; nav: boolean; dots: boolean }>,
  navEl: HTMLElement | null,
  dotsEl: HTMLElement | null
) => {
  if (!navEl && !dotsEl) return
  let active = rules[0]
  for (const rule of rules) {
    if (rule.query.matches) active = rule
  }
  if (navEl) navEl.hidden = !active?.nav
  if (dotsEl) dotsEl.hidden = !active?.dots
}

const destroySwiperOn = (el: HTMLElement) => {
  el.swiper?.destroy(true, true)
  el.swiper = undefined
  el.classList.remove('owl-loaded')
  el.querySelectorAll(':scope > .owl-nav, :scope > .owl-dots').forEach((node) => node.remove())
}

const initSwiperOn = (el: HTMLElement, options: OwlCarouselOptions) => {
  // Ref nội bộ cho event handlers (xem chú thích `on` bên dưới)
  let swiperRef: SwiperLike | undefined
  const handleSync = () => {
    if (swiperRef) syncActiveClasses(swiperRef)
  }

  // Re-init an toàn: dọn instance cũ + nav/dots cũ trước khi tạo mới.
  destroySwiperOn(el)

  const wrapper = el.querySelector<HTMLElement>(':scope > .owl-stage')
  if (!wrapper) return

  // Gắn class slide cho các phần tử con (Vue render lại có thể tạo node mới).
  Array.from(wrapper.children).forEach((child) => {
    child.classList.add(SLIDE_CLASS, 'owl-item')
  })

  const prefersReducedMotion =
    typeof window.matchMedia === 'function' &&
    window.matchMedia('(prefers-reduced-motion: reduce)').matches

  const useNav = options.nav ?? false
  const useDots = options.dots ?? false

  let navEl: HTMLElement | null = null
  let dotsEl: HTMLElement | null = null

  if (useNav) {
    navEl = document.createElement('div')
    navEl.className = 'owl-nav'
    const prev = document.createElement('button')
    prev.type = 'button'
    prev.className = 'owl-prev'
    prev.setAttribute('aria-label', 'Slide trước')
    prev.innerHTML = options.navText?.[0] ?? '<i class="ti-angle-left" aria-hidden="true"></i>'
    const next = document.createElement('button')
    next.type = 'button'
    next.className = 'owl-next'
    next.setAttribute('aria-label', 'Slide tiếp theo')
    next.innerHTML = options.navText?.[1] ?? '<i class="ti-angle-right" aria-hidden="true"></i>'
    navEl.append(prev, next)
    el.appendChild(navEl)
  }

  if (useDots) {
    dotsEl = document.createElement('div')
    dotsEl.className = 'owl-dots'
    el.appendChild(dotsEl)
  }

  const { breakpoints, visibilityRules } = buildBreakpoints(options)
  const isFade = options.animateOut === 'fadeOut'

  const swiper = new Swiper(el, {
    modules: [Autoplay, EffectFade, Navigation, Pagination],
    wrapperClass: 'owl-stage',
    slidesPerView: options.items ?? 1,
    spaceBetween: options.margin ?? 0,
    loop: options.loop ?? false,
    speed: isFade ? 1000 : 400,
    effect: isFade ? 'fade' : 'slide',
    fadeEffect: { crossFade: true },
    grabCursor: true,
    simulateTouch: options.mouseDrag !== false,
    autoplay:
      options.autoplay && !prefersReducedMotion
        ? {
            delay: options.autoplayTimeout ?? 5000,
            disableOnInteraction: false,
            pauseOnMouseEnter: options.autoplayHoverPause ?? false
          }
        : false,
    navigation:
      navEl && useNav
        ? {
            prevEl: navEl.querySelector<HTMLElement>('.owl-prev'),
            nextEl: navEl.querySelector<HTMLElement>('.owl-next'),
            disabledClass: 'disabled'
          }
        : false,
    pagination:
      dotsEl && useDots
        ? {
            el: dotsEl,
            bulletClass: 'owl-dot',
            bulletActiveClass: 'active',
            clickable: true,
            renderBullet: (index: number, className: string) =>
              `<button type="button" class="${className}" aria-label="Đến slide ${index + 1}"><span></span></button>`
          }
        : false,
    breakpoints,
    // LƯU Ý: event 'init' bắn ĐỒNG BỘ trong constructor (trước khi `const swiper`
    // gán xong → TDZ) và Swiper KHÔNG luôn luôn truyền instance vào handler.
    // → Dùng swiperRef nội bộ, set sau constructor; init sync chạy qua rAF bên dưới.
    on: {
      init: handleSync,
      slideChange: handleSync,
      update: handleSync,
      breakpoint: () => {
        handleSync()
        applyNavDotsVisibility(visibilityRules, navEl, dotsEl)
      }
    }
  })

  swiperRef = swiper

  el.classList.add('owl-loaded')
  applyNavDotsVisibility(visibilityRules, navEl, dotsEl)
  // Đảm bảo class active được gắn ngay cả khi event 'init' bắn trước khi slides sẵn sàng.
  window.requestAnimationFrame(() => syncActiveClasses(swiper))
}

/**
 * Khởi tạo carousel Swiper trên mọi phần tử khớp `selector`, giữ nguyên hợp
 * đồng API cũ của Owl (components không cần đổi code khi chuyển engine).
 * DOM chưa sẵn sàng → tự thử lại (retries × 100ms) như bản cũ.
 */
export function initOwlCarousel(selector: string, options: OwlCarouselOptions, retries = 10): void {
  const containers = document.querySelectorAll<HTMLElement>(selector)
  if (!containers.length) {
    if (retries > 0) {
      window.setTimeout(() => initOwlCarousel(selector, options, retries - 1), 100)
    }
    return
  }
  containers.forEach((el) => initSwiperOn(el, options))
}

/** Điều khiển autoplay ('stop' | 'play') — thay cho jQuery trigger event Owl. */
export function triggerOwlAutoplay(selector: string, action: 'stop' | 'play'): void {
  document.querySelectorAll<HTMLElement>(selector).forEach((el) => {
    const autoplay = el.swiper?.autoplay
    if (!autoplay) return
    if (action === 'stop') autoplay.stop()
    else autoplay.start()
  })
}

/** Hủy carousel khi component unmount — tránh leak timer autoplay/listeners. */
export function destroyOwlCarousel(selector: string): void {
  document.querySelectorAll<HTMLElement>(selector).forEach((el) => destroySwiperOn(el))
}