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

  private

  def set_team
    @team = Current.user.teams.find(params[:team_id])
  end

  def retrospective_params
    params.require(:retrospective).permit(:retrospective_type_id)
  end
end
