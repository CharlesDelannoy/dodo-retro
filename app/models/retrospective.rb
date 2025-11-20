# frozen_string_literal: true

class Retrospective < ApplicationRecord
  belongs_to :team
  belongs_to :creator, class_name: "User"
  belongs_to :retrospective_type
  belongs_to :current_revealing_user, class_name: "User", optional: true

  validates :current_step, presence: true, inclusion: {
    in: %w[ice_breaker ticket_creation ticket_reveal voting discussion completed]
  }

  before_create :generate_title

  private

  def generate_title
    self.title = "#{team.name}-#{Date.today.strftime('%Y-%m-%d')}-#{creator.username}"
  end
end
