class UserMailer < ActionMailer::Base

  default from: "info@myflix.com"

  def register_user(user)
    @user = user
    mail( to: @user.email, subject: "Welcome to MyFlix!" )
  end

  def forgot_password(user, url)
    @user, @url = user, url
    mail( to: @user.email, subject: "[MyFLix] Password Reset" )
  end

  def account_deactivated(user)
    @user = user
    mail( to: @user.email, subject: "Account deactivated" )
  end

end