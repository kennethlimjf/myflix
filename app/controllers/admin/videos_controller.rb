class Admin::VideosController < Admin::AdminsController
  def new
    @categories = Category.all
    @video = Video.new
  end
end

