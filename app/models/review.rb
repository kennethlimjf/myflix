class Review < ActiveRecord::Base
  belongs_to :video
  belongs_to :author, foreign_key: "user_id", class_name: "User"
  validates_presence_of :body
  validates_presence_of :rating
  validates_presence_of :author
  validates_inclusion_of :rating, in: 1..5
end