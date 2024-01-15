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
    if (items.length > 0) {
      const firstItem = items[0];
      firstItem.parentNode.appendChild(firstItem);
    }
  }
}
