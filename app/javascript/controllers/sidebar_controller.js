import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["menu"];

  toggle() {
    this.menuTarget.classList.toggle("hidden", this.isMenuVisible);
  }
}
