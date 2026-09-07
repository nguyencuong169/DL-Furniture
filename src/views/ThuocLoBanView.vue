<script setup lang="ts">
import { computed, ref, watchEffect } from 'vue'
import { useRoute } from 'vue-router'
import { Check, X, Ruler, Info } from 'lucide-vue-next'
import { setPageSeo } from '../utils/seo'
import { CUNGS, GOOD_SIZES, nearestGoodSize, traCuu } from '../config/thuocLoBan'

const route = useRoute()

const sizeInput = ref('')
const sizeCm = computed(() => {
  const value = parseFloat(sizeInput.value.replace(',', '.'))
  return Number.isFinite(value) && value > 0 ? value : null
})

const result = computed(() => {
  const size = sizeCm.value
  if (size === null) return null
  const lookup = traCuu(size)
  if (!lookup) return null
  return {
    cung: lookup.cung,
    subCung: lookup.subCung,
    position: lookup.position.toFixed(2),
    size: lookup.size
  }
})

const goodCungs = CUNGS.filter((c) => c.good)
const badCungs = CUNGS.filter((c) => !c.good)

// Gợi ý kích thước đẹp gần nhất
const nearestGood = computed(() => {
  const size = sizeCm.value
  if (size === null) return null
  return nearestGoodSize(size)
})

watchEffect(() => {
  setPageSeo({
    title: 'Thước lỗ ban — Tra cứu kích thước phong thủy nội thất | D&L Furniture',
    description:
      'Tra cứu thước lỗ ban 52.2cm trực tuyến: nhập kích thước cửa, nội thất, âm trần để biết cung tốt/xấu theo phong thủy. Công cụ miễn phí từ D&L Furniture.',
    path: route.path
  })
})
</script>

