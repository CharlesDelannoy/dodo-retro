# frozen_string_literal: true

class ReactionsController < ApplicationController
  before_action :set_ticket

  def create
    @reaction = @ticket.reactions.find_or_initialize_by(
      user: Current.user,
      emoji: params[:emoji]
    )

    if @reaction.persisted?
      # User already reacted with this emoji, so remove it (toggle)
      @reaction.destroy
    else
      # Add new reaction
      @reaction.save
    end

    head :ok
  end

  private

  def set_ticket
    @ticket = Ticket.find(params[:ticket_id])
  end
end
