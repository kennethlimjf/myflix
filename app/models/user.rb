class User < ActiveRecord::Base
  has_many :reviews
  has_many :queue_items, -> { order("list_order ASC") }

  validates_presence_of :email
  validates_uniqueness_of :email
  
  validates_presence_of :password
  validates_confirmation_of :password

  validates_presence_of :full_name

  has_secure_password
end