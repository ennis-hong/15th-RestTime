import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["element"]

  disconnect() {
    document.removeEventListener("click", this.handleOutsideClick.bind(this))
  }

  toggle() {
    debugger
    this.elementTarget.classList.toggle("hidden")
    if (!this.elementTarget.classList.contains("hidden")) {
      document.addEventListener("click", this.handleOutsideClick.bind(this))
    }
  }

  handleOutsideClick(event) {
    if (
      !this.element.contains(event.target) &&
      !this.elementTarget.classList.contains("hidden")
    ) {
      this.elementTarget.classList.add("hidden")
    }
  }
}
