# frozen_string_literal: true

class Ticket < ApplicationRecord
  belongs_to :retrospective
  belongs_to :retrospective_column
  belongs_to :author, class_name: "User"
  belongs_to :ticket_group, optional: true
  has_many :reactions, dependent: :destroy

  validates :content, presence: true

  # Don't broadcast on create - tickets are private during creation phase
  # They will be revealed in the reveal phase

  after_destroy_commit -> { broadcast_ticket_destroyed }
  after_update_commit -> { broadcast_ticket_updated if saved_change_to_is_revealed? }

  default_scope { order(created_at: :asc) }

  scope :revealed, -> { where(is_revealed: true) }
  scope :unrevealed, -> { where(is_revealed: false) }

  def reveal!
    update!(is_revealed: true)
  end

  private

  def broadcast_ticket_destroyed
    broadcast_remove_to(
      [retrospective.team, retrospective],
      target: self
    )
  end

  def broadcast_ticket_updated
    # When ticket is revealed, append it to the revealed column for all users
    if is_revealed?
      broadcast_append_to(
        [retrospective.team, retrospective],
        target: "revealed-column-#{retrospective_column_id}",
        partial: "tickets/ticket",
        locals: { ticket: self }
      )
    end
  end
end
