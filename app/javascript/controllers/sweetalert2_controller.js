import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["abc"];

  connect() {
    Swal.fire({
      position: "top-end",
      text: this.abcTarget.dataset.content,
      icon: "success",
      showConfirmButton: false,
      width: "200px",
      timer: 1500,
    });
  }
}
