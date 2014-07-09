class UserMailer < ActionMailer::Base

  default from: "info@myflix.com"

  def register_user(user)
    @user = user
    mail( to: @user.email, subject: "Welcome to MyFlix!" )
  end

end