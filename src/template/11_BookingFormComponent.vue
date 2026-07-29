<script setup lang="ts">
import { computed, nextTick, onBeforeUnmount, onMounted, reactive, ref } from 'vue'
import { submitConsultation } from '../api/consultationClient'
import image1 from '../assets/img/1.jpg'
import { bookingUseStore } from '../stores/bookingstore'

type ConsultationField =
  | 'fullName'
  | 'phone'
  | 'email'
  | 'serviceType'
  | 'propertyType'
  | 'estimatedArea'
  | 'acceptedPrivacy'

type ConsultationForm = {
  fullName: string
  phone: string
  email: string
  serviceType: string
  propertyType: string
  estimatedArea: number | null | ''
  budget: string
  projectLocation: string
  message: string
  acceptedPrivacy: boolean
  website: string
}

type ConsultationSelect2Collection = {
  hasClass(className: string): boolean
  off(events: string): ConsultationSelect2Collection
  on(
    events: string,
    handler: (event: { currentTarget: EventTarget | null }) => void
  ): ConsultationSelect2Collection
  select2(
    options:
      | {
          minimumResultsForSearch: number
          width: string
          dropdownCssClass: string
        }
      | 'destroy'
  ): ConsultationSelect2Collection
  trigger(eventName: string): ConsultationSelect2Collection
  val(value: string): ConsultationSelect2Collection
}

type ConsultationJQueryStatic = {
  (selector: string): ConsultationSelect2Collection
  fn: {
    select2?: unknown
  }
}

const SELECT2_INIT_RETRY_DELAY = 100
const SELECT2_INIT_MAX_ATTEMPTS = 30
const CONSULTATION_SELECTORS = [
  '#consultation-serviceType',
  '#consultation-propertyType',
  '#consultation-budget'
] as const

const bookingStore = bookingUseStore()
let select2InitAttempts = 0
let select2InitTimer: number | undefined

const props = withDefaults(
  defineProps<{
    backgroundImage?: string
  }>(),
  {
    backgroundImage: image1
  }
)

const bannerStyle = computed(() => ({
  backgroundImage: `url(${props.backgroundImage || image1})`
}))

const form = reactive<ConsultationForm>({
  fullName: '',
  phone: '',
  email: '',
  serviceType: '',
  propertyType: '',
  estimatedArea: null,
  budget: '',
  projectLocation: '',
  message: '',
  acceptedPrivacy: false,
  website: ''
})

const errors = reactive<Record<ConsultationField, string>>({
  fullName: '',
  phone: '',
  email: '',
  serviceType: '',
  propertyType: '',
  estimatedArea: '',
  acceptedPrivacy: ''
})

const submitState = ref<'idle' | 'submitting' | 'success' | 'error'>('idle')
const statusMessage = ref('')
const isSubmitting = computed(() => submitState.value === 'submitting')

function getConsultationJQuery() {
  if (typeof window === 'undefined') return null

  const jquery = (window as Window & { jQuery?: ConsultationJQueryStatic }).jQuery
  return jquery && typeof jquery.fn.select2 === 'function' ? jquery : null
}

function consultationSelect(selector: string) {
  const jquery = getConsultationJQuery()
  return jquery ? jquery(selector) : null
}

function syncConsultationSelects() {
  consultationSelect('#consultation-serviceType')?.val(form.serviceType).trigger('change.select2')
  consultationSelect('#consultation-propertyType')?.val(form.propertyType).trigger('change.select2')
  consultationSelect('#consultation-budget')?.val(form.budget).trigger('change.select2')
}

function initializeConsultationSelects() {
  const selects = CONSULTATION_SELECTORS.map(consultationSelect)
  if (selects.some((select) => !select)) return false

  selects.forEach((select) => {
    if (select && !select.hasClass('select2-hidden-accessible')) {
      select.select2({
        minimumResultsForSearch: Infinity,
        width: '100%',
        dropdownCssClass: 'consultation-select-dropdown'
      })
    }
    select?.off('.consultationForm')
  })

  const [serviceSelect, propertySelect, budgetSelect] = selects
  serviceSelect?.on('change.consultationForm', (event) => {
    form.serviceType = (event.currentTarget as HTMLSelectElement | null)?.value ?? ''
    clearFieldError('serviceType')
  })
  propertySelect?.on('change.consultationForm', (event) => {
    form.propertyType = (event.currentTarget as HTMLSelectElement | null)?.value ?? ''
    clearFieldError('propertyType')
  })
  budgetSelect?.on('change.consultationForm', (event) => {
    form.budget = (event.currentTarget as HTMLSelectElement | null)?.value ?? ''
  })

  syncConsultationSelects()
  return true
}

