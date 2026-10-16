# DebugMe

[日本語](./README.md) | **English**

<p align="center"><img src="./docs/banner.png" alt="DebugMe visual" width="100%"></p>

**Turn a worry into a debug log.**
An AI-assisted tool that organizes a worry as an error log and offers hints for thinking about your next step.

[**Open the live demo ↗**](https://debugme-2m5k.onrender.com) · [About](#about) · [Features](#features) · [Architecture](#architecture) · [Setup](#setup)

The service may take some time to start on the first visit.

## About

DebugMe is inspired by rubber duck debugging: explaining a problem can help you organize it.

You write a worry, AI structures it as a log, and you decide what to do next. This is not a medical or psychological diagnostic service. Severity and scores are AI-generated expressions, not objective measurements.

> AI supports. You decide.

## How to use it

1. Enter a worry of up to 200 characters, or choose a sample.
2. Press the generate button.
3. After the boot and analysis console sequence, read the log, severity, scores, and short suggested fixes.
4. Copy the log or open the X post composer.

Input is sent to the Claude API. Generated logs can be viewed through their URLs and may appear in the ranking. Do not enter personally identifying information.

## Features

- **Worry → error log**: an error name, fictional stack trace, cause, and hint
- **Analysis console**: boot messages, progress displays, and a typewriter reveal when generation completes
- **Severity and scores**: a gauge and four indicators during the generation session
- **Suggested fixes**: three short next steps
- **Sharing**: copy the log, open an X post composer, or share a saved log URL
- **Ranking**: generated logs ordered by view count
- **Neco the cat**: theme-specific messages, a pixel cat, and a broken pixel heart
- **Optional sound**: OFF by default; enabling SOUND plays short tones for activation, analysis start, completion, and connection failure
- **Responsive layout and reduced-motion support**

### Live display versus saved data

Rails receives Claude's response as a stream. The browser receives progress notifications over SSE; after the JSON response has been parsed, the log, scores, fixes, and other fields are sent together. Progress bars are presentation effects, not measurements of actual analysis completion.

The generated result currently persisted in the database is the error-log text. Scores, causes, hints, and suggested fixes are not persisted. Reopening a saved URL therefore does not restore every field from the original generation session; the score area indicates that no score was saved.

## Meet Neco

<p align="center"><img src="./docs/neco-profile.png" alt="Neco character artwork" width="700"></p>

Neco is DebugMe's cat assistant. Short messages accompany the thought-organizing experience and encourage a next step.

## Earlier demo material

This animation records an earlier UI. See the [live demo](https://debugme-2m5k.onrender.com) for the current colors, layout, and features.

![Earlier UI demo](./docs/demo.gif)

## Tech stack

| Layer | Technology |
| --- | --- |
| Language / backend | Ruby 3.1.4 / Rails 7.2 |
| Frontend | Hotwire / Stimulus / Importmap |
| AI | Claude API / `claude-sonnet-4-6` / `ruby-anthropic` |
| Transport | Server-Sent Events / `ActionController::Live` |
| Database | PostgreSQL |
| Request limits | Rack::Attack / Redis |
| Sound | Web Audio API |
| Hosting | Docker / Render |

See `.ruby-version`, `Gemfile`, `Gemfile.lock`, and `Dockerfile` for version requirements.

## Architecture

```text
Enter a worry
  → DebugLogsController#create persists it
  → The browser opens an SSE connection
  → DebugLogGenerator calls the Claude API
  → Rails parses the JSON response
  → The log text is saved and the result fields are sent to the browser
  → Stimulus renders the log, gauge, and fixes
```

| File | Responsibility |
| --- | --- |
| `app/controllers/debug_logs_controller.rb` | Create, show, SSE, and ranking |
| `app/services/debug_log_generator.rb` | Prompt construction and Claude stream handling |
| `app/javascript/controllers/stream_controller.js` | Console, result rendering, and sharing |
| `app/javascript/controllers/sound_controller.js` | Sound toggle and playback |
| `config/initializers/rack_attack.rb` | Per-IP request limits |

## Setup

Prepare Ruby 3.1.4, PostgreSQL, and Redis. To run Rails locally:

```bash
git clone https://github.com/mize1978/debugme.git
cd debugme
bundle install

# Adapt these values to your environment
export ANTHROPIC_API_KEY='your-api-key'
export DATABASE_HOST='localhost'
export DATABASE_PASSWORD='password'
export REDIS_URL='redis://localhost:6379/0'

bin/rails db:create db:migrate
bin/rails server
```

Open [http://localhost:3000](http://localhost:3000). The default database user is `postgres`. Set `DATABASE_URL` to use another user or port. Never commit API keys or other secrets.

### Environment variables

| Variable | Purpose |
| --- | --- |
| `ANTHROPIC_API_KEY` | Claude API key; required for AI generation |
| `DATABASE_HOST` / `DATABASE_PASSWORD` | Local PostgreSQL connection; defaults to `localhost` / `password` |
| `DATABASE_URL` | PostgreSQL connection URL; configured by Render in production |
| `REDIS_URL` | Redis for request limits; defaults to `redis://localhost:6379/0` |
| `RAILS_MASTER_KEY` | Rails credentials key for production |

Render configuration is in `render.yaml`. Configure secrets in Render.

---

MIT License — [LICENSE](./LICENSE) · Made by [MIZE](https://github.com/mize1978)
