import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form", "content", "columnId", "column"]
  static values = { retrospectiveId: String }

  showForm(event) {
    const columnId = event.currentTarget.dataset.columnId
    this.columnIdTarget.value = columnId
    this.contentTarget.value = ""
    document.getElementById('ticket-form-modal').classList.remove('hidden')
    this.contentTarget.focus()
  }

  closeForm() {
    document.getElementById('ticket-form-modal').classList.add('hidden')
  }

  submitTicket(event) {
    event.preventDefault()

    const content = this.contentTarget.value.trim()

    if (!content) {
      alert('Please enter some content for the ticket')
      return
    }

    // Submit via Turbo for automatic Turbo Stream handling
    const form = this.formTarget
    form.action = `/retrospectives/${this.retrospectiveIdValue}/tickets`
    form.method = 'POST'

    // Convert to form data for Rails
    const formData = new FormData()
    formData.append('ticket[content]', content)
    formData.append('ticket[retrospective_column_id]', this.columnIdTarget.value)

    fetch(form.action, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Accept': 'text/vnd.turbo-stream.html'
      },
      body: formData
    }).then(response => {
      if (response.ok) {
        return response.text()
      }
      throw new Error('Failed to create ticket')
    }).then(html => {
      Turbo.renderStreamMessage(html)
      this.closeForm()
    }).catch(error => {
      console.error('Error creating ticket:', error)
      alert('Failed to create ticket')
    })
  }
}
