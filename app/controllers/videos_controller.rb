class VideosController < AuthenticatedController
  def show
    @video = Video.find(params[:id])
    @review = Review.new
  end

  def search
    @results = Video.search_by_title(params[:search_term])
  end
end