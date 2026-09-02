// Re-initialize an Owl Carousel after Vue has rendered async content.
//
// The Owl Carousel jQuery plugin (and jQuery itself) are loaded globally via
// index.html scripts (src/assets/js/jquery-3.6.3.min.js, owl.carousel.min.js,
// custom.js). Because custom.js runs on document ready — BEFORE the async API
// data renders — the carousels are never initialised on the freshly rendered
// items, and the default `.owl-carousel { display: none }` CSS keeps them
// hidden. This helper re-runs the plugin initialisation after the items exist.
//
// custom.js also inits carousels by a parent class selector (e.g.
// `.pricing .owl-carousel`), which will match Vue-rendered sections too and
// may init on an empty container before async data resolves. initOwlCarousel
// detects that (`owl-loaded` class) and destroys it before re-initialising.

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

function getJQuery(): any {
  const w = window as unknown as { $?: any }
  return w.$
}

export function initOwlCarousel(selector: string, options: OwlCarouselOptions, retries = 10): void {
  const $ = getJQuery()

  if ($ && typeof $.fn?.owlCarousel === 'function') {
    const $el = $(selector)
    if ($el.length) {
      // If custom.js already initialised this carousel (e.g. it matched by a
      // parent class selector before the Vue items existed), tear it down
      // first so we can re-init with the freshly rendered items.
      if ($el.hasClass('owl-loaded')) {
        $el.trigger('destroy.owl.carousel')
      }
      $el.owlCarousel(options)
      return
    }
  }

  // jQuery/owl plugin or the target DOM may not be ready yet — retry briefly.
  if (retries > 0) {
    window.setTimeout(() => initOwlCarousel(selector, options, retries - 1), 100)
  }
}

// Điều khiển autoplay của một carousel đã init ('stop' | 'play') qua event trigger.
// Dùng cho các trường hợp cần phạm vi pause hẹp hơn autoplayHoverPause mặc định
// (ví dụ: chỉ pause khi hover vào nút CTA thay vì cả vùng hero).
export function triggerOwlAutoplay(selector: string, action: 'stop' | 'play'): void {
  const $ = getJQuery()
  if ($ && typeof $.fn?.owlCarousel === 'function') {
    $(selector).trigger(`${action}.owl.autoplay`)
  }
}

// Call on component unmount to avoid leaking owl-carousel's internal timers
// (autoplay) and event listeners once Vue removes the DOM node (e.g. on SPA
// route change away from the page while the carousel is mounted).
export function destroyOwlCarousel(selector: string): void {
  const $ = getJQuery()
  if (!$) return

  const $el = $(selector)
  if ($el.length && $el.hasClass('owl-loaded')) {
    $el.trigger('destroy.owl.carousel')
  }
}
