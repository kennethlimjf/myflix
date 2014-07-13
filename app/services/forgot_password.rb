class ForgotPassword

  def initialize(user, controller)
    @user, @controller = user, controller
    @status = false
  end

  def process
    if @user
      @user.generate_token
      @user.reload
      url = @controller.url_for(host: @controller.request.host_with_port, controller: 'users', action: 'reset_password', token: @user.token)
      UserMailer.delay.forgot_password(@user, url)
      @status = true
    end
  end

  def successful?
    @status
  end
end