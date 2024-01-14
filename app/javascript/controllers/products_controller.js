import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="products"
export default class extends Controller {
  static targets = ["productModal", "selectProduct", "serviceDate"];

  toggleModal(e) {
    e?.preventDefault();

    const productModal = this.productModalTarget;
    productModal.checked = !productModal.checked;
  }

  showCollapse(e) {
    const id = e.target.value;
    const collapse = document.querySelector(`#my-accordion_${id}`);
    const selectRadio = document.querySelector(`#product_id_${id}`);

    if (e.target == selectRadio) {
      collapse.checked = true;
    } else {
      selectRadio.checked = true;
    }
  }

  selectProductOption() {
    const selectRadio = document.querySelector(
      'input[type="radio"][name="product_id"]:checked'
    );
    const selectedProductId = selectRadio?.value;
    const selectProduct = this.selectProductTarget;
    selectProduct.value = selectedProductId;
    this.serviceDateTarget.classList.remove("hidden");

    this.toggleModal();
  }
}
