import { Controller } from "@hotwired/stimulus"
import Swal from "sweetalert2"

// Connects to data-controller="loading"
export default class extends Controller {
  disconnect() {
    Swal.close()
  }

  loading() {
    const { message } = this.element.dataset

    Swal.fire({
      title: message,
      allowEscapeKey: false,
      allowOutsideClick: false,
      showConfirmButton: false,
      focusConfirm: false,
    })
    Swal.showLoading()
  }
}
