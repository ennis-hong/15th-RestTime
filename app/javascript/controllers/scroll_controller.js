import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="scroll"
export default class extends Controller {
  static targets = ["item"];

  connect() {
    this.startScrolling();
  }

  startScrolling() {
    setInterval(() => {
      this.scrollNext();
    }, 4500);
  }

  scrollNext() {
    const items = this.itemTargets;
    // 檢查至少一個元素以上
    if (items.length > 0) {
      const firstItem = items[0];
      // 渲染到第一個元素
      firstItem.parentNode.appendChild(firstItem);
    }
  }
}
