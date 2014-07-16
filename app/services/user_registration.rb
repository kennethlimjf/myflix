class UserRegistration

  attr_accessor :user, :token, :error_message

  def initialize(user, token)
    @user = user
    @token = token
    @status = false
    @error_message = ""
  end

  def process
    if @user.valid?
      subscription = subscribe 
      if subscription.successful?
        @user.subscription_id = subscription.subscription_id
        register_user
      else
        @error_message = subscription.error_message
      end
    else
      @error_message = "Please fill up user form correctly"
    end
  end

  def successful?
    @status
  end

  private
    def register_user
      if @user.save
        @status = true
        begin
          UserMailer.register_user(@user).deliver
        rescue Net::SMTPAuthenticationError
          @error_message = "Account created, however there is a problem with sending welcome email."
        end
      else
        @error_message = "Please fill up user form correctly"
      end
    end

    def process_payment
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => @token,
        :description => "#{@user.email} has registered on Movix"
      )
    end

    def subscribe
      subscription = StripeWrapper::Subscribe.create(card: @token, plan: 'regular', email: @user.email)
    end
end