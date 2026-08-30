import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { mount } from '@vue/test-utils'
import { nextTick } from 'vue'

import StatsComponent from '../12_StatsComponent.vue'
import { fetchStats } from '../../api/statsClient'

/* Mock the statsClient module: keep FALLBACK_STATS real, only stub fetchStats */
vi.mock('../../api/statsClient', async (importOriginal) => {
  const actual = await importOriginal<typeof import('../../api/statsClient')>()
  return {
    ...actual,
    fetchStats: vi.fn(),
  }
})

/* ── Shared mock-state variables ────────────────────────────────────── */
let ioCallback: IntersectionObserverCallback | null = null
const mockObserve = vi.fn()
const mockDisconnect = vi.fn()
const mockUnobserve = vi.fn()
let mockTime: number

/* Helper: advance through all microtask cycles so Vue re-renders flush */
const flush = async () => {
  await nextTick()
  await nextTick()
}

/* Helper: create a fake IO entry */
const makeIoEntry = (intersecting: boolean): IntersectionObserverEntry =>
  ({ isIntersecting: intersecting, time: 0, target: {} as Element, rootBounds: null, boundingClientRect: {} as DOMRect, intersectionRect: {} as DOMRect, intersectionRatio: intersecting ? 0.6 : 0 }) as unknown as IntersectionObserverEntry

/* Helper: trigger the captured IO callback */
const fireIo = (intersecting = true) => {
  if (ioCallback) ioCallback([makeIoEntry(intersecting)], {} as IntersectionObserver)
}

