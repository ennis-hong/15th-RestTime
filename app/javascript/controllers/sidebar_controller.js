import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="sidebar"
export default class extends Controller {
  static targets = [ "toggleable" ]   
  
  connect() {
    console.log("成功");
  }
  toggle(){
    console.log(this.toggleableTarget)
  }
}
