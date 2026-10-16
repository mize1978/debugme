import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button"]

  connect() {
    this.enabled = false
    try { this.enabled = sessionStorage.getItem("debugme-sound") === "on" } catch (_) {}
    this.unlock = () => { if (this.enabled) this.ensureAudio() }
    this.effect = event => this.play(event.detail?.kind)
    this.element.addEventListener("debugme:sound", this.effect)
    document.addEventListener("pointerdown", this.unlock)
    document.addEventListener("keydown", this.unlock)
    this.updateButton()
  }

  disconnect() {
    this.element.removeEventListener("debugme:sound", this.effect)
    document.removeEventListener("pointerdown", this.unlock)
    document.removeEventListener("keydown", this.unlock)
    if (this.context) this.context.close().catch(() => {})
  }

  async toggle() {
    this.enabled = !this.enabled
    try { sessionStorage.setItem("debugme-sound", this.enabled ? "on" : "off") } catch (_) {}
    this.updateButton()
    if (this.enabled) await this.play("ready")
  }

  updateButton() {
    this.buttonTargets.forEach(button => {
      button.textContent = `SOUND ${this.enabled ? "ON" : "OFF"}`
      button.setAttribute("aria-pressed", String(this.enabled))
      button.setAttribute("aria-label", `効果音を${this.enabled ? "オフ" : "オン"}にする`)
    })
  }

  async ensureAudio() {
    const Audio = window.AudioContext || window.webkitAudioContext
    if (!Audio) return null
    try {
      if (!this.context) this.context = new Audio()
      if (this.context.state === "suspended") await this.context.resume()
      return this.context.state === "running" ? this.context : null
    } catch (_) { return null }
  }

  async play(kind) {
    if (!this.enabled) return
    const context = await this.ensureAudio()
    if (!context || !this.enabled) return
    const notes = {
      ready: [660, 880],
      start: [440, 660],
      complete: [523.25, 659.25, 783.99],
      error: [330, 220],
    }[kind]
    if (!notes) return
    notes.forEach((frequency, i) => {
      const oscillator = context.createOscillator()
      const gain = context.createGain()
      const start = context.currentTime + i * 0.085
      oscillator.type = "sine"
      oscillator.frequency.value = frequency
      gain.gain.setValueAtTime(0, start)
      gain.gain.linearRampToValueAtTime(0.035, start + 0.008)
      gain.gain.exponentialRampToValueAtTime(0.0001, start + 0.11)
      oscillator.connect(gain)
      gain.connect(context.destination)
      oscillator.onended = () => { oscillator.disconnect(); gain.disconnect() }
      oscillator.start(start)
      oscillator.stop(start + 0.12)
    })
  }
}
