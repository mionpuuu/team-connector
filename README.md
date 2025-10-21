# 🏓 Team Connector

## 概要
**Team Connector（チームコネクター）** は、  
スポーツチームやサークル活動の「予定」「出欠」「お知らせ」を  
ひとつの場所で簡単に管理できるWebアプリです。  

LINEなどのチャットで流れてしまう連絡を整理し、  
忙しいメンバーでも“開くだけで今月の予定がわかる”を実現します。  

---

## コンセプト
> 「つなぐことで、チームをもっとスムーズに。」

Team Connectorは、情報の分散をなくし、  
チーム全体の連絡・共有・参加管理をよりスムーズにすることを目的としています。  
スポーツに限らず、地域活動やサークル運営などにも応用可能です。

---

## URL  
（デプロイ後に追記予定）

---

## 使用技術
| カテゴリ | 使用技術 |
|-----------|-----------|
| フロントエンド | HTML / CSS / JavaScript (Ajax対応) |
| バックエンド | Ruby on Rails |
| データベース | PostgreSQL |
| 認証 | Devise |
| ファイル管理 | Active Storage（複数画像添付対応） |
| デプロイ | Render |
| 開発環境 | macOS / VSCode |

---

## 機能一覧

### 🏠 今月の予定確認（ホーム画面）
- アプリを開くと自動で「今月の予定」が表示される  
- 予定をクリックすると詳細ページへ遷移  
- 予定が多い場合は「もっと見る」で一覧ページへ  
- 予定がない場合は「今月の予定はありません」と表示  
- 過ぎたイベントは自動でグレーアウト  
- スマホ操作でも見やすいレスポンシブUI  

---

### 🗓 イベント登録・表示機能
- イベント登録時に以下を入力可能：  
- イベント名  
- 日付（カレンダー選択）  
- 時間  
- 場所（テキスト or Google Map URL）  
- 詳細メモ（任意）  
- 参加費（任意）  
- イベントは日付順で一覧表示  
- イベントごとに画像を複数添付可能（Active Storage対応）  

---

### ✅ 出欠登録・メモ機能（Ajax対応）
- 各イベント詳細ページで「参加／不参加」をワンタップ登録  
- 出欠登録後は即時反映（非同期通信）  
- 自分のステータスがボタン色で表示される  
- 「途中参加します」などの一言メモを添えられる  
- 出欠リストでメンバーごとのコメントを確認可能  

---

### 📢 お知らせ投稿機能
- お知らせを作成・閲覧できる  
- 重要度（★マーク）やピン留めを設定可能  
- 画像添付対応（大会要項・案内資料など）  
- メンバー全員が投稿可能（管理者制限なし）  

---

### 🔐 ユーザー管理機能（Devise）
- メールアドレスとパスワードで新規登録／ログイン／ログアウト  
- ログイン状態でのみ出欠登録・投稿が可能  
- パスワード再設定機能あり  

---

## 今後の実装予定
- 📅 カレンダー表示機能（simple_calendar等で視覚的に）  
- 💰 会費管理機能（支払い済み／未払い表示）  
- 🔔 通知・リマインド機能（イベント前日通知など）  
- 💬 コメント機能（イベント内ミニチャット）  
- 📱 PWA対応（スマホホーム画面に追加できる形へ）  

---

## ER図・DB設計
→ README内に追記済み（データベース設計セクション参照）

---

## コンセプトメッセージ
> 「開けば、チームがつながる。」  
Team Connectorは、日々の連絡を整理し、  
“誰でも使いやすく、ちゃんとつながる” チーム運営を支援します。




## usersテーブル

| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| name               | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |



### Association
- has_many :events
- has_many :attendances
- has_many :notices

## eventsテーブル

| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| title       | string     | null: false                    |
| date        | date       | null: false                    |
| time        | time       |                                |
| location    | string     |                                |
| description | text       |                                |
| fee         | integer    | default: 0                     |
| user        | references | null: false, foreign_key: true |


### Association
- belongs_to :user
- has_many :attendances
- has_many_attached :images


## attendancesテーブル（中間テーブル）

| Column | Type       | Options                        | 説明                   |
| ------ | ---------- | ------------------------------ | -------------------- |
| user   | references | null: false, foreign_key: true | 出欠登録したユーザー           |
| event  | references | null: false, foreign_key: true | 対象イベント               |
| status | integer    | default: 0, null: false        | 出欠ステータス（enum管理）      |
| note   | text       |                                | 出欠メモ（任意、「途中参加します」など） |


### Association
- belongs_to :user
- belongs_to :event


## noticesテーブル

| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| title      | string     | null: false                    |
| content    | text       | null: false                    |
| importance | boolean    | default: false                 |
| pinned     | boolean    | default: false                 |
| user       | references | null: false, foreign_key: true |

### Association
- belongs_to :user
- has_many_attached :images
