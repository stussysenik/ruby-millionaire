import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["message"]

  connect() {
    this.messageTargets.forEach(msg => {
      setTimeout(() => this.fadeOut(msg), 4000)
    })
  }

  dismiss(event) {
    const msg = event.currentTarget.closest("[data-flash-target='message']")
    this.fadeOut(msg)
  }

  fadeOut(element) {
    element.style.transition = "opacity 0.3s, transform 0.3s"
    element.style.opacity = "0"
    element.style.transform = "translateX(1rem)"
    setTimeout(() => element.remove(), 300)
  }

  remove(event) {
    event.target.remove()
  }
}
