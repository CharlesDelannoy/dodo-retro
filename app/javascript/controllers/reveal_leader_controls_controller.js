import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["controls"]
  static values = {
    creatorId: Number,
    currentUserId: Number
  }

  connect() {
    this.updateVisibility()
  }

  creatorIdValueChanged() {
    this.updateVisibility()
  }

  currentUserIdValueChanged() {
    this.updateVisibility()
  }

  updateVisibility() {
    const isLeader = this.currentUserIdValue === this.creatorIdValue

    if (this.hasControlsTarget) {
      if (isLeader) {
        this.controlsTarget.classList.remove('hidden')
      } else {
        this.controlsTarget.classList.add('hidden')
      }
    }
  }
}