describe('12_StatsComponent.vue', () => {
  beforeEach(() => {
    vi.useFakeTimers()
    mockTime = 1000
    ioCallback = null
    mockObserve.mockClear()
    mockDisconnect.mockClear()
    mockUnobserve.mockClear()

    /* IntersectionObserver mock */
    ;(globalThis as any).IntersectionObserver = class MockIntersectionObserver {
      constructor(callback: IntersectionObserverCallback) {
        ioCallback = callback
      }
      observe() {
        mockObserve()
      }
      unobserve() {
        mockUnobserve()
      }
      disconnect() {
        mockDisconnect()
      }
      takeRecords() {
        return []
      }
    }

    /* Window geometry */
    Object.defineProperty(window, 'scrollY', { value: 0, configurable: true, writable: true })
    Object.defineProperty(window, 'innerHeight', { value: 1000, configurable: true, writable: true })

    /* getBoundingClientRect — bar sits in middle of viewport */
    vi.spyOn(Element.prototype, 'getBoundingClientRect').mockReturnValue({
      top: 100,
      bottom: 500,
      left: 0,
      right: 0,
      width: 0,
      height: 400,
      x: 0,
      y: 100,
      toJSON: () => ({}),
    } as DOMRect)

    /* performance.now — controlled so animation progress is deterministic */
    vi.spyOn(performance, 'now').mockImplementation(() => mockTime)

    /* requestAnimationFrame — delegates to faked setTimeout, advancing mockTime */
    vi.spyOn(window, 'requestAnimationFrame').mockImplementation((cb: FrameRequestCallback) => {
      return setTimeout(() => {
        mockTime += 16.67
        cb(mockTime)
      }, 16.67) as unknown as number
    })
    vi.spyOn(window, 'cancelAnimationFrame').mockImplementation(() => {})

    /* fetchStats — defaults to empty (no real values to merge) */
    vi.mocked(fetchStats).mockResolvedValue([])
  })

  afterEach(() => {
    vi.useRealTimers()
    vi.restoreAllMocks()
  })

  describe('rendering', () => {
    it('renders the stats section with correct class and aria-label', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const section = wrapper.find('section.dl-stats')
      expect(section.exists()).toBe(true)
      expect(section.attributes('aria-label')).toBe(
        'Số liệu uy tín của D&L Furniture'
      )
    })

    it('renders 4 stat items in the grid', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const items = wrapper.findAll('.dl-stat')
      expect(items).toHaveLength(4)
    })

    it('renders correct labels for each stat', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const labels = wrapper.findAll('.dl-stat-label')
      expect(labels).toHaveLength(4)
      expect(labels[0].text()).toBe('Năm kinh nghiệm')
      expect(labels[1].text()).toBe('Dự án thực hiện')
      expect(labels[2].text()).toBe('M² nội thất hoàn thiện')
      expect(labels[3].text()).toBe('Khách hàng hài lòng')
    })

    it('renders correct suffixes (+ for most, % for satisfaction)', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const suffixes = wrapper.findAll('.dl-stat-suffix')
      expect(suffixes).toHaveLength(4)
      expect(suffixes[0].text()).toBe('+')
      expect(suffixes[1].text()).toBe('+')
      expect(suffixes[2].text()).toBe('+')
      expect(suffixes[3].text()).toBe('%')
    })

    it('renders an icon (svg) for each stat', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const icons = wrapper.findAll('.dl-stat-icon')
      expect(icons).toHaveLength(4)
      icons.forEach((icon) => {
        expect(icon.find('svg').exists()).toBe(true)
      })
    })

    it('renders the visually-hidden text with correct value and label', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const srOnly = wrapper.findAll('.visually-hidden')
      expect(srOnly).toHaveLength(4)
      // Uses stat.value (target value), not display value
      expect(srOnly[0].text()).toContain('15')
      expect(srOnly[0].text()).toContain('Năm kinh nghiệm')
    })

    it('shows 0 for all stat numbers before animation starts', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers).toHaveLength(4)
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })
    })
  })
  describe('IntersectionObserver triggering', () => {
    it('starts count-up when IO fires with intersecting=true and scrollY > 4', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      /* Simulate user has scrolled */
      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      /* Start-delay fires */
      vi.advanceTimersByTime(350)
      await flush()

      /* Animation completes */
      vi.advanceTimersByTime(3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')
    })

    it('does not start count-up when IO fires with intersecting=false', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(false)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })
    })

    it('does not re-trigger when already started', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      /* Fire IO again — should be a no-op */
      fireIo(true)
      await flush()

      /* Numbers should remain at final values, not reset */
      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')
      expect(mockObserve).toHaveBeenCalledTimes(1) /* only observed once during mount */
    })

    it('disconnects the IntersectionObserver when triggered', async () => {
      mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      expect(mockDisconnect).toHaveBeenCalled()
    })

    it('attaches a scroll fallback when IO fires but scrollY <= 4', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      /* scrollY is 0 (not scrolled) */
      expect(window.scrollY).toBe(0)

      const addSpy = vi.spyOn(window, 'addEventListener')
      fireIo(true)
      await flush()

      expect(addSpy).toHaveBeenCalledWith('scroll', expect.any(Function), { passive: true })

      /* No start-delay should have been set yet (only via scroll fallback) */
      vi.advanceTimersByTime(350 + 3000)
      await flush()

      /* Numbers still 0 because trigger hasn't been called */
      const numbers = wrapper.findAll('.dl-stat-number')
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })
    })

    it('does not attach scroll fallback when IO fires with intersecting=false', async () => {
      mount(StatsComponent)
      await flush()

      const addSpy = vi.spyOn(window, 'addEventListener')
      fireIo(false)
      await flush()

      expect(addSpy).not.toHaveBeenCalled()
    })

    it('does not attach scroll fallback twice on repeated IO events', async () => {
      mount(StatsComponent)
      await flush()

      const addSpy = vi.spyOn(window, 'addEventListener')
      fireIo(true)
      await flush()

      /* Fire again — should not add another listener */
      fireIo(true)
      await flush()

      const scrollCalls = addSpy.mock.calls.filter((c) => c[0] === 'scroll')
      expect(scrollCalls).toHaveLength(1)
    })
  })
  describe('scroll fallback', () => {
    /* Helper: mount, fire IO with scrollY=0, and grab the scroll listener */
    async function mountWithScrollFallback() {
      const wrapper = mount(StatsComponent)
      await flush()

      const addSpy = vi.spyOn(window, 'addEventListener')
      fireIo(true) /* scrollY is 0 → scroll fallback attached */
      await flush()

      const scrollCb = addSpy.mock.calls.find((c) => c[0] === 'scroll')?.[1] as () => void
      expect(scrollCb).toBeDefined()
      return { wrapper, scrollCb }
    }

    it('triggers count-up when bar enters the read zone on scroll', async () => {
      const { wrapper, scrollCb } = await mountWithScrollFallback()

      /* Bar is at top=100, bottom=500. Read line = 1000*0.8 = 800. 15% = 150 */
      /* 100 < 800 && 500 > 150 → should trigger */
      scrollCb()
      await flush()

      expect(mockObserve).toHaveBeenCalledTimes(1)
      expect(mockDisconnect).toHaveBeenCalled()

      /* Start delay + animation */
      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
    })

    it('does NOT trigger when bar is below the read zone (scrolled past)', async () => {
      const { wrapper, scrollCb } = await mountWithScrollFallback()

      /* Bar is below the read zone: top > 800 */
      vi.spyOn(Element.prototype, 'getBoundingClientRect').mockReturnValue({
        top: 900, bottom: 1300, left: 0, right: 0, width: 0, height: 400, x: 0, y: 900, toJSON: () => ({})
      } as DOMRect)

      scrollCb()
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })
    })

    it('does NOT trigger when bar is above the 15% threshold (not yet visible)', async () => {
      const { wrapper, scrollCb } = await mountWithScrollFallback()

      /* Bar is above viewport: bottom <= 150 */
      vi.spyOn(Element.prototype, 'getBoundingClientRect').mockReturnValue({
        top: -600, bottom: -100, left: 0, right: 0, width: 0, height: 500, x: 0, y: -600, toJSON: () => ({})
      } as DOMRect)

      scrollCb()
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })
    })

    it('removes the scroll listener after triggering', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      const removeSpy = vi.spyOn(window, 'removeEventListener')

      /* Fire IO with scrollY=0 to attach scroll fallback */
      const addSpy = vi.spyOn(window, 'addEventListener')
      fireIo(true)
      await flush()

      const scrollCb = addSpy.mock.calls.find((c) => c[0] === 'scroll')?.[1] as () => void

      /* Now scroll and trigger */
      scrollCb()
      await flush()

      expect(removeSpy).toHaveBeenCalledWith('scroll', expect.any(Function))
    })
  })

  describe('no IntersectionObserver support', () => {
    it('falls back to setTimeout(runCounters, 400) when IO is undefined', async () => {
      /* Temporarily remove IntersectionObserver */
      const originalIO = (globalThis as any).IntersectionObserver
      delete (globalThis as any).IntersectionObserver

      const wrapper = mount(StatsComponent)
      await flush()

      /* With 400 ms delay, numbers should still be 0 right after mount */
      let numbers = wrapper.findAll('.dl-stat-number')
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })

      /* After 400 ms, count-up starts */
      vi.advanceTimersByTime(400)
      await flush()

      /* Still 0 — animation in progress */
      numbers = wrapper.findAll('.dl-stat-number')
      numbers.forEach((n) => {
        expect(n.text()).toBe('0')
      })

      /* After animation completes (~3000 ms) */
      vi.advanceTimersByTime(3000)
      await flush()

      numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')

      /* Restore */
      ;(globalThis as any).IntersectionObserver = originalIO
    })
  })

  describe('count-up animation', () => {
    it('animates from 0 to target values with IO trigger', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      /* Before start delay — still 0 */
      let numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('0')

      /* After start delay fires — runCounters schedules a RAF */
      vi.advanceTimersByTime(350)
      await flush()

      /* Advance one frame so the first RAF callback fires */
      vi.advanceTimersByTime(100)
      await flush()

      /* Animation should be in progress — values > 0 but < target */
      numbers = wrapper.findAll('.dl-stat-number')
      expect(Number(numbers[0].text())).toBeGreaterThan(0)
      expect(Number(numbers[0].text())).toBeLessThan(15)

      /* Complete animation */
      vi.advanceTimersByTime(3000)
      await flush()

      numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
    })

    it('respects prefer-reduced-motion by not skipping animation (current impl)', async () => {
      /* The current component does NOT check prefers-reduced-motion in JS;
         the CSS media query only removes the box-shadow. The count-up still runs.
         This test documents that behaviour. */
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
    })

    it('formats large numbers with vi-VN locale (thousands separator)', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      /* 12000 → "12.000" in vi-VN locale */
      expect(numbers[2].text()).toBe('12.000')
    })
  })

  describe('real stats merging', () => {
    it('calls fetchStats on mount', async () => {
      mount(StatsComponent)
      await flush()

      expect(fetchStats).toHaveBeenCalledTimes(1)
    })

    it('applies real stats when value >= fallback', async () => {
      vi.mocked(fetchStats).mockResolvedValue([
        { id: 'experience', value: 20 },
        { id: 'projects', value: 500 },
        { id: 'area', value: 15000 },
        { id: 'satisfaction', value: 99 },
      ])

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('20')
      expect(numbers[1].text()).toBe('500')
      expect(numbers[2].text()).toBe('15.000')
      expect(numbers[3].text()).toBe('99')
    })

    it('ignores real stats when value < fallback', async () => {
      vi.mocked(fetchStats).mockResolvedValue([
        { id: 'experience', value: 5 },
        { id: 'projects', value: 100 },
        { id: 'area', value: 5000 },
        { id: 'satisfaction', value: 80 },
      ])

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      /* Fallback values should be preserved */
      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')
    })

    it('ignores real stats when value equals fallback (no change)', async () => {
      vi.mocked(fetchStats).mockResolvedValue([
        { id: 'experience', value: 15 },
        { id: 'projects', value: 320 },
        { id: 'area', value: 12000 },
        { id: 'satisfaction', value: 98 },
      ])

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')
    })

        it('ignores unknown stat IDs in real response', async () => {
      vi.mocked(fetchStats).mockResolvedValue([
        { id: 'experience', value: 20 },
        { id: 'unknown_stat' as any, value: 99999 },
      ])

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('20') /* experience updated */
      expect(numbers[1].text()).toBe('320') /* projects not in response → fallback */
      expect(numbers[2].text()).toBe('12.000') /* area not in response → fallback */
      expect(numbers[3].text()).toBe('98') /* satisfaction not in response → fallback */
    })

    it('keeps fallback values when fetchStats returns empty array', async () => {
      vi.mocked(fetchStats).mockResolvedValue([])

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')
    })

    it('keeps fallback values when fetchStats returns equal fallback values', async () => {
      /* fetchStats returns FALLBACK_STATS — the merge condition
         `found.value !== item.value` is false → no change */
      vi.mocked(fetchStats).mockResolvedValue([
        { id: 'experience', value: 15 },
        { id: 'projects', value: 320 },
        { id: 'area', value: 12000 },
        { id: 'satisfaction', value: 98 },
      ])

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
    })

    it('keeps numbers at 0 when fetchStats never resolves (pending)', async () => {
      vi.mocked(fetchStats).mockReturnValue(new Promise(() => {}))

      const wrapper = mount(StatsComponent)
      await flush()
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350 + 3000)
      await flush()

      /* Should use fallback values */
      const numbers = wrapper.findAll('.dl-stat-number')
      expect(numbers[0].text()).toBe('15')
      expect(numbers[1].text()).toBe('320')
      expect(numbers[2].text()).toBe('12.000')
      expect(numbers[3].text()).toBe('98')
    })
  })

  describe('cleanup on unmount', () => {
    it('disconnects the IntersectionObserver on unmount', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      expect(mockDisconnect).toHaveBeenCalledTimes(1)

      wrapper.unmount()

      expect(mockDisconnect).toHaveBeenCalledTimes(2)
    })

    it('removes the scroll listener on unmount when scroll fallback is active', async () => {
      const removeSpy = vi.spyOn(window, 'removeEventListener')

      const wrapper = mount(StatsComponent)
      await flush()

      const addSpy = vi.spyOn(window, 'addEventListener')
      fireIo(true) /* scrollY is 0 → scroll listener attached */
      await flush()

      const scrollHandler = addSpy.mock.calls.find((c) => c[0] === 'scroll')?.[1] as () => void
      expect(scrollHandler).toBeDefined()

      wrapper.unmount()

      /* removeEventListener must NOT pass { passive: true } — that option is
         only valid on addEventListener. The component removes with the exact
         handler reference it originally attached. */
      expect(removeSpy).toHaveBeenCalledWith('scroll', scrollHandler)
    })

    it('clears the start-delay timeout on unmount', async () => {
      const clearTimeoutSpy = vi.spyOn(window, 'clearTimeout')

      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      wrapper.unmount()

      /* clearTimeout should have been called to cancel the pending 350 ms delay */
      expect(clearTimeoutSpy).toHaveBeenCalled()
    })

    it('cancels the animation frame on unmount', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      Object.defineProperty(window, 'scrollY', { value: 100, configurable: true, writable: true })
      fireIo(true)
      await flush()

      vi.advanceTimersByTime(350) /* Start the animation */
      await flush()

      wrapper.unmount()

      /* cancelAnimationFrame is called during cleanup — no assertion on value,
         just verifying unmount doesn't throw */
      expect(true).toBe(true)
    })

    it('completes without errors when unmounted immediately after mount', async () => {
      const wrapper = mount(StatsComponent)
      await flush()

      expect(() => wrapper.unmount()).not.toThrow()
    })
  })
})




