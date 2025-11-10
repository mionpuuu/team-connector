# 🏓 Team Connector

## 概要
**Team Connector（チームコネクター）** は、スポーツチームやサークル活動の「予定・出欠・お知らせ」をひとつのダッシュボードでシンプルに管理できるWebアプリケーションです。

トップページ（ダッシュボード）では、今月の予定カレンダーや重要なお知らせをひと目で確認でき、チーム運営を効率化します。

---

## コンセプト
> **「つなぐことで、チームをもっとスムーズに。」**

Team Connectorは、情報の分散をなくし、チーム全体の連絡・共有・参加管理をよりスムーズにすることを目的としています。スポーツチームに限らず、地域活動やサークル運営などにも応用可能です。

---

## URL  
https://team-connector-9f74.onrender.com/
Basic認証ID：ikeyadmin
Basic認証PW：2222
メールアドレス：test@team
パスワード：111111
---

## 使用技術

### フロントエンド
- HTML / CSS (Tailwind CSS)
- JavaScript (Vanilla JS + Stimulus)
- Hotwire (Turbo, Stimulus)

### バックエンド
- Ruby 3.2.0
- Ruby on Rails 7.1.0

### データベース
- MySQL 8.0（開発・テスト環境）
- PostgreSQL（本番環境）

### 認証
- Devise

### ファイル管理
- Active Storage（複数画像添付対応）
- MiniMagick / ImageProcessing

### テスト
- RSpec
- FactoryBot
- Faker

### その他
- Rails I18n（日本語対応）
- Docker対応
- Render（デプロイ予定）

---

## 主な機能

### 🏠 ダッシュボード
- ログイン後のメイン画面
- 今月の予定を自動表示（日付順）
- 重要なお知らせをピン留め表示
- 試合作成・お知らせ作成への直接アクセス
- レスポンシブデザイン対応

### 🗓 イベント（試合・練習）管理機能
**登録機能:**
- イベント名、日付、時間、場所、詳細、参加費の登録
- 複数画像の添付（Active Storage使用）
- ユーザーによる作成・編集・削除

**表示機能:**
- 今後の予定を日付順で一覧表示
- イベント詳細ページでの情報確認
- 画像のモーダル表示（拡大表示）
- 過去の試合はアーカイブページで月別表示

### ✅ 出欠管理機能（Ajax対応）
- 「参加 / 未定 / 不参加」の3択で出欠登録
- Ajax通信による即時反映（ページリロード不要）
- 一言メモの追加可能（「途中参加します」など）
- リアルタイムで出欠状況を集計表示
- 出欠リストでメンバーごとのステータス確認

### 📢 お知らせ機能
- タイトル・本文での情報共有
- 重要度設定（ピン留め機能）
- 複数画像の添付対応
- 全メンバーが投稿可能
- 今月のお知らせと過去のお知らせの分類表示

### 💬 コメント機能
- イベントごとのコメント投稿
- ユーザー名と投稿日時の表示
- リアルタイムでのやり取り

### 🔐 ユーザー認証機能（Devise）
- メールアドレス・パスワードでの新規登録
- ログイン/ログアウト機能
- パスワード再設定機能
- ユーザー情報編集
- アカウント削除機能

### 📱 その他の機能
- 完全レスポンシブデザイン（スマホ・タブレット対応）
- 日本語インターフェース（Rails I18n使用）
- パンくずナビゲーション
- アクセス制限（未ログインユーザーの制限）

---

## 今後の実装予定

- 📅 カレンダー表示機能（月間カレンダーでのイベント可視化）
- 💰 会費管理機能（支払い済み/未払い表示）
- 🔔 通知・リマインド機能（イベント前日の自動通知）
- 📧 メール通知機能（新規イベント・お知らせの通知）
- 📊 統計機能（出席率の表示など）
- 👥 メンバー管理機能（役割・権限の設定）
- 📱 PWA対応（スマホホーム画面への追加）
- 🔍 検索機能（イベント・お知らせの検索）

---

## データベース設計

### usersテーブル
| Column             | Type   | Options                   |
| ------------------ | ------ | ------------------------- |
| username           | string | null: false               |
| email              | string | null: false, unique: true |
| encrypted_password | string | null: false               |