<template>
  <main>
    <!-- Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      style="background-image: url('/media/gallery/walnut-villa-living.webp')"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <h5>D&L Furniture — Phong thủy nội thất</h5>
            <h1>Thước lỗ ban</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- Giới thiệu -->
    <section class="tl-section tl-intro section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="tl-eyebrow">Công cụ tra cứu</span>
            <h2 class="tl-heading">Kích thước đẹp — Vận khí hanh thông</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-8">
            <p class="tl-lead">
              Thước lỗ ban là công cụ đo đạc phong thủy truyền thống, giúp gia chủ chọn kích thước
              cửa, nội thất, âm trần hợp cung tốt — mang lại tài lộc, sức khỏe và bình an cho gia
              đình. D&L Furniture sử dụng thước 52.2cm (thông dụng nhất) với 8 cung: 4 cung tốt
              (Tài, Nghĩa, Quan, Bản) và 4 cung xấu (Bệnh, Ly, Kiếp, Hại).
            </p>
            <p class="tl-lead">
              Nhập kích thước thực tế (cm) của hạng mục bạn đang thiết kế — cửa chính, cửa phòng,
              tủ bếp, giường ngủ, bàn thờ... — công cụ sẽ cho biết kích thước đó thuộc cung nào và
              gợi ý kích thước đẹp gần nhất.
            </p>
          </div>
          <div class="col-md-4">
            <div class="tl-info-card">
              <Info :size="20" :stroke-width="1.5" aria-hidden="true" />
              <p>
                <strong>Lưu ý:</strong> Kết quả mang tính tham khảo phong thủy. Kích thước thực tế
                cần dung hòa giữa cung tốt, công năng sử dụng và kết cấu công trình.
              </p>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Công cụ tra cứu -->
    <section class="tl-section tl-tool">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="tl-eyebrow tl-eyebrow--light">Tra cứu ngay</span>
            <h2 class="tl-heading tl-heading--light">Kích thước của bạn thuộc cung nào?</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6 offset-md-3">
            <div class="tl-tool-card">
              <div class="tl-tool-input">
                <Ruler :size="22" :stroke-width="1.5" class="tl-tool-icon" aria-hidden="true" />
                <input
                  v-model="sizeInput"
                  type="number"
                  inputmode="decimal"
                  min="0"
                  step="0.01"
                  placeholder="Nhập kích thước (cm)..."
                  class="tl-tool-field"
                  aria-label="Nhập kích thước theo cm"
                />
                <span class="tl-tool-unit">cm</span>
              </div>

              <!-- Kết quả -->
              <div v-if="result" class="tl-result" :class="result.cung.good ? 'tl-result--good' : 'tl-result--bad'">
                <div class="tl-result-icon">
                  <Check v-if="result.cung.good" :size="28" :stroke-width="1.6" aria-hidden="true" />
                  <X v-else :size="28" :stroke-width="1.6" aria-hidden="true" />
                </div>
                <div class="tl-result-body">
                  <span class="tl-result-label">
                    {{ result.cung.good ? 'Cung tốt' : 'Cung xấu' }}
                  </span>
                  <h3 class="tl-result-cung">{{ result.cung.name }} — {{ result.subCung }}</h3>
                  <p class="tl-result-meaning">{{ result.cung.meaning }}</p>
                  <p class="tl-result-size">
                    Kích thước {{ result.size.toFixed(2) }}cm → vị trí {{ result.position }}cm trên thước
                  </p>
                </div>
              </div>

              <!-- Gợi ý kích thước đẹp -->
              <div v-if="result && !result.cung.good && nearestGood" class="tl-suggestion">
                <p>
                  <strong>Gợi ý:</strong> Kích thước đẹp gần nhất là
                  <strong>{{ nearestGood.size.toFixed(2) }}cm</strong>
                  ({{ nearestGood.offset > 0 ? 'thêm' : 'bớt' }}
                  {{ Math.abs(nearestGood.offset).toFixed(2) }}cm).
                </p>
              </div>

              <p v-if="!result" class="tl-tool-hint">
                Nhập kích thước để xem kết quả — ví dụ: 81, 87, 107, 126, 162...
              </p>
            </div>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12">
            <div class="tl-good-sizes">
              <span class="tl-good-sizes-label">Kích thước đẹp thông dụng (cm):</span>
              <span v-for="size in GOOD_SIZES" :key="size" class="tl-good-size">{{ size }}</span>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Bảng 8 cung -->
    <section class="tl-section tl-cungs section-padding">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="tl-eyebrow">Bảng tra cứu</span>
            <h2 class="tl-heading">8 cung thước lỗ ban 52.2cm</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-6">
            <h3 class="tl-cung-group-title tl-cung-group-title--good">Cung tốt</h3>
            <div class="tl-cung-grid">
              <article v-for="cung in goodCungs" :key="cung.name" class="tl-cung-card tl-cung-card--good">
                <div class="tl-cung-card-head">
                  <span class="tl-cung-name">{{ cung.name }}</span>
                  <span class="tl-cung-badge">Tốt</span>
                </div>
                <p class="tl-cung-meaning">{{ cung.meaning }}</p>
                <div class="tl-cung-subs">
                  <span v-for="sub in cung.subCungs" :key="sub" class="tl-cung-sub">{{ sub }}</span>
                </div>
              </article>
            </div>
          </div>
          <div class="col-md-6">
            <h3 class="tl-cung-group-title tl-cung-group-title--bad">Cung xấu</h3>
            <div class="tl-cung-grid">
              <article v-for="cung in badCungs" :key="cung.name" class="tl-cung-card tl-cung-card--bad">
                <div class="tl-cung-card-head">
                  <span class="tl-cung-name">{{ cung.name }}</span>
                  <span class="tl-cung-badge tl-cung-badge--bad">Xấu</span>
                </div>
                <p class="tl-cung-meaning">{{ cung.meaning }}</p>
                <div class="tl-cung-subs">
                  <span v-for="sub in cung.subCungs" :key="sub" class="tl-cung-sub">{{ sub }}</span>
                </div>
              </article>
            </div>
          </div>
        </div>
      </div>
    </section>

    <!-- Ứng dụng trong nội thất -->
    <section class="tl-section tl-apply">
      <div class="container">
        <div class="row">
          <div class="col-md-12">
            <span class="tl-eyebrow tl-eyebrow--light">Ứng dụng thực tế</span>
            <h2 class="tl-heading tl-heading--light">Thước lỗ ban trong thiết kế nội thất</h2>
          </div>
        </div>
        <div class="row">
          <div class="col-md-4" v-for="item in [
            { title: 'Cửa chính & cửa phòng', text: 'Kích thước cửa hợp cung Tài, Quan giúp đón tài lộc, danh vọng vào nhà. Tránh cung Bệnh, Hại gây hao tổn sức khỏe.' },
            { title: 'Tủ bếp & bàn thờ', text: 'Tủ bếp nên chọn cung Nghĩa, Bản để gia đình hòa thuận, an cư. Bàn thờ ưu tiên cung Tài, Quan cho lộc tài tổ tiên phù hộ.' },
            { title: 'Giường ngủ & phòng thờ', text: 'Giường ngủ hợp cung Bản, Nghĩa giúp giấc ngủ sâu, gia đình êm ấm. Tránh cung Ly, Kiếp gây chia lìa, hao tài.' }
          ]" :key="item.title">
            <article class="tl-apply-card">
              <h3>{{ item.title }}</h3>
              <p>{{ item.text }}</p>
            </article>
          </div>
        </div>
        <div class="row">
          <div class="col-md-12 text-center">
            <RouterLink to="/lien-he" class="tl-cta-button">
              Tư vấn kích thước phong thủy cùng D&L
            </RouterLink>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style scoped>
