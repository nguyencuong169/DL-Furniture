<script setup lang="ts"></script>

<template>
    <footer class="footer">
      <div class="footer-top">
        <div class="container">
          <div class="row">
            <div class="col-md-4">
              <div class="footer-column footer-about">
                <h3 class="footer-title">About Hotel</h3>
                <p class="footer-about-text">
                  Welcome to the best five-star deluxe hotel in New York. Hotel elementum sesue the
                  aucan vestibulum aliquam justo in sapien rutrum volutpat.
                </p>

                <div class="footer-language">
                  <i class="lni ti-world"></i>
                  <select onchange="location = this.value;">
                    <option value="#0">English</option>
                    <option value="#0">German</option>
                  </select>
                </div>
              </div>
            </div>
            <div class="col-md-3 offset-md-1">
              <div class="footer-column footer-explore clearfix">
                <h3 class="footer-title">Explore</h3>
                <ul class="footer-explore-list list-unstyled">
                  <li><a href="index.html">Home</a></li>
                  <li><a href="rooms.html">Rooms & Suites</a></li>
                  <li><a href="restaurant.html">Restaurant</a></li>
                  <li><a href="spa-wellness.html">Spa & Wellness</a></li>
                  <li><a href="about.html">About Hotel</a></li>
                  <li><a href="contact.html">Contact</a></li>
                </ul>
              </div>
            </div>
            <div class="col-md-4">
              <div class="footer-column footer-contact">
                <h3 class="footer-title">Contact</h3>
                <p class="footer-contact-text">
                  1616 Broadway NY, New York 10001<br />United States of America
                </p>
                <div class="footer-contact-info">
                  <p class="footer-contact-phone">
                    <span class="flaticon-call"></span> 855 100 4444
                  </p>
                  <p class="footer-contact-mail">info@luxuryhotel.com</p>
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
                  © Copyright 2022 by <a href="#">DuruThemes.com</a>
                </p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </footer>
</template>

<style scoped></style>