function initializeConsultationSelectsWhenReady() {
  if (select2InitTimer !== undefined) {
    window.clearTimeout(select2InitTimer)
    select2InitTimer = undefined
  }

  if (initializeConsultationSelects()) {
    select2InitAttempts = 0
    return
  }

  if (select2InitAttempts >= SELECT2_INIT_MAX_ATTEMPTS) return

  select2InitAttempts += 1
  select2InitTimer = window.setTimeout(
    initializeConsultationSelectsWhenReady,
    SELECT2_INIT_RETRY_DELAY
  )
}

function destroyConsultationSelects() {
  CONSULTATION_SELECTORS.forEach((selector) => {
    const select = consultationSelect(selector)
    select?.off('.consultationForm')
    if (select?.hasClass('select2-hidden-accessible')) select.select2('destroy')
  })
}

function clearFieldError(field: ConsultationField) {
  errors[field] = ''
  if (submitState.value === 'error') {
    submitState.value = 'idle'
    statusMessage.value = ''
  }
}

function clearErrors() {
  ;(Object.keys(errors) as ConsultationField[]).forEach((field) => {
    errors[field] = ''
  })
}

function normalizePhone(phone: string) {
  const normalized = phone.trim().replace(/[\s().-]/g, '')
  return normalized.startsWith('+84') ? `84${normalized.slice(3)}` : normalized
}

function validateForm() {
  clearErrors()

  if (form.fullName.trim().length < 2) {
    errors.fullName = 'Vui lòng nhập họ và tên.'
  }

  const normalizedPhone = normalizePhone(form.phone)
  if (!/^(?:84\d{9}|0\d{9,10})$/.test(normalizedPhone)) {
    errors.phone = 'Vui lòng nhập số điện thoại hợp lệ.'
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(form.email.trim())) {
    errors.email = 'Vui lòng nhập email hợp lệ.'
  }

  if (!form.serviceType) {
    errors.serviceType = 'Vui lòng chọn dịch vụ cần tư vấn.'
  }

  if (!form.propertyType) {
    errors.propertyType = 'Vui lòng chọn loại công trình.'
  }

  if (
    form.estimatedArea !== '' &&
    form.estimatedArea !== null &&
    (!Number.isFinite(Number(form.estimatedArea)) ||
      Number(form.estimatedArea) < 1 ||
      Number(form.estimatedArea) > 100000)
  ) {
    errors.estimatedArea = 'Diện tích phải lớn hơn 0 m².'
  }

  if (!form.acceptedPrivacy) {
    errors.acceptedPrivacy = 'Vui lòng đồng ý để D&L Furniture liên hệ tư vấn.'
  }

  return (Object.keys(errors) as ConsultationField[]).find((field) => errors[field])
}

function resetForm() {
  Object.assign(form, {
    fullName: '',
    phone: '',
    email: '',
    serviceType: '',
    propertyType: '',
    estimatedArea: null,
    budget: '',
    projectLocation: '',
    message: '',
    acceptedPrivacy: false,
    website: ''
  })
  clearErrors()
  void nextTick(syncConsultationSelects)
}

function focusConsultationField(field: ConsultationField) {
  const element = document.getElementById(`consultation-${field}`)
  if (!element) return

  if (element.classList.contains('select2-hidden-accessible')) {
    const select2Control =
      element.nextElementSibling?.querySelector<HTMLElement>('.select2-selection')
    select2Control?.focus()
    return
  }

  element.focus()
}

async function handleSubmit() {
  if (isSubmitting.value) return

  submitState.value = 'idle'
  statusMessage.value = ''
  const firstInvalidField = validateForm()

  if (firstInvalidField) {
    await nextTick()
    focusConsultationField(firstInvalidField)
    return
  }

  submitState.value = 'submitting'

  try {
    const response = await submitConsultation({
      fullName: form.fullName.trim(),
      phone: form.phone.trim(),
      email: form.email.trim(),
      serviceType: form.serviceType,
      propertyType: form.propertyType,
      estimatedArea:
        form.estimatedArea === '' || form.estimatedArea === null
          ? null
          : Number(form.estimatedArea),
      budget: form.budget,
      projectLocation: form.projectLocation.trim(),
      message: form.message.trim(),
      pagePath:
        typeof window === 'undefined' ? '' : `${window.location.pathname}${window.location.search}`,
      acceptedPrivacy: form.acceptedPrivacy,
      website: form.website
    })

    resetForm()
    submitState.value = 'success'
    statusMessage.value = response.message
  } catch (error) {
    submitState.value = 'error'
    statusMessage.value =
      error instanceof Error
        ? error.message
        : 'Không thể gửi yêu cầu lúc này. Vui lòng gọi hotline để được hỗ trợ.'
  }
}

