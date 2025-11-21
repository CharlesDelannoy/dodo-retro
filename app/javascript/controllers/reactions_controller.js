import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { retrospectiveId: String }

  togglePicker(event) {
    const button = event.currentTarget
    const ticketId = button.dataset.ticketId

    // Check if picker already exists
    let picker = document.getElementById(`reaction-picker-${ticketId}`)

    if (picker) {
      picker.remove()
      return
    }

    // Create emoji picker
    picker = document.createElement('div')
    picker.id = `reaction-picker-${ticketId}`
    picker.className = 'bg-white rounded-lg shadow-xl border-2 border-gray-300 p-3'
    picker.style.minWidth = '240px'
    picker.style.zIndex = '9999'
    picker.style.position = 'absolute'
    picker.style.top = '100%'
    picker.style.left = '0'
    picker.style.marginTop = '0.5rem'

    const emojiGrid = document.createElement('div')
    emojiGrid.style.display = 'grid'
    emojiGrid.style.gridTemplateColumns = 'repeat(6, 1fr)'
    emojiGrid.style.gap = '0.25rem'

    this.commonEmojis().forEach(emoji => {
      const button = document.createElement('button')
      button.type = 'button'
      button.dataset.action = 'click->reactions#selectEmoji'
      button.dataset.emoji = emoji
      button.dataset.ticketId = ticketId
      button.className = 'flex items-center justify-center text-2xl hover:bg-gray-100 rounded transition-colors'
      button.style.width = '2.25rem'
      button.style.height = '2.25rem'
      button.textContent = emoji
      emojiGrid.appendChild(button)
    })

    picker.appendChild(emojiGrid)

    // Ensure parent has relative positioning
    button.parentElement.style.position = 'relative'
    button.parentElement.appendChild(picker)

    // Close picker when clicking outside
    setTimeout(() => {
      document.addEventListener('click', this.closePickerHandler = (e) => {
        if (!picker.contains(e.target) && e.target !== button) {
          picker.remove()
          document.removeEventListener('click', this.closePickerHandler)
        }
      })
    }, 0)
  }

  selectEmoji(event) {
    const button = event.currentTarget
    const emoji = button.dataset.emoji
    const ticketId = button.dataset.ticketId

    // Submit reaction
    fetch(`/retrospectives/${this.retrospectiveIdValue}/tickets/${ticketId}/reactions`, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({ emoji: emoji })
    })

    // Close picker
    const picker = document.getElementById(`reaction-picker-${ticketId}`)
    if (picker) picker.remove()
  }

  commonEmojis() {
    return ['🦤', '💩', '👍', '❤️', '😄', '🎉', '🚀', '👏', '💯', '🔥',
            '💡', '✅', '👀', '🤔', '😮', '💪', '🙌', '✨', '🎯', '📌',
            '⭐', '💬', '🤩', '🙏', '❓', '😂']
  }
}
