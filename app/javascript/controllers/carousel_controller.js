import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="carousel"
export default class extends Controller {
  static targets = ["slide"];

  // 初始
  initialize() {
    // 第一張
    this.currentIndex = 0;
    // 顯示當前
    this.showCurrentSlide();
    // 自動播放
    this.startAutoPlay();
    // 禁用觸摸滑動
    this.disableTouchSwipe();
  }

  startAutoPlay() {
    // 設置定時器自動切換下一張
    this.autoPlayTimer = setInterval(() => {
      this.next();
    }, 5000);
    this.disableTouchSwipe();
  }

  next() {
    this.currentIndex += 1;

    if (this.currentIndex >= this.slideTargets.length) {
      this.currentIndex = 0;
    }
    this.showCurrentSlide();
  }

  previous() {
    this.currentIndex -= 1;

    if (this.currentIndex < 0) {
      this.currentIndex = this.slideTargets.length - 1;
    }

    this.showCurrentSlide();
  }

  // 顯示當前幻燈片
  showCurrentSlide() {
    // 獲取第一個幻燈片元素的寬度
    const slideWidth = this.slideTargets[0].clientWidth;
    // 計算位移量
    const offsetWidth = -(this.currentIndex * slideWidth);

    // 遍歷所有幻燈片元素，更新它們的位置
    this.slideTargets.forEach((element) => {
      element.style.transform = `translateX(${offsetWidth}px)`;
    });
  }
}
