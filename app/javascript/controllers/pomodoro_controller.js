import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["time", "label", "toggle", "skip", "work", "short", "long", "sessions", "summary", "progress"]
  static values = {
    work: { type: Number, default: 25 },
    short: { type: Number, default: 5 },
    long: { type: Number, default: 15 },
    rounds: { type: Number, default: 4 }
  }

  connect() {
    this.kind = "work"
    this.remaining = this.workValue * 60
    this.tick = null
    this.originalTitle = document.title
    this.render()
  }

  disconnect() {
    this.stop()
  }

  start() {
    if (this.tick) return
    this.tick = setInterval(() => this.advance(), 1000)
    this.render()
  }

  pause() {
    this.stop()
    this.render()
  }

  reset() {
    this.stop()
    this.remaining = this.durationFor(this.kind)
    this.render()
  }

  skip() {
    this.stop()
    this.complete()
  }

  selectWork() { this.select("work") }
  selectShort() { this.select("short") }
  selectLong() { this.select("long") }

  select(kind) {
    if (this.kind === kind && this.remaining === this.durationFor(kind)) return
    this.stop()
    this.kind = kind
    this.remaining = this.durationFor(kind)
    this.render()
  }

  advance() {
    this.remaining -= 1
    if (this.remaining <= 0) {
      this.stop()
      this.remaining = 0
      this.render()
      this.complete()
    } else {
      this.render()
    }
  }

  complete() {
    const payload = { session: { kind: this.kind, planned_minutes: this.minutesFor(this.kind) } }
    fetch(this.data.get("create-url"), {
      method: "POST",
      headers: { "Content-Type": "application/json", "X-CSRF-Token": this.csrfToken() },
      body: JSON.stringify(payload)
    })
      .then((r) => r.json())
      .then((data) => {
        if (data.ok) this.refreshHistory()
      })
      .catch(() => {})
    this.buzz()
    const next = this.nextKind()
    this.kind = next
    this.remaining = this.durationFor(next)
    this.render()
  }

  nextKind() {
    if (this.kind === "work") {
      this.roundsValue -= 1
      return this.roundsValue <= 0 ? "long" : "short"
    }
    return "work"
  }

  buzz() {
    try {
      const ctx = new (window.AudioContext || window.webkitAudioContext)()
      const osc = ctx.createOscillator()
      const gain = ctx.createGain()
      osc.connect(gain)
      gain.connect(ctx.destination)
      osc.frequency.value = 880
      gain.gain.setValueAtTime(0.25, ctx.currentTime)
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + 1)
      osc.start()
      osc.stop(ctx.currentTime + 1)
    } catch (e) { /* no audio available */ }
  }

  refreshHistory() {
    fetch(this.data.get("history-url"), { headers: { Accept: "application/json" } })
      .then((r) => r.json())
      .then((data) => {
        this.renderHistory(data.sessions)
        this.summaryTarget.textContent = `${data.today_minutes} min focused today`
      })
      .catch(() => {})
  }

  renderHistory(sessions) {
    this.sessionsTarget.innerHTML = ""
    if (!sessions.length) {
      this.sessionsTarget.innerHTML = '<p class="md-empty">No sessions yet — start your first pomodoro above.</p>'
      return
    }
    sessions.forEach((s) => {
      const time = new Date(s.completed_at).toLocaleString()
      const row = document.createElement("li")
      row.className = "md-session-row"
      row.innerHTML = `<span class="md-session-kind">${s.kind_label}</span><span class="md-session-minutes">${s.planned_minutes} min</span><span class="md-session-time">${time}</span>`
      this.sessionsTarget.appendChild(row)
    })
  }

  minutesFor(kind) {
    return Math.round(this.durationFor(kind) / 60)
  }

  durationFor(kind) {
    if (kind === "work") return this.workValue * 60
    if (kind === "short") return this.shortValue * 60
    return this.longValue * 60
  }

  render() {
    const total = this.durationFor(this.kind)
    const done = total - this.remaining
    const pct = total > 0 ? Math.round((done / total) * 100) : 0
    const m = Math.floor(this.remaining / 60)
    const s = this.remaining % 60
    const text = `${String(m).padStart(2, "0")}:${String(s).padStart(2, "0")}`
    this.timeTarget.textContent = text
    this.timeTarget.setAttribute("aria-label", `${text} remaining in ${this.kindLabel()}`)
    this.labelTarget.textContent = this.kindLabel()
    this.progressTarget.setAttribute("value", String(pct))
    this.toggleTarget.textContent = this.tick ? "Pause" : "Start"
    this.toggleTarget.setAttribute("aria-label", this.tick ? "Pause the timer" : "Start the timer")
    this.skipTarget.disabled = this.remaining === total && !this.tick
    this.workTarget.setAttribute("aria-pressed", String(this.kind === "work"))
    this.shortTarget.setAttribute("aria-pressed", String(this.kind === "short"))
    this.longTarget.setAttribute("aria-pressed", String(this.kind === "long"))
    this.workTarget.classList.toggle("md-chip--selected", this.kind === "work")
    this.shortTarget.classList.toggle("md-chip--selected", this.kind === "short")
    this.longTarget.classList.toggle("md-chip--selected", this.kind === "long")
    document.title = this.tick ? `${text} · ${this.kindLabel()} — Pomodoro Timer` : this.originalTitle
  }

  stop() {
    if (this.tick) {
      clearInterval(this.tick)
      this.tick = null
    }
  }

  csrfToken() {
    const meta = document.querySelector('meta[name="csrf-token"]')
    return meta ? meta.getAttribute("content") : ""
  }

  kindLabel() {
    return { work: "Focus", short: "Short break", long: "Long break" }[this.kind]
  }
}