onMounted(async () => {
  window.addEventListener('load', initializeConsultationSelectsWhenReady, { once: true })
  await nextTick()
  initializeConsultationSelectsWhenReady()
})

onBeforeUnmount(() => {
  window.removeEventListener('load', initializeConsultationSelectsWhenReady)
  if (select2InitTimer !== undefined) window.clearTimeout(select2InitTimer)
  destroyConsultationSelects()
})
</script>

<template>
  <section
    v-show="bookingStore.isDisplay"
    class="testimonials consultation-section"
    aria-labelledby="consultation-title"
  >
    <div
      class="background bg-img bg-fixed section-padding pb-0 consultation-background"
      data-overlay-dark="3"
      :style="bannerStyle"
    >
      <div class="container">
        <div class="row align-items-center">
          <div class="col-lg-5 consultation-copy">
            <span class="consultation-eyebrow">Tư vấn chuyên sâu</span>
            <h2 id="consultation-title">Kiến tạo không gian dành riêng cho bạn</h2>
            <p class="consultation-intro">
              Từ ý tưởng ban đầu đến thi công hoàn thiện, đội ngũ D&amp;L Furniture đồng hành để cân
              bằng thẩm mỹ, công năng, vật liệu và ngân sách.
            </p>

            <ul class="consultation-benefits" aria-label="Quyền lợi tư vấn">
              <li><i class="ti-check" aria-hidden="true"></i> Khảo sát nhu cầu và hiện trạng</li>
              <li><i class="ti-check" aria-hidden="true"></i> Đề xuất giải pháp theo ngân sách</li>
              <li>
                <i class="ti-check" aria-hidden="true"></i> Quy trình thiết kế, sản xuất, thi công
                đồng bộ
              </li>
            </ul>

            <div class="reservations consultation-hotline">
              <div class="icon color-1"><span class="flaticon-call"></span></div>
              <div class="text">
                <p class="color-1">Tư vấn trực tiếp</p>
                <a class="color-1" href="tel:+84961109897">(+84) 961-109-897</a>
              </div>
            </div>
          </div>

          <div class="col-lg-6 offset-lg-1">
            <div class="booking-box consultation-box">
              <div class="head-box consultation-head">
                <h6>D&amp;L Furniture</h6>
                <h4>Đăng ký tư vấn thiết kế &amp; thi công</h4>
              </div>

              <div class="booking-inner clearfix">
                <form
                  class="form1 clearfix consultation-form"
                  novalidate
                  :aria-busy="isSubmitting"
                  @submit.prevent="handleSubmit"
                >
                  <div class="consultation-honeypot" aria-hidden="true">
                    <label for="consultation-website">Website</label>
                    <input
                      id="consultation-website"
                      v-model="form.website"
                      type="text"
                      tabindex="-1"
                      autocomplete="off"
                    />
                  </div>

                  <div class="row">
                    <div class="col-md-6">
                      <div class="consultation-field" :class="{ 'has-error': errors.fullName }">
                        <label class="consultation-label" for="consultation-fullName">
                          Họ và tên
                        </label>
                        <input
                          id="consultation-fullName"
                          v-model="form.fullName"
                          class="form-control input consultation-control"
                          type="text"
                          name="fullName"
                          placeholder="Họ và tên *"
                          autocomplete="name"
                          maxlength="255"
                          :aria-invalid="Boolean(errors.fullName)"
                          :aria-describedby="
                            errors.fullName ? 'consultation-fullName-error' : undefined
                          "
                          @input="clearFieldError('fullName')"
                        />
                        <small
                          v-if="errors.fullName"
                          id="consultation-fullName-error"
                          class="consultation-error"
                        >
                          {{ errors.fullName }}
                        </small>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div class="consultation-field" :class="{ 'has-error': errors.phone }">
                        <label class="consultation-label" for="consultation-phone">
                          Số điện thoại
                        </label>
                        <input
                          id="consultation-phone"
                          v-model="form.phone"
                          class="form-control input consultation-control"
                          type="tel"
                          name="phone"
                          placeholder="Số điện thoại *"
                          autocomplete="tel"
                          inputmode="tel"
                          maxlength="50"
                          :aria-invalid="Boolean(errors.phone)"
                          :aria-describedby="errors.phone ? 'consultation-phone-error' : undefined"
                          @input="clearFieldError('phone')"
                        />
                        <small
                          v-if="errors.phone"
                          id="consultation-phone-error"
                          class="consultation-error"
                        >
                          {{ errors.phone }}
                        </small>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div class="consultation-field" :class="{ 'has-error': errors.email }">
                        <label class="consultation-label" for="consultation-email">Email</label>
                        <input
                          id="consultation-email"
                          v-model="form.email"
                          class="form-control input consultation-control"
                          type="email"
                          name="email"
                          placeholder="Email *"
                          autocomplete="email"
                          maxlength="255"
                          :aria-invalid="Boolean(errors.email)"
                          :aria-describedby="errors.email ? 'consultation-email-error' : undefined"
                          @input="clearFieldError('email')"
                        />
                        <small
                          v-if="errors.email"
                          id="consultation-email-error"
                          class="consultation-error"
                        >
                          {{ errors.email }}
                        </small>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div class="consultation-field">
                        <label class="consultation-label" for="consultation-projectLocation">
                          Địa điểm công trình
                        </label>
                        <input
                          id="consultation-projectLocation"
                          v-model="form.projectLocation"
                          class="form-control input consultation-control"
                          type="text"
                          name="projectLocation"
                          placeholder="Địa điểm công trình"
                          autocomplete="address-level2"
                          maxlength="255"
                        />
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div
                        class="select1_wrapper consultation-field"
                        :class="{ 'has-error': errors.serviceType }"
                      >
                        <label class="consultation-label" for="consultation-serviceType">
                          Dịch vụ cần tư vấn
                        </label>
                        <div class="select1_inner consultation-select-wrap">
                          <select
                            id="consultation-serviceType"
                            v-model="form.serviceType"
                            class="select2 select consultation-control consultation-select"
                            name="serviceType"
                            data-dropdown-css-class="consultation-select-dropdown"
                            :aria-invalid="Boolean(errors.serviceType)"
                            :aria-describedby="
                              errors.serviceType ? 'consultation-serviceType-error' : undefined
                            "
                            @change="clearFieldError('serviceType')"
                          >
                            <option value="" disabled>Dịch vụ cần tư vấn *</option>
                            <option value="design-build">Thiết kế &amp; thi công trọn gói</option>
                            <option value="design">Thiết kế nội thất</option>
                            <option value="construction">Thi công hoàn thiện</option>
                            <option value="furniture">Sản xuất nội thất</option>
                          </select>
                        </div>
                        <small
                          v-if="errors.serviceType"
                          id="consultation-serviceType-error"
                          class="consultation-error"
                        >
                          {{ errors.serviceType }}
                        </small>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div
                        class="select1_wrapper consultation-field"
                        :class="{ 'has-error': errors.propertyType }"
                      >
                        <label class="consultation-label" for="consultation-propertyType">
                          Loại công trình
                        </label>
                        <div class="select1_inner consultation-select-wrap">
                          <select
                            id="consultation-propertyType"
                            v-model="form.propertyType"
                            class="select2 select consultation-control consultation-select"
                            name="propertyType"
                            data-dropdown-css-class="consultation-select-dropdown"
                            :aria-invalid="Boolean(errors.propertyType)"
                            :aria-describedby="
                              errors.propertyType ? 'consultation-propertyType-error' : undefined
                            "
                            @change="clearFieldError('propertyType')"
                          >
                            <option value="" disabled>Loại công trình *</option>
                            <option value="apartment">Căn hộ</option>
                            <option value="townhouse">Nhà phố</option>
                            <option value="villa">Biệt thự</option>
                            <option value="office">Văn phòng</option>
                            <option value="hospitality">Nhà hàng / khách sạn</option>
                            <option value="other">Công trình khác</option>
                          </select>
                        </div>
                        <small
                          v-if="errors.propertyType"
                          id="consultation-propertyType-error"
                          class="consultation-error"
                        >
                          {{ errors.propertyType }}
                        </small>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div
                        class="consultation-field"
                        :class="{ 'has-error': errors.estimatedArea }"
                      >
                        <label class="consultation-label" for="consultation-estimatedArea">
                          Diện tích dự kiến
                        </label>
                        <input
                          id="consultation-estimatedArea"
                          v-model.number="form.estimatedArea"
                          class="form-control input consultation-control"
                          type="number"
                          name="estimatedArea"
                          placeholder="Diện tích dự kiến (m²)"
                          inputmode="decimal"
                          min="1"
                          max="100000"
                          step="1"
                          :aria-invalid="Boolean(errors.estimatedArea)"
                          :aria-describedby="
                            errors.estimatedArea ? 'consultation-estimatedArea-error' : undefined
                          "
                          @input="clearFieldError('estimatedArea')"
                        />
                        <small
                          v-if="errors.estimatedArea"
                          id="consultation-estimatedArea-error"
                          class="consultation-error"
                        >
                          {{ errors.estimatedArea }}
                        </small>
                      </div>
                    </div>

                    <div class="col-md-6">
                      <div class="select1_wrapper consultation-field">
                        <label class="consultation-label" for="consultation-budget">
                          Ngân sách dự kiến
                        </label>
                        <div class="select1_inner consultation-select-wrap">
                          <select
                            id="consultation-budget"
                            v-model="form.budget"
                            class="select2 select consultation-control consultation-select"
                            name="budget"
                            data-dropdown-css-class="consultation-select-dropdown"
                          >
                            <option value="">Ngân sách dự kiến</option>
                            <option value="consult">Cần tư vấn</option>
                            <option value="under-500">Dưới 500 triệu</option>
                            <option value="500-1000">500 triệu – 1 tỷ</option>
                            <option value="1000-2000">1 – 2 tỷ</option>
                            <option value="over-2000">Trên 2 tỷ</option>
                          </select>
                        </div>
                      </div>
                    </div>

                    <div class="col-12">
                      <div class="consultation-field">
                        <label class="consultation-label" for="consultation-message">
                          Mong muốn của bạn
                        </label>
                        <textarea
                          id="consultation-message"
                          v-model="form.message"
                          class="form-control input consultation-control consultation-textarea"
                          name="message"
                          rows="3"
                          maxlength="4000"
                          placeholder="Chia sẻ phong cách, công năng hoặc thời gian dự kiến..."
                        ></textarea>
                      </div>
                    </div>

                    <div class="col-12">
                      <div
                        class="consultation-consent-wrap"
                        :class="{ 'has-error': errors.acceptedPrivacy }"
                      >
                        <label class="consultation-consent" for="consultation-acceptedPrivacy">
                          <input
                            id="consultation-acceptedPrivacy"
                            v-model="form.acceptedPrivacy"
                            type="checkbox"
                            name="acceptedPrivacy"
                            :aria-invalid="Boolean(errors.acceptedPrivacy)"
                            :aria-describedby="
                              errors.acceptedPrivacy
                                ? 'consultation-acceptedPrivacy-error'
                                : undefined
                            "
                            @change="clearFieldError('acceptedPrivacy')"
                          />
                          <span>
                            Tôi đồng ý để D&amp;L Furniture sử dụng thông tin trên nhằm liên hệ tư
                            vấn dự án.
                          </span>
                        </label>
                        <small
                          v-if="errors.acceptedPrivacy"
                          id="consultation-acceptedPrivacy-error"
                          class="consultation-error"
                        >
                          {{ errors.acceptedPrivacy }}
                        </small>
                      </div>
                    </div>

                    <div class="col-12">
                      <div
                        v-if="statusMessage"
                        class="consultation-status"
                        :class="`is-${submitState}`"
                        :role="submitState === 'error' ? 'alert' : 'status'"
                        aria-live="polite"
                      >
                        <i
                          :class="submitState === 'success' ? 'ti-check' : 'ti-alert'"
                          aria-hidden="true"
                        ></i>
                        <span>{{ statusMessage }}</span>
                      </div>

                      <button
                        type="submit"
                        class="btn-form1-submit consultation-submit"
                        :disabled="isSubmitting"
                      >
                        {{ isSubmitting ? 'Đang gửi yêu cầu...' : 'Nhận tư vấn miễn phí' }}
                      </button>
                    </div>
                  </div>
                </form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>
