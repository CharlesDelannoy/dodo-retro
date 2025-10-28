require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'requires email_address' do
      user = User.new(username: 'test', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("can't be blank")
    end

    it 'requires username' do
      user = User.new(email_address: 'test@example.com', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'requires unique email_address' do
      User.create!(email_address: 'test@example.com', username: 'first', password: 'password')
      user = User.new(email_address: 'test@example.com', username: 'second', password: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email_address]).to include("has already been taken")
    end
  end

  describe 'normalizations' do
    it 'normalizes email_address to lowercase and strips whitespace' do
      user = User.create!(email_address: '  TEST@EXAMPLE.COM  ', username: 'test', password: 'password')
      expect(user.email_address).to eq('test@example.com')
    end

    it 'strips whitespace from username' do
      user = User.create!(email_address: 'test@example.com', username: '  testuser  ', password: 'password')
      expect(user.username).to eq('testuser')
    end
  end

  describe 'pending invitations auto-acceptance' do
    it 'accepts pending invitations when user signs up with matching email' do
      team1 = create(:team)
      team2 = create(:team)
      inviter = create(:user)

      invitation1 = create(:pending_invitation, team: team1, email: 'newuser@example.com', inviter: inviter)
      invitation2 = create(:pending_invitation, team: team2, email: 'newuser@example.com', inviter: inviter)

      user = User.create!(email_address: 'newuser@example.com', username: 'newuser', password: 'password')

      expect(user.teams).to include(team1, team2)
      expect(invitation1.reload.status).to eq('accepted')
      expect(invitation2.reload.status).to eq('accepted')
    end

    it 'does not accept invitations for different email addresses' do
      team = create(:team)
      inviter = create(:user)

      invitation = create(:pending_invitation, team: team, email: 'other@example.com', inviter: inviter)

      user = User.create!(email_address: 'newuser@example.com', username: 'newuser', password: 'password')

      expect(user.teams).not_to include(team)
      expect(invitation.reload.status).to eq('pending')
    end

    it 'handles email normalization when accepting invitations' do
      team = create(:team)
      inviter = create(:user)

      invitation = create(:pending_invitation, team: team, email: 'newuser@example.com', inviter: inviter)

      user = User.create!(email_address: '  NEWUSER@EXAMPLE.COM  ', username: 'newuser', password: 'password')

      expect(user.teams).to include(team)
      expect(invitation.reload.status).to eq('accepted')
    end

    it 'does not accept already accepted invitations' do
      team = create(:team)
      inviter = create(:user)

      invitation = create(:pending_invitation, team: team, email: 'newuser@example.com', inviter: inviter, status: 'accepted')

      user = User.create!(email_address: 'newuser@example.com', username: 'newuser', password: 'password')

      # Should not create duplicate participant
      expect(team.participants.where(user: user).count).to eq(0)
    end
  end
end
