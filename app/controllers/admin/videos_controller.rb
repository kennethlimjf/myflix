class Admin::VideosController < Admin::AdminsController
  def new
    @categories = Category.all
    @video = Video.new
  end

  def create
    @video = Video.new video_params

    if @video.save
      @video.cover.store!
      flash[:notice] = 'You have added a video'
      redirect_to new_admin_video_path
    else
      @categories = Category.all
      flash[:error] = @video.errors.full_messages.join(" ")
      render :new
    end
  end


  private
    def video_params
      params.require(:video).permit(:title, :category_id, :description, :cover, :video_url)
    end
end

