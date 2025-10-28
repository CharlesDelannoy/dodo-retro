import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["emailInput", "emailsField"]

  connect() {
    console.log("Team form controller connected")
  }

  removeParticipant(event) {
    const participantInput = event.target.closest('.participant-input')
    const container = document.getElementById('participants-container')

    // Don't remove if it's the last input
    if (container.children.length > 1) {
      participantInput.remove()
    }
  }

  collectEmails(event) {
    // Collect all email inputs
    const emailInputs = document.querySelectorAll('[data-participant-email]')
    const emails = Array.from(emailInputs)
      .map(input => input.value.trim())
      .filter(email => email !== '')
      .join(',')

    // Set the hidden field value
    const emailsField = this.emailsFieldTarget
    emailsField.value = emails

    console.log("Collected emails:", emails)
  }
}