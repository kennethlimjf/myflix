class UsersController < ApplicationController
  before_action :authorize_user, only: :show

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      begin
        UserMailer.register_user(@user).deliver
      rescue Net::SMTPAuthenticationError
        flash[:error] = "Account created, however there is a problem with sending welcome email."
      end
      flash[:notice] = "Your new account has been created."
      redirect_to root_path
    else
      flash[:error] = "Please fill up the form correctly"
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end


  private
    def user_params
      params.require(:user).permit(:email, :password, :full_name)
    end
end