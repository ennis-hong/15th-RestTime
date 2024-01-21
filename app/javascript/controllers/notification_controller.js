import { Controller } from "@hotwired/stimulus"
import { destroy } from "@rails/request.js"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["notification"]

  delete() {
    const { notification } = this.element.dataset

    this.call_destroy(notification).then((count) => {
      const removeTarget = document.querySelector(
        `#notification_${notification}`
      )
      if (removeTarget) {
        removeTarget.remove()
      }

      if (count == 0) {
        const badge = document.querySelector("#badge")
        badge.classList.add("hidden")
      }
    })
  }

  async call_destroy(notification) {
    const url = `/notifications/${notification}`
    const response = await destroy(url)

    if (response.ok) {
      const { count } = await response.json
      return count
    }
  }
}
