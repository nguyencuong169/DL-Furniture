// Re-initialize an Owl Carousel after Vue has rendered async content.
//
// The Owl Carousel jQuery plugin (and jQuery itself) are loaded globally via
// index.html scripts (src/assets/js/jquery-3.6.3.min.js, owl.carousel.min.js,
// custom.js). Because custom.js runs on document ready — BEFORE the async API
// data renders — the carousels are never initialised on the freshly rendered
// items, and the default `.owl-carousel { display: none }` CSS keeps them
// hidden. This helper re-runs the plugin initialisation after the items exist.

export interface OwlCarouselOptions {
  loop?: boolean
  margin?: number
  mouseDrag?: boolean
  autoplay?: boolean
  autoplayHoverPause?: boolean
  dots?: boolean
  nav?: boolean
  navText?: string[]
  responsiveClass?: boolean
  responsive?: Record<string, { items?: number; dots?: boolean; nav?: boolean; margin?: number }>
}

export function initOwlCarousel(selector: string, options: OwlCarouselOptions, retries = 10): void {
  const w = window as unknown as { $?: any }
  const $ = w.$

  if ($ && typeof $.fn?.owlCarousel === 'function') {
    const $el = $(selector)
    if ($el.length) {
      // If custom.js already initialised this carousel (e.g. fallback data
      // rendered before document ready), tear it down first so we can re-init
      // with the freshly rendered items.
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
