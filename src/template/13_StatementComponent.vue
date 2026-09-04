<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'

const sectionRef = ref<HTMLElement | null>(null)
const isVisible = ref(false)
let observer: IntersectionObserver | null = null
let resetObserver: IntersectionObserver | null = null

const prefersReducedMotion =
  typeof window !== 'undefined' &&
  window.matchMedia?.('(prefers-reduced-motion: reduce)').matches

interface QuoteWord {
  text: string
  keyword: boolean
  delay: number
}

/* Reveal từng từ: mỗi từ hiện lên so le như được đặt lại từng nét;
   gạch chân từ khóa sau đó "vẽ" trái->phải như nét bút (xem .dl-keyword::after) */
const WORD_START_DELAY = 150
const WORD_STAGGER = 90

const buildQuoteWords = (
  words: Array<string | { text: string; keyword?: boolean }>,
  startIndex: number
): QuoteWord[] =>
  words.map((word, index) => ({
    // Nối sẵn khoảng trắng sau mỗi từ NGAY TRONG CHUỖI.
    // Không để space literal trong template — Vue compiler (chế độ condense)
    // sẽ xóa khoảng trắng đầu/cuối bên trong element, gây dính chữ như đã thấy.

    text: (typeof word === 'string' ? word : word.text) + ' ',
    keyword: typeof word !== 'string' && word.keyword === true,
    delay: WORD_START_DELAY + (startIndex + index) * WORD_STAGGER
  }))

const quoteLine1 = buildQuoteWords(
  ['Không', 'gian', 'đẹp', 'không', 'nằm', 'ở', 'sự', 'cầu', 'kỳ,'],
  0
)
const quoteLine2 = buildQuoteWords(
  [
    'mà',
    'nằm',
    'ở',
    'sự',
    { text: 'tận tâm', keyword: true },
    'trong',
    { text: 'từng chi tiết', keyword: true }
  ],
  quoteLine1.length
)

onMounted(() => {
  if (prefersReducedMotion || typeof IntersectionObserver === 'undefined') {
    isVisible.value = true
    return
  }

  const el = sectionRef.value
  if (!el) return

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        /* Reset về trạng thái ẩn là việc của resetObserver (ngưỡng rời HOÀN
           TOÀN viewport) — ở đây chỉ quan tâm lúc hiện */
        if (!entry.isIntersecting) return
        /* Đang hiện rồi thì không restart animation giữa chừng — chống flicker
           khi cuộn nhanh đi ngang qua section */
        if (isVisible.value) return
        // Đợi một chút để trình duyệt kịp vẽ trạng thái ẩn ban đầu (opacity: 0).
        // Kết hợp rAF + setTimeout đảm bảo đã có ít nhất một lần paint trước khi
        // kích hoạt animation — nếu không, phần tử "nhảy thẳng" hiện ra không animation.
        requestAnimationFrame(() => {
          setTimeout(() => {
            isVisible.value = true
          }, 80)
        })
      })
    },
    { threshold: 0.25, rootMargin: '0px 0px -5% 0px' }
  )
  observer.observe(el)

  /* RESET CÓ VANH (phương án C): giữ replay theo thiết kế gốc nhưng chống flicker.
     observer trên reset ở ngưỡng 25% + rootMargin -5% (rời NGAY khi còn lem viền)
     — nếu reset tại đó thì cuộn nhanh qua sẽ thấy chữ hiện dở bị tắt (flicker).
     Observer dưới đây dùng threshold 0, KHÔNG margin: chỉ kết luận "rời hẳn"
     khi pixel cuối cùng của section ra khỏi viewport → reset lúc đó invisible
     với người dùng; cuộn ngược lại trước khi rời hẳn → animation vẫn giữ nguyên. */
  resetObserver = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (!entry.isIntersecting && isVisible.value) {
          isVisible.value = false
        }
      })
    },
    { threshold: 0 }
  )
  resetObserver.observe(el)
})

onBeforeUnmount(() => {
  observer?.disconnect()
  resetObserver?.disconnect()
})
</script>

<template>
  <section
    ref="sectionRef"
    class="dl-statement"
    :class="{ 'is-visible': isVisible }"
    aria-label="Triết lý kiến tạo của D&L Furniture"
  >
    <div class="container dl-statement-container">
      <p class="section-subtitle dl-reveal" style="--reveal-delay: 0ms">
        <span>Triết lý kiến tạo</span>
      </p>

      <blockquote class="dl-statement-quote">
        <span class="dl-quote-line">
          <span
            v-for="word in quoteLine1"
            :key="`line1-${word.text}`"
            class="dl-word"
            :class="{ 'dl-keyword': word.keyword }"
            :style="{ '--reveal-delay': `${word.delay}ms` }"
          >{{ word.text }}</span>
        </span>
        <span class="dl-quote-line">
          <span
            v-for="word in quoteLine2"
            :key="`line2-${word.text}`"
            class="dl-word"
            :class="{ 'dl-keyword': word.keyword }"
            :style="{ '--reveal-delay': `${word.delay}ms` }"
          >{{ word.text }}</span>
        </span>
      </blockquote>

      <p class="dl-statement-note dl-reveal" style="--reveal-delay: 2200ms">
        Ở D&amp;L, mỗi đường vân gỗ, mỗi mối ghép đều có lý do tồn tại — và lý do đó bắt đầu từ cách
        bạn sống.
      </p>
    </div>
  </section>