/* ==========================================================================
   THƯỚC LỖ BAN — công cụ tra cứu phong thủy nội thất
   Ngôn ngữ luxury D&L: gold #aa8453, Gilda Display (heading),
   Barlow Condensed (eyebrow). Nhịp: banner tối → intro sáng → tool tối
   → bảng cung sáng → ứng dụng tối → CTA.
   ========================================================================== */

.tl-eyebrow {
  display: inline-block;
  margin-bottom: 10px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 3px;
  text-transform: uppercase;
}

.tl-eyebrow--light {
  color: #c9a876;
}

.tl-heading {
  margin: 0 0 26px;
  color: #1e1a16;
  font-family: 'Gilda Display', serif;
  font-size: 34px;
  line-height: 1.2;
}

.tl-heading--light {
  color: #f5efe6;
}

/* ---- Intro ---- */
.tl-intro .tl-lead {
  margin-bottom: 16px;
  color: #5a5348;
  font-size: 16px;
  line-height: 1.75;
}

.tl-info-card {
  display: flex;
  gap: 14px;
  padding: 22px 20px;
  background: #faf7f2;
  border: 1px solid rgba(170, 132, 83, 0.25);
  border-left: 3px solid #aa8453;
  color: #6b6357;
  font-size: 14px;
  line-height: 1.65;
}

.tl-info-card svg {
  flex-shrink: 0;
  margin-top: 2px;
  color: #aa8453;
}

.tl-info-card p {
  margin: 0;
}

.tl-info-card strong {
  color: #1e1a16;
}

/* ---- Công cụ (nền tối) ---- */
.tl-tool {
  padding: 90px 0;
  background: #211c17;
}

.tl-tool-card {
  padding: 34px 30px;
  background: rgba(245, 239, 230, 0.04);
  border: 1px solid rgba(245, 239, 230, 0.12);
}

.tl-tool-input {
  display: flex;
  align-items: center;
  gap: 12px;
  padding: 0 18px;
  background: #f5efe6;
  border: 1px solid rgba(170, 132, 83, 0.35);
  transition: border-color 0.25s ease, box-shadow 0.25s ease;
}

