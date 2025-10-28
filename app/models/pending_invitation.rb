class PendingInvitation < ApplicationRecord
  belongs_to :team
  belongs_to :inviter, class_name: 'User'

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :email, uniqueness: { scope: :team_id, message: "has already been invited to this team" }
  validates :status, presence: true, inclusion: { in: %w[pending accepted] }

  normalizes :email, with: ->(e) { e.strip.downcase }

  scope :pending, -> { where(status: 'pending') }
  scope :accepted, -> { where(status: 'accepted') }

  def accept!
    update!(status: 'accepted')
  end
end
