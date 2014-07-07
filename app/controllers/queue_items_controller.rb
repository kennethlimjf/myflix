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
      flash[:error] = @queue_item.errors.first.last
      redirect_to video_path(@video)
    end
  end

  def destroy
    q = QueueItem.find(params[:id]) 
    if current_user.queue_items.include?(q)
      QueueItem.destroy(params[:id])
      current_user.queue_items.each_with_index { |q, i| q.update_attribute(:list_order, i+1); }
    end
    redirect_to my_queue_path
  end
end