</template>

<style scoped>
.consultation-copy {
  padding-bottom: 75px;
}

.consultation-eyebrow {
  display: block;
  margin-bottom: 13px;
  color: #d8b98d;
  font-family: 'Barlow Condensed', sans-serif;
  font-size: 13px;
  letter-spacing: 5px;
  text-transform: uppercase;
}

.consultation-copy h2 {
  margin-bottom: 20px;
  color: #fff;
  font-size: 42px;
  font-weight: 400;
  line-height: 1.2;
}

.consultation-intro {
  margin-bottom: 24px;
  color: rgba(255, 255, 255, 0.82);
  line-height: 1.8;
}

.consultation-benefits {
  padding: 0;
  margin: 0 0 30px;
  list-style: none;
}

.consultation-benefits li {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin-bottom: 10px;
  color: #fff;
  font-size: 14px;
}

.consultation-benefits i {
  margin-top: 5px;
  color: #d8b98d;
  font-size: 11px;
}

.consultation-hotline {
  margin-bottom: 0;
}

.consultation-box {
  border: 1px solid rgba(170, 132, 83, 0.08);
  padding: 34px;
  box-shadow: 0 20px 50px rgba(25, 21, 17, 0.1);
}

.consultation-head {
  margin-bottom: 14px;
}

