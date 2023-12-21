import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";

// Connects to data-controller="timepicker"
export default class extends Controller {
  connect() {
    const { time } = this.element.dataset;

    flatpickr(this.element, {
      enableTime: true,
      noCalendar: true,
      dateFormat: "H:i",
      time_24hr: true,
      minuteIncrement: 30,
      defaultDate: time,
    });
  }
}
