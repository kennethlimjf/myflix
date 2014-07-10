class UsersController < ApplicationController
  before_action :authorize_user, only: :show
  before_action :require_sign_out, except: [:show]

  def new
    @user = User.new
  end

  def create
    @user = register_user

    if @user.persisted?
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def forgot_password

  end

  def forgot_password_submit
    user = User.find_by_email(params[:email])
    if user
      user.generate_token
      user = user.reload
      UserMailer.forgot_password(user).deliver
      flash[:notice] = "We have sent an email to your inbox."
      redirect_to root_path
    else
      flash[:error] = "There a problem with your email."
      redirect_to forgot_password_path
    end
  end

  def reset_password
    @token = params[:token]
    redirect_to root_path unless User.find_by_token( @token )
  end

  def reset_password_submit
    user = User.find_by_token( params[:token] )
    user.password = params[:new_password]
    if user.save
      flash[:notice] = "User account password has been updated."
    else
      flash[:error] = "There is a problem. #{user.errors.full_messages.join(" ")}. Visit the forgot password again to reset password."
    end
    
    user.clear_token
    redirect_to sign_in_path
  end

end