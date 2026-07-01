# ErrorLog AI

> あなたの悩みをエラーログに変換します。

**🚧 現在開発中 — Coming Soon**

---

## 概要

日常の悩みや愚痴を入力すると、AI がプログラムのエラーログ形式に変換して出力します。  
笑えるけど、少し救われる。そんなアプリです。

```
入力：「彼氏から返信が来ない」

──────────────────────────────────────
[ERROR] ConnectionTimeout
恋人との通信が確立できません

  at Relationship.waitForReply (heart.rb:42)
  at Life.checkNotifications (life.rb:108)

再試行回数    : 47
最終通信      : 3時間前
エラーレベル  : 🟠 ERROR

Suggested Fix:
  → 今日は十分頑張りました。
  → このエラーは永続化されません。
  → 一晩おいて再試行してください。
──────────────────────────────────────
```

---

## 予定機能

- **AI エラーログ生成** — Claude API によるリアルタイムストリーミング出力
- **エラーレベル自動判定** — INFO / WARNING / ERROR / CRITICAL / FATAL をAIが決定
- **レア演出** — 低確率で `✨ NO BUG DETECTED` が出現
- **公開オプション** — 結果を匿名で公開可能（デフォルトは非公開）
- **みんなのログ** — 公開されたログの一覧、笑った・共感ランキング
- **ログイン制限** — 未ログイン 5回/日、ログイン 20回/日

---

## 技術スタック（予定）

- Ruby 3.2 / Rails 7.2
- Claude API（Anthropic）— ストリーミング出力
- Turbo Streams / Stimulus（Hotwire）
- ActionCable — リアルタイム通信
- 動的 OGP 生成 — X シェア時にエラーログが画像で表示
- Docker / Docker Compose
- PostgreSQL

---

## コンセプト

同じ悩みを入力しても、AI が毎回異なる切り口で変換するため何度でも楽しめます。  
「Suggested Fix」は笑えるネタの中に、少し前向きになれる一言を添えます。

> RewardMe が「楽しみながら続ける体験」なら、  
> ErrorLog AI は「悩みを笑いに変える体験」。

---

## ステータス

| フェーズ | 状態 |
|---|---|
| 企画・設計 | ✅ 完了 |
| 開発 | 🚧 準備中 |
| リリース | ⏳ 未定 |

---

## 作者

**mize** — https://github.com/mize1978
