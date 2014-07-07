class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :list_order
  validates_presence_of :video
  validates_presence_of :user
  validates_uniqueness_of :video, scope: :user_id

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  before_validation :set_list_order

  def user_rating
    user_review = video.reviews.order("created_at DESC").find_by(author: user)
    user_review ? user_review.rating : nil
  end

  def category_name
    video.category.name
  end

  private
    def set_list_order
      self.list_order = user.queue_items.count + 1 if user
    end
end