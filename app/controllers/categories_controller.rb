class CategoriesController < ApplicationController
  before_action :authorize_user

  def show
    @category = Category.find( params[:id] )
  end
end