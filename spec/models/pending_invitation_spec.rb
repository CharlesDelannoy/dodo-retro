require 'rails_helper'

RSpec.describe PendingInvitation, type: :model do
  describe 'associations' do
    it { should belong_to(:team) }
    it { should belong_to(:inviter).class_name('User') }
  end

  describe 'validations' do
    it 'requires email' do
      invitation = build(:pending_invitation, email: nil)
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to include("can't be blank")
    end

    it 'requires valid email format' do
      invitation = build(:pending_invitation, email: 'invalid')
      expect(invitation).not_to be_valid
      expect(invitation.errors[:email]).to include("is invalid")
    end

    it 'requires status' do
      invitation = build(:pending_invitation, status: nil)
      expect(invitation).not_to be_valid
      expect(invitation.errors[:status]).to include("can't be blank")
    end

    it 'validates status inclusion' do
      invitation = build(:pending_invitation, status: 'invalid')
      expect(invitation).not_to be_valid
      expect(invitation.errors[:status]).to include("is not included in the list")
    end

    it 'requires unique email per team' do
      team = create(:team)
      create(:pending_invitation, team: team, email: 'test@example.com')
      duplicate = build(:pending_invitation, team: team, email: 'test@example.com')
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:email]).to include("has already been invited to this team")
    end

    it 'allows same email for different teams' do
      team1 = create(:team)
      team2 = create(:team)
      create(:pending_invitation, team: team1, email: 'test@example.com')
      duplicate = build(:pending_invitation, team: team2, email: 'test@example.com')
      expect(duplicate).to be_valid
    end
  end

  describe 'normalizations' do
    it 'normalizes email to lowercase and strips whitespace' do
      invitation = create(:pending_invitation, email: '  TEST@EXAMPLE.COM  ')
      expect(invitation.email).to eq('test@example.com')
    end
  end

  describe 'scopes' do
    let!(:pending_invitation) { create(:pending_invitation, status: 'pending') }
    let!(:accepted_invitation) { create(:pending_invitation, status: 'accepted') }

    it '.pending returns only pending invitations' do
      expect(PendingInvitation.pending).to include(pending_invitation)
      expect(PendingInvitation.pending).not_to include(accepted_invitation)
    end

    it '.accepted returns only accepted invitations' do
      expect(PendingInvitation.accepted).to include(accepted_invitation)
      expect(PendingInvitation.accepted).not_to include(pending_invitation)
    end
  end

  describe '#accept!' do
    it 'changes status to accepted' do
      invitation = create(:pending_invitation, status: 'pending')
      invitation.accept!
      expect(invitation.reload.status).to eq('accepted')
    end
  end
end
