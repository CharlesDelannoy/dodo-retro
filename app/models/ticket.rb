# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :retrospective
  belongs_to :retrospective_column
  belongs_to :author, class_name: "User"

  validates :content, presence: true

  # Don't broadcast on create - tickets are private during creation phase
  # They will be revealed in the reveal phase

  after_destroy_commit -> { broadcast_ticket_destroyed }

  default_scope { order(created_at: :asc) }

  private

  def broadcast_ticket_destroyed
    # Only broadcast destroy to ticket author
    broadcast_remove_to(
      [retrospective.team, retrospective],
      target: self
    )
  end
end
