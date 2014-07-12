class UsersController < AuthenticatedController
  before_action :require_sign_in, only: :show
  before_action :require_sign_out, except: [:show]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.valid?
      charge = process_payment 
      if charge.successful?
        @user = register_user(@user)
        flash[:notice] = "Your payment was successful. Your account has been created."
        redirect_to root_path
      else
        flash[:error] = charge.error_message
        render :new
      end
    else
      flash[:error] = "Please fill up the form correctly"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def forgot_password
  end

  def forgot_password_submit
    user = User.find_by_email(params[:email])
    if user
      user.generate_token
      user = user.reload
      url = url_for(host: request.host_with_port, controller: 'users', action: 'reset_password', token: user.token)
      UserMailer.delay.forgot_password(user, url)
      flash[:notice] = "We have sent an email to your inbox."
      redirect_to root_path
    else
      flash[:error] = "There a problem with your email."
      redirect_to forgot_password_path
    end
  end

  def reset_password
    @token = params[:token]
    redirect_to root_path unless User.find_by_token( @token )
  end

  def reset_password_submit
    user = User.find_by_token( params[:token] )
    user.password = params[:new_password]
    if user.save
      flash[:notice] = "User account password has been updated."
    else
      flash[:error] = "There is a problem. #{user.errors.full_messages.join(" ")}. Visit the forgot password again to reset password."
    end
    
    user.clear_token
    redirect_to sign_in_path
  end

  def join
    @invitation = Invitation.find_by( token: params[:token] )

    if @invitation
      @token = @invitation.token
      @user = User.new
      @user.email = @invitation.email
      render :new
    else
      redirect_to expired_token_path
    end
  end

  def join_submit
    @invitation = Invitation.find_by( token: params[:token] )
    
    if @invitation
      @user = User.new(user_params)

      if @user.valid?
        charge = process_payment 
        if charge.successful?
          @user = register_user(@user)
          handle_invitation
          flash[:notice] = "Your payment was successful. Your account has been created."
          redirect_to root_path
        else
          flash[:error] = charge.error_message
          render :new
        end
      else
        flash[:error] = "Please fill up the form correctly"
        render :new
      end
    else
      redirect_to expired_token_path
    end
  end

  private
    def process_payment
      token = params[:stripeToken]
      charge = StripeWrapper::Charge.create(
        :amount => 999,
        :currency => "usd",
        :card => token,
        :description => "#{user_params[:email]} has registered on Movix"
      )
    end

    def handle_invitation
      @invitation.inviter.follow(@user)
      @user.follow(@invitation.inviter)
      @invitation.clear_token
    end

    def register_user user      
      if user.save
        begin
          UserMailer.register_user(@user).deliver
        rescue Net::SMTPAuthenticationError
          flash[:error] = "Account created, however there is a problem with sending welcome email."
        end
        flash[:notice] = "Your new account has been created."
      else
        flash[:error] = "Please fill up the form correctly"
      end
      user
    end

    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end