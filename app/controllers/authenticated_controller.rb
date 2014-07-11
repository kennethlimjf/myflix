class AuthenticatedController < ApplicationController
  before_action :require_sign_in
  
  protected
    def require_sign_in
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