import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input"]

  increment() {
    const input = this.inputTarget
    const max = parseInt(input.max) || 9999
    const current = parseInt(input.value) || 0
    if (current < max) {
      input.value = current + 1
    }
  }

  decrement() {
    const input = this.inputTarget
    const min = parseInt(input.min) || 1
    const current = parseInt(input.value) || 0
    if (current > min) {
      input.value = current - 1
    }
  }

  submitForm() {
    const form = this.element.closest("form")
    if (form) {
      clearTimeout(this._submitTimeout)
      this._submitTimeout = setTimeout(() => form.requestSubmit(), 200)
    }
  }
}
