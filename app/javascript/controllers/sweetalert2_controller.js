import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";
// Connects to data-controller="sweetalert2"
export default class extends Controller {
  static targets = ["abc"];

  connect() {
    Swal.fire({
      title: "success",
      text: this.abcTarget.dataset.content,
      icon: "success",
      confirmButtonText: "Cool",
    });
  }
}
// export default class extends Controller {
//   connect() {
//     Swal.fire({
//       title: "success",
//       text: "flash[type]",
//       icon: "success",
//       confirmButtonText: "Cool",
//     });
//   }
// }
// console.log(this.abcTarget.dataset.content);
