class TeamMailer < ApplicationMailer
  # Sends invitation to existing users who have an account
  def invitation_existing_user(team:, user:, inviter:)
    @team = team
    @user = user
    @inviter = inviter

    mail(
      to: user.email_address,
      subject: "#{inviter.username} added you to #{team.name} on Dodo Retro"
    )
  end

  # Sends invitation to email addresses without an account
  def invitation_new_user(team:, email:, inviter:)
    @team = team
    @email = email
    @inviter = inviter

    mail(
      to: email,
      subject: "#{inviter.username} invited you to join #{team.name} on Dodo Retro"
    )
  end
end
