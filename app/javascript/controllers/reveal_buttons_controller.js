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

    // Also poll the header periodically in case we miss the event
    this.pollInterval = setInterval(() => {
      this.syncWithHeader()
    }, 500)
  }

  disconnect() {
    document.removeEventListener('reveal-header:updated', this.boundHandleHeaderUpdate)
    if (this.pollInterval) {
      clearInterval(this.pollInterval)
    }
  }

  handleHeaderUpdate(event) {
    // Update the revealing user ID from the event
    const newRevealingUserId = event.detail.revealingUserId
    this.currentRevealingUserIdValue = newRevealingUserId ? parseInt(newRevealingUserId) : null
  }

  syncWithHeader() {
    // Check the reveal-header for the current revealing user ID
    const revealHeader = document.querySelector('[data-current-revealing-user-id]')
    if (revealHeader) {
      const newRevealingUserId = revealHeader.dataset.currentRevealingUserId
      const parsedId = newRevealingUserId ? parseInt(newRevealingUserId) : null

      // Only update if it's different
      if (parsedId !== this.currentRevealingUserIdValue) {
        this.currentRevealingUserIdValue = parsedId
      }
    }
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
