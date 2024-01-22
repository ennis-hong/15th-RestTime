// app/javascript/controllers/location_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.getLocation();
  }

  getLocation() {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        this.handlePosition.bind(this),
        this.handleError.bind(this)
      );
    } else {
      console.log("Geolocation is not supported by this browser.");
    }
  }

  handlePosition(position) {
    fetch("/your_endpoint", {
      method: "GET",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("[name='csrf-token']").content,
      },
      body: JSON.stringify({
        latitude: position.coords.latitude,
        longitude: position.coords.longitude,
      }),
    })
      .then((response) => {
        if (response.ok) {
          return response.json(); // 或 response.text()
        } else {
          throw new Error("Network response was not ok.");
        }
      })
      .catch((error) => {
        console.error(
          "There has been a problem with your fetch operation:",
          error
        );
      });
  }

  handleError(error) {
    console.error("Error in obtaining position:", error);
  }
}