.tl-tool-input:focus-within {
  border-color: #aa8453;
  box-shadow: 0 0 0 3px rgba(170, 132, 83, 0.18);
}

.tl-tool-icon {
  flex-shrink: 0;
  color: #aa8453;
}

.tl-tool-field {
  flex: 1;
  min-width: 0;
  padding: 16px 0;
  background: transparent;
  border: none;
  outline: none;
  color: #1e1a16;
  font-family: 'Barlow', sans-serif;
  font-size: 18px;
  font-weight: 500;
}

.tl-tool-field::placeholder {
  color: #8a8177;
}

.tl-tool-unit {
  flex-shrink: 0;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 15px;
  font-weight: 600;
  letter-spacing: 1px;
  text-transform: uppercase;
}

.tl-tool-hint {
  margin: 18px 0 0;
  color: #b9b0a2;
  font-size: 14px;
  text-align: center;
}

.tl-good-sizes {
  display: flex;
  flex-wrap: wrap;
  align-items: center;
  justify-content: center;
  gap: 8px;
  margin-top: 26px;
}

.tl-good-sizes-label {
  margin-right: 4px;
  color: #8a8177;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  font-weight: 600;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.tl-good-size {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  padding: 6px 10px;
  background: rgba(170, 132, 83, 0.12);
  border: 1px solid rgba(170, 132, 83, 0.35);
  border-radius: 3px;
  color: #c9a876;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 0.5px;
  transition: background 0.25s ease, color 0.25s ease, transform 0.25s ease;
}

.tl-good-size:hover {
  background: #aa8453;
  color: #fff;
  transform: translateY(-2px);
}

/* ---- Kết quả ---- */
.tl-result {
  display: flex;
  gap: 16px;
  margin-top: 22px;
  padding: 22px 20px;
  border: 1px solid;
}

.tl-result--good {
  background: rgba(170, 132, 83, 0.08);
  border-color: rgba(170, 132, 83, 0.45);
}

.tl-result--bad {
  background: rgba(190, 60, 60, 0.08);
  border-color: rgba(190, 60, 60, 0.45);
}

.tl-result-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
  width: 52px;
  height: 52px;
  border-radius: 50%;
}

.tl-result--good .tl-result-icon {
  background: rgba(170, 132, 83, 0.18);
  color: #aa8453;
}

.tl-result--bad .tl-result-icon {
  background: rgba(190, 60, 60, 0.18);
  color: #be3c3c;
}

.tl-result-body {
  min-width: 0;
}

.tl-result-label {
  display: block;
  margin-bottom: 4px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  font-weight: 600;
  letter-spacing: 2px;
  text-transform: uppercase;
}

.tl-result--good .tl-result-label {
  color: #aa8453;
}

.tl-result--bad .tl-result-label {
  color: #be3c3c;
}

.tl-result-cung {
  margin: 0 0 6px;
  color: #f5efe6;
  font-family: 'Gilda Display', serif;
  font-size: 22px;
}

.tl-result-meaning {
  margin: 0 0 8px;
  color: #b9b0a2;
  font-size: 14.5px;
  line-height: 1.6;
}

.tl-result-size {
  margin: 0;
  color: #8a8177;
  font-size: 13px;
}

.tl-suggestion {
  margin-top: 14px;
  padding: 14px 18px;
  background: rgba(170, 132, 83, 0.1);
  border-left: 3px solid #aa8453;
  color: #c9a876;
  font-size: 14px;
  line-height: 1.6;
}

.tl-suggestion strong {
  color: #f5efe6;
}

/* ---- Bảng 8 cung ---- */
.tl-cungs {
  background: #faf7f2;
}

.tl-cung-group-title {
  margin: 0 0 18px;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 16px;
  font-weight: 600;
  letter-spacing: 2.5px;
  text-transform: uppercase;
}

.tl-cung-group-title--good {
  color: #aa8453;
}

