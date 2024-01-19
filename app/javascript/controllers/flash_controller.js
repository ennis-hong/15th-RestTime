import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["flash"];

  connect() {
    if (this.isLoginSuccess()) {
      this.successalert();
    } else {
      this.erroralert();
    }
  }

  isLoginSuccess() {
    return this.flashTarget.dataset.status === "success";
  }

  successalert() {
    Swal.fire({
      position: "top-end",
      icon: "success",
      text: this.flashTarget.dataset.content,
      showConfirmButton: false,
      timer: 3000,
      width: "300px",
    });
  }

  erroralert() {
    Swal.fire({
      position: "center",
      text: this.flashTarget.dataset.content,
      icon: "error",
      showConfirmButton: false,
      width: "300px",
      timer: 3000,
    });
  }
}
