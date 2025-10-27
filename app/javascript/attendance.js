function attendanceButtons() {
  // 参加ボタン
  const attendForm = document.getElementById("attend-form");
  if (attendForm) {
    attendForm.addEventListener("submit", (e) => {
      e.preventDefault();
      const formData = new FormData(attendForm);
      const XHR = new XMLHttpRequest();
      const eventId = attendForm.dataset.eventId;
      XHR.open("POST", `/events/${eventId}/attend`, true);
      XHR.responseType = "json";
      XHR.send(formData);
      XHR.onload = () => {
        if (XHR.status != 200) {
          alert(`エラー: ${XHR.statusText}`);
          return;
        }
        updateAttendanceList(XHR.response.html);
      };
    });
  }

  // 未定ボタン
  const pendingForm = document.getElementById("pending-form");
  if (pendingForm) {
    pendingForm.addEventListener("submit", (e) => {
      e.preventDefault();
      const formData = new FormData(pendingForm);
      const XHR = new XMLHttpRequest();
      const eventId = pendingForm.dataset.eventId;
      XHR.open("POST", `/events/${eventId}/pending`, true);
      XHR.responseType = "json";
      XHR.send(formData);
      XHR.onload = () => {
        if (XHR.status != 200) {
          alert(`エラー: ${XHR.statusText}`);
          return;
        }
        updateAttendanceList(XHR.response.html);
      };
    });
  }

  // 不参加ボタン
  const cancelForm = document.getElementById("cancel-form");
  if (cancelForm) {
    cancelForm.addEventListener("submit", (e) => {
      e.preventDefault();
      const formData = new FormData(cancelForm);
      const XHR = new XMLHttpRequest();
      const eventId = cancelForm.dataset.eventId;
      XHR.open("POST", `/events/${eventId}/cancel`, true);
      XHR.responseType = "json";
      XHR.send(formData);
      XHR.onload = () => {
        if (XHR.status != 200) {
          alert(`エラー: ${XHR.statusText}`);
          return;
        }
        updateAttendanceList(XHR.response.html);
      };
    });
  }
}

function updateAttendanceList(html) {
  const attendanceSection = document.getElementById("attendance-list");
  if (attendanceSection) {
    attendanceSection.innerHTML = html;
  }
}

window.addEventListener('turbo:load', attendanceButtons);