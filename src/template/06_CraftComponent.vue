<script setup lang="ts">
import { onBeforeUnmount, onMounted, ref } from 'vue'

/* ── ENTRANCE REVEAL (chạy 1 lần) ─────────────────────────────────────────
   Section này trước đây không có animation vào — cảm giác "đứt" giữa các
   section đều có fade-up. Tự chứa IntersectionObserver (không phụ thuộc
   animate-box của theme custom.js vốn chỉ init một lần lúc document.ready).
   Chạy MỘT LẦN rồi ngắt observer — khác Statement (replay): đây là section
   nội dung lớn, replay mỗi lần cuộn qua lại gây phiền. */
const sectionRef = ref<HTMLElement | null>(null)
const isRevealed = ref(false)
let observer: IntersectionObserver | null = null

const prefersReducedMotion =
  typeof window !== 'undefined' &&
  window.matchMedia?.('(prefers-reduced-motion: reduce)').matches

/* ── VIDEO LOOP ───────────────────────────────────────────────────────────
   Pexels License: miễn phí cho thương mại, không bắt buộc attribution.
   Nguồn: pexels.com/video/young-carpenter-using-hand-plane-on-piece-of-wood-5972622
   (HD 1080p, ~6MB). prefers-reduced-motion → không render video, giữ ảnh tĩnh. */
const videoEl = ref<HTMLVideoElement | null>(null)
const videoAllowed = !prefersReducedMotion
let mediaObserver: IntersectionObserver | null = null

const syncVideoPlayback = (visible: boolean) => {
  const video = videoEl.value
  if (!video) return
  if (visible) {
    void video.play().catch(() => {
      /* autoplay bị trình duyệt chặn — poster tĩnh vẫn hiển thị, không lỗi */
    })
  } else {
    video.pause()
  }
}

const onVisibilityChange = () => {
  if (document.hidden) syncVideoPlayback(false)
  else syncVideoPlayback(true)
}

onMounted(() => {
  if (prefersReducedMotion || typeof IntersectionObserver === 'undefined') {
    isRevealed.value = true
    return
  }

  const el = sectionRef.value
  if (!el) return

  observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting) {
          isRevealed.value = true
          observer?.disconnect()
        }
      })
    },
    { threshold: 0.18, rootMargin: '0px 0px -5% 0px' }
  )
  observer.observe(el)

  /* Phát/dừng video theo viewport: tiết kiệm CPU/pin khi section ngoài màn hình,
     và dừng hẳn khi tab ẩn (muted video vẫn chạy nền nếu không tự quản) */
  if (videoAllowed && el) {
    mediaObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => syncVideoPlayback(entry.isIntersecting))
      },
      { threshold: 0.1 }
    )
    mediaObserver.observe(el)
    document.addEventListener('visibilitychange', onVisibilityChange)
  }
})

onBeforeUnmount(() => {
  observer?.disconnect()
  mediaObserver?.disconnect()
  document.removeEventListener('visibilitychange', onVisibilityChange)
})
</script>

<template>
  <section
    ref="sectionRef"
    class="home-craft"
    :class="{ 'is-revealed': isRevealed }"
    aria-labelledby="home-craft-title"
  >
    <div class="home-craft-media">
      <!-- Video: Pexels License (miễn phí thương mại, không bắt buộc attribution).
           Nguồn: pexels.com/video/5972622 — carpenter using hand plane on wood.
           Poster = ảnh tĩnh cũ: hiển thị ngay lập tức trước khi video buffer. -->
      <video
        v-if="videoAllowed"
        ref="videoEl"
        class="home-craft-video"
        src="/media/videos/craft-handplane.mp4"
        poster="/media/gallery/artisan-walnut-chair.webp"
        muted
        loop
        playsinline
        autoplay
        preload="metadata"
        aria-hidden="true"
      ></video>
      <!-- prefers-reduced-motion: ảnh tĩnh thay video (WCAG 2.2.2) -->
      <img
        v-else
        src="/media/gallery/artisan-walnut-chair.webp"
        alt="Nghệ nhân hoàn thiện chi tiết nội thất gỗ óc chó"
        width="1672"
        height="941"
        loading="lazy"
        decoding="async"
      />
    </div>
    <div class="home-craft-content">
      <p class="section-subtitle"><span>Kỹ nghệ D&amp;L Furniture</span></p>
      <h2 id="home-craft-title" class="section-title"><span>Kỹ nghệ phía sau bề mặt hoàn thiện</span></h2>
      <p>
        Một chi tiết đẹp không chỉ được nhìn thấy. Nó được cảm nhận qua hướng vân, độ mịn của bề
        mặt, sự chính xác của mối ghép và chuyển động nhẹ nhàng trong từng thao tác sử dụng.
      </p>
      <ul>
        <li>Chọn phôi và cân sắc độ giữa các module.</li>
        <li>Kiểm soát mối ghép, cạnh tiếp xúc và bề mặt chạm.</li>
        <li>Hiệu chỉnh tại công trình theo điều kiện sử dụng thực tế.</li>
      </ul>
      <RouterLink to="/thu-vien" class="home-craft-link">
        Khám phá thư viện vật liệu <i class="ti-arrow-right" aria-hidden="true"></i>
      </RouterLink>
    </div>
  </section>
