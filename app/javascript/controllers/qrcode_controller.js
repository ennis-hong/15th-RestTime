import { Controller } from "@hotwired/stimulus";
import QRcode from "qrcode";
// Connects to data-controller="qrcode"
export default class extends Controller {
  connect() {
    const { text } = this.element.dataset;
    if (text) {
      QRcode.toCanvas(
        this.element,
        text,
        {
          width: 200,
          margin: 1,
          color: {
            light: "#ffff",
          },
        },
        (err) => {
          console.log(err);
        }
      );
    }
  }
}
