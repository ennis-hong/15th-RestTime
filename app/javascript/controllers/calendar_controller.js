import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="calendar"
export default class extends Controller {
  static targets = ["calendar"];
  toggleCalendar() {
    this.calendarTarget.classList.toggle("hidden");
  }
}