</template>

<style scoped>
.home-craft {
  display: grid;
  grid-template-columns: minmax(0, 1.1fr) minmax(420px, 0.9fr);
  min-height: 540px;
  background: #1f1d1a;
}

.home-craft-media {
  min-height: 540px;
  overflow: hidden;
}

.home-craft-media img,
.home-craft-media video {
  display: block;
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition:
    filter 0.5s ease,
    transform 0.5s ease;
}

.home-craft:hover .home-craft-media img,
.home-craft:hover .home-craft-media video,
.home-craft:focus-within .home-craft-media img,
.home-craft:focus-within .home-craft-media video {
  filter: brightness(75%);
  transform: scale(1.09);
  transition:
    filter 1s ease,
    transform 1s ease;
}

.home-craft-content {
  display: flex;
  align-items: flex-start;
  flex-direction: column;
  justify-content: center;
  padding: 62px clamp(46px, 6vw, 90px);
}

/* Trạng thái trước reveal: nội dung ẩn + trượt nhẹ xuống; media tối hơn nhẹ.
   is-revealed: vào theo fade-up (delay 0.1s để media kịp "mở" trước một nhịp) */
.home-craft-content {
  opacity: 0;
  transform: translateY(28px);
  transition:
    opacity 0.8s ease 0.1s,
    transform 0.8s cubic-bezier(0.25, 1, 0.5, 1) 0.1s;
}

.home-craft-media img,
.home-craft-media video {
  filter: brightness(82%);
}

.home-craft.is-revealed .home-craft-content {
  opacity: 1;
  transform: none;
}

.home-craft.is-revealed .home-craft-media img,
.home-craft.is-revealed .home-craft-media video {
  filter: brightness(100%);
}

.home-craft h2 {
  max-width: 570px;
  margin-bottom: 0;
}

.home-craft-content > p:not(.section-subtitle) {
  max-width: 590px;
  margin: 28px 0 0;
  color: rgba(255, 255, 255, 0.74);
  font-size: 16px;
  line-height: 1.85;
}

.home-craft ul {
  display: grid;
  gap: 13px;
  margin: 28px 0 0;
  padding: 0;
  list-style: none;
}

.home-craft li {
  position: relative;
  padding-left: 23px;
  color: rgba(255, 255, 255, 0.82);
  font-size: 16px;
}

.home-craft li::before {
  position: absolute;
  top: 9px;
  left: 0;
  width: 8px;
  height: 1px;
  background: #c39a62;
  content: '';
}

.home-craft-link {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-top: 36px;
  padding-bottom: 8px;
  border-bottom: 1px solid rgba(195, 154, 98, 0.5);
  color: #c39a62;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 0.16em;
  text-transform: uppercase;
}

.home-craft-link:hover {
  color: #fff;
}

@media (max-width: 991px) {
  .home-craft {
    grid-template-columns: minmax(0, 1fr);
  }

  .home-craft-media {
    min-height: 0;
    aspect-ratio: 16 / 9;
  }

  .home-craft-content {
    padding: 70px 48px;
  }
}

@media (max-width: 575px) {
  .home-craft-media {
    aspect-ratio: 4 / 3;
  }

  .home-craft-content {
    padding: 58px 24px 64px;
  }

  .home-craft-content > p:not(.section-subtitle) {
    font-size: 15px;
  }
}

@media (prefers-reduced-motion: reduce) {
  .home-craft-content {
    opacity: 1;
    transform: none;
    transition: none;
  }

  .home-craft-media img,
  .home-craft-media video {
    filter: none;
    transition: none;
  }
}
</style>
