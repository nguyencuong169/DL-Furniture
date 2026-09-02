// Ẩn preloader ngay khi Vue mount xong thay vì chờ jQuery fadeOut + delay
// ~1.4s như custom.js của theme gốc. Nếu jQuery đã ẩn sẵn (display:none)
// thì việc remove DOM vẫn an toàn; nếu custom.js lỗi, preloader vẫn được gỡ.

const FADE_MS = 400

export function hidePreloader(): void {
  if (typeof document === 'undefined') return

  const targets = [
    document.getElementById('preloader'),
    document.querySelector<HTMLElement>('.preloader-bg')
  ].filter((el): el is HTMLElement => el !== null)

  if (!targets.length) return

  targets.forEach((el) => {
    el.style.transition = `opacity ${FADE_MS}ms ease`
    el.style.opacity = '0'
    el.style.pointerEvents = 'none'
  })

  window.setTimeout(() => {
    targets.forEach((el) => el.remove())
  }, FADE_MS)
}