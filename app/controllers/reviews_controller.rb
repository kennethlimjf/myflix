class ReviewsController < AuthenticatedController
  def create
    @video = Video.find(params[:video_id])
    @review = Review.new(review_params)
    @review.author = current_user

    if @review.save
      flash[:notice] = "You have successfully posted a review for this video."
      redirect_to video_path(params[:video_id])
    else
      flash[:error] = "There is a problem with your review. Please check."
      render 'videos/show'
    end
  end


  private
    def review_params
      params.require(:review).permit(:rating, :body, :user_id).merge({ "video_id" => params[:video_id] })
    end
end