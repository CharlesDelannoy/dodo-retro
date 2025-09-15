require 'rails_helper'

RSpec.describe Participant, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }

    it 'validates uniqueness of user_id scoped to team_id' do
      create(:participant, user: user, team: team)
      duplicate_participant = build(:participant, user: user, team: team)

      expect(duplicate_participant).not_to be_valid
      expect(duplicate_participant.errors[:user_id]).to include("is already a member of this team")
    end

    it 'allows same user to be in different teams' do
      team1 = create(:team)
      team2 = create(:team)

      participant1 = create(:participant, user: user, team: team1)
      participant2 = build(:participant, user: user, team: team2)

      expect(participant1).to be_valid
      expect(participant2).to be_valid
    end
  end

  describe 'factory' do
    it 'creates a valid participant' do
      participant = build(:participant)
      expect(participant).to be_valid
    end
  end
end
