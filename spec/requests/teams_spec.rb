require 'rails_helper'

RSpec.describe "Teams", type: :request do
  let(:user) { create(:user) }
  let(:team) { create(:team, creator: user) }

  before do
    # Mock authentication by setting Current.session with user
    session = double('session', user: user)
    allow(Current).to receive(:session).and_return(session)
    allow(Current).to receive(:user).and_return(user)
  end

  describe "GET /teams" do
    it "returns http success" do
      get teams_path
      expect(response).to have_http_status(:success)
    end

    it "displays user's teams" do
      # Add user as participant to see the team in their list
      team.participants.create!(user: user)
      get teams_path
      expect(response.body).to include(team.name)
    end
  end

  describe "GET /teams/new" do
    it "returns http success" do
      get new_team_path
      expect(response).to have_http_status(:success)
    end

    it "displays team creation form" do
      get new_team_path
      expect(response.body).to include("Create Team")
      expect(response.body).to include("Team Name")
    end
  end

  describe "POST /teams" do
    let(:valid_params) { { team: { name: "Test Team" } } }
    let(:invalid_params) { { team: { name: "" } } }

    context "with valid parameters" do
      it "creates a new team" do
        expect {
          post teams_path, params: valid_params
        }.to change(Team, :count).by(1)
      end

      it "redirects to the team show page" do
        post teams_path, params: valid_params
        expect(response).to redirect_to(Team.last)
      end

      it "creates team with current user as creator" do
        post teams_path, params: valid_params
        created_team = Team.last
        expect(created_team.creator).to eq(user)
      end

      it "adds creator as first participant" do
        post teams_path, params: valid_params
        created_team = Team.last
        expect(created_team.participants.first.user).to eq(user)
      end
    end

    context "with participant emails" do
      let(:existing_user) { create(:user, email_address: "existing@example.com") }
      let(:params_with_emails) do
        {
          team: { name: "Test Team" },
          participant_emails: "existing@example.com, nonexistent@example.com"
        }
      end

      before { existing_user } # create the user

      it "adds existing users as participants" do
        post teams_path, params: params_with_emails
        created_team = Team.last
        expect(created_team.users).to include(existing_user)
      end

      it "shows alert for non-existent users" do
        post teams_path, params: params_with_emails
        expect(flash[:alert]).to include("Some participants need to create an account")
        expect(flash[:alert]).to include("nonexistent@example.com")
      end
    end

    context "with invalid parameters" do
      it "does not create a team" do
        expect {
          post teams_path, params: invalid_params
        }.not_to change(Team, :count)
      end

      it "returns unprocessable content status" do
        post teams_path, params: invalid_params
        expect(response).to have_http_status(:unprocessable_content)
      end
    end
  end

  describe "GET /teams/:id" do
    it "returns http success" do
      get team_path(team)
      expect(response).to have_http_status(:success)
    end

    it "displays team details" do
      get team_path(team)
      expect(response.body).to include(team.name)
      expect(response.body).to include(team.creator.username)
    end
  end

  describe "POST /teams/add_participant_input" do
    it "returns turbo stream response" do
      post add_participant_input_teams_path, headers: { "Accept" => "text/vnd.turbo-stream.html" }
      expect(response).to have_http_status(:success)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
    end
  end
end
