import { Controller } from "@hotwired/stimulus"
import { createConsumer } from "@rails/actioncable"

export default class extends Controller {
  static targets = ["question"]
  static values = { id: String }

  connect() {
    this.channel = createConsumer().subscriptions.create(
      { channel: "RetrospectiveChannel", id: this.idValue },
      {
        received: (data) => {
          if (data.action === 'ice_breaker_question_changed') {
            this.updateQuestion(data.question, data.question_type)
          }
        }
      }
    )
  }

  disconnect() {
    if (this.channel) {
      this.channel.unsubscribe()
    }
  }

  changeQuestion(event) {
    event.preventDefault()

    fetch(`/retrospectives/${this.idValue}/change_ice_breaker_question`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Content-Type': 'application/json'
      }
    })
  }

  updateQuestion(question, questionType) {
    const questionContainer = document.getElementById('ice-breaker-question')
    const badgeClass = questionType === 'question' ? 'bg-blue-100 text-blue-800' : 'bg-purple-100 text-purple-800'

    questionContainer.innerHTML = `
      <div class="inline-flex items-center px-3 py-1 rounded-full text-xs font-medium mb-4 ${badgeClass}">
        ${questionType.charAt(0).toUpperCase() + questionType.slice(1)}
      </div>
      <p class="text-2xl font-semibold text-gray-900 animate-fade-in">
        ${question}
      </p>
    `
  }
}
