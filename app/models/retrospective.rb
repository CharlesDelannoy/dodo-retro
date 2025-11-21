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

    # When advancing to reveal, select first random revealer
    if new_step == 'ticket_reveal'
      select_next_revealer!
    end

    update!(current_step: new_step)
  end

  def select_next_revealer!
    # Get all team members who have unrevealed tickets
    user_ids_with_tickets = tickets.unrevealed.distinct.pluck(:author_id)

    if user_ids_with_tickets.any?
      # Randomly select next person
      next_user_id = user_ids_with_tickets.sample
      update!(current_revealing_user_id: next_user_id)
    else
      # No more tickets to reveal, clear revealer
      update!(current_revealing_user_id: nil)
    end
  end

  def current_revealer_has_more_tickets?
    return false unless current_revealing_user_id
    tickets.unrevealed.where(author_id: current_revealing_user_id).exists?
  end

  private

  def generate_title
    self.title = "#{team.name}-#{Date.today.strftime('%Y-%m-%d')}-#{creator.username}"
  end
end
