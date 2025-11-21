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
      @retrospective.reload
      @columns = @retrospective.retrospective_type.retrospective_columns.order(:position)

      # Broadcast step change to all non-leader users
      @retrospective.broadcast_replace_to(
        [@retrospective.team, @retrospective],
        target: "retrospective-content",
        partial: "retrospectives/step_content",
        locals: {
          retrospective: @retrospective,
          is_leader: false,
          columns: @columns
        }
      )

      # Respond with turbo stream to update the leader's view
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace(
            "retrospective-content",
            partial: "retrospectives/step_content",
            locals: {
              retrospective: @retrospective,
              is_leader: true,
              columns: @columns
            }
          )
        end
        format.html { redirect_to @retrospective }
      end
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
        revealer_changed = false
        unless @retrospective.current_revealer_has_more_tickets?
          @retrospective.select_next_revealer!
          revealer_changed = true

          # Broadcast header update to all users when revealer changes
          @retrospective.broadcast_replace_to(
            [@retrospective.team, @retrospective],
            target: "reveal-header",
            partial: "retrospectives/reveal_header",
            locals: { retrospective: @retrospective }
          )
        end

        # Reload the revealer-section turbo frame for the current user
        # Since the form is inside the frame, this response will be captured by the frame
        redirect_to revealer_section_retrospective_path(@retrospective), status: :see_other
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

      # Broadcast header update to all users - this shows whose turn it is
      # The Stimulus controller will react to this and show/hide reveal buttons
      @retrospective.broadcast_replace_to(
        [@retrospective.team, @retrospective],
        target: "reveal-header",
        partial: "retrospectives/reveal_header",
        locals: { retrospective: @retrospective }
      )

      head :ok
    else
      head :forbidden
    end
  end

  def revealer_section
    @retrospective = Retrospective.find(params[:id])
    @columns = @retrospective.retrospective_type.retrospective_columns.order(:position)

    render turbo_frame: "revealer-section", layout: false
  end

  private

  def set_team
    @team = Current.user.teams.find(params[:team_id])
  end

  def retrospective_params
    params.require(:retrospective).permit(:retrospective_type_id)
  end
end
