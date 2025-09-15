class TeamsController < ApplicationController
  before_action :set_team, only: [:show]

  def index
    @teams = Current.user.teams.includes(:creator, :users)
  end

  def new
    @team = Team.new
  end

  def create
    @team = Current.user.created_teams.build(team_params)

    if @team.save
      # Add creator as first participant
      @team.participants.create!(user: Current.user)

      # Add other participants from email addresses
      if params[:participant_emails].present?
        add_participants_from_emails
      end

      redirect_to @team, notice: 'Team was successfully created!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @participants = @team.participants.includes(:user)
  end

  def add_participant_input
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.append('participants-container', partial: 'participant_input') }
    end
  end


  private

  def set_team
    @team = Team.find(params[:id])
  end

  def team_params
    params.require(:team).permit(:name)
  end

  def add_participants_from_emails
    email_addresses = params[:participant_emails].split(',').map(&:strip).reject(&:blank?)
    missing_users = []

    email_addresses.each do |email|
      user = User.find_by(email_address: email.downcase)
      if user
        @team.participants.find_or_create_by(user: user)
      else
        missing_users << email
      end
    end

    if missing_users.any?
      flash[:alert] = "Some participants need to create an account before being added: #{missing_users.join(', ')}"
    end
  end
end
