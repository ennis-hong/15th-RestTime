import { Controller } from "@hotwired/stimulus";
import { MandarinTraditional } from "flatpickr/dist/l10n/zh-tw.js";
import { patch } from "@rails/request.js";
import Swal from "sweetalert2";

// Connects to data-controller="datepicker"
export default class extends Controller {
  initializeDatePicker(e) {
    e.preventDefault();
    const { servicetimes, shop } = this.element.dataset;
    const dayOfWeekToNumber = {
      Sunday: 0,
      Monday: 1,
      Tuesday: 2,
      Wednesday: 3,
      Thursday: 4,
      Friday: 5,
      Saturday: 6,
    };
    const schedulerDays = JSON.parse(servicetimes);
    const disabledDays = schedulerDays
      .filter((day) => day.off_day)
      .map((day) => dayOfWeekToNumber[day.day_of_week]);

    const callAvailable = (shop, date) => {
      console.log(`shop: ${shop}`);
      this.call_available(shop, date).then((availableSlots) => {
        const content = Swal.getHtmlContainer();
        if (content) {
          content.replaceChild(
            this.slots_html(availableSlots),
            document.querySelector("#slots")
          );
        }
      });
    };

    Swal.fire({
      title: "選擇日期",
      html: '<div id="calendar-container"><div id="calendar" style="text-align: center;"></div></div><hr><div id="slots"></div><hr><input id="booking_date" class="label" readonly=true />',
      showCloseButton: true,
      focusConfirm: false,
      didOpen: () => {
        flatpickr("#calendar", {
          locale: MandarinTraditional,
          inline: true,
          dateFormat: "Y/m/d",
          minDate: new Date().fp_incr(1),
          maxDate: new Date().fp_incr(30),
          disable: [
            function (date) {
              return disabledDays.includes(date.getDay());
            },
          ],
          onChange: function (selectedDates, dateStr, instance) {
            console.log("change");
            callAvailable(shop, dateStr);
          },
        });
      },
    });
  }

  async call_available(shop, booking_date) {
    const url = `/api/v1/bookings/${shop}/available_slots`;

    const response = await patch(url, {
      body: JSON.stringify({ booking_date: booking_date }),
    });

    if (response.ok) {
      const { available_slots } = await response.json;
      return available_slots;
    } else {
      // const { url } = await response.json;
      // window.location.href = url;
    }
  }

  slots_html(slots) {
    const slotsDiv = document.createElement("div");
    slotsDiv.id = "slots";
    slotsDiv.className = "grid grid-cols-4 gap-2 my-3";

    slots.map((slot) => {
      const btn = document.createElement("button");
      btn.className = "btn btn-outline rounded-none";
      btn.textContent = slot;

      btn.addEventListener("click", this.handleClick);

      slotsDiv.appendChild(btn);
    });

    return slotsDiv;
  }

  handleClick() {
    const allBtn = document.querySelectorAll("button");
    allBtn.forEach((btn) => btn.classList.remove("btn-active"));
    this.classList.add("btn-active");
  }
}
