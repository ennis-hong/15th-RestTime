import { Controller } from "@hotwired/stimulus"
import { destroy } from "@rails/request.js"

// Connects to data-controller="notification"
export default class extends Controller {
  static targets = ["element", "notification"]
  hidden() {
    this.elementTarget.classList.add("hidden")
  }

  delete() {
    const { notification } = this.element.dataset
    console.log(notification)
    console.log(this.notificationTargets)

    this.call_destroy(notification).then((res) => {
      if (res.ok) {
        const removeTarget = document.querySelector(
          `#notification_${notification}`
        )
        if (removeTarget) {
          removeTarget.remove()
        }
      } else {
      }
    })
  }

  async call_destroy(notification) {
    const url = `/notifications/${notification}`
    const response = await destroy(url)

    return response
  }
}
