# frozen_string_literal: true

class RetrospectivesController < ApplicationController
  before_action :set_team, only: [:new, :create]

  def new
    @retrospective = @team.retrospectives.build
    @retrospective_types = RetrospectiveType.includes(:retrospective_columns).all
  end

  def create
    @retrospective = @team.retrospectives.build(retrospective_params)
    @retrospective.creator = Current.user

    if @retrospective.save
      redirect_to @retrospective, notice: "Retrospective '#{@retrospective.title}' has been created."
    else
      @retrospective_types = RetrospectiveType.includes(:retrospective_columns).all
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @retrospective = Retrospective.find(params[:id])
    @is_leader = @retrospective.creator_id == Current.user.id
    @columns = @retrospective.retrospective_type.retrospective_columns.order(:position)
  end

  def advance_step
    @retrospective = Retrospective.find(params[:id])

    if @retrospective.creator_id == Current.user.id
      @retrospective.advance_to_next_step!

      # Broadcast step change to all users
      @retrospective.broadcast_replace_to(
        [@retrospective.team, @retrospective],
        target: "retrospective-content",
        partial: "retrospectives/step_content",
        locals: { retrospective: @retrospective, is_leader: true, columns: @retrospective.retrospective_type.retrospective_columns.order(:position) }
      )

      head :ok
    else
      head :forbidden
    end
  end

  def change_ice_breaker_question
    @retrospective = Retrospective.find(params[:id])

    # Only leader can change question
    if @retrospective.creator_id == Current.user.id
      @question = @retrospective.random_ice_breaker_question

      # Broadcast to ALL users subscribed to this retrospective
      @retrospective.broadcast_replace_to(
        [@retrospective.team, @retrospective],
        target: "ice-breaker-question",
        partial: "retrospectives/ice_breaker_question",
        locals: { question: @question }
      )

      head :ok
    else
      head :forbidden
    end
  end

  def reveal_ticket
    @retrospective = Retrospective.find(params[:id])

    # Only current revealer can reveal their tickets
    if @retrospective.current_revealing_user_id == Current.user.id
      @ticket = @retrospective.tickets.unrevealed.where(author_id: Current.user.id).find(params[:ticket_id])

      if @ticket
        @ticket.reveal!

        # Check if current revealer has more tickets
        unless @retrospective.current_revealer_has_more_tickets?
          @retrospective.select_next_revealer!
        end

        # Broadcast header update to all users
        @retrospective.broadcast_replace_to(
          [@retrospective.team, @retrospective],
          target: "reveal-header",
          partial: "retrospectives/reveal_header",
          locals: { retrospective: @retrospective }
        )

        # Respond with turbo stream to refresh the current user's unrevealed section
        respond_to do |format|
          format.turbo_stream do
            render turbo_stream: turbo_stream.replace(
              "revealer-section",
              partial: "retrospectives/revealer_section",
              locals: { retrospective: @retrospective }
            )
          end
          format.html { head :ok }
        end
      else
        head :not_found
      end
    else
      head :forbidden
    end
  end

  def next_revealer
    @retrospective = Retrospective.find(params[:id])

    # Only leader can force move to next revealer
    if @retrospective.creator_id == Current.user.id
      @retrospective.select_next_revealer!

      # Broadcast header update to all users
      @retrospective.broadcast_replace_to(
        [@retrospective.team, @retrospective],
        target: "reveal-header",
        partial: "retrospectives/reveal_header",
        locals: { retrospective: @retrospective }
      )

      # Broadcast revealer section update to all users
      @retrospective.broadcast_replace_to(
        [@retrospective.team, @retrospective],
        target: "revealer-section",
        partial: "retrospectives/revealer_section",
        locals: { retrospective: @retrospective }
      )

      head :ok
    else
      head :forbidden
    end
  end

  private

  def set_team
    @team = Current.user.teams.find(params[:team_id])
  end

  def retrospective_params
    params.require(:retrospective).permit(:retrospective_type_id)
  end
end
