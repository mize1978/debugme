# DebugMe

**日本語** | [English](./README.en.md)

<p align="center"><img src="./docs/banner.png" alt="DebugMeのビジュアル" width="100%"></p>

**悩みを、デバッグログに。**
AIが悩みをエラーログ風に整理し、次の一歩を考えるためのヒントを返す思考整理ツールです。

[**ライブデモを開く ↗**](https://debugme-2m5k.onrender.com) · [概要](#debugmeとは) · [機能](#機能) · [構成](#構成) · [セットアップ](#セットアップ)

初回アクセス時などは、起動に時間がかかる場合があります。

## DebugMeとは

ラバーダックデバッグの「問題を言葉にして説明すると、整理のきっかけになる」という考え方から生まれたアプリです。

ユーザーが悩みを書き、AIがログの形に整理し、ユーザー自身が次の行動を考えます。医療・心理の診断を行うサービスではありません。表示される深刻度やスコアはAIが生成する表現であり、客観的な測定値ではありません。

> AIは裏方。答えを出すのはあなた自身。

## 使い方

1. 200文字以内で悩みを入力するか、サンプルを選びます。
2. 「エラーログを生成する」を押します。
3. 起動・解析のコンソール表示のあと、ログ、深刻度・スコア、短い解決案を確認します。
4. ログをコピーしたり、Xへの投稿画面を開いたりできます。

入力内容はClaude APIへ送信されます。生成されたログはURLから閲覧でき、ランキングにも掲載される場合があります。個人を特定できる情報は入力しないでください。

## 機能

- **悩みをエラーログへ変換**：エラー名、スタックトレース風の文章、原因、ヒントを生成
- **解析中のコンソール表示**：起動ログや進行表示、完了時のタイプライター表示
- **深刻度とスコア**：生成時にゲージと4つの指標を表示
- **SUGGESTED FIX**：短い解決案を3つ表示
- **共有**：ログのコピー、Xの投稿画面へのリンク、保存済みログのURL
- **ランキング**：閲覧数順のログ一覧
- **猫のNeco**：入力テーマに応じたメッセージ、ドット猫、割れたドットハート
- **効果音**：初期状態はOFF。SOUNDをONにすると、切り替え時・解析開始・完了・接続エラー時に短い電子音を再生
- **レスポンシブ表示と動きを減らす設定への対応**

### 生成中の表示と保存内容

Claudeの応答はRailsがストリームで受け取ります。ブラウザにはSSEで進行通知を送り、JSONの解析完了後にログ・スコア・解決案などをまとめて渡します。画面の進行バーは演出であり、実際の解析率を計測したものではありません。

現在DBに保存する生成結果はエラーログ本文です。生成時のスコア・原因・ヒント・解決案は保存していないため、保存済みURLを開き直すと生成直後と同じ情報すべては再表示されません。スコア部分は未保存の表示になります。

## Necoについて

<p align="center"><img src="./docs/neco-profile.png" alt="Necoのキャラクター画像" width="700"></p>

NecoはDebugMeの猫のアシスタントです。悩みを整理する画面に寄り添い、短いメッセージで次の一歩を支えます。

## 制作時のデモ素材

以下は初期UIの記録です。現在の配色・配置・機能の確認には[ライブデモ](https://debugme-2m5k.onrender.com)をご覧ください。

![初期UIのデモ](./docs/demo.gif)

## 技術スタック

| 役割 | 技術 |
| --- | --- |
| 言語・バックエンド | Ruby 3.1.4 / Rails 7.2 |
| フロントエンド | Hotwire / Stimulus / Importmap |
| AI | Claude API / `claude-sonnet-4-6` / `ruby-anthropic` |
| 通信 | Server-Sent Events / `ActionController::Live` |
| DB | PostgreSQL |
| リクエスト制限 | Rack::Attack / Redis |
| 効果音 | Web Audio API |
| 公開環境 | Docker / Render |

バージョンの指定は`.ruby-version`、`Gemfile`、`Gemfile.lock`、`Dockerfile`を参照してください。

## 構成

```text
悩みを入力
  → DebugLogsController#createで保存
  → ブラウザがSSE接続を開始
  → DebugLogGeneratorがClaude APIを呼び出す
  → Railsが応答のJSONを解析
  → ログ本文を保存し、結果一式をブラウザへ通知
  → Stimulusがログ・ゲージ・解決案を表示
```

| ファイル | 役割 |
| --- | --- |
| `app/controllers/debug_logs_controller.rb` | 作成・表示・SSE・ランキング |
| `app/services/debug_log_generator.rb` | Claudeへのプロンプトとストリーム受信 |
| `app/javascript/controllers/stream_controller.js` | コンソール、結果表示、共有 |
| `app/javascript/controllers/sound_controller.js` | 効果音のON/OFFと再生 |
| `config/initializers/rack_attack.rb` | IP単位のリクエスト制限 |

## セットアップ

Ruby 3.1.4、PostgreSQL、Redisを用意します。以下はローカルでRailsを起動する手順です。

```bash
git clone https://github.com/mize1978/debugme.git
cd debugme
bundle install

# 自分の環境に合わせて設定
export ANTHROPIC_API_KEY='your-api-key'
export DATABASE_HOST='localhost'
export DATABASE_PASSWORD='password'
export REDIS_URL='redis://localhost:6379/0'

bin/rails db:create db:migrate
bin/rails server
```

[http://localhost:3000](http://localhost:3000)を開きます。DB設定の標準ユーザーは`postgres`です。異なるユーザーやポートを使う場合は、`DATABASE_URL`で接続先を指定できます。APIキーなどの秘密情報はコミットしないでください。

### 環境変数

| 変数 | 用途 |
| --- | --- |
| `ANTHROPIC_API_KEY` | Claude APIのキー。AI生成に必要 |
| `DATABASE_HOST` / `DATABASE_PASSWORD` | ローカルDB接続先。標準値は`localhost` / `password` |
| `DATABASE_URL` | PostgreSQL接続URL。本番ではRender側で設定 |
| `REDIS_URL` | リクエスト制限用Redis。未指定時は`redis://localhost:6379/0` |
| `RAILS_MASTER_KEY` | 本番のRails credentials用キー |

Render向けの構成は`render.yaml`にあります。キーなどの秘密情報はRender側で設定します。

---

MIT License — [LICENSE](./LICENSE) · Made by [MIZE](https://github.com/mize1978)
