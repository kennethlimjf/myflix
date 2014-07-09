class User < ActiveRecord::Base
  has_many :follows
  has_many :follow_users, through: :follows
  
  has_many :followers, class_name: "Follow", foreign_key: "follow_user_id"
  has_many :follower_users, through: :followers, source: :user

  has_many :reviews, -> { order("created_at DESC") }
  has_many :queue_items, -> { order("list_order ASC") }

  validates_presence_of :email
  validates_uniqueness_of :email
  
  validates_presence_of :password
  validates_confirmation_of :password

  validates_presence_of :full_name

  has_secure_password

  def has_video_in_queue?(video)
    queue_items.each { |queue_item| return true if queue_item.video == video }
    false
  end

  def videos_count
    queue_items.count
  end

  def follow(user)
    follow_users << user
  end

  def unfollow(user)
    follow_users.destroy(user)
  end
end