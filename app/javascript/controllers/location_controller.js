// app/javascript/controllers/location_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["link"];

  nearby_shop() {
    this.getLocation();
  }

  getLocation() {
    // 檢查瀏覽器是否支援 Geolocation API
    if (navigator.geolocation) {
      // 若支援，則請求當前位置，並將當前位置資訊傳給 handlePosition 方法處理
      navigator.geolocation.getCurrentPosition(this.handlePosition.bind(this));
    } else {
      alert("您的瀏覽器不支援地理定位。請嘗試更新您的瀏覽器或使用其他瀏覽器。");
    }
  }

  handlePosition(position) {
    const url = new URL(this.linkTarget.href);
    url.searchParams.append("latitude", position.coords.latitude);
    url.searchParams.append("longitude", position.coords.longitude);
    // 重定向瀏覽器到新構建的 URL
    window.location = url.toString();
  }
}
