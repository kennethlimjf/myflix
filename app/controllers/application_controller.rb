class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end


  protected
    def register_user
      @user = User.new(user_params)

      if @user.save
        begin
          UserMailer.register_user(@user).deliver
        rescue Net::SMTPAuthenticationError
          flash[:error] = "Account created, however there is a problem with sending welcome email."
        end
        flash[:notice] = "Your new account has been created."
      else
        flash[:error] = "Please fill up the form correctly"
      end
      
      @user
    end

    def authorize_user
      unless logged_in?
        flash[:notice] = "You will need to sign in first."
        redirect_to sign_in_path
      end
    end

    def require_sign_out
      if logged_in?
        flash[:notice] = "You need to sign out first"
        redirect_to root_path
      end
    end


  private
    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end
