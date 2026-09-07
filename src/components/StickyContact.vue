<script setup lang="ts">
import { onMounted, onUnmounted, ref } from 'vue'
import { Phone } from 'lucide-vue-next'

/**
 * NÚT LIÊN HỆ NỔI (sticky) — góc phải dưới màn hình.
 * Gọi điện + Zalo + Messenger.
 * Ẩn khi cuộn gần chân trang (tránh đè footer).
 */
const HOTLINE = '+84961109897'
const ZALO_LINK = 'https://zalo.me/84961109897'
const MESSENGER_LINK = 'https://m.me/DLFurniture'

const isNearFooter = ref(false)

function onScroll() {
  const doc = document.documentElement
  const scrollBottom = doc.scrollHeight - window.innerHeight - window.scrollY
  isNearFooter.value = scrollBottom < 140
}

onMounted(() => {
  window.addEventListener('scroll', onScroll, { passive: true })
  onScroll()
})

onUnmounted(() => {
  window.removeEventListener('scroll', onScroll)
})
</script>

<template>
  <div class="sticky-contact" :class="{ 'sticky-contact--hidden': isNearFooter }">
    <!-- Messenger -->
    <a
      class="sticky-contact-btn sticky-contact-btn--messenger"
      :href="MESSENGER_LINK"
      target="_blank"
      rel="noopener noreferrer"
      aria-label="Chat Messenger với D&L Furniture"
    >
      <svg
        class="sticky-contact-icon"
        :width="24"
        :height="24"
        viewBox="0 0 24 24"
        fill="none"
        aria-hidden="true"
      >
        <defs>
          <radialGradient id="msg-grad" cx="50%" cy="50%" r="50%">
            <stop offset="0%" stop-color="#00B2FF" />
            <stop offset="100%" stop-color="#006AFF" />
          </radialGradient>
        </defs>
        <path
          d="M12 2C6.477 2 2 6.145 2 11.243c0 2.906 1.445 5.497 3.707 7.191V22l3.427-1.88c.92.255 1.884.388 2.866.388 5.523 0 10-4.145 10-9.243S17.523 2 12 2zm1.07 12.457l-2.54-2.71-4.96 2.71 5.46-5.8 2.6 2.71 4.9-2.71-5.46 5.8z"
          fill="url(#msg-grad)"
        />
      </svg>
      <span class="sticky-contact-label">Messenger</span>
    </a>

    <!-- Zalo -->
    <a
      class="sticky-contact-btn sticky-contact-btn--zalo"
      :href="ZALO_LINK"
      target="_blank"
      rel="noopener noreferrer"
      aria-label="Chat Zalo với D&L Furniture"
    >
      <svg
        class="sticky-contact-icon"
        :width="24"
        :height="24"
        viewBox="0 0 24 24"
        fill="none"
        aria-hidden="true"
      >
        <path
          d="M12 2C6.48 2 2 5.82 2 10.5c0 2.68 1.35 5.07 3.47 6.69-.14.5-.55 1.87-1.34 2.61 0 0 2.35-.16 3.93-1.45.71.19 1.46.29 2.24.3.17.01.33.01.5.01 5.52 0 10-3.82 10-8.5S17.52 2 12 2z"
          fill="#fff"
        />
        <path
          d="M7.5 14.5h-2a.5.5 0 0 1-.5-.5v-3a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5v3a.5.5 0 0 1-.5.5z"
          fill="#0068FF"
        />
        <path
          d="M18.5 14.5h-2a.5.5 0 0 1-.5-.5v-3a.5.5 0 0 1 .5-.5h2a.5.5 0 0 1 .5.5v3a.5.5 0 0 1-.5.5z"
          fill="#0068FF"
        />
        <path
          d="M10.5 14.5h-1a.5.5 0 0 1-.5-.5v-3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v3a.5.5 0 0 1-.5.5z"
          fill="#0068FF"
        />
        <path
          d="M15.5 14.5h-1a.5.5 0 0 1-.5-.5v-3a.5.5 0 0 1 .5-.5h1a.5.5 0 0 1 .5.5v3a.5.5 0 0 1-.5.5z"
          fill="#0068FF"
        />
        <path
          d="M12 10.5c-.83 0-1.5-.67-1.5-1.5s.67-1.5 1.5-1.5 1.5.67 1.5 1.5-.67 1.5-1.5 1.5z"
          fill="#0068FF"
        />
      </svg>
      <span class="sticky-contact-label">Zalo</span>
    </a>

    <!-- Gọi điện -->
    <a
      class="sticky-contact-btn sticky-contact-btn--phone"
      :href="`tel:${HOTLINE}`"
      aria-label="Gọi điện cho D&L Furniture"
    >
      <Phone :size="22" :stroke-width="1.6" aria-hidden="true" />
      <span class="sticky-contact-label">Gọi ngay</span>
    </a>
  </div>
