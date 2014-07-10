class InvitesController < ApplicationController
  before_action :authorize_user, except: [:join, :join_submit]

  def new
    @friend_name, @friend_email = "", ""
    @message = "Please join this really cool site!"
  end

  def invite_submit
    @friend_name, @friend_email, @message = params[:friend_name], params[:friend_email], params[:message]

    if input_valid?
      InviteMailer.invitation_email(current_user.full_name, current_user.email, @friend_name, @friend_email, @message).deliver
      flash[:notice] = "Your invitation has been sent to #{@friend_name} at #{@friend_email}"
      redirect_to root_path
    else
      flash[:error] = "There is a problem with your submission. Please fill in all blanks."
      render :new
    end
  end

  def join
    @user = User.new
    @user.email = params[:email]
    @inviter_email = params[:inviter_email]
    render :join
  end

  def join_submit
    @user = register_user

    if @user.persisted?
      inviter = User.find_by( email: params[:inviter_email] )
      if inviter
        inviter.follow(@user)
        @user.follow(inviter)
      end
      redirect_to root_path
    else
      render :join
    end
  end


  private
    def input_valid?
      if  params[:friend_name] &&
          params[:friend_email] &&
          params[:message] &&
          !params[:friend_name].strip.empty? &&
          !params[:friend_email].strip.empty? &&
          !params[:message].strip.empty?
        true
      else
        false
      end
    end

end