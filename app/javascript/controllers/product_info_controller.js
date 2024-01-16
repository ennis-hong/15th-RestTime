import { Controller } from "@hotwired/stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static values = {
    title: String,
    description: String,
    price: String,
    imageUrl: String,
    serviceMin: String,
    url: String,
  };

  showDetails() {
    Swal.fire({
      html: `
        <div w-full">
          <figure>
            <img src="${this.imageUrlValue}" alt="${this.titleValue}" class="rounded-xl p-2 mt-5"/>
          </figure>
          <div class="card-body">
            <h2 class="card-title text-2xl">
              ${this.titleValue}
              <span class="text-orange-500 text-end text-3xl ml-auto">${this.priceValue}</span>
              <div class="badge badge-secondary text-white">${this.serviceMinValue}</div>
              </h2>
              <hr class="border-2 text-slate-500">
            <p class="text-left text-gray-500">${this.descriptionValue}</p>
            <div class="card-actions justify-end">
              <button class="btn btn-primary">
                <a href="${this.urlValue}">立即預定</a>
              </button>
            </div>
          </div>
        </div>
      `,
      width: "650px",
      showConfirmButton: false,
      showClass: {
        backdrop: `
        rgba(0,0,123,0.4)
        left top
        no-repeat
      `,
      },
    });
  }
}