</template>

<style scoped>
/* ── NÚT LIÊN HỆ NỔI ────────────────────────────────────────────────────
   Style theo ngôn ngữ luxury D&L: gold #aa8453, Barlow Condensed,
   bo góc nhẹ, đổ bóng sâu, hiệu ứng pulse nhẹ cho nút gọi. */
.sticky-contact {
  position: fixed;
  right: 22px;
  bottom: 22px;
  z-index: 1040;
  display: flex;
  flex-direction: column;
  gap: 12px;
  transition:
    opacity 0.35s ease,
    transform 0.35s ease,
    visibility 0.35s ease;
}

.sticky-contact--hidden {
  opacity: 0;
  transform: translateY(16px);
  visibility: hidden;
  pointer-events: none;
}

.sticky-contact-btn {
  position: relative;
  display: flex;
  align-items: center;
  justify-content: center;
  width: 54px;
  height: 54px;
  border-radius: 50%;
  color: #fff;
  text-decoration: none;
  box-shadow: 0 10px 28px rgba(17, 15, 13, 0.28);
  transition:
    transform 0.25s ease,
    box-shadow 0.25s ease,
    background 0.25s ease;
}

.sticky-contact-btn:hover,
.sticky-contact-btn:focus-visible {
  transform: translateY(-3px);
  color: #fff;
  box-shadow: 0 16px 36px rgba(17, 15, 13, 0.34);
}

.sticky-contact-btn:focus-visible {
  outline: 2px solid #aa8453;
  outline-offset: 3px;
}

.sticky-contact-icon {
  display: block;
  flex-shrink: 0;
}

/* Messenger — gradient xanh */
.sticky-contact-btn--messenger {
  background: linear-gradient(135deg, #00B2FF 0%, #006AFF 100%);
}

.sticky-contact-btn--messenger:hover,
.sticky-contact-btn--messenger:focus-visible {
  background: linear-gradient(135deg, #0099e6 0%, #0055cc 100%);
}

/* Zalo — xanh đặc trưng */
.sticky-contact-btn--zalo {
  background: #0068ff;
}

.sticky-contact-btn--zalo:hover,
.sticky-contact-btn--zalo:focus-visible {
  background: #0057d6;
}

/* Gọi điện — gold D&L + pulse */
.sticky-contact-btn--phone {
  background: #aa8453;
}

.sticky-contact-btn--phone:hover,
.sticky-contact-btn--phone:focus-visible {
  background: #8e6738;
}

.sticky-contact-btn--phone::before {
  content: '';
  position: absolute;
  inset: 0;
  border-radius: 50%;
  border: 2px solid rgba(170, 132, 83, 0.55);
  animation: sticky-pulse 2.2s ease-out infinite;
  pointer-events: none;
}

@keyframes sticky-pulse {
  0% {
    transform: scale(1);
    opacity: 0.9;
  }
  70% {
    transform: scale(1.45);
    opacity: 0;
  }
  100% {
    transform: scale(1.45);
    opacity: 0;
  }
}

/* Nhãn hiện khi hover */
.sticky-contact-label {
  position: absolute;
  right: calc(100% + 12px);
  top: 50%;
  transform: translateY(-50%);
  padding: 6px 14px;
  background: #211c17;
  border: 1px solid rgba(170, 132, 83, 0.35);
  border-radius: 4px;
  color: #f5efe6;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 1.5px;
  text-transform: uppercase;
  white-space: nowrap;
  opacity: 0;
  visibility: hidden;
  transition:
    opacity 0.25s ease,
    visibility 0.25s ease;
}

.sticky-contact-label::after {
  content: '';
  position: absolute;
  left: 100%;
  top: 50%;
  transform: translateY(-50%);
  border: 5px solid transparent;
  border-left-color: #211c17;
}

.sticky-contact-btn:hover .sticky-contact-label,
.sticky-contact-btn:focus-visible .sticky-contact-label {
  opacity: 1;
  visibility: visible;
}

/* Mobile — nút nhỏ hơn, nhãn luôn ẩn */
@media (max-width: 575.98px) {
  .sticky-contact {
    right: 14px;
    bottom: 14px;
    gap: 10px;
  }

  .sticky-contact-btn {
    width: 48px;
    height: 48px;
  }

  .sticky-contact-label {
    display: none;
  }
}

@media (prefers-reduced-motion: reduce) {
  .sticky-contact-btn--phone::before {
    animation: none;
  }

  .sticky-contact-btn,
  .sticky-contact {
    transition: none;
  }
}
</style>