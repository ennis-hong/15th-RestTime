import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["alert"];

  connect() {
    Swal.fire({
      position: "center",
      text: this.alertTarget.dataset.content,
      icon: "error",
      showConfirmButton: false,
      width: "300px",
      timer: 3000,
    });
  }
}
