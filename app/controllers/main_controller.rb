class MainController < AuthenticatedController
  before_action :require_sign_in, except: [:front]
  
  def front
    redirect_to home_path if current_user
  end
  
  def home
    @categories = Category.all
  end
end