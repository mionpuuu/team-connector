import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal", "modalImage"]

  open(event) {
    console.log("open!")  
    const fullUrl = event.currentTarget.dataset.fullUrl
    this.modalTarget.classList.remove("hidden")
    this.modalImageTarget.src = fullUrl
  }

  close(event) {
    if (event.target === this.modalTarget || event.target.closest("button")) {
      this.modalTarget.classList.add("hidden")
      this.modalImageTarget.src = ""
    }
  }
}
