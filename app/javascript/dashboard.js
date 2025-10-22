// Tailwind設定（必要なら保持）
tailwind.config = {
  theme: {
    extend: {
      colors: {
        'indigo-650': '#4f46e5',
      },
      fontFamily: {
        sans: ['Inter', 'sans-serif'],
      },
    },
  },
};

// Lucide Icons初期化
import 'lucide';

// ================================
// 🎯 ダッシュボード用 JavaScript
// ================================

// --- デモ用データ（後でRailsの@eventsに置き換え予定） ---
const dummyEvents = [
  {
    id: 1,
    title: "【10/27(日) 試合】出欠確認のお願い（最終回）",
    date: "10月27日 (日)",
    time: "10:00 - 15:00",
    location: "市民体育館Aコート",
    type: "試合",
    status: "未回答",
    note: "",
    fee: 1500,
    description: "今シーズン最後の試合です。9:30集合、昼食は各自持参。",
  },
  {
    id: 2,
    title: "今週の練習連絡 (木曜日)",
    date: "10月24日 (木)",
    time: "19:00 - 21:00",
    location: "学校体育館B",
    type: "練習",
    status: "未回答",
    note: "",
    fee: 0,
    description: "基本練習と戦術確認を行います。参加費は無料。",
  },
];

// --- 出欠ステータスの定義 ---
const statusMap = {
  0: { text: "未回答", color: "bg-gray-400" },
  1: { text: "参加", color: "bg-green-500" },
  2: { text: "欠席", color: "bg-red-500" },
  3: { text: "遅刻/調整", color: "bg-yellow-500" },
};

const statusUITextMap = {
  未回答: 0,
  参加: 1,
  欠席: 2,
  "遅刻/調整": 3,
};

let currentEvent = null;

// ================================
// 🪟 モーダル開閉
// ================================

export function openModal(eventId) {
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

export function closeModal() {
  document.getElementById("event-modal").classList.add("hidden");
  document.body.classList.remove("overflow-hidden");
  currentEvent = null;
}

// ================================
// ✅ 出欠登録ボタン処理
// ================================

export function setStatus(statusValue) {
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

export function saveAttendance() {
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
