class Reaction < ApplicationRecord
  belongs_to :ticket
  belongs_to :user

  validates :emoji, presence: true
  validates :ticket_id, uniqueness: { scope: [:user_id, :emoji] }

  # Broadcast reaction changes to all users viewing the retrospective
  after_create_commit -> { broadcast_reaction_update }
  after_destroy_commit -> { broadcast_reaction_update }

  private

  def broadcast_reaction_update
    ticket.retrospective.broadcast_replace_to(
      [ticket.retrospective.team, ticket.retrospective],
      target: "ticket_#{ticket.id}_reactions",
      partial: "tickets/reactions",
      locals: { ticket: ticket }
    )
  end
end
