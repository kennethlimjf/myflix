class ApplicationController < ActionController::Base
  protect_from_forgery
  helper_method :current_user, :logged_in?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def expired_token
    render 'shared/expired_token'
  end


  protected
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
end
