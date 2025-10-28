# Preview all emails at http://localhost:3000/rails/mailers/team_mailer
class TeamMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/team_mailer/invitation_existing_user
  def invitation_existing_user
    team = Team.first || Team.new(id: 1, name: "Development Team")
    user = User.first || User.new(id: 1, username: "johndoe", email_address: "john@example.com")
    inviter = User.second || User.new(id: 2, username: "janedoe", email_address: "jane@example.com")

    TeamMailer.invitation_existing_user(team: team, user: user, inviter: inviter)
  end

  # Preview this email at http://localhost:3000/rails/mailers/team_mailer/invitation_new_user
  def invitation_new_user
    team = Team.first || Team.new(id: 1, name: "Development Team")
    inviter = User.first || User.new(id: 1, username: "janedoe", email_address: "jane@example.com")
    email = "newuser@example.com"

    TeamMailer.invitation_new_user(team: team, email: email, inviter: inviter)
  end

end