.tl-cung-group-title--bad {
  color: #be3c3c;
}

.tl-cung-grid {
  display: grid;
  grid-template-columns: repeat(2, 1fr);
  gap: 14px;
  margin-bottom: 34px;
}

.tl-cung-card {
  padding: 18px 18px 16px;
  background: #fff;
  border: 1px solid rgba(170, 132, 83, 0.2);
  border-top: 2px solid;
  transition: box-shadow 0.25s ease, transform 0.25s ease;
}

.tl-cung-card:hover {
  box-shadow: 0 12px 28px rgba(17, 15, 13, 0.08);
  transform: translateY(-2px);
}

.tl-cung-card--good {
  border-top-color: #aa8453;
}

.tl-cung-card--bad {
  border-top-color: #be3c3c;
}

.tl-cung-card-head {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 8px;
}

.tl-cung-name {
  color: #1e1a16;
  font-family: 'Gilda Display', serif;
  font-size: 20px;
}

.tl-cung-badge {
  padding: 3px 10px;
  background: rgba(170, 132, 83, 0.12);
  border-radius: 3px;
  color: #aa8453;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 11px;
  font-weight: 600;
  letter-spacing: 1.5px;
  text-transform: uppercase;
}

.tl-cung-badge--bad {
  background: rgba(190, 60, 60, 0.1);
  color: #be3c3c;
}

.tl-cung-meaning {
  margin: 0 0 12px;
  color: #6b6357;
  font-size: 13.5px;
  line-height: 1.55;
}

.tl-cung-subs {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.tl-cung-sub {
  padding: 3px 8px;
  background: #faf7f2;
  border: 1px solid rgba(170, 132, 83, 0.15);
  border-radius: 3px;
  color: #8a8177;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 12px;
  letter-spacing: 0.5px;
}

/* ---- Ứng dụng (nền tối) ---- */
.tl-apply {
  padding: 90px 0;
  background: #211c17;
}

.tl-apply-card {
  height: 100%;
  padding: 26px 24px;
  background: rgba(245, 239, 230, 0.04);
  border: 1px solid rgba(245, 239, 230, 0.1);
  border-top: 2px solid #aa8453;
  transition: background 0.25s ease, transform 0.25s ease;
}

.tl-apply-card:hover {
  background: rgba(245, 239, 230, 0.07);
  transform: translateY(-2px);
}

.tl-apply-card h3 {
  margin: 0 0 10px;
  color: #f5efe6;
  font-family: 'Gilda Display', serif;
  font-size: 19px;
}

.tl-apply-card p {
  margin: 0;
  color: #b9b0a2;
  font-size: 14.5px;
  line-height: 1.7;
}

.tl-cta-button {
  display: inline-flex;
  align-items: center;
  gap: 10px;
  margin-top: 40px;
  padding: 14px 34px;
  background: #aa8453;
  color: #fff;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 14px;
  font-weight: 600;
  letter-spacing: 2.5px;
  text-transform: uppercase;
  transition: gap 0.25s ease, background 0.25s ease;
}

.tl-cta-button:hover,
.tl-cta-button:focus-visible {
  gap: 15px;
  background: #8e6738;
  color: #fff;
}

/* ---- Responsive ---- */
@media (max-width: 991.98px) {
  .tl-heading {
    font-size: 28px;
  }

  .tl-cung-grid {
    grid-template-columns: 1fr;
  }
}

@media (max-width: 575.98px) {
  .tl-tool {
    padding: 70px 0;
  }

  .tl-apply {
    padding: 70px 0;
  }

  .tl-tool-card {
    padding: 24px 18px;
  }

  .tl-result {
    flex-direction: column;
    align-items: flex-start;
  }
}

@media (prefers-reduced-motion: reduce) {
  .tl-cung-card,
  .tl-apply-card,
  .tl-cta-button {
    transition: none;
  }
}
</style>