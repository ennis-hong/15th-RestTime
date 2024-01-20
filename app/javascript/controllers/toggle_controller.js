import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle"
export default class extends Controller {
  static targets = ["element"]
  hidden() {
    console.log("hi")
    this.elementTarget.classList.add("hidden")
  }
}
