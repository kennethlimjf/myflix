class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video
  validates_presence_of :video
  validates_presence_of :user
  validates_uniqueness_of :video, scope: :user_id, message: "You have already added this video in your queue."

  delegate :title, to: :video, prefix: :video
  delegate :category, to: :video

  before_create :set_list_order

  def rating
    user_review = video.reviews.order("created_at DESC").find_by(author: user)
    user_review ? user_review.rating : nil
  end

  def rating=(value)
    video.reviews.find_by(author: user).update_attribute(:rating, value)
  end

  def category_name
    video.category.name
  end

  def self.update_user_queue_items!(user, queue_items_params)
    return user.queue_items if user.queue_items.empty? || user.queue_items.count == 1

    self.transaction do
      positions = queue_items_params.map { |i| i["list_order"] }.uniq

      # Update list order
      if positions.size != queue_items_params.size
        raise ActiveRecord::Rollback
      else
        queue_items_params.each do |params|

          qi = QueueItem.find(params["id"])
          
          # Update List order          
          qi.update_columns( list_order: params["list_order"] )

          # Update rating
          if qi.video.reviews.find_by(author: user)
            qi.rating = params["rating"]
          else
            qi.video.reviews.build(rating: params["rating"], author: qi.user, video: qi.video).save(validate: false)
          end          
        end
        self.normalize(user)
        user.reload.queue_items
      end
    end

  end

  def self.normalize(user)
    user.queue_items.each_with_index { |q, i| q.update_attribute(:list_order, i+1); }
  end

  private
    def set_list_order
      self.list_order = user.queue_items.count + 1 if user
    end
end