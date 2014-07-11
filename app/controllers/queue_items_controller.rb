class QueueItemsController < AuthenticatedController
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
      QueueItem.normalize(current_user)
    end
    redirect_to my_queue_path
  end

  def update_queue_items
    @queue_items = queue_items_params
    result = QueueItem.update_user_queue_items!(current_user, queue_items_params)

    if result
      flash[:notice] = "Your queue has been updated."
    else
      flash[:error] = "There is a problem."
    end
    redirect_to my_queue_path
  end

  private
    def queue_items_params
      params[:queue_items]
    end
end