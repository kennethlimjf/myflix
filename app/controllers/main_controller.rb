class MainController < ApplicationController
  def home
    @categories = Category.all
  end
end