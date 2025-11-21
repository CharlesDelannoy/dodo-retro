# frozen_string_literal: true

class Retrospective < ApplicationRecord
  belongs_to :team
  belongs_to :creator, class_name: "User"
  belongs_to :retrospective_type
  belongs_to :current_revealing_user, class_name: "User", optional: true
  has_many :tickets, dependent: :destroy

  validates :current_step, presence: true, inclusion: {
    in: %w[ice_breaker ticket_creation ticket_reveal voting discussion completed]
  }

  before_create :generate_title

  broadcasts_to ->(retrospective) { [retrospective.team, retrospective] }, inserts_by: :prepend

  def random_ice_breaker_question
    IceBreakerQuestion.order('RANDOM()').first
  end

  def advance_to_next_step!
    new_step = case current_step
               when 'ice_breaker' then 'ticket_creation'
               when 'ticket_creation' then 'ticket_reveal'
               when 'ticket_reveal' then 'voting'
               when 'voting' then 'discussion'
               when 'discussion' then 'completed'
               else current_step
               end

    update!(current_step: new_step)
  end

  private

  def generate_title
    self.title = "#{team.name}-#{Date.today.strftime('%Y-%m-%d')}-#{creator.username}"
  end
end
