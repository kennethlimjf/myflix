class QueueItemsController < ApplicationController
  before_action :authorize_user 

  def index
    @queue_items = current_user.queue_items
  end

  def create
    @video = Video.find_by(id: params[:video_id])
    @queue_item = QueueItem.new(video: @video, user: current_user)

    if @queue_item.save
      flash[:notice] = "Video has been added to your queue."
      redirect_to my_queue_path
    else
      flash[:error] = "Some error has occurred in the process. Please try again."
      render 'videos/show'
    end
  end
end