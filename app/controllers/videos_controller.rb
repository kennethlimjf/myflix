class VideosController <ApplicationController
  before_action :authorize_user

  def show
    @video = Video.find(params[:id])
    @review = Review.asd
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end
end