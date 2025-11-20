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
  end

  private

  def set_team
    @team = Current.user.teams.find(params[:team_id])
  end

  def retrospective_params
    params.require(:retrospective).permit(:retrospective_type_id)
  end
end
