import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = ["menu"];
  isMenuVisible = false;

  toggle() {
    this.isMenuVisible = !this.isMenuVisible;
    this.menuTarget.classList.toggle("hidden", !this.isMenuVisible);
  }
}
