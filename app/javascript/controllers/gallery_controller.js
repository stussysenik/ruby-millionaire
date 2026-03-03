import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["mainImage"]

  select(event) {
    const url = event.params.url
    if (this.hasMainImageTarget && url) {
      this.mainImageTarget.src = url
    }

    // Update thumbnail borders
    this.element.querySelectorAll("button").forEach(btn => {
      btn.classList.remove("border-accent")
    })
    event.currentTarget.classList.add("border-accent")
  }
}