.consultation-head h4 {
  padding-bottom: 12px;
  margin-bottom: 12px;
}

.consultation-form .row {
  margin-right: -5px;
  margin-left: -5px;
  align-items: flex-start;
}

.consultation-form .row > [class*='col-'] {
  padding-right: 5px;
  padding-left: 5px;
}

.consultation-field {
  position: relative;
  margin-bottom: 10px;
}

.consultation-label {
  position: absolute;
  width: 1px;
  height: 1px;
  padding: 0;
  margin: -1px;
  overflow: hidden;
  clip: rect(0, 0, 0, 0);
  white-space: nowrap;
  border: 0;
}

.consultation-control {
  box-sizing: border-box;
  display: block;
  width: 100%;
  height: 46px;
  min-height: 46px;
  margin: 0;
  padding: 10px 15px;
  border: 1px solid #e2dbd2;
  border-radius: 0;
  outline: 0;
  background: #fff;
  box-shadow: none;
  color: #222;
  font-family: 'Barlow', sans-serif;
  font-size: 14px;
  line-height: 24px;
  transition:
    border-color 0.2s ease,
    box-shadow 0.2s ease;
}

.consultation-control:hover {
  border-color: rgba(170, 132, 83, 0.55);
}

.consultation-control::placeholder {
  color: #888;
  opacity: 1;
}

