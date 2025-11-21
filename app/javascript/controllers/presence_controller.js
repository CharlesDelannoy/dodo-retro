import { Controller } from "@hotwired/stimulus"
import consumer from "channels/consumer"

export default class extends Controller {
  static targets = ["avatars"]
  static values = { retrospectiveId: String }

  connect() {
    this.subscription = consumer.subscriptions.create(
      {
        channel: "PresenceChannel",
        retrospective_id: this.retrospectiveIdValue
      },
      {
        received: (data) => {
          if (data.action === "update_presence") {
            this.avatarsTarget.innerHTML = data.html
          }
        }
      }
    )
  }

  disconnect() {
    if (this.subscription) {
      this.subscription.unsubscribe()
    }
  }
}
