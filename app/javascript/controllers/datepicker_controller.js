import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="datepicker"
export default class extends Controller {
  connect() {
    const { servicetimes } = this.element.dataset;
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

    flatpickr(this.element, {
      enableTime: true,
      time_24hr: true,
      dateFormat: "Y/m/d H:i",
      minuteIncrement: 15,
      minDate: new Date().fp_incr(1),
      maxDate: new Date().fp_incr(30),
      disable: [
        function (date) {
          return disabledDays.includes(date.getDay());
        },
      ],
      onChange: function (selectedDates, dateStr, instance) {
        const dayOfWeek = selectedDates[0].getDay();
        if (schedulerDays) {
          const serviceTime = schedulerDays.find(
            (item) => dayOfWeekToNumber[item.day_of_week] === dayOfWeek
          );
          instance.set("minTime", serviceTime.open_time);
          instance.set("maxTime", serviceTime.close_time);
          instance.set("defaultHour", serviceTime.open_time.split(":")[0]);
        }
      },
    });
  }
}