.consultation-control:focus {
  border-color: #aa8453;
  box-shadow: 0 0 0 2px rgba(170, 132, 83, 0.12);
}

.consultation-field.has-error .consultation-control,
.consultation-consent-wrap.has-error .consultation-consent input {
  border-color: #a94a43;
}

.consultation-select-wrap {
  position: relative;
  height: 46px;
  background: transparent;
}

.consultation-select-wrap::after {
  position: absolute;
  top: 50%;
  right: 17px;
  color: #aa8453;
  content: '\e64b';
  font-family: 'themify';
  font-size: 9px;
  pointer-events: none;
  transform: translateY(-50%);
}

.consultation-select {
  padding-right: 38px;
  appearance: none;
  cursor: pointer;
}

.consultation-form :deep(.select2),
.consultation-form :deep(.select2-container) {
  display: block;
  width: 100% !important;
  height: 46px;
  margin-bottom: 0;
  background: transparent;
}

.consultation-form :deep(.selection) {
  display: block;
  width: 100%;
  height: 46px;
}

.consultation-form :deep(.select2-container--default .select2-selection--single) {
  height: 46px;
  min-height: 46px;
  border: 1px solid #e2dbd2;
  background: #fff;
  transition:
    border-color 0.2s ease,
    box-shadow 0.2s ease;
}

.consultation-form :deep(.select2-container--default .select2-selection--single:hover) {
  border-color: rgba(170, 132, 83, 0.55);
}

.consultation-form
  :deep(.select2-container--default .select2-selection--single .select2-selection__rendered) {
  padding: 10px 38px 10px 15px;
  color: #222;
  font-size: 14px;
  line-height: 24px;
}

.consultation-form
  :deep(.select2-container--default.select2-container--focus .select2-selection--single),
