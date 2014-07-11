class Admin::AdminsController < AuthenticatedController
  before_action :require_admin

  protected
    def require_admin
      unless current_user && current_user.admin?
        flash[:error] = "You are not authroized to do this."
        redirect_to root_path
      end
    end
end