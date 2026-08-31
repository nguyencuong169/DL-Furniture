<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'

const sectionRef = ref<HTMLElement | null>(null)
const isVisible = ref(false)
let observer: IntersectionObserver | null = null

const prefersReducedMotion =
  typeof window !== 'undefined' &&
  window.matchMedia?.('(prefers-reduced-motion: reduce)').matches

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
        if (entry.isIntersecting) {
          observer?.disconnect()
          // Ép trình duyệt vẽ xong trạng thái ẩn ban đầu (opacity: 0) trước khi
          // chuyển sang hiện — nếu không, 2 lần render bị gộp làm một và transition
          // "biến mất" (đổi trạng thái thẳng, không animate)
          requestAnimationFrame(() => {
            requestAnimationFrame(() => {
              isVisible.value = true
            })
          })
        }
      })
    },
    { threshold: 0.3, rootMargin: '0px 0px -10% 0px' }
  )
  observer.observe(el)
})

onBeforeUnmount(() => {
  observer?.disconnect()
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
        <span class="dl-reveal-line" style="--reveal-delay: 120ms">
          Không gian đẹp không nằm ở sự cầu kỳ,
        </span>
        <span class="dl-reveal-line" style="--reveal-delay: 280ms">
          mà nằm ở sự <span class="dl-keyword">tận tâm</span> trong
          <span class="dl-keyword">từng chi tiết</span>.
        </span>
      </blockquote>

      <p class="dl-statement-note dl-reveal" style="--reveal-delay: 440ms">
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

.dl-reveal-line {
  display: block;
}

/* Từ khóa cốt lõi: màu đồng + gạch chân mảnh, tách khỏi màu chữ chính
   để mắt người đọc dừng lại đúng chỗ mang thông điệp */
.dl-keyword {
  color: #aa8453;
  text-decoration: underline;
  text-decoration-color: #d7b98a;
  text-decoration-thickness: 1.5px;
  text-underline-offset: 6px;
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

/* Entrance: label -> dòng 1 -> dòng 2 (chứa từ khóa) -> ghi chú, so le theo --reveal-delay.
   Mỗi phần tử chạy đúng 1 lần, không lặp, không phụ thuộc thư viện ngoài. */
.dl-reveal,
.dl-reveal-line {
  opacity: 0;
  transform: translateY(14px);
  /* TẠM THỜI 2.5s để bạn test bằng mắt — đổi lại 0.6s sau khi xác nhận chạy đúng */
  transition: opacity 2.5s ease, transform 2.5s ease;
  transition-delay: var(--reveal-delay, 0ms);
}

.dl-statement.is-visible .dl-reveal,
.dl-statement.is-visible .dl-reveal-line {
  opacity: 1;
  transform: translateY(0);
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
  .dl-reveal-line {
    transition: none;
    transform: none;
  }
}
</style>