.consultation-form
  :deep(.select2-container--default.select2-container--open .select2-selection--single) {
  border-color: #aa8453;
  box-shadow: 0 0 0 2px rgba(170, 132, 83, 0.12);
}

.consultation-field.has-error :deep(.select2-container--default .select2-selection--single) {
  border-color: #a94a43;
}

.consultation-textarea {
  height: 88px;
  min-height: 88px;
  resize: vertical;
}

.consultation-error {
  display: block;
  margin: 3px 0 0 2px;
  color: #a94a43;
  font-size: 10px;
  line-height: 1.3;
}

.consultation-consent-wrap {
  margin: 2px 0 12px;
}

.consultation-form label.consultation-consent {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin: 0;
  color: #555 !important;
  font-family: 'Barlow', sans-serif;
  font-size: 13px;
  font-weight: 400;
  line-height: 1.45;
  cursor: pointer;
  opacity: 1;
}

.consultation-form label.consultation-consent span {
  color: inherit !important;
  opacity: 1;
}

.consultation-consent input {
  width: 17px;
  height: 17px;
  flex: 0 0 17px;
  margin: 1px 0 0;
  border: 1px solid #cfc5ba;
  accent-color: #aa8453;
}

.consultation-status {
  display: flex;
  align-items: center;
  gap: 10px;
  margin-bottom: 12px;
  padding: 12px 14px;
  border-left: 3px solid currentColor;
  font-size: 13px;
  line-height: 1.5;
  box-shadow: 0 6px 18px rgba(25, 21, 17, 0.06);
}

.consultation-status span {
  display: block;
  flex: 1;
  color: inherit !important;
  opacity: 1 !important;
}

.consultation-status i {
  display: grid;
  width: 22px;
  height: 22px;
  flex: 0 0 22px;
  margin-top: 0;
  place-items: center;
  border-radius: 50%;
  color: inherit !important;
  font-size: 11px;
}

.consultation-status.is-success {
  border-color: #5f8a64;
  background: linear-gradient(90deg, #eaf4eb 0%, #f5faf5 100%);
  color: #2f5b35;
}

.consultation-status.is-success i {
  background: rgba(47, 91, 53, 0.1);
}

.consultation-status.is-error {
  border-color: #a94a43;
  background: linear-gradient(90deg, #f8e9e7 0%, #fcf5f4 100%);
  color: #7c3732;
}

.consultation-status.is-error i {
  background: rgba(124, 55, 50, 0.1);
}

.consultation-submit {
  margin-top: 0;
  line-height: 56px;
  box-shadow: 0 10px 24px rgba(170, 132, 83, 0.2);
  transition:
    background-color 0.25s ease,
    box-shadow 0.25s ease,
    transform 0.25s ease;
}

.consultation-submit:hover {
  box-shadow: 0 12px 28px rgba(34, 34, 34, 0.18);
  transform: translateY(-1px);
}

.consultation-submit:disabled {
  cursor: wait;
  opacity: 0.65;
}

.consultation-submit:disabled:hover {
  box-shadow: 0 10px 24px rgba(170, 132, 83, 0.2);
  transform: none;
}

.consultation-honeypot {
  position: absolute;
  left: -10000px;
  width: 1px;
  height: 1px;
  overflow: hidden;
}

@media (max-width: 991.98px) {
  .consultation-copy {
    padding-bottom: 45px;
  }

  .consultation-copy h2 {
    font-size: 38px;
  }

  .consultation-box {
    margin-bottom: 70px;
  }
}

@media (max-width: 575.98px) {
  .consultation-copy h2 {
    font-size: 33px;
  }

  .consultation-box {
    padding: 28px 20px;
  }

  .consultation-head h4 {
    font-size: 25px;
  }
}
</style>

<style>
.consultation-select-dropdown {
  overflow: hidden;
  border: 1px solid #e2dbd2;
  background: #fff;
  box-shadow: 0 14px 32px rgba(25, 21, 17, 0.14);
}

.consultation-select-dropdown .select2-results__options {
  max-height: 240px;
}

.consultation-select-dropdown .select2-results__option {
  overflow: hidden;
  padding: 9px 14px;
  border-top-color: #eee8e1;
  font-size: 14px;
  line-height: 20px;
  text-align: left;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.consultation-select-dropdown .select2-results__option[aria-disabled='true'] {
  display: none;
}
</style>
