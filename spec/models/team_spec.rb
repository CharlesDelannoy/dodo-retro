require 'rails_helper'

RSpec.describe Team, type: :model do
  describe 'associations' do
    it { should belong_to(:creator).class_name('User') }
    it { should have_many(:participants).dependent(:destroy) }
    it { should have_many(:users).through(:participants) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(2).is_at_most(100) }
  end

  describe 'factory' do
    it 'creates a valid team' do
      team = build(:team)
      expect(team).to be_valid
    end
  end

  describe 'team creation' do
    let(:user) { create(:user) }
    let(:team) { create(:team, creator: user) }

    it 'is created with a valid creator' do
      expect(team.creator).to eq(user)
      expect(team).to be_persisted
    end

    it 'can have multiple participants' do
      user1 = create(:user)
      user2 = create(:user)

      team.participants.create!(user: user1)
      team.participants.create!(user: user2)

      expect(team.users).to include(user1, user2)
      expect(team.users.count).to eq(2)
    end
  end
end
