import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="products"
export default class extends Controller {
  toggleModal(e) {
    e?.preventDefault();

    const products_modal = document.querySelector("#products_modal");
    products_modal.checked = !products_modal.checked;
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
    const selectProduct = document.querySelector("#product_id");
    selectProduct.value = selectedProductId;

    this.toggleModal();
  }
}
