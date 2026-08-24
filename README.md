<!-- foundation:identity -->
# Pomodoro Timer

A focused-work Pomodoro timer: start work and break sessions, track rounds, and keep a history of completed sessions.

- Site: https://pomodoro-timer.api.holode.xyz
- Support: support@pomodoro-timer.api.holode.xyz
<!-- /foundation:identity -->

## What this is

A focused-work Pomodoro timer: start work and break sessions, track rounds, and keep a history of completed sessions.

## Who it is for

- Visitor (no account needed)

## Main features

- **Run a pomodoro** — Open the app straight to the timer; pick work or break; start, pause, reset, skip
- **Auto-record completed sessions** — When a countdown reaches zero, save a Session with its kind and duration
- **View history** — See today's focus minutes and a list of recent completed sessions

## Core entities

- Session
- TimerSettings

## Run locally

```bash
bundle install
bin/rails db:prepare
bin/dev
```

Requires Ruby, PostgreSQL, and the usual Rails toolchain. See `bin/setup` if present.

## Demo

A few completed work sessions spread over the last two days so history and today's focus-time summary render with data.

## Deploy notes

Production `config.hosts` is derived from `domain` in `config/foundation.yml`. Keep that value aligned with the real host or every request will 403.