**Association:**
- has_many :events
- has_many :attendances
- has_many :notices
- has_many :comments

---

### eventsテーブル
| Column      | Type       | Options                        |
| ----------- | ---------- | ------------------------------ |
| title       | string     | null: false                    |
| date        | date       | null: false                    |
| time        | time       |                                |
| location    | string     | null: false                    |
| description | text       | null: false                    |
| fee         | integer    | default: 0                     |
| user        | references | null: false, foreign_key: true |

**Association:**
- belongs_to :user
- has_many :attendances, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many_attached :images

---

### attendancesテーブル（中間テーブル）
| Column | Type       | Options                        | 説明                          |
| ------ | ---------- | ------------------------------ | ----------------------------- |
| user   | references | null: false, foreign_key: true | 出欠登録したユーザー          |
| event  | references | null: false, foreign_key: true | 対象イベント                  |
| status | integer    | default: 0, null: false        | 出欠ステータス（enum: undecided/attending/absent/pending） |
| notice | text       |                                | 出欠メモ（任意）              |

**Association:**
- belongs_to :user
- belongs_to :event

---

### noticesテーブル
| Column     | Type       | Options                        |
| ---------- | ---------- | ------------------------------ |
| title      | string     | null: false                    |
| content    | text       | null: false                    |
| importance | boolean    | default: false                 |
| pinned     | boolean    | default: false                 |
| user       | references | null: false, foreign_key: true |

**Association:**
- belongs_to :user
- has_many_attached :images

---

### commentsテーブル
| Column  | Type       | Options                        |
| ------- | ---------- | ------------------------------ |
| user    | references | null: false, foreign_key: true |
| event   | references | null: false, foreign_key: true |
| content | text       | null: false                    |

**Association:**
- belongs_to :user
- belongs_to :event

---

## ローカル環境での実行方法

### 必要な環境
- Ruby 3.2.0
- Rails 7.1.0
- MySQL 8.0
- Node.js / Yarn

### セットアップ手順

1. **リポジトリのクローン**
```bash
git clone <repository-url>
cd team-connector
```

2. **依存関係のインストール**
```bash
bundle install
yarn install
```

3. **データベースの作成**
```bash
rails db:create
rails db:migrate
```

4. **サーバーの起動**
```bash
./bin/dev
# または
rails s
```

5. **ブラウザでアクセス**
```
http://localhost:3000
```

---

## テスト実行方法

RSpecを使用したテストを実行できます。

```bash
# 全てのテストを実行
bundle exec rspec

# 特定のテストファイルを実行
bundle exec rspec spec/models/user_spec.rb
```

---

## 工夫したポイント

### 1. Ajaxによる出欠登録
ページ遷移なしで出欠状況をリアルタイム更新。`XMLHttpRequest`を使用し、JSON形式でデータを受け取ることで、本番環境でも安定動作する仕組みを実装しました。

### 2. レスポンシブデザイン
Tailwind CSSを活用し、スマートフォンからPCまで、あらゆるデバイスで快適に使用できるUIを実現しました。

### 3. 画像管理
Active Storageを使用し、イベントやお知らせに複数の画像を添付可能に。画像はクリックでモーダル表示され、詳細を確認できます。

### 4. 国際化対応
Rails I18nを使用し、日本語でのエラーメッセージやラベル表示に対応。今後の多言語対応も容易に実装可能です。

### 5. テスト駆動開発
RSpecとFactoryBotを使用し、モデルの振る舞いを網羅的にテスト。安定した開発とリファクタリングを可能にしています。

---

## 制作背景

このアプリケーションは、スポーツチームの運営において「情報の分散」という課題を解決するために開発しました。

従来はLINEグループやメールで予定を共有し、Googleスプレッドシートで出欠管理をするなど、複数のツールを使い分ける必要がありました。Team Connectorでは、これらの機能を一つのプラットフォームに統合し、チーム運営をよりスムーズにすることを目指しています。

---

## 制作者

**Mion**

プログラミングスクールでの学習を通じて、Web開発の基礎から応用まで習得。本アプリケーションは、学習の集大成として、実際のチーム運営の課題を解決するために開発しました。

---

## ライセンス

このプロジェクトはMITライセンスの下で公開されています。