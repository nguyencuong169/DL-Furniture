<script setup lang="ts"></script>

<template>
    <footer class="footer">
      <div class="footer-top">
        <div class="container">
          <div class="row">
            <div class="col-md-4">
              <div class="footer-column footer-about">
                <h3 class="footer-title">D&L Furniture</h3>
                <p class="footer-about-text">
                  Được thành lập vào năm 2022 bởi đội ngũ kiến trúc sư đầy sáng tạo
                  nhiệt huyết cùng với đội ngũ thợ thi công tay nghề cao, giàu kinh nghiệm. <br/>
                  Các thiết kế của chúng tôi theo phong cách đương đại với triết lý tối giản.
                </p>

                <div class="footer-language">
                  <i class="lni ti-world"></i>
                  <select onchange="location = this.value;">
                    <option value="#0">Vietnamese</option>
                    <option value="#0">English</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="col-md-3 offset-md-1">
              <div class="footer-column footer-explore clearfix">
                <h3 class="footer-title">Danh mục</h3>
                <ul class="footer-explore-list list-unstyled">
                  <li><a href="/">Trang chủ</a></li>
                  <li><a href="/gioi-thieu">Giới thiệu</a></li>
                  <li><a href="/san-pham">Sản phẩm</a></li>
                  <li><a href="/du-an">Dự án</a></li>                  
                  <li><a href="/lien-he">Liên hệ</a></li>
                </ul>
              </div>
            </div>
            <div class="col-md-4">
              <div class="footer-column footer-contact">
                <h3 class="footer-title">Liên hệ</h3>
                <p class="footer-contact-text">
                  Đường Cầu Liêu<br />Thạch Xá - Thạch Thất - Hà Nội
                </p>
                <div class="footer-contact-info">
                  <p class="footer-contact-phone">
                    <span class="flaticon-call"></span> (+84)945-366-622
                  </p>
                  <p class="footer-contact-mail">info@dl-furniture.com</p>
                </div>
                <div class="footer-about-social-list">
                  <a href="#"><i class="ti-instagram"></i></a>
                  <a href="#"><i class="ti-twitter"></i></a>
                  <a href="#"><i class="ti-youtube"></i></a>
                  <a href="#"><i class="ti-facebook"></i></a>
                  <a href="#"><i class="ti-pinterest"></i></a>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="footer-bottom">
        <div class="container">
          <div class="row">
            <div class="col-md-12">
              <div class="footer-bottom-inner">
                <p class="footer-bottom-copy-right">
                  © Copyright 2024 by <a href="#">D&L Furniture</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
</template>

<style scoped></style>
