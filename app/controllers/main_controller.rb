class MainController < ApplicationController
  before_action :authorize_user, except: [:front]
  
  def front
    redirect_to home_path if current_user
  end
  
  def home
    @categories = Category.all
  end
end