
// ================================
// 🪟 モーダル開閉
// ================================

window.openModal = function(eventId) { 
  const event = dummyEvents.find((e) => e.id === eventId);
  if (!event) return;

  currentEvent = event;

  document.getElementById("modal-title").textContent = event.title;
  document.getElementById("modal-datetime").textContent = `${event.date} ${event.time}`;
  document.getElementById("modal-location").textContent = event.location;
  document.getElementById("modal-fee").textContent =
    event.fee > 0 ? `¥ ${event.fee.toLocaleString()}` : "無料";
  document.getElementById("modal-description").textContent = event.description;

  const currentStatusValue = statusUITextMap[event.status] || 0;
  document.getElementById("current-attendance-value").value = currentStatusValue;

  ["status-0", "status-1", "status-2", "status-3"].forEach((id) => {
    const btn = document.getElementById(id);
    btn.classList.remove("bg-indigo-600", "text-white");
    btn.classList.add("text-indigo-600", "bg-white");
  });

  if (currentStatusValue !== 0) {
    const active = document.getElementById(`status-${currentStatusValue}`);
    active.classList.add("bg-indigo-600", "text-white");
  }

  document.getElementById("attendance-note").value = event.note || "";
  document.getElementById("event-modal").classList.remove("hidden");
  document.body.classList.add("overflow-hidden");
}

window.closeModal = function() {
  document.getElementById("event-modal").classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
  currentEvent = null;
}

// ================================
// ✅ 出欠登録ボタン処理
// ================================

window.setStatus = function(statusValue) { 
  document.getElementById("current-attendance-value").value = statusValue;

  ["status-0", "status-1", "status-2", "status-3"].forEach((id, i) => {
    const btn = document.getElementById(id);
    btn.classList.remove("bg-indigo-600", "text-white");
    btn.classList.add("text-indigo-600", "bg-white");

    if (i === statusValue && statusValue !== 0) {
      btn.classList.add("bg-indigo-600", "text-white");
    }
  });
}

window.saveAttendance = function() { 
  if (!currentEvent) return;

  const newStatusValue = parseInt(
    document.getElementById("current-attendance-value").value,
    10
  );
  const newNote = document.getElementById("attendance-note").value.trim();

  const newStatusText =
    Object.keys(statusUITextMap).find(
      (key) => statusUITextMap[key] === newStatusValue
    ) || "未回答";

  currentEvent.status = newStatusText;
  currentEvent.note = newNote;

  updateEventCard(currentEvent);

  const message = document.createElement("div");
  message.className =
    "p-3 bg-indigo-100 border border-indigo-300 text-sm text-indigo-800 rounded-lg absolute top-0 left-0 right-0 z-50";
  message.textContent = "出欠情報を更新しました！";

  const card = document.getElementById(`event-card-${currentEvent.id}`);
  card.style.position = "relative";
  card.insertBefore(message, card.firstChild);

  setTimeout(() => {
    message.style.opacity = "0";
    setTimeout(() => message.remove(), 300);
  }, 2000);

  closeModal();
}

// ================================
// 🧩 イベントカードの更新
// ================================

function updateEventCard(event) {
  const card = document.getElementById(`event-card-${event.id}`);
  if (!card) return;

  const userStatusDiv = card.querySelector(".user-attendance-status");
  const statusValue = statusUITextMap[event.status];
  const statusInfo = statusMap[statusValue];

  userStatusDiv.innerHTML = `
    <span class="text-xs font-semibold mr-1">あなたの回答:</span>
    <span class="px-2 py-0.5 rounded-full text-xs font-bold text-white shadow-md ${statusInfo.color}">
      ${statusInfo.text}
    </span>
    ${event.note ? '<span class="text-xs text-gray-500 ml-1">(メモあり)</span>' : ""}
  `;
}

// ================================
// 🚀 初期描画
// ================================

function renderEvents() {
  const container = document.getElementById("event-list-container");
  if (!container) return;

  container.innerHTML = dummyEvents
    .map((event) => {
      const statusValue = statusUITextMap[event.status];
      const statusInfo = statusMap[statusValue];
      const isRsvpNeeded = event.type !== "練習" && event.type !== "お知らせ";

      return `
      <div id="event-card-${event.id}" 
           class="bg-white p-4 rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300 border-l-4 ${
             event.type === "試合" ? "border-red-500" : "border-indigo-400"
           } cursor-pointer relative"
           onclick="openModal(${event.id})">
          <div class="flex justify-between mb-2">
              <span class="text-xs font-semibold px-2 py-0.5 rounded-full ${
                event.type === "試合"
                  ? "bg-red-100 text-red-700"
                  : "bg-blue-100 text-blue-700"
              }">${event.type}</span>
              <span class="text-sm font-bold">${event.date} ${event.time}</span>
          </div>
          <h3 class="text-lg font-extrabold text-gray-900 mb-2">${event.title}</h3>
          <p class="text-sm text-gray-600 flex items-center mb-3">
              <i data-lucide="map-pin" class="w-4 h-4 mr-2 text-indigo-500"></i>${event.location}
              ${
                event.fee > 0
                  ? `<span class="ml-4 font-semibold text-green-700">| ¥ ${event.fee.toLocaleString()}</span>`
                  : ""
              }
          </p>
          ${
            isRsvpNeeded
              ? `
            <div class="user-attendance-status mt-3 pt-3 border-t border-gray-100">
              <span class="text-xs font-semibold mr-1">あなたの回答:</span>
              <span class="px-2 py-0.5 rounded-full text-xs font-bold text-white shadow-md ${statusInfo.color}">
                ${statusInfo.text}
              </span>
              ${
                event.note
                  ? '<span class="text-xs text-gray-500 ml-1">(メモあり)</span>'
                  : ""
              }
            </div>`
              : ""
          }
      </div>`;
    })
    .join("");

  lucide.createIcons();
}

window.addEventListener("DOMContentLoaded", renderEvents);
