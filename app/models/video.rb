class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, -> { order("created_at DESC") }
  validates_presence_of :title, :description
  has_many :queue_items

  def self.search_by_title(search_term)
    (search_term.empty?) ? [] : where("title LIKE ?", "%#{search_term}%").order('created_at DESC')
  end

  def average_rating
    reviews.any? ? ( reviews.reduce(0){ |p, c| p + c.rating } ) / reviews.count : 0
  end
end