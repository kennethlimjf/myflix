class InvitationMailer < ActionMailer::Base
  
  default from: 'connect@myflix.com'

  def invitation_email(inviter, invitation)
    @inviter, @invitation = inviter, invitation
    mail( to: @invitation.email, subject: "[MyFLiX] #{@inviter.full_name} has invited you to join!" )
  end
  
end