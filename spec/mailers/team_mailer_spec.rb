require "rails_helper"

RSpec.describe TeamMailer, type: :mailer do
  describe "invitation_existing_user" do
    let(:team) { create(:team) }
    let(:user) { create(:user) }
    let(:inviter) { create(:user) }
    let(:mail) { TeamMailer.invitation_existing_user(team: team, user: user, inviter: inviter) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{inviter.username} added you to #{team.name} on Dodo Retro")
      expect(mail.to).to eq([user.email_address])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi #{user.username}")
      expect(mail.body.encoded).to match(team.name)
      expect(mail.body.encoded).to match(inviter.username)
    end
  end

  describe "invitation_new_user" do
    let(:team) { create(:team) }
    let(:inviter) { create(:user) }
    let(:email) { "newuser@example.com" }
    let(:mail) { TeamMailer.invitation_new_user(team: team, email: email, inviter: inviter) }

    it "renders the headers" do
      expect(mail.subject).to eq("#{inviter.username} invited you to join #{team.name} on Dodo Retro")
      expect(mail.to).to eq([email])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hello!")
      expect(mail.body.encoded).to match(team.name)
      expect(mail.body.encoded).to match(inviter.username)
    end
  end
end
