class Category < ActiveRecord::Base
  has_many :videos, -> { order 'title ASC' }

  def recent_videos
    Video.where(category_id: self.id).order('created_at DESC').limit(6)
  end
end