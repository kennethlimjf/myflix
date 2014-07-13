class UsersController < AuthenticatedController
  before_action :require_sign_in, only: :show
  before_action :require_sign_out, except: [:show]

  def new
    @user = User.new

    if params[:token]
      @invitation = Invitation.find_by( token: params[:token] )

      if @invitation
        @token = @invitation.token
        @user.email = @invitation.email
      else
        redirect_to expired_token_path
      end
    end
  end

  def create
    if params[:token] && !params[:token].empty?
      @invitation = Invitation.find_by( token: params[:token] )
      unless @invitation
        redirect_to expired_token_path; return
      end
    end

    user_registration = UserRegistration.new( User.new(user_params), params[:stripeToken] )
    user_registration.process
    @user = user_registration.user

    if user_registration.successful?
      flash[:notice] = "Your payment was successful. Your account has been created."
      handle_invitation if @invitation
      redirect_to root_path
    else
      flash[:error] = user_registration.error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def forgot_password
  end

  def forgot_password_submit
    forgot_password = ForgotPassword.new( User.find_by_email(params[:email]), self )
    forgot_password.process

    if forgot_password.successful?
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


  private
    def handle_invitation
      @invitation.inviter.follow(@user)
      @user.follow(@invitation.inviter)
      @invitation.clear_token
    end

    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end