</template>

<style scoped>
.dl-statement {
  position: relative;
  padding: 96px 0 100px;
  background: #fff;
  text-align: center;
}

.dl-statement-container {
  width: 100%;
  max-width: 1140px;
  margin-right: auto;
  margin-left: auto;
  padding-right: 15px;
  padding-left: 15px;
}

@media (min-width: 576px) {
  .dl-statement-container {
    max-width: 540px;
  }
}

@media (min-width: 768px) {
  .dl-statement-container {
    max-width: 720px;
  }
}

@media (min-width: 992px) {
  .dl-statement-container {
    max-width: 960px;
  }
}

@media (min-width: 1200px) {
  .dl-statement-container {
    max-width: 1140px;
  }
}

.dl-statement .section-subtitle {
  margin-bottom: 18px;
}

.dl-statement-quote {
  margin: 0;
  color: #221f1a;
  font-family: 'Gilda Display', serif;
  font-size: clamp(30px, 4vw, 48px);
  font-weight: 400;
  letter-spacing: -0.01em;
  line-height: 1.35;
  /* Ghi đè nền mặc định của thẻ blockquote kế thừa từ CSS toàn cục của theme */
  background-color: unset;
}

.dl-quote-line {
  display: block;
  padding: 0 6px;
}

/* Từng từ hiện lên so le như được đặt lại từng nét.
   Dùng CSS @keyframes animation (không phải transition) để chạy đúng ngay cả khi
   được kích hoạt trước lần vẽ đầu tiên — transition sẽ "nhảy thẳng" nếu trạng thái
   ẩn chưa kịp render (trường hợp reload trình duyệt khôi phục vị trí cuộn). */
.dl-word {
  display: inline;
  position: relative;
  opacity: 0;
}

.dl-statement.is-visible .dl-word {
  animation: dl-word-reveal 0.7s ease var(--reveal-delay, 0ms) both;
}

/* Từ khóa cốt lõi: màu đồng; bỏ text-decoration hệ thống, dùng đường vẽ riêng bên dưới */
.dl-keyword {
  color: #aa8453;
  /* Giữ từ khóa (vd "từng chi tiết") không bị ngắt giữa chừng ở màn hẹp —
     gạch chân nét bút vẽ trên một dòng, không bị tách đôi */
  white-space: nowrap;
}

.dl-keyword::after {
  position: absolute;
  right: 0.25em;  /* Bù cho khoảng trắng nối sau từ khóa — không vẽ thừa qua space */
  bottom: 4px;
  left: 0;
  height: 1.5px;
  background: linear-gradient(90deg, #aa8453, #d7b98a);
  content: '';
  transform: scaleX(0);
  transform-origin: left center;
}

/* Gạch chân bắt đầu sau khi từ đã lộ diện xong (0.7s) cộng thêm một nhịp nghỉ */
.dl-statement.is-visible .dl-keyword::after {
  animation: dl-underline-draw 0.8s cubic-bezier(0.4, 0, 0.2, 1)
    calc(var(--reveal-delay, 0ms) + 820ms) both;
}

@keyframes dl-word-reveal {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}

/* Khối (subtitle/note) vẫn được trượt nhẹ — phần tử block không gây xê dịch baseline như inline */
@keyframes dl-fade-slide {
  from {
    opacity: 0;
    transform: translateY(16px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes dl-underline-draw {
  from {
    transform: scaleX(0);
  }
  to {
    transform: scaleX(1);
  }
}

.dl-statement-note {
  max-width: 640px;
  margin: 26px auto 0;
  color: #6e6962;
  font-size: 15px;
  line-height: 1.8;
}

.dl-statement::before,
.dl-statement::after {
  position: absolute;
  left: 50%;
  width: 64px;
  height: 2px;
  transform: translateX(-50%);
  background: linear-gradient(90deg, #aa8453, #d7b98a);
  content: '';
}

.dl-statement::before {
  top: 48px;
}

.dl-statement::after {
  bottom: 50px;
}

/* Subtitle + note: hiện dần dùng animation, delay riêng theo --reveal-delay */
.dl-reveal {
  opacity: 0;
}

.dl-statement.is-visible .dl-reveal {
  animation: dl-fade-slide 0.7s ease var(--reveal-delay, 0ms) both;
}

@media (max-width: 767.98px) {
  .dl-statement {
    padding: 80px 0 84px;
  }
}

@media (max-width: 575.98px) {
  .dl-statement {
    padding: 72px 0 76px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .dl-reveal,
  .dl-word {
    opacity: 1;
    animation: none;
    transform: none;
  }

  .dl-keyword::after {
    animation: none;
    transform: scaleX(1);
  }
}
</style>
