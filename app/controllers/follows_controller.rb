class FollowsController < AuthenticatedController
  def index
    @follow_users = current_user.follow_users
  end

  def destroy
    unfollow_user = User.find(params[:id])
    current_user.unfollow(unfollow_user)
    redirect_to people_path
  end

  def create
    follow_user = User.find(params[:id])
    current_user.follow(follow_user)
    redirect_to people_path
  end
end