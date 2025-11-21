# frozen_string_literal: true

class TicketsController < ApplicationController
  before_action :set_retrospective

  def create
    @ticket = @retrospective.tickets.build(ticket_params)
    @ticket.author = Current.user

    if @ticket.save
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.append(
            "column_#{@ticket.retrospective_column_id}_tickets",
            partial: "tickets/ticket",
            locals: { ticket: @ticket }
          )
        end
        format.json { head :ok }
      end
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    @ticket = @retrospective.tickets.find(params[:id])

    if @ticket.update(ticket_params)
      head :ok
    else
      render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @ticket = @retrospective.tickets.find(params[:id])

    if @ticket.author_id == Current.user.id
      @ticket.destroy
      head :ok
    else
      head :forbidden
    end
  end

  private

  def set_retrospective
    @retrospective = Retrospective.find(params[:retrospective_id])
  end

  def ticket_params
    params.require(:ticket).permit(:content, :retrospective_column_id, :position)
  end
end
