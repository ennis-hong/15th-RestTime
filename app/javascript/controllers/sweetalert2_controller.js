import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";
// Connects to data-controller="sweetalert2"
export default class extends Controller {
  connect() {
    Swal.fire({
      title: "success",
      text: "Do you want to continue",
      icon: "success",
      confirmButtonText: "Cool",
    });
  }
}
