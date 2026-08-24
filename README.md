# Pomodoro Timer

A focused-work Pomodoro timer: run 25-minute focus sessions, take short or
long breaks, and keep a history of what you finished.

## What it does

- A single-page timer, straight on the root — no account needed
- Focus / short break / long break modes with a circular progress dial
- Start, pause, reset, and skip controls
- Completed sessions are recorded and shown in recent history
- A "minutes focused today" summary keeps the daily tally

## Running it yourself

```sh
bin/setup
bin/dev
```

Open http://localhost:3000. The timer runs entirely in the browser; completed
sessions POST to `/pomodoro_sessions` and are stored in PostgreSQL.

## Stack

- Ruby on Rails (importmap + Stimulus, no Node build)
- PostgreSQL
- Material Design 3 chrome with a custom SVG timer dial

## Tests

```sh
bin/rails test
```

## Demo

The Holodex preview wipes daily at 3AM Mexico City; the repo is the keeper.
