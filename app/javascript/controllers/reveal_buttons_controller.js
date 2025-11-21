import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    currentUserId: Number,
    currentRevealingUserId: Number
  }

  connect() {
    this.updateButtonsVisibility()

    // Listen for reveal-header updates
    this.boundHandleHeaderUpdate = this.handleHeaderUpdate.bind(this)
    document.addEventListener('reveal-header:updated', this.boundHandleHeaderUpdate)
  }

  disconnect() {
    document.removeEventListener('reveal-header:updated', this.boundHandleHeaderUpdate)
  }

  handleHeaderUpdate(event) {
    // Update the revealing user ID from the event
    const newRevealingUserId = event.detail.revealingUserId
    this.currentRevealingUserIdValue = newRevealingUserId ? parseInt(newRevealingUserId) : null
  }

  currentRevealingUserIdValueChanged() {
    this.updateButtonsVisibility()
  }

  updateButtonsVisibility() {
    const isMyTurn = this.currentRevealingUserIdValue === this.currentUserIdValue

    // Update the section styling
    const unrevealedSection = this.element.querySelector('[data-unrevealed-tickets-section]')
    if (unrevealedSection) {
      if (isMyTurn) {
        unrevealedSection.classList.remove('bg-gray-50', 'border-gray-200')
        unrevealedSection.classList.add('bg-yellow-50', 'border-yellow-200')
        unrevealedSection.querySelector('h3')?.classList.remove('text-gray-900')
        unrevealedSection.querySelector('h3')?.classList.add('text-yellow-900')
      } else {
        unrevealedSection.classList.remove('bg-yellow-50', 'border-yellow-200')
        unrevealedSection.classList.add('bg-gray-50', 'border-gray-200')
        unrevealedSection.querySelector('h3')?.classList.remove('text-yellow-900')
        unrevealedSection.querySelector('h3')?.classList.add('text-gray-900')
      }
    }

    // Show/hide reveal buttons
    const revealButtons = this.element.querySelectorAll('[data-reveal-button]')
    revealButtons.forEach(button => {
      if (isMyTurn) {
        button.classList.remove('hidden')
      } else {
        button.classList.add('hidden')
      }
    })

    // Update helper text
    const helperText = this.element.querySelector('[data-helper-text]')
    if (helperText) {
      if (isMyTurn) {
        helperText.textContent = 'Click reveal button to share'
        helperText.classList.remove('text-gray-600')
        helperText.classList.add('text-yellow-700')
      } else {
        helperText.textContent = 'Waiting for your turn'
        helperText.classList.remove('text-yellow-700')
        helperText.classList.add('text-gray-600')
      }
    }
  }
}
