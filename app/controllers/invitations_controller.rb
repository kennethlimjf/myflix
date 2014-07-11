class InvitationsController < AuthenticatedController
  def new
    @invitation = Invitation.new
    @invitation.message = "Please join this really cool site!"
  end

  def create
    @invitation = Invitation.new(invitation_params)
    @invitation.inviter = current_user
    @invitation.generate_token

    if @invitation.save
      InvitationMailer.invitation_email(current_user, @invitation).deliver
      flash[:notice] = "Your invitation has been sent to #{@invitation.name} at #{@invitation.email}"
      redirect_to root_path
    else
      flash[:error] = "There is a problem with your submission. Please fill in all blanks."
      render :new
    end
  end

  
  private
    def invitation_params
      params.require(:invitation).permit(:name, :email, :message)
    end
end