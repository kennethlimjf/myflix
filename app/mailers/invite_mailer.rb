class InviteMailer < ActionMailer::Base
  
  default from: 'connect@myflix.com'

  def invitation_email(inviter_name, inviter_email, name, email, message)
    @inviter_name, @inviter_email, @name, @email, @message = inviter_name, inviter_email, name, email, message
    mail( to: @email, subject: "[MyFLiX] #{inviter_name} has invited you to join!" )
  end
  
end