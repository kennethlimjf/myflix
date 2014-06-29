class MainController < ApplicationController
  
  def front
  end
  
  def home
    @categories = Category.all
  end
end