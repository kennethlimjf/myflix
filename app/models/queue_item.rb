class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :list_order

  def user_rating
    user_review = video.reviews.order("created_at DESC").find_by(author: user)
    user_review ? user_review.rating : nil
  end
end