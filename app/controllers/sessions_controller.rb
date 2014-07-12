class SessionsController < ApplicationController
  def new
    redirect_to home_path if current_user
  end

  def create
    # require 'pry'; binding.pry
    user = User.find_by(email: params[:email]).try(:authenticate, params[:password])

    if user
      reset_session
      session[:user_id] = user.id
      flash[:notice] = "You have successfully signed in."  
      redirect_to home_path
    else
      flash[:error] = "There is a problem with your email and password."
      render :new
    end
  end

  def destroy
    reset_session
    flash[:notice] = "You have successfully signed out."
    redirect_to root_path
  end
end