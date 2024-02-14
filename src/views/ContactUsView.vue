<script setup lang="ts">
import AboutComponent from '../template/03_AboutComponent.vue'
import PricingComponent from '../template/05_PricingComponent.vue'
import FaciltiesComponent from '../template/07_FaciltiesComponent.vue'
import TeamComponent from '../template/14_TeamComponent.vue'
import TestiominalsComponent from '../template/08_TestiominalsComponent.vue'
</script>

<template>
  <main>
    <!-- Header Banner -->
    <div
      class="banner-header section-padding valign bg-img bg-fixed"
      data-overlay-dark="4"
      data-background="https://dl-furniture.netlify.app/assets/1-FQ5yJaaV.jpg"
    >
      <div class="container">
        <div class="row">
          <div class="col-md-12 caption mt-90">
            <h5>GET IN TOUCH</h5>
            <h1>Liên hệ với chúng tôi</h1>
          </div>
        </div>
      </div>
    </div>

    <!-- Contact -->
    <section class="contact section-padding">
      <div class="container">
        <div class="row mb-90">
          <div class="col-md-6 mb-60">
            <h3>D&L Furniture</h3>
            <p>
              Hotel ut nisl quam nestibulum ac quam nec odio elementum sceisue the aucan ligula.
              Orci varius natoque penatibus et magnis dis parturient monte nascete ridiculus mus
              nellentesque habitant morbine.
            </p>
            <div class="reservations mb-30">
              <div class="icon"><span class="flaticon-call"></span></div>
              <div class="text">
                <p>Reservation</p>
                <a href="tel:0945366622">(+84)945-366-622</a>
              </div>
            </div>
            <div class="reservations mb-30">
              <div class="icon"><span class="flaticon-envelope"></span></div>
              <div class="text">
                <p>Email Info</p>
                <a href="mailto:info@dl-furniture.com">info@dl-furniture.com</a>
              </div>
            </div>
            <div class="reservations">
              <div class="icon"><span class="flaticon-location-pin"></span></div>
              <div class="text">
                <p>Address</p>
                Đường Cầu Liêu<br />Thạch Xá - Thạch Thất - Hà Nội
              </div>
            </div>
          </div>
          <div class="col-md-5 mb-30 offset-md-1">
            <h3>Get in touch</h3>
            <form method="post" class="contact__form" action="#">
              <!-- form message -->
              <div class="row">
                <div class="col-12">
                  <div class="alert alert-success contact__msg" style="display: none" role="alert">
                    Your message was sent successfully.
                  </div>
                </div>
              </div>
              <!-- form elements -->
              <div class="row">
                <div class="col-md-6 form-group">
                  <input name="name" type="text" placeholder="Tên *" required />
                </div>
                <div class="col-md-6 form-group">
                  <input name="email" type="email" placeholder="Email *" required />
                </div>
                <div class="col-md-6 form-group">
                  <input name="phone" type="text" placeholder="Điện thoại *" required />
                </div>
                <div class="col-md-6 form-group">
                  <input name="subject" type="text" placeholder="Tiêu đề *" required />
                </div>
                <div class="col-md-12 form-group">
                  <textarea
                    name="message"
                    id="message"
                    cols="30"
                    rows="4"
                    placeholder="Nội dung *"
                    required
                  ></textarea>
                </div>
                <div class="col-md-12">
                  <button type="submit" class="butn-dark2"><span>Gửi tin nhắn</span></button>
                </div>
              </div>
            </form>
          </div>
        </div>
        <!-- Map Section -->
        <div class="row">
          <div class="col-md-12 map animate-box" data-animate-effect="fadeInUp">
            <iframe
              src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d1573147.7480448114!2d-74.84628175962355!3d41.04009641088412!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x89c25856139b3d33%3A0xb2739f33610a08ee!2s1616%20Broadway%2C%20New%20York%2C%20NY%2010019%2C%20Amerika%20Birle%C5%9Fik%20Devletleri!5e0!3m2!1str!2str!4v1646760525018!5m2!1str!2str"
              width="100%"
              height="600"
              style="border: 0"
              allowfullscreen="true"
              loading="lazy"
            ></iframe>
          </div>
        </div>
      </div>
    </section>
  </main>
</template>

<style></style>
