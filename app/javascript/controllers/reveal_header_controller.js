import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // When this controller connects (including after turbo stream updates),
    // dispatch an event to notify other controllers
    this.dispatch("updated", { detail: { revealingUserId: this.element.dataset.currentRevealingUserId } })
  }
}
