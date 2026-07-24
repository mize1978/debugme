# DebugMe

<p align="center">
  <img src="./docs/banner.png" width="100%">
</p>

<p align="center">
  <a href="https://debugme-2m5k.onrender.com"><strong>🔗 Live Demo</strong></a>
  &nbsp;·&nbsp;
  <a href="#what-is-debugme">About</a>
  &nbsp;·&nbsp;
  <a href="#demo">Demo</a>
  &nbsp;·&nbsp;
  <a href="#architecture">Architecture</a>
</p>

<p align="center">
  <img alt="Ruby" src="https://img.shields.io/badge/Ruby-3.1.4-CC342D?logo=ruby&logoColor=white">
  <img alt="Rails" src="https://img.shields.io/badge/Rails-7.2-CC0000?logo=rubyonrails&logoColor=white">
  <img alt="Claude" src="https://img.shields.io/badge/Claude-sonnet--4--6-D97757">
  <img alt="License" src="https://img.shields.io/badge/License-MIT-blue">
</p>

> **Debug your day.**
> AI-powered thought debugging.
>
> 🔗 **Try it live → [debugme-2m5k.onrender.com](https://debugme-2m5k.onrender.com)**
> *(free instance — first load may take ~50s to wake up)*

---

*DebugMe never speaks first.*
*It listens. It organizes. It reflects.*
*AI should support. Users should decide.*

---

## What is DebugMe?

DebugMe is not an AI counselor.
It helps you organize your own thoughts.

Inspired by rubber duck debugging — the idea that explaining a problem out loud helps you find the answer yourself — DebugMe gives that experience a structure. You write. AI listens. You decide.

---

DebugMeは相談AIではありません。
思考を整理するためのデバッグツールです。

プログラマーが使うラバーダックデバッグにインスピレーションを受けた、思考整理ツールです。
AIは裏方。答えを出すのはあなた自身。

---

## Demo

**1. Waiting** — Neco is ready, but never speaks first.

![Waiting](./docs/idle.png)

**2. Streaming** — your worry is analyzed in real time.

![Streaming](./docs/demo.gif)

**3. Result** — your worry, debugged.

![Result](./docs/hero.png)

*Input → Streaming → Log → Summary → Reflect*

---

## 🐈 Meet Neco

<p align="center">
  <img src="./docs/neco-profile.png" width="900">
</p>

> *"DebugMe never speaks first."*

Neco is DebugMe's AI companion.

Instead of giving immediate answers,
Neco listens, organizes your thoughts,
and helps you discover your own next step.

---

### Character Profile

| | |
|---|---|
| **Name** | Neco |
| **Role** | AI Error Log Assistant |
| **Personality** | Quiet but kind |
| **Special Skill** | Finding hidden bugs in thoughts |
| **Likes** | Coffee · Listening · Debugging |
| **Dislikes** | Being ignored · Undefined variables · Infinite loops |
| **Motto** | *"Let's debug today together. にゃーん。"* |

---

## Features

*What DebugMe does for you:*

- **Thought → Error Log** — turns a worry into a structured, debuggable error log
- **Real-time streaming** — watch Neco analyze your input line by line, live
- **Severity & diagnostics** — a 0–100% "severity" gauge plus self-esteem / action / communication scores
- **Suggested fixes** — three concrete, bite-sized next steps
- **Reflection, not answers** — DebugMe reflects your thoughts back so *you* decide

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Ruby 3.1.4 |
| Backend | Ruby on Rails 7.2 |
| Frontend | Hotwire (Turbo + Stimulus), Import Maps (no Node build) |
| AI | Claude API (`claude-sonnet-4-6`), streaming |
| Realtime | Server-Sent Events via `ActionController::Live` |
| Database | PostgreSQL |
| Cache / Rate-limit | Redis + Rack::Attack |
| Infrastructure | Docker · Render (Blueprint) |

---

## Architecture

DebugMe streams the analysis to the browser in real time. The worry is
persisted first, then a dedicated SSE endpoint pipes Claude's streaming
output straight to a Stimulus controller — no polling, no page reload.

```mermaid
flowchart TD
    subgraph Browser
        A["Stimulus controller<br/>(EventSource)"]
    end
    subgraph Rails
        B["DebugLogsController#create<br/>persist worry"] --> C["DebugLogsController#stream<br/>ActionController::Live + SSE"]
        C --> D["DebugLogGenerator<br/>prompt builder"]
    end
    E["Claude API<br/>(streaming)"]
    F[("PostgreSQL")]

    A -- "POST worry" --> B
    A -- "open SSE" --> C
    D -- "stream tokens" --> E
    E -- "chunks" --> C
    C -- "parse JSON, persist log" --> F
    C == "SSE: complete event<br/>(error_log, summary, fixes)" ==> A
    A --> G[Render: boot log → error log<br/>→ severity gauge → suggested fixes]
```

**Flow:** `Input → persist → SSE stream → Claude → Error Log → Summary → Reflection`

---

## Why I Built This

AI services that generate answers are everywhere.

But I wanted to build something different — an experience where AI supports the user's thinking, not replaces it.

Most AI tools speak first. They suggest. They advise. They answer before you've finished thinking.

DebugMe does none of that.

It listens. It organizes. It reflects back what you said — so you can see your own thoughts more clearly.

> *DebugMe never speaks first.*

The user is always the protagonist. AI is the tool.

This isn't just a product decision. It's a design philosophy I want to carry across everything I build.

RewardMe shows what an experience can feel like.
FrameLens shows what an algorithm can look like.
DebugMe shows what AI *shouldn't* do — and why that restraint matters.

---

## Roadmap

- [ ] GitHub Login
- [ ] Personal Debug History
- [ ] AI Memory — Neco remembers your past logs
- [ ] Weekly Reflection — look back on your week
- [ ] Mood Timeline — visualize how you've changed
- [ ] Multiple AI Models
- [ ] Share Debug Log

---

## Setup

**Requirements:** Ruby 3.1.4 · PostgreSQL · Redis

```bash
# 1. Start PostgreSQL and Redis (e.g. via Homebrew)
brew services start postgresql
brew services start redis

# 2. Install dependencies (Import Maps — no Node/yarn needed)
bundle install

# 3. Configure environment
cp .env.example .env
#   → set ANTHROPIC_API_KEY (required)

# 4. Database
bin/rails db:create db:migrate

# 5. Run
bin/rails s   # http://localhost:3000
```

## Environment Variables

| Key | Required | Description |
|---|---|---|
| `ANTHROPIC_API_KEY` | ✅ | Anthropic API key (Claude) |
| `RAILS_MASTER_KEY` | prod | Rails credentials master key (`config/master.key`) |
| `DATABASE_HOST` / `DATABASE_PASSWORD` | dev | Local PostgreSQL connection |
| `DATABASE_URL` | prod | PostgreSQL URL (Render provides this) |
| `REDIS_URL` | ✅ | Redis URL — defaults to `redis://localhost:6379` in dev |

> **Deploy:** `render.yaml` is a Blueprint that provisions Web + Redis +
> PostgreSQL in one click. Set `ANTHROPIC_API_KEY` and `RAILS_MASTER_KEY`
> as secrets in the Render dashboard.

---

MIT License — see [LICENSE](./LICENSE). Made by [MIZE](https://github.com/mize1978)

---

🐈 Thanks for visiting.

Remember,

> *"You are not a bug.*
> *You're just debugging."*
